module mux_n (sel, src0, src1, z);
  parameter n;
  input [n-1:0] sel;
  input [n-1:0] src0;
  input [n-1:0] src1;
  output reg [n-1:0] z;


  always @(sel or src0 or src1)
      begin
        if (sel == 1'b0) z <= src0;
        else z <= src1;
      end

endmodule
