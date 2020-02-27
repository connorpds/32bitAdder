
module write_back(
	input wire [31:0] mem_out,
	input wire [31:0] ALU_out,
	input wire [31:0] PC,
	input wire [15:0] imm16,
	input wire mem_to_reg,
	input wire lhi,
	input wire link,
	input wire lb,
	input wire lh,
	input wire load_extend,
	output reg [31:0] WB_out
);

wire [31:0] mem_out_lb;
wire [31:0] mem_out_lh;
wire [31:0] det_lb_out;
wire [31:0] det_lh_out;
wire [31:0] det_ALU_out;
wire [31:0] det_PC_out;
wire [31:0] WB_out_temp;
wire [31:0] PC_plus_8;

//Calculate PC+8 for jumping and linking to store in R31
CLA_32 incr4_calc(.a(PC), .b(32'b1000), .c_in(1'b0), .s(PC_plus_8), .c_out(),.overflow());

//Prepare the lb and lh versions of mem_out
extend #(8) lb_extend(.ext_op(load_extend), .in(mem_out[7:0]), .out(mem_out_lb));
extend #(16) lh_extend(.ext_op(load_extend), .in(mem_out[15:0]), .out(mem_out_lh));

//Decide on version of mem_out
mux_32 det_lb(.sel(lb), .src0(mem_out), .src1(mem_out_lb), .z(det_lb_out));
mux_32 det_lh(.sel(lh), .src0(det_lb_out), .src1(mem_out_lh), .z(det_lh_out));

//Decide if using mem_out, ALU_out, PC, or extended imm16
mux_32 det_ALU(.sel(mem_to_reg), .src0(ALU_out), .src1(det_lh_out), .z(det_ALU_out));
mux_32 det_PC(.sel(link), .src0(det_ALU_out), .src1(PC_plus_8), .z(det_PC_out));
mux_32 det_imm16(.sel(lhi), .src0(det_PC_out), .src1( { imm16, 16'b0} ), .z(WB_out_temp));

always @ *
	WB_out = WB_out_temp;

endmodule
