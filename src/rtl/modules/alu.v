// ------------
// Arithmetic-Logic Unit (ALU)
module alu
(
 input [31:0]  src_a, // source A
 input [31:0]  src_b, // source B
 input [2:0]   op_code, // operation code
 output [31:0] result // result 
 );

  // ------------
  // Internal reg's
  reg [31:0]   result_reg; // reg for use in always block
     
  // ------------
  // MODULE IMPLEMENTATION
  always @ ( * ) begin
    case ( op_code )
      `ALUOP_ADD   : result_reg = src_a + src_b;
      `ALUOP_OR    : result_reg = src_a | src_b;
      `ALUOP_SRL   : result_reg = src_a >> src_b [4:0];
      `ALUOP_SLL   : result_reg = src_a << src_b [4:0];
      `ALUOP_SLTU  : result_reg = (src_a < src_b) ? 1 : 0;
      `ALUOP_SUB   : result_reg = src_a - src_b;
      `ALUOP_SRC1  : result_reg = src_a;
      default      : result_reg = src_a + src_b;
    endcase
  end

  assign result = result_reg;
  // ------------

endmodule
// ------------   
