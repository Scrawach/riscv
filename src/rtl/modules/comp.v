/*
 Comparator (Comp)
 */
module comp
(
 input [31:0] src_1,
 input [31:0] src_2,
 output       equal,
 output       less,
 output       greater,
 output       signed_less,
 output       signed_greater
 );

  wire signed [31:0] signed_src_1;
  wire signed [31:0] signed_src_2;

  assign signed_src_1 = src_1;
  assign signed_src_2 = src_2;

  assign equal   = src_1 == src_2;
  assign less    = src_1  < src_2;
  assign greater = src_1  > src_2;

  assign signed_less    = signed_src_1 < signed_src_2;
  assign signed_greater = signed_src_1 > signed_src_2;
  
endmodule // comp 
