
//n-bit register with write enable and synchronous reset
module register_n_pipe(clk, reset, wr_en, d, q);
// synopsys template
	parameter n = 32;

	input wire clk;
	input wire reset;//synchronous
	input wire wr_en;
	input wire [n-1:0] d;
	output wire [n-1:0] q;

//wire for gating d with reset
wire [n-1:0] data_in;

//wire for gating clock
wire [n-1:0] clk_0, clk_1, clk_in;

genvar i;
generate
for(i = 0; i < n; i = i + 1) begin:genRegn


	//create the register_32
	dff d0(clk, d[i], wr_en, reset, q[i]);

end
endgenerate



endmodule
