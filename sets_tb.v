`timescale 1ns/1ns
module sets_tb;
	reg [31:0] A;
	reg zf;
	reg nz;
	reg dummy;
	wire [31:0] slt_out;
	wire [31:0] seq_out;
	wire [31:0] sne_out;
	wire [31:0] sgt_out;
	wire [31:0] sle_out;
	wire [31:0] sge_out;

	slt slt(.a(A), .slt(slt_out));
	seq seq(.zf(zf), .seq(seq_out));
	sne sne(.nz(nz), .sne(sne_out));
	sgt sgt(.nz(nz), .a(A), .sgt(sgt_out));
	sle sle(.zf(zf), .a(A), .sle(sle_out));
	sge sge(.a(A), .sge(sge_out));

	initial begin
		$monitor("A=%b -> slt_out=%b, seq_out=%b, sne_out=%b, sgt_out=%b, sle_out=%b, sge_out=%b", A, slt_out,seq_out,sne_out,sgt_out,sle_out,sge_out);


		//A0
		A = 32'h00000000; zf = 1; nz = 0;
		#10
		//A+
		A = 32'h00000001; zf = 0; nz = 1;
		#10
		//A-
		A = 32'hFFFFFFFF; zf=0; nz = 1;
		#10
		dummy = 0;
		end
endmodule
