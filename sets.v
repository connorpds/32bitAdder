`include "/lib/and_gate.v"
`include "/lib/or_gate.v"
`include "/lib/xor_gate.v"
`include "/lib/not_gate.v"


//input A is 32-bit input, coming from adder/subtractor
//set less than
module slt(
  input wire [31:0] a,
  output wire [31:0] slt
);

  assign slt[31:0] = {{31{1'b0}}, a[31]};
endmodule


//set equal
module seq(
  input wire zf,
  output wire [31:0] seq
);


 assign  seq[31:0] = {{31{1'b0}}, zf};

endmodule

//set not equal
module sne(
  input wire nz,
  output wire [31:0] sne
);

  assign sne[31:0] = {{31{1'b0}}, nz};

endmodule

//set greater
module sgt(
  input wire nz,
  input wire [31:0] a,
  output wire [31:0] sgt
);
//!sign
wire sx;
not_gate ns(a[31],sx);
and_gate and_nsn(nz,sx,sgt[0]);


  assign sgt[31:1] = {31{1'b0}};
endmodule


//set less-than or equal
module slte(
  input wire [31:0] a,
  input wire zf,
  output wire [31:0] slte
  );
wire [31:0] slt_out;
slt slt0(a,slt_out);
or_gate(zf,slt_out[0],slte[0]);


  assign slte[31:1] = {31{1'b0}};

endmodule

module sge(
  input wire [31:0] a,
  output wire [31:0] sge
  );

  not_gate ns(a[31],sge[0]);
  assign sge[31:1] = {31{1'b0}};
  endmodule
