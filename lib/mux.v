module mux (sel, src0, src1, z);

  input sel;
  input src0;
  input src1;
  output reg z;


  always @(sel or src0 or src1)
      begin
        if (sel == 1'b0) z <= src0;
        else z <= src1;
      end

endmodule
