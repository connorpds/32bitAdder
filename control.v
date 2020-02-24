`include "add_32_lookahead.v"
`include "register_n.v"
`include "lib/mux_n.v"
`include "lib/mux_32.v"

//Probably new signals needed
// -sign extend on load for signed / unsigned
// -jump on register
// - func on branches?
module control(
	//input reg [31:0] a,
	input wire [31:0] inst,
	output reg mem_wr,
	output reg reg_wr,
	output reg r_type,
	output reg branch_inst,
	output reg jmp,
	output reg imm_inst, //should ALU use imm or register busB
	output reg zero_extend, //need to zero extend i-type logical functions
	output reg mem_to_reg,
	output reg func_code, //needs to be over-rideable
);

//Setting mem_wr
always @ *
	case(inst[31:26])
		6'h28: mem_wr = 1'b1; //SB
		6'h29: mem_wr = 1'b1; //SH
		6'h2b: mem_wr = 1'b1; //SW
		default: mem_wr = 1'b0;
	endcase

//Setting reg_wr
always @ *
	case(inst[31:26])
		5'h2: jmp=1'b1; //J
		//5'h3: jmp=1'b1; //JAL -- pretty sure the "link" part requires writing to reg
		6'h4: reg_wr = 1'b0; //BEQZ
		6'h5: reg_wr = 1'b0; //BNEZ
		6'h28: reg_wr = 1'b0; //SB
		6'h29: reg_wr = 1'b0; //SH
		6'h2b: reg_wr = 1'b0; //SW
		default: reg_wr = 1'b0;
	endcase
		
//Setting r_type
always @ * 
	case(inst[31:26])
		6'h0: r_type = 1'b1; //ALU op
		6'h1: r_type = 1'b1; //FP op
		default: r_type = 1'b0;
	endcase

//Setting branch_inst
always @ *
	case(inst[31:26])
		6'h4: branch_inst = 1'b1; //BEQZ
		6'h5: branch_inst = 1'b1; //BNEZ
		default: branch_inst = 1'b0;
	endcase

//Setting jmp
always @ *
	case(inst[31:26])
		5'h2: jmp=1'b1; //J
		5'h3: jmp=1'b1; //JAL
		default: jmp=1'b0;
	endcase
	
//Setting imm_inst
always @ * 
	case(inst[31:26])
		6'h0: imm_inst = 1'b0; //ALU op
		6'h1: imm_inst = 1'b0; //FP op
		default: r_type = 1'b1;
	endcase
	
//Setting zero_extend
always @ * 
	case(inst[31:26])
		6'hc: zero_extend=1'b1; //ANDI
		6'hd: zero_extend=1'b1; //ORI
		6'he: zero_extend=1'b1; //XORI
		default: zero_extend=1'b0;
	endcase
	
//Setting mem_to_reg
always @ *
	case(inst[31:26])
		6'h20: mem_to_reg=1'b1; //LB
		6'h21: mem_to_reg=1'b1; //LH
		6'h23: mem_to_reg=1'b1; //LW
		6'h24: mem_to_reg=1'b1; //LBU
		6'h25: mem_to_reg=1'b1; //LHU
		default: mem_to_reg=1'b0;
	endcase

//setting func_code
always @ *
	case(inst[31:26])
		6'h8: func_code = 6'h20; //ADDI
		6'h9: func_code = 6'h21; //ADDUI
		6'ha: func_code = 6'h22; //SUBI
		6'hb: func_code = 6'h23; //SUBUI
		6'hc: func_code = 6'h24; //ANDI
		6'hd: func_code = 6'h25; //ORI
		6'he: func_code = 6'h26; //XORI
		6'h14: func_code = 6'h4; //SLLI
		6'h16: func_code = 6'h6; //SRLI
		6'h17: func_code = 6'h7; //SRAI
		6'h18: func_code = 6'h28; //SEQI
		6'h19: func_code = 6'h29; //SNEI
		6'h1a: func_code = 6'h2a; //SLTI
		6'h1b: func_code = 6'h2b; //SGTI
		6'h1c: func_code = 6'h2c; //SLEI
		6'h1d: func_code = 6'h2d; //SGEI
	default: func_code = 6'h22; //Performing subtraction by default
endmodule