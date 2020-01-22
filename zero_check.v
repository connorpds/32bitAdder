`include "/lib/and_gate.v"
module zero_check
(
  input wire [31:0] value,
  output wire zero_flag
);



    wire [32:0] orwire;
    assign orwire[0] = 1'b0;


//can't treat the same wire as input and output for a gate
genvar g1;
for (g1 = 0; g1 < 32; g1 = g1 + 1) begin
    or_gate o1(value[g1],orwire[g1], orwire[g1 + 1]);
end

assign zero_flag = orwire[32];




endmodule
