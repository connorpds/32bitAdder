
module inst_fetch(
	//input reg [31:0] a,
	input wire [15:0] imm16,
	input wire [25:0] jmp_imm26,
	input wire [31:0] reg_imm32, //value from register file
	input wire clk,
	//Control inputs
	input wire branch,
	input wire jmp,
	input wire jmp_r,
	input wire reset,
	input wire pc_enable,
	output reg [31:0] pc
);

wire [31:0] pc_out;
wire [31:0] pc_in;
wire [31:0] incr4_addr;
wire [31:0] jmp_addr;
wire [31:0] branch_addr;
wire [5:0] jmp_sign_extend;
wire [15:0] branch_sign_extend;
wire [31:0] temp_w_jump;
wire [31:0] temp_w_branch;
wire [31:0] temp_w_reg;


not_gate reset_not_gate(.x(reset), .z(reset_not));
and_gate true_pc_enable(.x(pc_enable), .y(reset_not), .z(pc_enable_full));
register_n PC_reg(.clk(clk), .reset(reset), .wr_en(pc_enable), .d(pc_in), .q(pc_out) );

//Adders to compute possible next addresses
CLA_32 incr4_calc(.a(pc_out), .b(32'b100), .c_in(1'b0), .s(incr4_addr), .c_out(),.overflow());

//Deprecated as of pipeline -- this addition happens as a natural result of pipelinings
CLA_32 branch_calc(.a(pc_out), .b({branch_sign_extend, imm16}), .c_in(1'b0), .s(branch_addr), .c_out(),.overflow());
CLA_32 jmp_calc(.a(pc_out), .b({jmp_sign_extend, jmp_imm26}), .c_in(1'b0), .s(jmp_addr), .c_out(),.overflow());

//Sign extenders for immediate and jump addresses
mux_n #(6) jmp_extend_mux(.sel(jmp_imm26[25]), .src0(6'b000000), .src1(6'b111111), .z(jmp_sign_extend));
mux_n #(16) branch_extend_mux(.sel(imm16[15]), .src0(16'b0), .src1(16'b1111111111111111), .z(branch_sign_extend));

//Combinational logic to determine pc_in
mux_32 det_jmp (.sel(jmp), .src0(incr4_addr), .src1(jmp_addr), .z(temp_w_jump));
mux_32 det_branch (.sel(branch), .src0(temp_w_jump), .src1(branch_addr), .z(temp_w_branch));
mux_32 det_jmp_r (.sel(jmp_r), .src0(temp_w_branch), .src1(reg_imm32), .z(temp_w_reg));
mux_32 startup_freeze(.sel(reset), .src0(temp_w_reg), .src1(32'b0), .z(pc_in));

always @*
	pc <= pc_out; // continuous assign so we can have internal wire and output

endmodule
