`include "lib/sram.v"
`include "lib/syncram.v"

module pipeline_tb;
  reg reset;
  reg clk;
  reg override_inst;
  reg [31:0] force_inst;
  wire [31:0] instruction;
  wire [31:0] mem_read_data;
  wire mem_wr;
  wire sh;
  wire sb;
  wire [31:0] mem_addr;
  wire [31:0] mem_write_data;
  wire [31:0] PC;
  wire [31:0] busA;
  reg dummy;
  reg [4:0] i;
  wire [31:0] inst_in; //check

	mux_32 override_mux(.sel(override_inst), .src0(instruction), .src1(force_inst), .z(inst_in));
	pipeline cpu_undertest (.reset(reset), .clk(clk), .instruction(inst_in), .mem_read_data(mem_read_data), .mem_addr(mem_addr), .mem_write_data(mem_write_data), .PC(PC), .mem_wr(mem_wr), .busA_probe(busA), .mem_sh(sh), .mem_sb(sb));
	sram #( "dlx binary/btest_sensible.dat" ) inst_mem(.cs(1'b1), .oe(1'b1), .we(1'b0), .addr(PC), .din(32'b0), .dout(instruction));
	syncram #( "dlx binary/btest.dat" ) data_mem(.clk(clk), .cs(1'b1), .oe(1'b1), .sh(sh), .sb(sb), .we(mem_wr), .addr(mem_addr), .din(mem_write_data), .dout(mem_read_data));

	initial begin
		//$monitor("imm16=%h, jmp_imm26=%h, clk=%b, branch=%b, jmp=%b, reset=%b -> pc=%h", imm16, jmp_imm26, clk, branch, jmp, reset, pc);
    reset = 1'b1;
    clk = 1'b1;
	override_inst = 1'b0;
	force_inst = 32'b0;
    #200
    reset = 1'b0;
    #24200

    dummy = 0;

	// Register dumping time
	i = 5'b0;
	override_inst = 1'b1;
	force_inst = { 6'b001000, 27'b0 };

	#200
	//$display("reg=%d, val=%h", i, busA); //TODO

	for (i = 5'b00000; i < 5'b11111; i = i + 5'b00001) begin
			force_inst = { 6'b001000, i+5'b00001, 5'b00000, 16'b0 };
			#200
			$display("reg=%d, val=%h", i, busA);
	end

	force_inst = { 6'b001000, 5'b11111, 5'b00000, 16'b0 };
	#200
	$display("reg=%d, val=%h", i, busA);
	$finish(1);

	end

	always
	begin
		#100 clk = ~clk;
	end

endmodule
