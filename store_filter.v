
module store_filter(
	input wire [31:0] busB,
	input wire sb,
	input wire sh,
	output reg [31:0] mem_write_data
);

wire [31:0] det_sb_out;
wire [31:0] mem_write_data_out;

mux_32 det_sb(.sel(sb), .src0(busB), .src1({24'b0, busB[7:0]}), .z(det_sb_out));
mux_32 det_sh(.sel(sh), .src0(det_sb_out), .src1({16'b0, busB[15:0]}), .z(mem_write_data_out));

always @ *
	mem_write_data = mem_write_data_out;

endmodule
