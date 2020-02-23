`include "/decoder_3to8.v"

module decoder_5to32(
	input reg [4:0] in,
	//Control inputs
	output wire [32:0] out
);

wire [7:0] two_to_four_out;

//Need one 2-to-4 decoder
decoder_3to8 two_to_four(.in({1'b0, in[4:3]}), .enable('1'), .out(two_to_four_out));

//And 4 3-to-8 decoders
decoder_3to8 first_3to8(.in(in[2:0]), .enable(two_to_four_out[0]), .out(out[7:0]));
decoder_3to8 second_3to8(.in(in[2:0]), .enable(two_to_four_out[1]), .out(out[15:8]));
decoder_3to8 third_3to8(.in(in[2:0]), .enable(two_to_four_out[2]), .out(out[23:16]));
decoder_3to8 fourth_3to8(.in(in[2:0]), .enable(two_to_four_out[3]), .out(out[31:24]));

endmodule