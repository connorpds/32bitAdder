
module reg_eq_check(
	input wire[5:0] reg1,
	input wire[5:0] reg2,
	input wire eq
);

wire [4:0] xnor_out;
wire and_0;
wire and_1;
wire and_2;

xnor_gate_n #(5) xnor_comp(.x(reg1), .y(reg2), .z(xnor_out));
and_gate and0(.x(xnor_out[4]), .y(xnor_out[3]), .z(and_0));
and_gate and1(.x(and_0), .y(xnor_out[2]), .z(and_1));
and_gate and2(.x(and_1), .y(xnor_out[1]), .z(and_2));
and_gate and3(.x(and_2), .y(xnor_out[0]), .z(eq));

endmodule
