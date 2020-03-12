module multu_tb;
	reg [31:0] A;
	reg [31:0] B;
	reg clk;
	//Control inputs
	reg doMult;
	reg reset;
	wire mult_done;
	wire [31:0] Out;
	reg dummy;

	multu mult_undertest (.a(A), .b(B), .clk(clk), .doMult(doMult), .reset(reset),.out(Out), .mult_done(mult_done));

	initial begin
		$monitor("A=%b B=%b, clk=%b -> doMult=%b, reset=%b, Out=%b, mult_done=%b", A, B, clk, doMult, reset, Out, mult_done);
		A = 32'h17;
		B = 32'h3;
		reset=1'b1;
		clk=1'b1;
		#4
		doMult = 1'b1;
		reset = 1'b0;
		#4
		doMult = 1'b0;
		#256
		//should now be done
		dummy = 1'b0;

		A = 32'h03;
		B = 32'h69;
		clk=1'b1;
		#4
		doMult = 1'b1;
		#4
		doMult = 1'b0;
		#256
		//should now be done
		dummy = 1'b0;


	end

	always
	begin
		#2 clk = ~clk;
	end

endmodule
