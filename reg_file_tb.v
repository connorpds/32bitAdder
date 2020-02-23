module reg_file_tb;
	reg [4:0] rs;
	reg [4:0] rs2;
	reg [4:0] rd;
	reg [31:0] busW;
	reg clk;
	//Control inputs
	reg r_type;
	reg reg_wr;
	reg reset;
	wire [31:0] busA;
	wire [31:0] busB;

	reg [31:0] i;
	reg_file reg_file_undertest(.rs(rs), .rs2(rs2), .rd(rd), .busW(busW), .clk(clk), .r_type(r_type), .reg_wr(reg_wr), .reset(reset), .busA(busA), .busB(busB));

	initial begin
		$monitor("rs=%h rs2=%h rd=%h busW=%h clk=%b r_type=%b reg_wr=%b reset=%b -> busA=%h busB=%h", rs, rs2, rd, busW, clk, r_type, reg_wr, reset, busA, busB);
		rs = 5'b00000;
		rs2= 5'b00000;
		rd = 5'b00000;
		busW = 32'b0;
		clk = 1'b1;
		r_type = 1'b0;
		reg_wr = 1'b0;
		reset = 1'b1;
		#4
		reset = 1'b0;
		#1
		busW = 32'b1;
		#3
		reg_wr = 1'b1;
		#1
		
		for (i = 5'b00001; i < 5'b11111; i = i + 5'b00001) begin
			#3
			rs = i-1;
			rs2 = i; //as r_type is low, writing to rs2
			#1
			busW = { 27'b0, i };
		end
		#3
		rs = 5'b11110;
		rs2= 5'b11111;
		#1
		busW = 32'b11111;
		#3
		rs=5'b11111;
		#1
		r_type = 1'b1;
		rd = 5'b10;
		busW = 32'b1010101;
		#3
		rs2 = 5'b10;
		#1
		rs= 5'b11;
		$finish(1);

	end

	always
	begin
		#2 clk = ~clk;
	end

endmodule
