`include "/lib/mux_32.v"
`include "/shift_ops.v"

module multu(
	reg [31:0] A;
	reg [31:0] B;
	reg clk;
	wire [31:0] Out;
);

wire [31:0] mp_out; // Multiplicand out
wire [63:0] prod_out; // Product register out
wire [31:0] adder_out;
wire [31:0] adder_in;
wire [63:0] shifted_prod;
wire [63:0] add_shift_out;
wire [63:0] prod_in;
wire add0;
wire a_s;
wire prod_en;

// Map control
multu_cont control(.add0(add0), .a_s(a_s), .prod_en(prod_en))

// Perform add 
mux_32 det_adder_in(.sel(add0), .src1(32'b0), .src0(mp_out), .z(adder_in));
CLA_32 adder(.A(mp_out), .B(prod_out[63:32]), .c_in(1'b0), .s(adder_out), .c_out(0), .overflow(1'b0));

// Determine input to product reg
srl_64 shifted_prod(.A(prod_out), .B(64'b1), .out(shifted_prod));
mux_n #(64) (.sel(a_s), .src0( {adder_out, prod_out[31:0]} ), src1( shifted_prod ), .z( add_shift_out ) );
mux_n #(64) (.sel(prod_en), .src0(add_shift_out), .src1({32'b0, B}), .z(prod_in));

//Registers
register_n #(64) product_reg( .clk(clk), .reset(1'b0), .wr_en(1'b1), .d(prod_out), .q(prod_in) );
register_n #(32) mp_reg( .clk(clk), .reset(1'b0), .wr_en(1'b1), .d(A), .q(mp_out));

endmodule