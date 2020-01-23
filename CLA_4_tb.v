module CLA_4_tb;
	reg [3:0] A;
	reg [3:0] B;
	reg Cin;
	wire [3:0] Sum;
	wire Cout;
	reg [3:0] i;
	reg [3:0] j;
	wire c3;

	CLA_4 cla (.a(A), .b(B), .c_in(Cin), .s(Sum), .c_out(Cout),.c3(c3));

	initial begin
		$monitor("A=%b B=%b, Cin=%b -> Sum=%b, Cout=%b", A, B, Cin, Sum, Cout);

		for(i = 4'b0000; i < 4'b1111; i = i + 4'b0001) begin
			for (j = 4'b0000; j < 4'b1111; j = j + 4'b0001) begin
				#100
				A = i; B=j; Cin=1'b0;
				#100
				if (Sum != A+B) begin
				   $finish(1);
				end
				#100
				Cin = 1'b1;
				#100
				if (Sum != A+B+Cin) begin
				   $finish(1);
				end
			end
		end
	end
endmodule
