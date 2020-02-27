
module mux4
(
    input wire [1:0] sel,
    input wire [3:0] src,
    output wire result
);

//sel,src0,src1,out
wire m1out, m2out;
mux m1(sel[0],src[0],src[1],m1out);
mux m2(sel[0],src[2],src[3],m2out);

mux m3(sel[1],m1out,m2out,result);

endmodule

module mux8
(
    input wire [2:0] sel,
    input wire [7:0] src,
    output wire result
);

wire m1out, m2out;
mux4 m1(sel[1:0],src[3:0],m1out);
mux4 m2(sel[1:0],src[7:4],m2out);

mux m3(sel[2],m1out, m2out, result);
endmodule

module mux16
(
    input wire [3:0] sel,
    input wire [15:0] src,
    output wire result
);

wire m1out, m2out;
mux8 m1(sel[2:0],src[7:0],m1out);
mux8 m2(sel[2:0],src[15:8],m2out);

mux m3(sel[3],m1out, m2out, result);
endmodule
