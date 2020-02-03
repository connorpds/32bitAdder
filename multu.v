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
wire add0;

//Perform add 
mux_32 det_adder_in(.sel(add0), .src1(32'b0), .src0(mp_out), .z(adder_in))
CLA_32 adder(.A(mp_out), .B(prod_out[63:32]), .c_in(1'b0), .s(adder_out), .c_out(0), .overflow(1'b0))

//

//Registers
register_n #(64) product_reg( .clk(clk), .reset(1'b0), .wr_en(1'b1), .d(prod_out), .q( {adder_out, 
register_n #(32) mp_reg( .clk(clk), .reset(1'b0), .wr_en(1'b1)

