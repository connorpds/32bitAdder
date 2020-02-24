//execute for single cycle
//essentially just combines mult and alu with common in and out
include "/alu_32.v"
include "mult.v" //not actually using rn but whatever

module execute(
  input wire [31:0] A,
  input wire [31:0] B,
  input wire [5:0] opcode,
  output wire [31:0] out
  )

  //assume 6'b111111 is mult
  wire out_sel;
  wire doMult;

  always @*
    case (opcode)
      6'b111111 : begin
                  out_sel = 1;
                  doMult = 1;
                  end
      default   : begin
                  out_sel = 0;
                  doMult = 0;
                  end
    endcase
  end

  wire [31:0] inter_alu_res;
  alu_32 exec_alu(.A(A),.B(B),.opcode(opcode),.out(inter_alu_res));

  wire [31:0] inter_mult_result;
  always @*
    inter_mult_result = A * B;
  end

  mux_32 sel_mult_or_alu(.sel(out_sel),.src0(inter_alu_res),.src1(inter_mult_result),out);
