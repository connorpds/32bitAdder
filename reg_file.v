module reg_file(
	input reg [4:0] rs,
	input reg [4:0] rs2,
	input reg [4:0] rd,
	input reg [31:0] busW,
	input reg clk,
	//Control inputs
	input reg r_type,
	input reg reg_wr,
	input reg reset,
	output wire [31:0] busA,
	output wire [31:0] busB
);

wire [1023:0] reg_out;
wire [31:0] source1;
wire [31:0] source2;
wire [31:0] dest;
wire [31:0] dest_wr_en;
wire rw;



//Determination of destination
mux_n #(5) det_dest(.sel(r_type), .src0(rs2), .src1(rd), .z(rw));

//Decoding of register addresses
decoder_3to8 decode_src1(.in(rs), .out(source1));
decoder_3to8 decode_src2(.in(rs2), .out(source2));
decoder_3to8 decode_dest(.in(rw), .out(dest));
and_32 check_wr_en(.x({32{wr_en}}), .y(dest), .z(dest_wr_en));
//Instantiation of registers
genvar i;
generate
	for (i=0; i < 32; i = i + 1) begin
		register_n register(.clk(clk), .reset(reset), .wr_en(dest_wr_en[i]), .d(busW), .q(reg_out[((32*(i+1))-1):32*i]));
	end
endgenerate

//Assignment of out
