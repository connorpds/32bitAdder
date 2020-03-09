module hazard_detect(
  input wire id_ex_read,
  input wire [4:0] id_ex_rs2,
  input wire [4:0] if_id_rs,
  input wire [4:0] if_id_rs2,
  output wire hazard
);

//reg_eq_check a_reg_eq(r1,r2,out)
wire rsrs2;
wire rs2rs2;
reg_eq_check rs_rs2(id_ex_rs2,if_id_rs,rsrs2);
reg_eq_check rs2_rs2(id_ex_rs2,if_id_rs2,rs2rs2);

wire regeq;
or_gate regs_eq(rsrs2,rs2rs2,regeq);

and_gate and_out(regeq,id_ex_read, hazard);

endmodule
