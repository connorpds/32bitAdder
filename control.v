`include "add_32_lookahead.v"
`include "register_n.v"
`include "lib/mux_n.v"
`include "lib/mux_32.v"

module control(
	//input reg [31:0] a,
	input wire [31:0] instruction,
	output reg mem_wr,
	output reg reg_wr,
	output reg r_type,
	output reg branch_inst,
	output reg jmp,
	output reg imm_inst,
	output reg mem_to_reg
);

always @ *

endmodule