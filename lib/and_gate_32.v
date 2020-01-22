module and_gate_32 (x, y, z);
  input [31:0] x;
  input [31:0] y;
  output [31:0] z;
  
  assign z = (x&y) ;
  
  
endmodule
  




