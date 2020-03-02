
module zero_check
(
  input wire [31:0] value,
  output wire zero_flag
);



    wire [31:0] orwire;
    assign orwire[0] = 1'b0;
    wire not_zf;


//can't treat the same wire as input and output for a gate
genvar g1;
generate
for (g1 = 0; g1 < 32; g1 = g1 + 1) begin:testZcheck
    if (g1 < 31)
      or_gate o1(value[g1],orwire[g1], orwire[g1 + 1]);
    else
      or_gate o1(value[g1],orwire[g1], not_zf);

    //FOR 2 MHZ SPEEDUP, CHANGE THIS
    not_gate nnz(not_zf,zero_flag);

end
endgenerate




endmodule
