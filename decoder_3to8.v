module decoder_3to8(
	input wire [2:0] in,
	input wire enable,
	//Control inputs
	output reg	 [7:0] out
);

//Going to do this naively with case statement for now, see how it synthesizes
always @ *
begin
	if(enable)
		begin
			case(in)
				3'b000: begin
							out[0]=1'b1; out[7:1]=7'b0;
						end
				3'b001: begin
							out[0]=1'b0; out[1]=1'b1; out[7:2]=6'b0;
						end
				3'b010: begin
							out[1:0]=2'b0; out[2]=1'b1; out[7:3]=5'b0;
						end
				3'b011: begin
							out[2:0]=3'b0; out[3]=1'b1; out[7:4]=4'b0;
						end
				3'b100: begin
							out[3:0]=4'b0; out[4]=1'b1; out[7:5]=3'b0;
						end
				3'b101: begin
							out[4:0]=5'b0; out[5]=1'b1; out[7:6]=2'b0;
						end
				3'b110: begin
							out[5:0]=6'b0; out[6]=1'b1; out[7]=1'b0;
						end
				3'b111: begin
							out[6:0]=7'b0; out[7]=1'b1;
						end
			endcase
		end
	else
		begin
			out[31:0] = 32'b0;
		end
end
endmodule