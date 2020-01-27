module sll_32(
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A << B;
end

endmodule

module slr_32(
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A >> B;
end

endmodule

module sra_32(
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A >>> B;
end

endmodule