`include "dependencies.v"

module forwarding_tb;
  reg ex_mem_wr;
  reg mem_wb_wr;
  reg [4:0] id_ex_rs;
  reg [4:0] id_ex_rs2;
  reg [4:0] ex_mem_rd;
  reg [4:0] mem_wb_rd;
  wire [1:0] A_sel;
  wire [1:0] B_sel;
  
	forwarding unit_undertest (.ex_mem_wr(ex_mem_wr), .mem_wb_wr(mem_wb_wr), .id_ex_rs(id_ex_rs), .id_ex_rs2(id_ex_rs2), .ex_mem_rd(ex_mem_rd), .mem_wb_rd(mem_wb_rd), .A_sel(A_sel), .B_sel(B_sel));

	initial begin
	$monitor("ex_mem_wr=%b mem_wb_wr=%b, id_ex_rs=%d, id_ex_rs2=%d, ex_mem_rd=%d, mem_wb_rd=%d -> Asel=%b, Bsel=%b", ex_mem_wr, mem_wb_wr, id_ex_rs, id_ex_rs2, ex_mem_rd, mem_wb_rd, A_sel, B_sel); 
		ex_mem_wr = 1'b0;
		mem_wb_wr = 1'b0;
		id_ex_rs = 5'b1;
		id_ex_rs2 = 5'b1;
		ex_mem_rd = 5'b1;
		mem_wb_rd = 5'b1;
		
		#4
		
		ex_mem_wr = 1'b1;
		
		#4
		
		id_ex_rs2 = 5'b10;
		
		#4
		
		id_ex_rs = 5'b11;
		
		#4
		
		ex_mem_rd = 5'b11;
		
		#4
		
		ex_mem_wr = 1'b0;
		mem_wb_wr = 1'b1;
		
		#4
		
		id_ex_rs2 = 5'b1;
		
		#4
		
		ex_mem_rd = 5'b1;
		
		#4
		
		id_ex_rs = 5'b1;
		
		
		
	end

endmodule
