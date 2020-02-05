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
  output wire add0, //0 is adding multiplicand, 1 is adding 0
  output wire a_s, //add or shift. 0 is add, 1 is shift
  output wire combined_reset //0 is product[31:0] not updated externally, 1: product[31:0] is B
  //NOT SURE EXACTLY WHAT TO DO HERE. THIS MAY BE BEST DONE OUTSIDE THE CONTROL.
  );

  //-need memory to remember if it's been intialized. starts at 0. DONEZO
  //-need memory to count how many shifts have occurred ---basically done
  //-need memory to remember what last thing was
reg doing_mult;
 //just for now

//initialization: when doMult goes high, we decide to initialize. We will
//probably do some resetting here, too.
  reg init;
  always@ (posedge doMult)
    begin
      init = 1;
      doing_mult = 1;
    end

  always@ (negedge doMult)
    begin
      init = 0;
    end

//5 bit register and counter, adds 0 when add_count is 0, adds 1 when add_count is 1
  wire [4:0] reg5out;
  wire [4:0] out5;
  wire next_op;
  wire a_s0; //a_s for internal use
  wire mult_done;

  //memory to keep track of which op to perform
  not_gate not_a_s(a_s0,next_op); //e
  register_n #(1) reg1(.clk(clk), .reset(combined_reset),.wr_en(doing_mult),.d(next_op),.q(a_s0));


//ALTERNATE SOLN. 32 BIT ALL HIGH START REGISTER, KEEP RIGHT shifting
//UNTIL LSB IS 0, THEN WE'VE SHIFTED A FULL 32 TIMES
  register_n #(5) reg5(.clk(clk), .reset(combined_reset),.wr_en(a_s),.d(out5),.q(reg5out));
  add_5 incr(.a(reg5out),.b({4'b0000,a_s}),.s(out5));
  //checking if the register is all 1s, implying 32 shifts have occurred
  and_5 add5maxed(reg5out[0],reg5out[1],reg5out[2],reg5out[3],reg5out[4],mult_done);




  not_gate stop_doing(mult_done, doing_mult); //turns doing_mult off
  mux mltdone_add_only(mult_done,a_s0,zero,a_s);

  endmodule
