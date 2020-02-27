
module mult(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire clk,
	//Control inputs
	input wire doMult,
	input wire reset,
	output wire [31:0] out,
	output wire mult_done
);

wire [31:0] mp_out; // Multiplicand out
wire [31:0] mp_out_not;
wire [63:0] prod_out; // Product register out
wire [31:0] adder_out;
wire [31:0] potential_adder_in;
wire [31:0] adder_in;
wire [63:0] shifted_prod;
wire [63:0] add_shift_out;
wire [63:0] prod_in;
wire cin;
wire add0; // add0=1 -> add 0 to product reg
wire a_s; // a_s = 0 -> perform add, otherwise shift
wire prod_en; // enable product register loading from outside world
wire doSub; // dosub == 0 -> perform add, otherwise subtract

// Map control
mult_control control(.doMult(doMult), .sysClk(clk), .mClk(clk), .reset(reset), .add0(add0), .a_s(a_s), .doSub(doSub), .combined_reset(prod_en), .mult_done(mult_done), .prod_LSB(prod_out[0]));

// setup for add
not_gate_32 mp_not(.x(mp_out), .z(mp_out_not));
mux_32 det_addorsub(.sel(doSub), .src0(mp_out), .src1(mp_out_not), .z(potential_adder_in));
mux_32 det_adder_in(.sel(add0), .src0(potential_adder_in), .src1(32'b0), .z(adder_in));
mux det_cin(.sel(doSub), .src0(1'b0), .src1(1'b1), .z(cin));

//Do add
CLA_32 adder(.a(adder_in), .b(prod_out[63:32]), .c_in(cin), .s(adder_out), .c_out(), .overflow());

// Determine input to product reg
srl_64 shifted_prod0(.A(prod_out), .B(64'b1), .out(shifted_prod));
mux_n #(64) shift_mux(.sel(a_s), .src0( {adder_out, prod_out[31:0]} ), .src1( shifted_prod ), .z( add_shift_out ));
mux_n #(64) load_mux(.sel(prod_en), .src0(add_shift_out), .src1({32'b0, b}), .z(prod_in));

//Registers
register_n #(64) product_reg( .clk(clk), .reset(1'b0), .wr_en(1'b1), .d(prod_in), .q(prod_out) );
register_n #(32) mp_reg( .clk(clk), .reset(1'b0), .wr_en(prod_en), .d(a), .q(mp_out));

assign out = prod_out;

endmodule
