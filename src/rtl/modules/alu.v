// ------------
// Arithmetic-Logic Unit (ALU)
module alu
(
 input [31:0]  src_a, // source A
 input [31:0]  src_b, // source B
 input [3:0]   op_code, // operation code
 output [31:0] result // result 
 );

  wire signed [31:0] signed_src_a;
  wire               sltu;
  wire               slt;
          
  // ------------
  // Internal reg's
  reg [31:0]   result_reg; // reg for use in always block

  assign signed_src_a = src_a;
  
  assign sltu = src_a < src_b;
  assign slt  = src_a[31] ^ src_b[31] ? src_a[31] : sltu;
           
  // ------------
  // MODULE IMPLEMENTATION
  always @ ( * ) begin
    case ( op_code )
      `ALUOP_ADD   : result_reg = src_a + src_b;
      `ALUOP_SUB   : result_reg = src_a - src_b;
      `ALUOP_SLT   : result_reg = {31'b0, slt };
      `ALUOP_SLTU  : result_reg = {31'b0, sltu};
      `ALUOP_AND   : result_reg = src_a & src_b;
      `ALUOP_OR    : result_reg = src_a | src_b;
      `ALUOP_XOR   : result_reg = src_a ^ src_b;
      
      `ALUOP_SLL   : result_reg = src_a         << src_b[4:0];
      `ALUOP_SRL   : result_reg = src_a         >> src_b[4:0];
      `ALUOP_SRA   : result_reg = signed_src_a >>> src_b[4:0];
            
      `ALUOP_SRC1  : result_reg = src_b;
      default      : result_reg = 32'hXX_XX_XX_XX;
    endcase
  end

  assign result = result_reg;
  // ------------

endmodule
// ------------   
