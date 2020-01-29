`include "/lib/and_gate.v"
`include "/lib/or_gate.v"
`include "/lib/xor_gate.v"
~include "/lib/not_gate.v"


//input A is 32-bit input, coming from adder/subtractor
//set less than
module slt(
  input wire [31:0] a,
  output wire [31:0] slt
);

always @* begin
  slt[31:0] = {{31{1'b0}}, a[31]};
end
endmodule


//set equal
module seq(
  input wire zf,
  output wire [31:0] seq
);


always @* begin
  seq[31:0] = {{31{1'b0}}, zf};
end
endmodule

//set not equal
module sne(
  input wire nz,
  output wire [31:0] sne
);


always @* begin
  sne[31:0] = {{31{1'b0}}, nz};
end
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
and_gate(nz,ns,sgt[0]);

always @* begin
  sgt[31:1] = {31{1'b0}};
end
endmodule


//set less-than or equal
module slte(
  input wire [31:0] a,
  input wire zf,
  output wire [31:0] slte
  ):
wire [31:0] slt_out;
slt slt0(a,slt_out);
or_gate(zf,slt_out[0],slte[0]);

always @* begin
  slte[31:1] = {31{1'b0}};
end
endmodule

module sge(
  input wire [31:0] a,
  output wire [31:0] sge
  );

  not_gate ns(a[31],sge[0]);
  assign sge[31:1] = {31{1'b0}};
  endmodule
