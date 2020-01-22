module or_gate (x, y, z);
  input x;
  input y;
  output z;

  assign z = (x|y) ;


endmodule



module or_3 (w,x,y,z);
  input w;
  input x;
  input y;
  output z;

  assign z =  w | x | y;
endmodule

module or_4 (v,w,x,y,z);
  input v;
  input w;
  input x;
  input y;
  output z;

  assign z = v | w | x | y;
endmodule

module or_5 (u,v,w,x,y,z);
  input u;
  input v;
  input w;
  input x;
  input y;
  output z;
  assign z = u | v | w | x | y;
endmodule
