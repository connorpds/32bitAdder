//execute for single cycle
//essentially just combines mult and alu with common in and out

module execute(
  input wire [31:0] busA,
  input wire [31:0] busB,
  input wire [5:0] ALU_ctr,
  input wire ext_op,
  input wire ALUsrc,
  input wire doMult,
  input wire [15:0] imm16,
  input wire clk,
  input wire reset,
  output wire mult_done,
  output wire [31:0] out
  );


  reg [1:0] out_sel;
  //determine if multiplying
  always @*
    case (ALU_ctr)
      6'h0e : begin
                  out_sel = 01; //01 for signed mult
                  end
      6'h16 : begin
                  out_sel = 10; //10 for unsigned mult
                  end
      default: begin
                  out_sel = 00;
                  end
    endcase



  //extend imm16 as appropriate
  wire [31:0] imm32;
  extend ext_imm(.ext_op(ext_op),.in(imm16),.out(imm32));

  //select between busB: 0, and imm32: 1, for input to mult and alu
  wire [31:0] input_B;
  mux_32 busB_imm32(.sel(ALUsrc),.src0(busB),.src1(imm32),.z(input_B));

  //get ALU result
  wire [31:0] inter_alu_res;
  alu_32 exec_alu(.A(busA),.B(input_B),.opcode(ALU_ctr),.out(inter_alu_res));

  //get mult result
//  reg [31:0] inter_mult_result;
//  always @*
//    inter_mult_result = busA * input_B;
  wire [31:0] mult_res;
  wire [31:0] multu_res;
  wire mult_signed_done;
  wire mult_unsigned_done;

  //signed mult
  mult signed_mult(.a(busA),.b(busB),.clk(clk),.doMult(doMult),.reset(reset),.out(mult_res),.mult_done(mult_signed_done));

  //unsigned mult
  multu unsigned_mult(.a(busA),.b(busB),.clk(clk),.doMult(doMult),.reset(reset),.out(multu_res),.mult_done(mult_unsigned_done));

  or_gate mlt_Done(mult_signed_done,mult_signed_done,mult_done);
  //select between ALU result and mult results
  mux_4to1_32 sel_mult_or_alu(.sel(out_sel),.a(inter_alu_res),.b(mult_res),.c(multu_res),.d(inter_alu_res), .out(out));

  endmodule
