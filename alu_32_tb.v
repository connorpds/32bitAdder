module alu_32_tb;
	reg [31:0] A;
	reg [31:0] B;
	reg [5:0] opcode;
	reg [31:0] out;
	
	alu_32 alu(.A(a), .B(B), .opcode(opcode), .out(out))
	
	initial begin
		$monitor("A=%b B=%b, opcode=%b -> out=%b", A, B, opcode, out);
		
		//Testing SLL
		#100
		A = 32'b1;
		B = 32'b1;
		opcode = 6'b000100;
		#100
		if (out != A << B) begin
			$finish(1);
		end
		
		//Testing SRL
		#100
		A = 32'b10;
		B = 32'b1;
		opcode = 6'b000110;
		#100
		if (out != A >> B) begin
			$finish(1);
		end
		
		//Testing SRA
		#100
		A={{1'b1}, {31{1'b0}}};
		B = 32'b1;
		opcode = 6'b000111;
		#100
		if (out != A >>> B) begin
			$finish(1);
		end
		
		//Testing ADD
		#100
		A={{1'b1}, {31{1'b0}}};
		B = 32'b1;
		opcode = 6'b100000;
		#100
		if (out != A + B) begin
			$finish(1);
		end
		
		//Testing SUB
		#100
		A={{1'b1}, {31{1'b0}}};
		B = 32'b1;
		opcode = 6'b100010;
		#100
		if (out != A - B) begin
			$finish(1);
		end
		
		//Testing AND
		#100
		A=32'b101;
		B = 32'b1;
		opcode = 6'b100100;
		#100
		if (out != 32'b1) begin
			$finish(1);
		end
		
		//Testing OR
		#100
		A=32'b101;
		B = 32'b1;
		opcode = 6'b100101;
		#100
		if (out != 32'b101) begin
			$finish(1);
		end
		
		//Testing XOR
		#100
		A=32'b101;
		B = 32'b1;
		opcode = 6'b100110;
		#100
		if (out != 32'b100) begin
			$finish(1);
		end
		
		//Testing SEQ
		#100
		A=32'b101;
		B = 32'b101;
		opcode = 6'b101000;
		#100
		if (out != 32'b1) begin
			$finish(1);
		end
		
		//Testing SNE
		#100
		A=32'b101;
		B = 32'b101;
		opcode = 6'b101001;
		#100
		if (out != 32'b0) begin
			$finish(1);
		end
		
		//Testing SLT
		#100
		A=32'b101;
		B = 32'b01;
		opcode = 6'b101010;
		#100
		if (out != 32'b0) begin
			$finish(1);
		end
		
		//Testing SGT
		#100
		A=32'b101;
		B = 32'b01;
		opcode = 6'b101011;
		#100
		if (out != 32'b1) begin
			$finish(1);
		end
		
		//Testing SLE
		#100
		A=32'b101;
		B = 32'b101;
		opcode = 6'b101100;
		#100
		if (out != 32'b1) begin
			$finish(1);
		end
		
		//Testing SGE
		#100
		A=32'b101;
		B = 32'b101;
		opcode = 6'b101101;
		#100
		if (out != 32'b1) begin
			$finish(1);
		end