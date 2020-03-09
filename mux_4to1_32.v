
//n-bit register with write enable and synchronous reset
module mux_4to1_32
(
	input wire [1:0] sel,
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [31:0] c,
	input wire [31:0] d,
	output wire [31:0] out
);

wire [31:0] a_or_b;
wire [31:0] c_or_d;

mux_32 choose_a_b(.sel(sel[0]), .src0(a), .src1(b), .z(a_or_b));
mux_32 choose_c_d(.sel(sel[0]), .src0(c), .src1(d), .z(c_or_d));
mux_32 choose_final(.sel(sel[1]), .src0(a_or_b), .src1(c_or_d), .z(out));


endmodule
