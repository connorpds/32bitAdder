
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
wire[31:0] sll_out;
wire[31:0] srl_out;
wire[31:0] sra_out;

wire c_out;
wire c_in;
wire add_opcode;
wire overflow;

//Determine inputs to the adder
xnor_gate_6to1 determine_add(.x(opcode), .y(6b'100000), .z(add_opcode));
not_gate_32 b_inverter(.x(B), .z(B_inv));
mux_32 b_mux(.sel(add_opcode), .src0(B_inv), .src1(B), .z(B_adder));
mux c_in_mux(.sel(add_opcode), .src0(1'b1), .src1(1'b0), .z(c_in));

//Perform add/subtract
CLA_32 adder(.a(A), .b(B_adder), .c_in(c_in), .s(adder_out), .c_out(c_out), .overflow(overflow));

//Shifters
sll_32 sll(.A(A), .B(B), .out(sll_out));
srl_32 srl(.A(A), .B(B), .out(srl_out));
sra_32 sra(.A(A), .B(B), .out(sra_out));

//Logical ops
and_gate_32 andfunc(.x(A), .y(B), .z(and_out));
or_gate_32 orfunc(.x(A), .y(B), .z(or_out));
xor_gate_32 xorfunc(.x(A), .y(B), .z(xor_out));

//Set-ifs



//MUX at the end for op selection, based off of DLX ALU func codes
always @ ( A OR B OR opcode )
	case (opcode)
		6'b100 : out = sll_out //SLL
		6'b110 : out = srl_out //SRL
		6'b111 : out = sra_out //SRA
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
		

	