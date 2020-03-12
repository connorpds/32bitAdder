//multu Control logic module
module mult_control
(
  input wire doMult,
  input wire sysClk,
  input wire mClk,
  input wire reset, //high, reset all the things
  input wire prod_LSB, //product LSB
  output wire add0, //0 is adding multiplicand, 1 is adding 0
  output wire doSub, //0 is do addition, 1 is do subtraction
  output wire a_s, //add or shift. 0 is add, 1 is shift
  output wire combined_reset, //0 is product[31:0] not updated externally, 1: product[31:0] is B
  output wire mult_done
  );

  //-need memory to remember if it's been intialized. starts at 0. DONEZO
  //-need memory to count how many shifts have occurred ---basically done
  //-need memory to remember what last thing was
wire doing_mult;
reg ctrl_reset;
//assign ctrl_reset = doMult;


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

  wire mult_done_temp;

  //memory to keep track of which op to perform
  not_gate not_a_s(a_s0,next_op); //e
  register_n #(1) op_tracker(.clk(mClk), .reset(combined_reset),.wr_en(doing_mult),.d(next_op),.q(a_s0));


//ALTERNATE SOLN. 32 BIT ALL HIGH START REGISTER, KEEP RIGHT shifting
//UNTIL LSB IS 0, THEN WE'VE SHIFTED A FULL 32 TIMES
  register_n #(6) counter_reg(.clk(mClk), .reset(combined_reset),.wr_en(1'b1),.d(out6),.q(reg6out));
  add_6 incr(.a(reg6out),.b({5'b00000,a_s}),.s(out6),.c_out(add_c_out));
  //checking if the register is all 1s, implying 32 shifts have occurred
  assign mult_done_temp = reg6out[5];




  not_gate stop_doing(mult_done_temp, doing_mult); //turns doing_mult off
  mux mltdone_add_only(mult_done_temp,a_s0,1'b0,a_s);

  wire prev_LSB;
  wire prev_LSB_en;
  and_gate plsb_doing(next_op,doing_mult,prev_LSB_en);
  register_n #(1) prev_LSB_(.clk(mClk), .reset(combined_reset),.wr_en(prev_LSB_en),.d(prod_LSB),.q(prev_LSB));


  wire mult_finish;
  wire not_mult_finish;
  wire mult_done0;
  register_n #(1) stagger_done(.clk(mClk), .reset(combined_reset),.wr_en(1'b1),.d(mult_done_temp),.q(mult_finish));
  not_gate nmf(mult_finish, not_mult_finish);
  and_gate muld_done_find(not_mult_finish, mult_done_temp, mult_done0);
  register_n #(1) stagger_md(.clk(mClk), .reset(reset),.wr_en(1'b1),.d(mult_done0),.q(mult_done));


  //T0D0 LIST:
  //-MEMORY FOR PREVIOUS LSB DONEZERINO
  //-CHANGE ADD0
  //-ADD/SUBTRACT OUTPUT (doSub, 0 for add, 1 for sub)

  //add0 and doSub truth table
  nor_gate add0_(prev_LSB,prod_LSB,add0);
  wire n_prev;
  not_gate nprev(prev_LSB,n_prev);
  and_gate doSub_(prod_LSB,n_prev,doSub);

endmodule
