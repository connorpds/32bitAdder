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
//decoder_3to8 decode_src1(.in(rs), .out(source1));
//decoder_3to8 decode_src2(.in(rs2), .out(source2));
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
always @ *
	case(rs)
		5b'00000: busA = reg_out[31:0];
		5b'00001: busA = reg_out[63:32];
		5b'00010: busA = reg_out[95:64];
		5b'00011: busA = reg_out[127:96];
		5b'00100: busA = reg_out[159:128];
		5b'00101: busA = reg_out[191:160];
		5b'00110: busA = reg_out[223:192];
		5b'00111: busA = reg_out[255:224];
		5b'01000: busA = reg_out[287:256];
		5b'01001: busA = reg_out[319:288];
		5b'01010: busA = reg_out[351:320];
		5b'01011: busA = reg_out[383:352];
		5b'01100: busA = reg_out[415:384];
		5b'01101: busA = reg_out[447:416];
		5b'01110: busA = reg_out[479:448];
		5b'01111: busA = reg_out[511:480];
		5b'10000: busA = reg_out[543:512];
		5b'10001: busA = reg_out[575:544];
		5b'10010: busA = reg_out[607:576];
		5b'10011: busA = reg_out[639:608];
		5b'10100: busA = reg_out[671:640];
		5b'10101: busA = reg_out[703:672];
		5b'10110: busA = reg_out[735:704];
		5b'10111: busA = reg_out[767:736];
		5b'11000: busA = reg_out[799:768];
		5b'11001: busA = reg_out[831:800];
		5b'11010: busA = reg_out[863:832];
		5b'11011: busA = reg_out[895:864];
		5b'11100: busA = reg_out[927:896];
		5b'11101: busA = reg_out[959:928];
		5b'11110: busA = reg_out[991:960];
		5b'11111: busA = reg_out[1023:992];
		default: busA = reg_out[31:0];
	endcase
	
always @ *
	case(rs2)
		5b'00000: busB = reg_out[31:0];
		5b'00001: busB = reg_out[63:32];
		5b'00010: busB = reg_out[95:64];
		5b'00011: busB = reg_out[127:96];
		5b'00100: busB = reg_out[159:128];
		5b'00101: busB = reg_out[191:160];
		5b'00110: busB = reg_out[223:192];
		5b'00111: busB = reg_out[255:224];
		5b'01000: busB = reg_out[287:256];
		5b'01001: busB = reg_out[319:288];
		5b'01010: busB = reg_out[351:320];
		5b'01011: busB = reg_out[383:352];
		5b'01100: busB = reg_out[415:384];
		5b'01101: busB = reg_out[447:416];
		5b'01110: busB = reg_out[479:448];
		5b'01111: busB = reg_out[511:480];
		5b'10000: busB = reg_out[543:512];
		5b'10001: busB = reg_out[575:544];
		5b'10010: busB = reg_out[607:576];
		5b'10011: busB = reg_out[639:608];
		5b'10100: busB = reg_out[671:640];
		5b'10101: busB = reg_out[703:672];
		5b'10110: busB = reg_out[735:704];
		5b'10111: busB = reg_out[767:736];
		5b'11000: busB = reg_out[799:768];
		5b'11001: busB = reg_out[831:800];
		5b'11010: busB = reg_out[863:832];
		5b'11011: busB = reg_out[895:864];
		5b'11100: busB = reg_out[927:896];
		5b'11101: busB = reg_out[959:928];
		5b'11110: busB = reg_out[991:960];
		5b'11111: busB = reg_out[1023:992];
		default: busB=reg_out[31:0];
	endcase

endmodule
		
		