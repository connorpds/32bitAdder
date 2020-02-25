//mem_access for single cycle
// writes to/reads from a memaddress
`include "/lib/syncram.v"
module mem_access(
  input wire enable,
  input wire wr_en,
  input wire clk,
  input wire [31:0] address,
  input wire [31:0] data_in,
  output wire [31:0] contents
);

parameter mem_path;//path to the memory file

//two situations here:
//1. We read contents at address
//2. We write data_in to address, when wr_en is high


syncram #(mem_path) data_memory(.clk(clk),.cs(1'b1),.oe(1'b1),.we(wr_en),.addr(address),.din(data_in),.dout(contents));
endmodule 
