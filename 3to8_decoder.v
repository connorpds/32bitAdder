module decoder_3to8(
	input reg [2:0] in,
	//Control inputs
	output wire [7:0] out
);

//Going to do this naively with case statement for now, see how it synthesizes
always @ *
	case(in)
		3b'000: begin
					out[0]=1b'1; out[1:7]=7'b0;
				end
		5b'001: begin
					out[0]=1'b0; out[1]=1b'1; out[2:7]=6'b0;
				end
		5b'010: begin
					out[0:1]=2'b0; out[2]=1b'1; out[3:7]=5'b0;
				end
		5b'011: begin
					out[0:2]=3'b0; out[3]=1b'1; out[4:7]=4'b0;
				end
		5b'100: begin
					out[0:3]=4'b0; out[4]=1b'1; out[5:7]=3'b0;
				end
		5b'101: begin
					out[0:4]=5'b0; out[5]=1b'1; out[6:7]=2'b0;
				end
		5b'110: begin
					out[0:5]=6'b0; out[6]=1b'1; out[7]=1'b0;
				end
		5b'111: begin
					out[0:6]=7'b0; out[7]=1b'1
				end
	endcase
endmodule