`include "dependencies.v"

//pipeline CPU datapath.
//components are pipeline stages
module pipeline
(
  input wire reset,
  input wire clk,
  input wire [31:0] instruction,
  input wire [31:0] mem_read_data,
  output wire [31:0] mem_addr,
  output wire [31:0] mem_write_data,
  output wire [31:0] PC,
  output wire [31:0] busA_probe, //for testing, comes from register file
  output wire mem_sb,
  output wire mem_sh,
  output wire mem_lb,
  output wire mem_lh,
  output wire mem_wr
  );


//instruction [25:21] is rs1
//instruction [20:16] is rs2
//instruction [15:11] is rdst
//instruction [15:0] is imm16
//instruction [25:0] is jmp_imm26


//WIRES COMING OUT OF CONTROL
wire reg_wr;
wire r_type;
wire branch_z;
wire branch_nz;
wire jmp;
wire jmp_r;
wire link;
wire imm_inst; //should ALU use imm or register busB
wire imm_extend; //need to zero extend i-type logical functions
wire load_extend; //because we can load sub-word unsigned, need to be able to not sign extend
wire mem_to_reg;
wire sb;
wire sh;
wire lb;
wire lh;
wire lhi;
wire [5:0] func_code; //needs to be set for imm operations
wire ctrl_mem_wr;
wire noStall;

//SINGLE-BIT CONTROL SIGNALS MEGAWIRE (to make writing the pipeline registers less terrible)
wire [12:0] ctrl_sig;
assign ctrl_sig = {mem_to_reg,r_type,reg_wr,lhi,link,load_extend,lh,lb,sh,sb,ctrl_mem_wr,imm_inst,imm_extend};

//REGISTER WIRES:
wire [31:0] busA;
wire [31:0] busB;
wire [31:0] WB_out;
wire [4:0] into_rs2;

//MULT WIRES
wire mult_freeze;
wire doMult;

//ALU OUTPUT
wire [31:0] EX_out;

//pipeline register wires:
wire [64:0] IF_to_ID;
wire [148:0] ID_to_EX;
wire [145:0] EX_to_MEM;
wire [142:0] MEM_to_WB;

//INSTRUCTION DECODE WIRES
wire busA_0; //if busB is 0, high, else, low
wire bnz_comb; //branch_nz & busA_1
wire busA_1;
wire bz_comb; //branch_z & busA_1
wire comb_branch; //combined branch_z and branch_nz with the conditions they deal with.
                  //used for final branch determination.
                  //comb_branch = branch_nz * !busB_0  + branch_z * busB_0


wire pipe_reg_en;

//used to freeze entire pipeline...will need to be ANDed in later with !(hazard_detected) signal
//freezing enire pipeline for using multi cycle mult
//ID AND WB COMPONENTS

//rs, rs2 are our ID state inputs
//rs2_wb, r_type, and rd_wb are our WB state inputs

//////////////////////
//REGISTER FILE ///
/////////////////
reg_file_pipe registers(.rs(IF_to_ID[57:53]),.rs2(IF_to_ID[52:48]),.rd_wb(MEM_to_WB[142:138]),.rs2_wb(into_rs2),.busW(WB_out),.clk(clk),.r_type(MEM_to_WB[134]),.reg_wr(MEM_to_WB[133]) ,.reset(reset),.busA(busA),.busB(busB));
assign busA_probe = busA; //FOR TESTING
///////////////////////////////
//PIPELINE REGISTERS ////
////////////////////

//valid bit is the MSB of each register other than IF_ID.

//IF to ID
wire hazard_detected;
wire nohazard;
wire not_reset;
wire wr_en_in0;
wire wr_en_in;
and_gate enable_write(noStall, nohazard, wr_en_in0);
and_gate check_for_freeze(wr_en_in0, pipe_reg_en, wr_en_in);
not_gate notrst(reset,not_reset);
register_n #(65) IF_ID(.clk(clk), .reset(reset), .wr_en(wr_en_in), .d({not_reset, instruction,PC}) ,.q(IF_to_ID));
hazard_detect detect(.id_ex_read(ID_to_EX[146]),.id_ex_rs2(ID_to_EX[52:48]), .if_id_rs(IF_to_ID[57:53]), .if_id_rs2(IF_to_ID[52:48]),.hazard(hazard_detected));
not_gate no_hazard(hazard_detected, nohazard);

//ID to EX
//select between ctrl_sig and 13'b0
wire [12:0] ctrl_sig_in;
wire id_ex_valid;
wire branch_mark0;
wire branch_mark;
or_gate branch_mark_find(branch_z, branch_nz, branch_mark0);
or_gate branch_mark_jr(branch_mark0, jmp_r, branch_mark);
and_gate idex_valid(nohazard,IF_to_ID[64],id_ex_valid);
mux_n #(13) squash_sig(nohazard,13'b0,ctrl_sig,ctrl_sig_in);
register_n #(149) ID_EX(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({branch_mark, id_ex_valid,ctrl_sig_in, func_code,busB,busA,IF_to_ID[63:0]}), .q(ID_to_EX));

//EX to MEM

//selecting proper rd field [47:43]
//rs2 is [52:48]
//(rd and rs2 indices are invariant between registers)
//rtype = 0, mux selects rs2 (rtype is ID_to_EX[145])
//rtype = 1, mux selects rd
wire [4:0] rs2_if_link;
wire [4:0] rd_in;
wire [31:0] ex_busB; //Very early
mux_n #(5) rs2sel_link(.sel(ID_to_EX[142]), .src0(ID_to_EX[52:48]), .src1(5'b11111), .z(rs2_if_link));
mux_n #(5) rdsel(ID_to_EX[145], rs2_if_link , ID_to_EX[47:43],rd_in);
register_n #(146) EX_MEM(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({rd_in, ID_to_EX[148:136], EX_out, ex_busB, ID_to_EX[63:0]}),.q(EX_to_MEM));



//MEM to WB
register_n #(143) MEM_WB(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({EX_to_MEM[145:131], mem_read_data, EX_to_MEM[127:96], EX_to_MEM[63:0]}),.q(MEM_to_WB));



///////////////////////////////////////////////////////
//    PIPELINE /////////////////////////
/////////////////////////////



/////////////////////////
//Instruction Fetch ///
/////////////////////
inst_fetch IF(.imm16(IF_to_ID[47:32]),.jmp_imm26(IF_to_ID[57:32]),.reg_imm32(busA),.clk(clk),.branch(comb_branch),.jmp(jmp),.jmp_r(jmp_r),.reset(reset),.pc(PC), .pc_enable(wr_en_in));

/////////////////////////
//Instruction Decode///
/////////////////////
control ID(.inst(IF_to_ID[63:32]),.mem_wr(ctrl_mem_wr),.reg_wr(reg_wr),.r_type(r_type),.branch_z(branch_z),.branch_nz(branch_nz),.jmp(jmp),.jmp_r(jmp_r),.link(link),.imm_inst(imm_inst),.imm_extend(imm_extend),.load_extend(load_extend),.mem_to_reg(mem_to_reg),.sb(sb),.sh(sh),.lb(lb),.lh(lh),.lhi(lhi),.func_code(func_code));

//ONE OTHER ID OPERATION: DETERMINING/CALCULATING BRANCHING
zero_check is_busA_0(busA, busA_0);
not_gate nzbusA(busA_0,busA_1);
and_gate bnz(branch_nz,busA_1,bnz_comb);
and_gate bz(branch_z, busA_0, bz_comb);
or_gate combine_branch_signals(bz_comb, bnz_comb,comb_branch);

//determine branch stall (hazard detection around branching sucks)
//bID = ID_to_EX[148]
//b_EX = EX_to_MEM[140]
//b_MEM = MEM_to_WB[137]
wire bex_bid;
wire bex_bid_bmem;
wire stall;
and_gate bexbid(ID_to_EX[148],EX_to_MEM[140],bex_bid);
nand_gate bexbidbmem(bex_bid,MEM_to_WB[137],bex_bid_bmem);
and_gate calcStall(bex_bid_bmem, branch_mark, stall);
not_gate nostalling(stall, noStall);
////////////////////////////
//Execute //////////////
////////////////////


//Mult determining
wire mult_done_not;
wire mult_signed_op;
wire mult_u_op;
wire func_code_01;
wire mult_op;
wire mult_freezing;
wire mult_not_freezing;
wire mult_op_potential;

xnor_gate_6to1 det_mult_signed(.x(ID_to_EX[37:32]), .y(6'h0e), .z(mult_signed_op));
xnor_gate_6to1 det_multu(.x(ID_to_EX[37:32]), .y(6'16), .z(mult_u_op));
xnor_gate_6to1 det_func_code(.x(ID_to_EX[63:58]), .y(6'h01), .z(func_code_01));
or_gate det_mult_op_potential(.x(mult_signed_op), .y(mult_u_op), .z(mult_op_potential));
and_gate det_mult_op(.x(mult_op_potential), .y(func_code_01), .z(mult_op));

not_gate mult_done_not(.x(mult_done), .z(mult_done_not));
and_gate mult_freeze_det(.x(mult_done_not), .y(mult_op), .z(mult_freeze));
not_gate (.x(mult_freeze), .z(pipe_reg_en);

register_n #(1) stalling_status(.clk(clk), .reset(reset), .wr_en(1'b1), .d(mult_freeze), .q(mult_freezing));
not_gate det_mult_not_freezing(.x(mult_freezing), .z(mult_not_freezing));
and_gate det_doMult(.x(mult_freeze), .y(mult_not_freezing), .z(doMult));

//Forwarding:
wire [1:0] A_sel0;
wire [1:0] B_sel0;
wire [1:0] A_sel;
wire [1:0] B_sel;
wire [31:0] ex_busA;
//wire [31:0] ex_busB; -- declared earlier
wire reg_valid;
//busA_0 = ID_to_EX[95:64]
//busB_0 = ID_to_EX[127:96]
//ALU_out EX_to_MEM : [127:96]
//MEM_out MEM_to_WB : [127:96]
forwarding forward(.ex_mem_wr(EX_to_MEM[136]),.mem_wb_wr(MEM_to_WB[133]),.id_ex_rs(ID_to_EX[57:53]),.id_ex_rs2(ID_to_EX[52:48]),.ex_mem_rd(EX_to_MEM[145:141]),.mem_wb_rd(MEM_to_WB[142:138]),.A_sel(A_sel0),.B_sel(B_sel0));
//accounting for register validity
and_gate regs_valid(EX_to_MEM[139],MEM_to_WB[136],reg_valid);

and_gate_n #(2) aSelValid({reg_valid,reg_valid},A_sel0,A_sel);
and_gate_n #(2) bSelValid({reg_valid,reg_valid},B_sel0,B_sel);

//selecting between non forwarded and various forwarded values
mux_4to1_32 sel_A(A_sel,ID_to_EX[95:64],WB_out,EX_to_MEM[127:96],32'hFFFFFFFF,ex_busA);
mux_4to1_32 sel_B(B_sel,ID_to_EX[127:96],WB_out,EX_to_MEM[127:96],32'hFFFFFFFF,ex_busB);
execute EX(.busA(ex_busA),.busB(ex_busB),.ALU_ctr(ID_to_EX[133:128]),.ext_op(ID_to_EX[134]),.ALUsrc(ID_to_EX[135]),.imm16(ID_to_EX[47:32]),.out(EX_out));


/////////////////////////////
//Memory ////////////////
/////////////////////


assign mem_sb = EX_to_MEM[129]; //FOR TESTING!
assign mem_sh = EX_to_MEM[130]; //FOR TESTING!
assign mem_lb = EX_to_MEM[131];
assign mem_lh = EX_to_MEM[132];
assign mem_write_data = EX_to_MEM[95:64];
//store_filter MEM(.busB(EX_to_MEM[95:64]),.sb(EX_to_MEM[129]),.sh(EX_to_MEM[130]),.mem_write_data(mem_write_data)); //prepares correct data size
assign mem_wr = EX_to_MEM[128];
assign mem_addr = EX_to_MEM[127:96];


///////////////////////
//Write Back////////
/////////////////
write_back WB(.mem_out(MEM_to_WB[127:96]),.ALU_out(MEM_to_WB[95:64]),.PC(MEM_to_WB[31:0]),.imm16(MEM_to_WB[47:32]),.mem_to_reg(MEM_to_WB[135]),.lhi(MEM_to_WB[132]),.link(MEM_to_WB[131]),.lb(MEM_to_WB[128]),.lh(MEM_to_WB[129]),.load_extend(MEM_to_WB[130]),.WB_out(WB_out));
mux_n #(5) link_rs2_pick(MEM_to_WB[131], MEM_to_WB[52:48],5'b11111,into_rs2);

endmodule
