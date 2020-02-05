`include "/lib/and_gate.v"
`include "/lib/or_gate.v"
`include "/lib/xor_gate.v"

module full_adder
(
	input wire  x,
	input wire  y,
	input wire c_in1,
	output wire sum,
	output wire c_out1
);

//from kmap: s = x ^ b ^ c
// c_out = bc + ac + ab = c(a+b) + ab = ab + (a^b)c

wire a1, a2, a3,a4;
xor_gate x1(x,y,a1);
xor_gate x2(a1,c_in1,sum); //s now contains a^b^c

and_gate n1(x,y,a3); //a3 is ab


//a1 already contains a^b
and_gate n3(a1, c_in1, a4);
or_gate o2(a4, a3, c_out1);

endmodule

module half_adder
(
	input wire a,
	input wire b,
	output wire s,
	output wire c
);

xor_gate xor11(a,b,s);
and_gate and11(a,b,c);

endmodule


module add_32
(
input wire [31:0] a,
input wire [31:0] b,
output wire [31:0] s,
output wire c_out,
);

wire [31:0] c_in;
genvar g1;

for (g1 = 0; g1 < 32; g1 = g1 + 1) begin

		if (g1 == 0)
			half_adder half_add(a[0],b[0],s[0],c_in[0]);
		else
			full_adder _add(a[g1],b[g1],c_in[g1-1],s[g1],c_in[g1]);

end


assign c_out = c_in[31];

wire axnb, sxa;
xnor_gate xn1(a[31],b[31],axnb);
xor_gate xo1(a[31],s[31],sxa);

and_gate n5(axnb,sxa,overflow);
zero_check z5(s, zero_flag);


endmodule

module add_5
(
input wire [4:0] a,
input wire [4:0] b,
output wire [4:0] s,
output wire c_out,
);

wire [4:0] c_in;
genvar g1;

for (g1 = 0; g1 < 5; g1 = g1 + 1) begin

		if (g1 == 0)
			half_adder half_add(a[0],b[0],s[0],c_in[0]);
		else
			full_adder _add(a[g1],b[g1],c_in[g1-1],s[g1],c_in[g1]);

end


assign c_out = c_in[4];


endmodule
