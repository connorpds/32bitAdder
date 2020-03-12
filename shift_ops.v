module sll_32(
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A << B;
end

endmodule

module srl_32(
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A >> B;
end

endmodule

module srl_64(
	input wire [63:0] A,
	input wire [63:0] B,
	output reg [63:0] out
);

always @ * begin
	out = A >> B;
end

endmodule

module sra_32(
	input wire signed [31:0] A,
	input wire [31:0] B,
	output reg [31:0] out
);

always @ * begin
	out = A >>> B;
end

endmodule

module sra_64(
	input wire signed [63:0] A,
	input wire [63:0] B,
	output reg [63:0] out
);

always @ * begin
	out = A >>> B;
end

endmodule
