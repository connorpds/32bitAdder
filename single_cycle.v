`include "dependencies.v"

//single cycle CPU datapath.
//components are pipeline stages and control module
module single_cycle
(
  input wire reset,
  input wire clk,
  input wire [31:0] instruction,
  input wire [31:0] mem_read_data,
  output wire [31:0] mem_addr,
  output wire [31:0] mem_write_data,
  output wire [31:0] PC,
  output wire [31:0] busA_probe,
  output wire mem_wr,
  output wire sh_out,
  output wire sb_out
  );


//instruction [25:21] is rs1
//instruction [20:16] is rs2
//instruction [15:11] is rdst
//instruction [15:0] is imm16
//instruction [25:0] is jmp_imm26


//WIRES COMING OUT OF CONTROL (THESE WILL BE USED IN BASICALLY EVERY STAGE)
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
wire [5:0] func_code; //needs to be set for imm operationss

//REGISTER WIRES:
wire [31:0] busA;
wire [31:0] busB;
wire [31:0] WB_out;

wire [4:0] into_rs2;
mux_n #(5) link_rs2_pick(link, instruction[20:16],5'b11111,into_rs2);
reg_file registers(.rs(instruction[25:21]),.rs2(into_rs2),.rd(instruction[15:11]),.busW(WB_out),.clk(clk),.r_type(r_type),.reg_wr(reg_wr),.reset(reset),.busA(busA),.busB(busB));
assign busA_probe = busA;
//OTHER WIRES:
wire comb_branch; //combined branch_z and branch_nz with the conditions they deal with.
                  //used for final branch determination.
wire busA_0; //if busB is 0, high, else, low
zero_check is_busA_0(busA, busA_0);

//now we find comb_branch
//comb_branch = branch_nz * !busB_0  + branch_z * busB_0
wire bnz_comb;
wire busA_1;
not_gate nzbusA(busA_0,busA_1);
and_gate bnz(branch_nz,busA_1,bnz_comb);
wire bz_comb;
and_gate bz(branch_z, busA_0, bz_comb);
or_gate combine_branch_signals(bz_comb, bnz_comb,comb_branch);


//PLAN: CONNECT IN ORDER OF PIPELINE STAGES. YES, WE KNOW IT'S A SINGLE CYCLE CPU

//Instruction Fetch:
inst_fetch IF(.imm16(instruction[15:0]),.jmp_imm26(instruction[25:0]),.reg_imm32(busA),.clk(clk),.branch(comb_branch),.jmp(jmp),.jmp_r(jmp_r),.reset(reset),.pc(PC));

//Instruction Decode (control...     ugh):
control ID(.inst(instruction),.mem_wr(mem_wr),.reg_wr(reg_wr),.r_type(r_type),.branch_z(branch_z),.branch_nz(branch_nz),.jmp(jmp),.jmp_r(jmp_r),.link(link),.imm_inst(imm_inst),.imm_extend(imm_extend),.load_extend(load_extend),.mem_to_reg(mem_to_reg),.sb(sb),.sh(sh),.lb(lb),.lh(lh),.lhi(lhi),.func_code(func_code));
assign sb_out = sb;
assign sh_out = sh;
//Execute:
wire [31:0] EX_out;
execute EX(.busA(busA),.busB(busB),.ALU_ctr(func_code),.ext_op(imm_extend),.ALUsrc(imm_inst),.imm16(instruction[15:0]),.out(EX_out));
assign mem_addr = EX_out;
//Memory:
//note that most memory operations are happening outside synthesized design via cpu outputs
//this prepares the mem_write data of the correct size.
store_filter MEM(.busB(busB),.sb(sb),.sh(sh),.mem_write_data(mem_write_data));


//Write Back:
write_back WB(.mem_out(mem_read_data),.ALU_out(EX_out),.PC(PC),.imm16(instruction[15:0]),.mem_to_reg(mem_to_reg),.lhi(lhi),.link(link),.lb(lb),.lh(lh),.load_extend(load_extend),.WB_out(WB_out));


endmodule
