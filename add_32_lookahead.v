`include "/lib/and_gate.v"
`include "/lib/or_gate.v"
`include "/lib/xor_gate.v"



module CLA_4
(
input wire c_in,
input wire [3:0] a,
input wire [3:0] b,
output wire [3:0] s,
output wire c_out
);

//gate syntax: gate name(arg1,arg2,out)

//Pi = Ai XOR Bi
//Gi = Ai * Bi
//Si = Pi XOR Ci
//Ci+1 = Gi + Pi*Ci

//ADDER 0

wire p0, g0, c1;
//P0 = A0 XOR B0
xor_gate prop0(a[0],b[0],p0);
//G0 = A0*B0
and_gate gen0(a[0],b[0],g0);
//S0 = P0 XOR C0
xor_gate sum0(p0,c_in,s[0]);
//C1 = G0 + P0*C0
wire p0c0;
and_gate c1and0(p0,c_in,p0c0);
or_gate c1or0(g0,p0c0,c1);


//ADDER 1

wire p1, g1, c2;
//P1 = A1 XOR B1
xor_gate prop1(a[1],b[1],p1);
//G1 = A1*B1
and_gate gen1(a[1],b[1],g1);
//S1 =  P1 XOR C1
xor_gate sum1(p1,c1,s[1]);
//C2 = G1 + C1*S1
//C2 = G1 + P1*(G0 + P0*C0)
// = G1 + P1*G0 + P1*P0*C0
wire p1g0, p1p0c0;
and_gate and_p1g0(p1,g0,p1g0);
and_3 and_p1p0c0(p1,p0,c0,p1p0c0);
or_3 c2_or(g1,p1g0,p1p0c0);



//ADDER 2
wire p2, g2, c3;
//P2 = A2 XOR B2
xor_gate prop2(a[2],b[2],p2);
//G2 = A2*B2
and_gate gen2(a[2],b[2],g2);
//S2 = P2 XOR C2
xor_gate sum2(p2,c2,s[2]);
//C3 = G2 + P2 * (G1 + P1*(G0 + P0*C0))
// = G2 + P2*G1 + P2*P1(G0 + P0*C0)
// = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*C0
wire p2g1, p2p1g0, p2p1p0c0;
and_gate and_p2g1(p2,g1,p2g1);
and_3 and_p2p1g0(p2,p1,g0,p2p1g0);
and_4 and_p2p1p0c0(p2,p1,p0,c0,p2p1p0c0);
or_4 c3_or(p2g1,p2p1g0,p2p1p0c0,c3);


//ADDER 3
wire p3, g3;
//P3 = A3 XOR B3
xor_gate prop3(a[3],b[3],p3);
//G3 = A3 * B2
and_gate gen3(a[3],b[3],g3);
//S3 = P3 XOR C3
xor_gate sum3(p3,c3,s[3]);
//C_out = G3 + P3 *  (G2 + P2*(G1 + P1*(G0 + P0*C0)))
// = G3 + P3*G2 + P3*P2*(G1 + P1*(G0 + P0*C0))
// = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*(G0 + P0*C0)
// = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*C0
wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0;
and_gate and_p3g2(p3,g2,p3g2);
and_3 and_p3p2g1(p3,p2,g1,p3p2g1);
and_4 and_p3p2p1g0(p3,p2,p1,g0,p3p2p1g0);
and_5 and_p3p2p1p0c0(p3,p2,p1,p0,c0,p3p2p1p0c0);
or_5 c_out_or(g2,p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0,c_out);


endmodule

//now with the 4-bit CLA complete, we cascade eight of them to create
//a 32-bit CLA

module CLA_32
(
input wire [31:0] a,
input wire [31:0] b,
output wire [31:0] s,
output wire c_out
);

genvar genr;
wire [8:0] c;
assign c[0] = 1'b0;
for (genr = 0; genr < 8; genr = genr + 1) begin
    localparam integer stride = (1 + genr) * 4 - 1;
    CLA_4 cla4(c[genr],a[stride:stride - 3],b[stride:stride - 3],s[stride:stride - 3],c[genr+1]);
end

endmodule



/*module add_4_lookahead
(
input wire c_in,
input wire [3:0] a,
input wire [3:0] b,
output wire [3:0] s,
output wire c_out,
);*/
