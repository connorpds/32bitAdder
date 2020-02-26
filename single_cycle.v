`include "/mem_access.v"
`include "/execute.v"
`include "/control.v"
`include "/inst_fetch.v"
`include "/WB.v"
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
  output wire [31:0] PC
  );


//instruction [25:21] is rs1
//instruction [20:16] is rs2
//instruction [15:11] is rdst
//instruction [15:0] is imm16
//instruction [25:0] is jmp_imm26


//WIRES COMING OUT OF CONTROL (THESE WILL BE USED IN BASICALLY EVERY STAGE)
wire mem_wr;
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

//OTHER WIRES:
wire comb_branch; //combined branch_z and branch_nz with the conditions they deal with.
                  //used for final branch determination.
wire busB_0; //if busB is 0, high, else, low
zero_check is_busB_0(busB, busB_0);

//now we find comb_branch
//comb_branch = branch_nz * !busB_0  + branch_z * busB_0
wire bnz_comb;
wire busB_1;
not_gate nzbusB(busB_0,busB_1);
and_gate bnz(branch_nz,busB_1,bnz_comb);
wire bz_comb;
and_gate bz(branch_z, busB_0, bz_comb);
or_gate combine_branch_signals(bz_comb, bnz_comb,comb_branch);


//PLAN: CONNECT IN ORDER OF PIPELINE STAGES. YES, WE KNOW IT'S A SINGLE CYCLE CPU

//Instruction Fetch:
inst_fetch IF(.imm16(instruction[15:0]),.jmp_imm26(instruction[25:0]),.reg_imm32(busA),.clk(clk),.branch(comb_branch),.jmp(jmp),.jmp_r(jmp_r),.reset(reset),.pc(PC));

//Instruction Decode (control...     ugh):
control ID(.inst(instruction),.mem_wr(mem_wr),.reg_wr(reg_wr),.r_type(r_type),.branch_z(branch_z),.branch_nz(branch_nz),.jmp(jmp),.jmp_r(jmp_r),.link(link),.imm_inst(imm_inst),.imm_extend(imm_extend),.load_extend(load_extend),.mem_to_reg(mem_to_reg),.sb(sb),.sh(sh),.lb(lb),.lh(lh),.lhi(lhi),.func_code(func_code));

//Execute:
wire [31:0] EX_out;
execute EX(.busA(busA),.busB(busB),.ALU_ctr(func_code),.ext_op(imm_extend),.ALUsrc(imm_inst),.imm16(instruction[15:0]),.out(EX_out));

//Memory:
//note that most memory operations are happening outside synthesized design via cpu outputs
//this prepares the mem_write data of the correct size.
store_filter MEM(.busB(busB),.sb(sb),.sh(sh),.mem_write_data(mem_write_data));


//Write Back:
wire [31:0] WB_out;
write_back WB(.mem_out(mem_read_data),.ALU_out(EX_out),.PC(PC),.imm16(instruction[15:0]),.mem_to_reg(mem_to_reg),.lhi(lhi),.link(link),.lb(lb),.lh(lh),.load_extend(load_extend),.WB_out(WB_out));


endmodule
