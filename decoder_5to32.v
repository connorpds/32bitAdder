
module decoder_5to32(
	input wire [4:0] in,
	//Control inputs
	output reg [31:0] out
);

wire [7:0] two_to_four_out;
wire [31:0] out_temp;

//Need one 2-to-4 decoder
decoder_3to8 two_to_four(.in({1'b0, in[4:3]}), .enable(1'b1), .out(two_to_four_out));

//And 4 3-to-8 decoders
decoder_3to8 first_3to8(.in(in[2:0]), .enable(two_to_four_out[0]), .out(out_temp[7:0]));
decoder_3to8 second_3to8(.in(in[2:0]), .enable(two_to_four_out[1]), .out(out_temp[15:8]));
decoder_3to8 third_3to8(.in(in[2:0]), .enable(two_to_four_out[2]), .out(out_temp[23:16]));
decoder_3to8 fourth_3to8(.in(in[2:0]), .enable(two_to_four_out[3]), .out(out_temp[31:24]));

always @*
	out = out_temp;


endmodule
