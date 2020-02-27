module inst_fetch_tb;
	//reg [31:0] a,
	reg [15:0] imm16;
	reg [25:0] jmp_imm26;
	reg [31:0] reg_imm32;
	reg clk;
	//Control inputs
	reg branch;
	reg jmp;
	reg jmp_r;
	reg reset;
	wire [31:0] pc;

	inst_fetch fetch_undertest (.imm16(imm16), .jmp_imm26(jmp_imm26), .reg_imm32(reg_imm32), .jmp_r(jmp_r), .clk(clk), .branch(branch), .jmp(jmp), .reset(reset), .pc(pc));

	initial begin
		$monitor("imm16=%h, jmp_imm26=%h, clk=%b, branch=%b, jmp=%b, reset=%b -> pc=%h", imm16, jmp_imm26, clk, branch, jmp, reset, pc);
		imm16 = 16'b00;
		jmp_imm26 = 26'b0;
		reset=1'b1;
		clk=1'b1;
		jmp=1'b0;
		jmp_r=1'b0;
		branch=1'b0;
		#4
		reset=1'b0;
		#4
		#4
		imm16=16'b100;
		branch=1'b1;
		#4
		branch=1'b0;
		#4
		branch=1'b1;
		imm16=16'b1111111111110000;
		#4
		branch=1'b0;
		jmp_imm26=26'b100;
		jmp=1'b1;
		#4
		jmp_imm26=26'b11111111111111111111110000;
		#4
		jmp=1'b0;
		$finish(1);

	end

	always
	begin
		#2 clk = ~clk;
	end

endmodule
