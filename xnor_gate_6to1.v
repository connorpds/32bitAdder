module xnor_gate_6to1(
	input wire[5:0] x,
	input wire[5:0] y,
	input wire z
);

wire [5:0] xnor_out;
wire and_0;
wire and_1;
wire and_2;
wire and_3;

xnor_gate_n #(6) xnor_comp(.x(x), .y(y), .z(z));
and_gate and0(.x(xnor_out[5]), .y(xnor_out[4]), .z(and_0));
and_gate and1(.x(and_0), .y(xnor_out[3]), .z(and_1));
and_gate and2(.x(and_1), .y(xnor_out[2]), .z(and_2));
and_gate and3(.x(and_2), .y(xnor_out[1]), .z(and_3));
and_gate and4(.x(and_3), .y(xnor_out[0]), .z(z));

endmodule