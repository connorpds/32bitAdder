module decoder_3to8_tb;
	reg [2:0] in;
	reg enable;
	wire [7:0] out;
	
	decoder_3to8 decoder_ut(.in(in), .enable(enable), .out(out));
	
	initial begin
		$monitor("in=%b, enable=%b -> out=%b", in, enable, out);
		
		in = 3'b000;
		enable = 1'b0;
		#5
		in = 3'b001;
		#5
		enable = 1'b1;
		#5
		in = 3'b010;
		#5
		in = 3'b011;
		#5
		in = 3'b100;
		#5
		in = 3'b101;
		#5
		in = 3'b110;
		#5
		in = 3'b111;
		#5
		in = 3'b000;
	end
endmodule
