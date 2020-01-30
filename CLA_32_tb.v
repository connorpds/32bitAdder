module CLA_32_tb;
	reg [31:0] A;
	reg [31:0] B;
	reg Cin;
	wire [31:0] Sum;
	wire Cout;
	wire ovrflw;

	CLA_32 cla (.a(A), .b(B), .c_in(Cin), .s(Sum), .c_out(Cout),.overflow(ovrflw));

	initial begin
		$monitor("A=%b B=%b, Cin=%b -> Sum=%b, Cout=%b", A, B, Cin, Sum, Cout);

		//Testing the 1st 4-bit CLA
		#100
		A= {32{1'b0}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {{31{1'b0}}, 1'b1};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{31{1'b0}}, 1'b1};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {{31{1'b0}}, 1'b0};
		B= {{31{1'b0}}, 1'b0};
		Cin = 1;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 2nd 4-bit CLA
		#100
		A= {{27{1'b0}}, 1'b1, {4{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{27{1'b0}}, 1'b1, {4{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{27{1'b0}}, 2'b01, {3{1'b0}}};
		B={{27{1'b0}}, 2'b01, {3{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 3rd 4-bit CLA
		#100
		A= {{23{1'b0}}, 1'b1, {8{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{23{1'b0}}, 1'b1, {8{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{23{1'b0}}, 2'b01, {7{1'b0}}};
		B={{23{1'b0}}, 2'b01, {7{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 4th 4-bit CLA
		#100
		A= {{19{1'b0}}, 1'b1, {12{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{19{1'b0}}, 1'b1, {12{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{19{1'b0}}, 2'b01, {11{1'b0}}};
		B={{19{1'b0}}, 2'b01, {11{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 5th 4-bit CLA
		#100
		A= {{15{1'b0}}, 1'b1, {16{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{15{1'b0}}, 1'b1, {16{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{15{1'b0}}, 2'b01, {15{1'b0}}};
		B={{15{1'b0}}, 2'b01, {15{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 6th 4-bit CLA
		#100
		A= {{11{1'b0}}, 1'b1, {20{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{11{1'b0}}, 1'b1, {20{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{11{1'b0}}, 2'b01, {19{1'b0}}};
		B={{11{1'b0}}, 2'b01, {19{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 7th 4-bit CLA
		#100
		A= {{7{1'b0}}, 1'b1, {24{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{7{1'b0}}, 1'b1, {24{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{7{1'b0}}, 2'b01, {23{1'b0}}};
		B={{7{1'b0}}, 2'b01, {23{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end

		//Testing the 8th 4-bit CLA
		#100
		A= {{3{1'b0}}, 1'b1, {28{1'b0}}};
		B= {32{1'b0}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A= {32{1'b0}};
		B= {{3{1'b0}}, 1'b1, {28{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{3{1'b0}}, 2'b01, {27{1'b0}}};
		B={{3{1'b0}}, 2'b01, {27{1'b0}}};
		Cin = 0;
		#100
		if (Sum != A+B+Cin) begin
			$finish(1);
		end
		#100
		A={{1'b1}, {31{1'b0}}};
		B={{1'b1}, {31{1'b0}}};
		Cin = 0;
		#100
		if (Cout != 1) begin
			$finish(1);
		end
		#100
		A = 32'h80000000;
		B = 32'h00000001;
		Cin = 0;
		#100
		Cin = 0;

	end
endmodule
