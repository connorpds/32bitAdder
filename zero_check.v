module zero_check (value, zero_flag);
// synopsys template
parameter integer n = 32;
input [n-1:0] value;
output zero_flag;



    wire [n-1:0] orwire;
    assign orwire[0] = 1'b0;
    wire not_zf;


//can't treat the same wire as input and output for a gate
genvar g1;
generate
for (g1 = 0; g1 < n; g1 = g1 + 1) begin:testZcheck
    if (g1 < n - 1)
      or_gate o1(value[g1],orwire[g1], orwire[g1 + 1]);
    else
      or_gate o1(value[g1],orwire[g1], not_zf);

    //FOR 2 MHZ SPEEDUP, CHANGE THIS
    not_gate nnz(not_zf,zero_flag);

end
endgenerate




endmodule
