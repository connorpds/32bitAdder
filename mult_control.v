//multu Control logic module
`include "/lib/mux.v"
`include "/lib/and_gate.v"
`include "/lib/or_gate.v"
`include "/lib/not_gate.v"
`include "/register_n.v"
`include "/add_32.v"
module multu_control
(
  input wire doMult,
  input wire sysClk,
  input wire mClk,
  input wire reset, //high, reset all the things
  input wire prod_LSB, //product LSB
  output wire add0, //0 is adding multiplicand, 1 is adding 0
  output wire a_s, //add or shift. 0 is add, 1 is shift
  output wire combined_reset, //0 is product[31:0] not updated externally, 1: product[31:0] is B
  output wire mult_done
  );

  //-need memory to remember if it's been intialized. starts at 0. DONEZO
  //-need memory to count how many shifts have occurred ---basically done
  //-need memory to remember what last thing was
wire doing_mult;
reg ctrl_reset;

//add0 is just !LSB
not_gate notLSB(prod_LSB,add0);

or_gate comb_rst(ctrl_reset,reset,combined_reset);


//initialization: when doMult goes high, we decide to initialize. We will
//probably do some resetting here, too.
  always@ (posedge doMult)
    begin
      ctrl_reset = 1;
    end

  always@ (negedge doMult)
    begin
      ctrl_reset = 0;
    end

//6 bit register and counter, adds 0 when add_count is 0, adds 1 when add_count is 1
  wire [5:0] reg6out;
  wire [5:0] out6;
  wire next_op;
  wire a_s0; //a_s for internal use
  wire add_c_out;
  wire mult_inter;

  //memory to keep track of which op to perform
  not_gate not_a_s(a_s0,next_op); //e
  register_n #(1) op_tracker(.clk(mClk), .reset(combined_reset),.wr_en(doing_mult),.d(next_op),.q(a_s0));


//ALTERNATE SOLN. 32 BIT ALL HIGH START REGISTER, KEEP RIGHT shifting
//UNTIL LSB IS 0, THEN WE'VE SHIFTED A FULL 32 TIMES
  register_n #(6) counter_reg(.clk(mClk), .reset(combined_reset),.wr_en(1'b1),.d(out6),.q(reg6out));
  add_6 incr(.a(reg6out),.b({5'b00000,a_s}),.s(out6),.c_out(add_c_out));
  //checking if the register is all 1s, implying 32 shifts have occurred
  assign mult_done = reg6out[5];




  not_gate stop_doing(mult_done, doing_mult); //turns doing_mult off
  mux mltdone_add_only(mult_done,a_s0,1'b0,a_s);

endmodule
