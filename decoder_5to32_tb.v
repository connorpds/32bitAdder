module decoder_5to32_tb;
	reg [4:0] in;
	reg [4:0] i;
	wire [31:0] out;
	
	decoder_5to32 decoder_ut(.in(in), .out(out));
	
	initial begin
		$monitor("in=%b -> out=%b", in, out);
		
		in = 5'b00000;
		
		for (i = 5'b00000; i < 5'b11111; i = i + 5'b00001) begin
			#5
			in = i;
		end
		#5
		in = 5'b11111;
	end
endmodule
