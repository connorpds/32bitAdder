module inst_fetch_tb;
  reg reset;
  reg clk;
  reg [31:0] instruction;
  reg [31:0] mem_read_data;
  wire mem_wr;
  wire [31:0] mem_addr;
  wire [31:0] mem_write_data;
  wire [31:0] PC;

	single_cycle cpu_undertest (.reset(reset), .clk(clk), .instruction(instruction), .mem_read_data(mem_read_data), .mem_addr(mem_addr), .mem_write_data(mem_write_data), .PC(PC), .mem_wr(mem_wr));
	syncram #( "FILE NAME HERE" ) inst_mem(.clk(clk), .cs(1'b1), .oe(1'b1), .we(1'b0), .addr(PC), .din(32'b0), .dout(instruction));
	syncram #( "FILE NAME HERE" ) data_mem(.clk(clk), .cs(1'b1), .oe(1'b1), .we(mem_wr), .addr(mem_addr), .din(mem_write_data), .dout(mem_read_data));
	
	initial begin
		//$monitor("imm16=%h, jmp_imm26=%h, clk=%b, branch=%b, jmp=%b, reset=%b -> pc=%h", imm16, jmp_imm26, clk, branch, jmp, reset, pc);
		

	end

	always
	begin
		#2 clk = ~clk;
	end

endmodule
