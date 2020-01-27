
module alu_32(
	input wire [31:0] A, 
	input wire [31:0] B,
	input wire [5:0] opcode,
	output reg [31:0] out
);

wire[31:0] B_inv;
wire[31:0] B_adder;
wire[31:0] and_out;
wire[31:0] or_out;
wire[31:0] xor_out;

wire c_out;
wire c_in;
wire c_in_sel;
wire overflow;

//Determine inputs to the adder
not_gate_32 b_inverter(.x(B), .z(B_inv));
mux_32 b_sel(.sel(B_sel), .src0(B), .src1(B_inv), .z(B_adder));
mux (.sel(c_in_sel), .src0(1'b0), .src1(1'b1), .z(c_in));

//Perform add/subtract
CLA_32 adder(.a(A), .b(B_adder), .c_in(c_in), .s(adder_out), .c_out(c_out), .overflow(overflow));

//Shifters


//Logical ops
and_gate_32 andfunc(.x(A), .y(B), .z(and_out));
or_gate_32 orfunc(.x(A), .y(B), .z(or_out));
xor_gate_32 xorfunc(.x(A), .y(B), .z(xor_out));

//Set-ifs

//MUX at the end for op selection, based off of DLX ALU func codes
always @ ( A OR B OR opcode )
	case (opcode)
		6'b100 : out = //SLL
		6'b110 : out = //SRL
		6'b111 : out = //SRA
		6'b100000 : out = adder_out; //ADD
		6'b100010 : out = adder_out; //SUB
		6'b100100 : out = and_out; //AND
		6'b100101 : out = or_out; //OR
		6'b100110 : out = xor_out; //XOR
		6'b101000 : out = //SEQ
		6'b101001 : out = //SNE
		6'b101010 : out = //SLT
		6'b101011 : out = //SGT
		6'b101100 : out = //SLE
		6'b101101 : out = //SGE
		//6'b001110 : out = //MUL
	endcase
end module		
		

	