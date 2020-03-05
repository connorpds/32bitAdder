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

//SINGLE-BIT CONTROL SIGNALS MEGAWIRE (to make writing the pipeline registers less terrible)
wire [12:0] ctrl_sig;
assign ctrl_sig = {mem_to_reg,r_type,reg_wr,lhi,link,load_extend,lh,lb,sh,sb,ctrl_mem_wr,imm_inst,imm_extend};

//REGISTER WIRES:
wire [31:0] busA;
wire [31:0] busB;
wire [31:0] WB_out;
wire [4:0] into_rs2;


//ALU OUTPUT
wire [31:0] EX_out;

//pipeline register wires:
wire [63:0] IF_to_ID;
wire [146:0] ID_to_EX;
wire [138:0] EX_to_MEM;
wire [135:0] MEM_to_WB;

//INSTRUCTION DECODE WIRES
wire busA_0; //if busB is 0, high, else, low
wire bnz_comb; //branch_nz & busA_1
wire busA_1;
wire bz_comb; //branch_z & busA_1
wire comb_branch; //combined branch_z and branch_nz with the conditions they deal with.
                  //used for final branch determination.
                  //comb_branch = branch_nz * !busB_0  + branch_z * busB_0


wire pipe_reg_en;
assign pipe_reg_en = 1'b1; //THIS WILL CHANGE LATER WITH STALLS

//ID AND WB COMPONENTS

//rs, rs2 are our ID state inputs
//rs2_wb, r_type, and rd_wb are our WB state inputs

//////////////////////
//REGISTER FILE ///
/////////////////
reg_file_pipe registers(.rs(IF_to_ID[57:53]),.rs2(IF_to_ID[52:48]),.rd_wb(MEM_to_WB[47:43]),.rs2_wb(MEM_to_WB[52:48]),.busW(WB_out),.clk(clk),.r_type(MEM_to_WB[134]),.reg_wr(MEM_to_WB[133]) ,.reset(reset),.busA(busA),.busB(busB));

///////////////////////////////
//PIPELINE REGISTERS ////
////////////////////
//IF to ID
register_n #(64) IF_ID(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({instruction,PC}) ,.q(IF_to_ID));

//ID to EX
register_n #(147) ID_EX(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({ctrl_sig, func_code,busB,busA,IF_to_ID}), .q(ID_to_EX));

//EX to MEM

//selecting proper rd field [47:43]
//rs2 is [52:48]
//(rd and rs2 indices are invariant between registers)
//rtype = 0, mux selects rs2 (rtype is ID_to_EX[145])
//rtype = 1, mux selects rd
wire [4:0] rd_in;
mux_n #(5) rdsel(ID_to_EX[145],ID_to_EX[52:48], ID_to_EX[47:43],rd_in);
register_n #(139) EX_MEM(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({ID_to_EX[138:129], EX_out, ID_to_EX[127:96],ID_to_EX[63:48], rd_in, ID_to_EX[42:0]}),.q(EX_to_MEM));



//MEM to WB
register_n #(136) MEM_WB(.clk(clk), .reset(reset), .wr_en(pipe_reg_en), .d({EX_to_MEM[138:131], mem_read_data, EX_out, EX_to_MEM[63:0]}),.q(MEM_to_WB));



///////////////////////////////////////////////////////
//    PIPELINE /////////////////////////
/////////////////////////////



/////////////////////////
//Instruction Fetch ///
/////////////////////
inst_fetch IF(.imm16(instruction[15:0]),.jmp_imm26(instruction[25:0]),.reg_imm32(busA),.clk(clk),.branch(comb_branch),.jmp(jmp),.jmp_r(jmp_r),.reset(reset),.pc(PC));

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

////////////////////////////
//Execute //////////////
////////////////////

//Forwarding:
wire [1:0] A_sel;
wire [1:0] B_sel;
wire [31:0] ex_busA;
wire [31:0] ex_busB;
//busA_0 = ID_to_EX[95:64]
//busB_0 = ID_to_EX[127:96]
//ALU_out EX_to_MEM : [127:96]
//MEM_out MEM_to_WB : [127:96]
forwarding forward(.ex_mem_wr(EX_to_MEM[136]),.mem_wb_wr(EX_to_MEM[136]),.id_ex_rs(ID_to_EX[57:53]),.id_ex_rs2(ID_to_EX[52:48]),.ex_mem_rd(EX_to_MEM[47:43]),.mem_wb_rd(MEM_to_WB[47:43]),.A_sel(A_sel),.B_sel(B_sel));
//selecting between non forwarded and various forwarded values
mux_4to1_32 sel_A(A_sel,ID_to_EX[95:64],MEM_to_WB[127:96],EX_to_MEM[127:96],32'hFFFFFFFF,ex_busA);
mux_4to1_32 sel_B(B_sel,ID_to_EX[127:96],MEM_to_WB[127:96],EX_to_MEM[127:96],32'hFFFFFFFF,ex_busB);
execute EX(.busA(ex_busA),.busB(ex_busB),.ALU_ctr(ID_to_EX[133:128]),.ext_op(ID_to_EX[134]),.ALUsrc(ID_to_EX[135]),.imm16(ID_to_EX[63:48]),.out(EX_out));


/////////////////////////////
//Memory ////////////////
/////////////////////

store_filter MEM(.busB(EX_to_MEM[95:64]),.sb(EX_to_MEM[129]),.sh(EX_to_MEM[130]),.mem_write_data(mem_write_data)); //prepares correct data size
assign mem_wr = EX_to_MEM[128];
assign mem_addr = EX_to_MEM[127:96];


///////////////////////
//Write Back////////
/////////////////
write_back WB(.mem_out(MEM_to_WB[127:96]),.ALU_out(MEM_to_WB[95:64]),.PC(MEM_to_WB[31:0]),.imm16(MEM_to_WB[63:48]),.mem_to_reg(MEM_to_WB[135]),.lhi(MEM_to_WB[132]),.link(MEM_to_WB[131]),.lb(MEM_to_WB[128]),.lh(MEM_to_WB[129]),.load_extend(MEM_to_WB[130]),.WB_out(WB_out));
mux_n #(5) link_rs2_pick(MEM_to_WB[131], MEM_to_WB[52:48],5'b11111,into_rs2);

endmodule
