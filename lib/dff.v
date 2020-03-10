module dff (clk, d, wr_en, reset, q);
    input clk;
    input d;
	input wr_en;
	input reset;
    output reg q;
    
    always @(negedge clk)
      begin
			if(reset) begin
			q <= 1'b0;
			end
		 else if (wr_en) begin
         q <= d;
			end
      end
      
endmodule 
          
    
    
