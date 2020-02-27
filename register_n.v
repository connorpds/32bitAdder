
//n-bit register with write enable and synchronous reset
module register_n
#(
	parameter integer n = 32
)
(
	input wire clk,
	input wire reset,//synchronous
	input wire wr_en,
	input wire [n-1:0] d,
	output wire [n-1:0] q
);

//wire for gating d with reset
wire [n-1:0] data_in;

//wire for gating clock
wire [n-1:0] clk_0, clk_1, clk_in;

genvar i;
for(i = 0; i < n; i = i + 1) begin

	//Assign the data in line
	and_gate and1(d[i], !reset, data_in[i]);

	//Assign clk_0 and clk_1
	and_gate and2(clk, wr_en, clk_0[i]);
	and_gate and3(reset, clk, clk_1[i]);

	//Assign final clock input
	or_gate or1(clk_0[i], clk_1[i], clk_in[i]);

	//create the register_32
	dffr d0(clk_in[i], data_in[i], q[i]);

end




endmodule
