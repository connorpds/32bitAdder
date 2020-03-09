module forwarding(
  input wire ex_mem_wr,
  input wire mem_wb_wr,
  input wire [4:0] id_ex_rs,
  input wire [4:0] id_ex_rs2,
  input wire [4:0] ex_mem_rd,
  input wire [4:0] mem_wb_rd,
  output wire [1:0] A_sel,
  output wire [1:0] B_sel
);


///////////////////////
//EX FORWARDING///
/////////////////

//for both ex_a_fwd and ex_b_fwd
//ex_en_check = ex_mem_wr AND (ex_mem_rd != 0)
wire ex_rd_0;
wire ex_en_check;
zero_check #(5) rd_ex_0(ex_mem_rd, ex_rd_0);
and_gate ex_en(ex_mem_wr, ex_rd_0, ex_en_check);

//EX_A_FWD
wire ex_reg_eq_a;
wire ex_A_FWD;
reg_eq_check a_reg_eq(ex_mem_rd,id_ex_rs,ex_reg_eq_a);
and_gate ex_a_fwd_det(ex_en_check, ex_reg_eq_a, ex_A_FWD);
//when true, A_sel = 10

//EX_B_FWD
wire ex_reg_eq_b;
wire ex_B_FWD;
reg_eq_check b_reg_eq(ex_mem_rd,id_ex_rs2,ex_reg_eq_b);
and_gate ex_b_fwd_det(ex_en_check, ex_reg_eq_b, ex_B_FWD);
//when true, B_sel = 10

/////////////////////////
//MEM FORWARDING/////
/////////////////

wire mem_rd_0;
wire mem_en_check;
zero_check #(5) rd_mem_0(mem_wb_rd, mem_rd_0);
and_gate mem_en(mem_wb_wr, mem_rd_0, mem_en_check);


//MEM_A_FWD
wire Nex_A_FWD; //not ex_A_FWD
wire mem_reg_eq_a;
wire mem_A_FWD;
wire intermemA; //mem_reg_eq_a && Nex_A_FWD
//when true, A_sel = 01
not_gate nexA(ex_A_FWD, Nex_A_FWD);
reg_eq_check mema_reg_eq(mem_wb_rd, id_ex_rs, mem_reg_eq_a);
and_gate eq_a_nex_a(Nex_A_FWD, mem_reg_eq_a, intermemA);
and_gate memAFWD(intermemA, mem_en_check, mem_A_FWD);

//MEM_B_FWD
wire Nex_B_FWD; //not ex_B_FWD
wire mem_reg_eq_b;
wire mem_B_FWD;
wire intermemB; //mem_reg_eq_b && Nex_B_FWD
//when true, A_sel = 01
not_gate nexB(ex_B_FWD, Nex_B_FWD);
reg_eq_check memb_reg_eq(mem_wb_rd, id_ex_rs2, mem_reg_eq_b);
and_gate eq_b_nex_b(Nex_B_FWD, mem_reg_eq_b, intermemB);
and_gate memBFWD(intermemB, mem_en_check, mem_B_FWD);
//when true, B_sel = 01


//A_sel = {ex_A_FWD,mem_A_FWD}
assign A_sel = {ex_A_FWD, mem_A_FWD};

//_Bsel = {ex_B_FWD,mem_B_FWD}
assign B_sel = {ex_B_FWD, mem_B_FWD};

endmodule
