`include "lib/mux_n.v"
//ext_op = 0 for unsigned, 1 for signed
module extend(ext_op,in,out);
  parameter integer n = 16;
  input wire ext_op;
  input wire [n-1:0] in;
  output reg [n*2 -1:0] out;

  reg [n-1:0] mux_out;
  //need wire to determine msb for signed
  //want 1 bits if MSB is 1 and ext_op is 1
  wire ext_sel;
  and_gate msb_extOP(ext_op,in[n-1],ext_sel);
  mux_n #(n) sel_ext_bits(ext_sel,{n{1'b0}},{n{1'b1}},mux_out);

  //concatenate to get 32-bit output 
  always @*
      out = {mux_out,in};


  endmodule
