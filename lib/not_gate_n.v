module not_gate_n (x, z);
  // synopsys template
  parameter integer n = 32;
  input [n-1:0] x;
  output [n-1:0] z;

  assign z = ~x ;


endmodule
