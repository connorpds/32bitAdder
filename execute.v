//execute for single cycle
//essentially just combines mult and alu with common in and out
`include "/alu_32.v"
`include "/mult.v" //not actually using rn but whatever
`include "/extend.v"
module execute(
  input wire [31:0] busA,
  input wire [31:0] busB,
  input wire [5:0] ALU_ctr,
  input wire ext_op,
  input wire ALUsrc,
  input wire [15:0] imm16,
  output wire [31:0] out
  );

  //assume 6'b111111 is mult
  reg out_sel;
  reg doMult;
  //determine if multiplying
  always @*
    case (ALU_ctr)
      6'h0e : begin
                  out_sel = 1;
                  doMult = 1;
                  end
      default: begin
                  out_sel = 0;
                  doMult = 0;
                  end
    endcase



  //extend imm16 as appropriate
  reg [31:0] imm32;
  extend ext_imm(.ext_op(ext_op),.in(imm16),.out(imm32));

  //select between busB: 0, and imm32: 1, for input to mult and alu
  reg [31:0] input_B;
  mux_32 busB_imm32(.sel(ALUsrc),.src0(busB),.src1(imm32),.z(input_B));

  //get ALU result
  wire [31:0] inter_alu_res;
  alu_32 exec_alu(.A(busA),.B(input_B),.opcode(func_code),.out(inter_alu_res));

  //get mult result
  reg [31:0] inter_mult_result;
  always @*
    inter_mult_result = busA * input_B;

  //select between ALU result and mult result
  mux_32 sel_mult_or_alu(.sel(out_sel),.src0(inter_alu_res),.src1(inter_mult_result),.z(out));

  endmodule
