module alu_32(
	input wire [31:0] A,
	input wire [31:0] B,
	input wire [5:0] opcode,
	output reg [31:0] out
);

wire[31:0] B_inv;
wire[31:0] B_adder;
wire[31:0] adder_out;
wire[31:0] and_out;
wire[31:0] or_out;
wire[31:0] xor_out;
wire[31:0] sll_out;
wire[31:0] srl_out;
wire[31:0] sra_out;
wire[31:0] seq_out;
wire[31:0] sne_out;
wire[31:0] slt_out;
wire[31:0] sgt_out;
wire[31:0] sle_out;
wire[31:0] sge_out;

wire c_out;
wire c_in;
wire zero_flag;
wire not_zero_flag;
wire add_opcode;
wire addi_opcode;
wire doing_add;
wire overflow;

//Determine inputs to the adder
xnor_gate_6to1 determine_add(.x(opcode), .y(6'b100000), .z(add_opcode));
xnor_gate_6to1 determine_addi(.x(opcode), .y(6'b100001), .z(addi_opcode));
or_gate det_add(.x(add_opcode), .y(addi_opcode), .z(doing_add));


not_gate_32 b_inverter(.x(B), .z(B_inv));
mux_32 b_mux(.sel(doing_add), .src0(B_inv), .src1(B), .z(B_adder));
mux c_in_mux(.sel(doing_add), .src0(1'b1), .src1(1'b0), .z(c_in));

//Perform add/subtract
CLA_32 adder(.a(A), .b(B_adder), .c_in(c_in), .s(adder_out), .c_out(c_out), .overflow(overflow));
zero_check zero(.value(adder_out), .zero_flag(zero_flag));
not_gate not_zero(.x(zero_flag), .z(not_zero_flag));

//Shifters
sll_32 sll(.A(A), .B(B), .out(sll_out));
srl_32 srl(.A(A), .B(B), .out(srl_out));
sra_32 sra(.A(A), .B(B), .out(sra_out));

//Logical ops
and_gate_32 andfunc(.x(A), .y(B), .z(and_out));
or_gate_32 orfunc(.x(A), .y(B), .z(or_out));
xor_gate_32 xorfunc(.x(A), .y(B), .z(xor_out));

//Set-ifs
seq seq_op(.zf(zero_flag), .seq(seq_out));
sne sne_op(.nz(not_zero_flag), .sne(sne_out));
slt slt_op(.a(adder_out), .slt(slt_out));
sgt sgt_op(.nz(not_zero_flag),.a(adder_out), .sgt(sgt_out));
sle	sle_op(.zf(zero_flag), .a(adder_out), .sle(sle_out));
sge sge_op(.a(adder_out), .sge(sge_out));

//MUX at the end for op selection, based off of DLX ALU func codes
always @*
	case (opcode)
		6'b000100 : out = sll_out; //SLL, 0x4
		6'b000110 : out = srl_out; //SRL, 0x6
		6'b000111 : out = sra_out; //SRA, 0x7
		6'b100000 : out = adder_out; //ADD 0x20
		6'b100001 : out = adder_out; //ADDI 0x21
		6'b100010 : out = adder_out; //SUB 0x22
		6'b100100 : out = and_out; //AND 0x24
		6'b100101 : out = or_out; //OR 0x25
		6'b100110 : out = xor_out; //XOR 0x26
		6'b101000 : out = seq_out; //SEQ 0x28
		6'b101001 : out = sne_out; //SNE 0x29
		6'b101010 : out = slt_out; //SLT 0x2a
		6'b101011 : out = sgt_out; //SGT 0x2b
		6'b101100 : out = sle_out; //SLE 0x2c
		6'b101101 : out = sge_out; //SGE 0x2d
		default		: out = adder_out;
		//6'b001110 : out = //MUL 0x0e
	endcase
endmodule
