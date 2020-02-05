module CLA_32_tb;
	reg [31:0] A;
	reg [31:0] B;
	reg clk;
	//Control inputs
	reg doMult;
	reg reset;
	reg mult_done;
	wire [31:0] Out;
	
	multu mult_undertest (.a(A), .b(B), .clk(clk), .doMult(doMult), .reset(reset),.Out(Out), mult_done(mult_done));

	initial begin
		$monitor("A=%b B=%b, clk=%b -> doMult=%b, reset=%b, Out=%b, mult_done=%b", A, B, clk, doMult, reset, Out, mult_done);
		A = 32'b1
		B = 32'b101
		reset=1'b1
		clk=1'b1
		#4
		doMult = 1'b1
		#4
		doMult = 1'b0
		#256
		//should now be done
		#4
		
	end
	
	always
	begin
		#2 clk = ~clk
	end

endmodule
