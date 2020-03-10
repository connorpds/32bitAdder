
module reg_file(
	input wire [4:0] rs,
	input wire [4:0] rs2,
	input wire [4:0] rd,
	input wire [31:0] busW,
	input wire clk,
	//Control inputs
	input wire r_type,  // Controls register write destination; if 0 busW->rs2, if 1 busW->rd
	input wire reg_wr,
	input wire reset,
	output reg [31:0] busA,
	output reg [31:0] busB
);

wire [1023:0] reg_out;
wire [31:0] source1;
wire [31:0] source2;
wire [31:0] dest;
wire [31:0] dest_wr_en;
wire [4:0] rw;



//Determination of destination
mux_n #(5) det_dest(.sel(r_type), .src0(rs2), .src1(rd), .z(rw));

//Decoding of register addresses
//decoder_5to32 decode_src1(.in(rs), .out(source1));
//decoder_5to32 decode_src2(.in(rs2), .out(source2));
decoder_5to32 decode_dest(.in(rw), .out(dest));
and_gate_32 check_wr_en(.x({{31{reg_wr}}, 1'b0 }), .y(dest), .z(dest_wr_en));

//Instantiation of registers
genvar i;
generate
	for (i=0; i < 32; i = i + 1) begin:genRegFile
		register_n register(.clk(clk), .reset(reset), .wr_en(dest_wr_en[i]), .d(busW), .q(reg_out[((32*(i+1))-1):32*i]));
	end
endgenerate

//Assignment of out
always @ *
	case(rs)
		5'b00000: busA = reg_out[31:0];
		5'b00001: busA = reg_out[63:32];
		5'b00010: busA = reg_out[95:64];
		5'b00011: busA = reg_out[127:96];
		5'b00100: busA = reg_out[159:128];
		5'b00101: busA = reg_out[191:160];
		5'b00110: busA = reg_out[223:192];
		5'b00111: busA = reg_out[255:224];
		5'b01000: busA = reg_out[287:256];
		5'b01001: busA = reg_out[319:288];
		5'b01010: busA = reg_out[351:320];
		5'b01011: busA = reg_out[383:352];
		5'b01100: busA = reg_out[415:384];
		5'b01101: busA = reg_out[447:416];
		5'b01110: busA = reg_out[479:448];
		5'b01111: busA = reg_out[511:480];
		5'b10000: busA = reg_out[543:512];
		5'b10001: busA = reg_out[575:544];
		5'b10010: busA = reg_out[607:576];
		5'b10011: busA = reg_out[639:608];
		5'b10100: busA = reg_out[671:640];
		5'b10101: busA = reg_out[703:672];
		5'b10110: busA = reg_out[735:704];
		5'b10111: busA = reg_out[767:736];
		5'b11000: busA = reg_out[799:768];
		5'b11001: busA = reg_out[831:800];
		5'b11010: busA = reg_out[863:832];
		5'b11011: busA = reg_out[895:864];
		5'b11100: busA = reg_out[927:896];
		5'b11101: busA = reg_out[959:928];
		5'b11110: busA = reg_out[991:960];
		5'b11111: busA = reg_out[1023:992];
		default: busA = reg_out[31:0];
	endcase

always @ *
	case(rs2)
		5'b00000: busB = reg_out[31:0];
		5'b00001: busB = reg_out[63:32];
		5'b00010: busB = reg_out[95:64];
		5'b00011: busB = reg_out[127:96];
		5'b00100: busB = reg_out[159:128];
		5'b00101: busB = reg_out[191:160];
		5'b00110: busB = reg_out[223:192];
		5'b00111: busB = reg_out[255:224];
		5'b01000: busB = reg_out[287:256];
		5'b01001: busB = reg_out[319:288];
		5'b01010: busB = reg_out[351:320];
		5'b01011: busB = reg_out[383:352];
		5'b01100: busB = reg_out[415:384];
		5'b01101: busB = reg_out[447:416];
		5'b01110: busB = reg_out[479:448];
		5'b01111: busB = reg_out[511:480];
		5'b10000: busB = reg_out[543:512];
		5'b10001: busB = reg_out[575:544];
		5'b10010: busB = reg_out[607:576];
		5'b10011: busB = reg_out[639:608];
		5'b10100: busB = reg_out[671:640];
		5'b10101: busB = reg_out[703:672];
		5'b10110: busB = reg_out[735:704];
		5'b10111: busB = reg_out[767:736];
		5'b11000: busB = reg_out[799:768];
		5'b11001: busB = reg_out[831:800];
		5'b11010: busB = reg_out[863:832];
		5'b11011: busB = reg_out[895:864];
		5'b11100: busB = reg_out[927:896];
		5'b11101: busB = reg_out[959:928];
		5'b11110: busB = reg_out[991:960];
		5'b11111: busB = reg_out[1023:992];
		default: busB=reg_out[31:0];
	endcase

endmodule
