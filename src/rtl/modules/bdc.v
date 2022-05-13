/*
 Branch Decoder (BDC)
 */
module bdc
(
 input         branch,           // Branch instruction
 input         fast_jump,        // JAL instruction
 input [2:0]   branch_condition, // Condition for branching
 input [31:0]  immJ,             // Immediate data for J-type command
 input [31:0]  immB,             // Immediate data for B-type command
 input [31:0]  pc,               // Program counter
 input [31:0]  rs1_data,         // Register source #1
 input [31:0]  rs2_data,         // Register source #2
 input         forwarding_rs1, 
 input         forwarding_rs2,
 input [31:0]  alu_res,
 output        pc_write,
 output [31:0] pc_next
 );

  reg          cond_branch;
  /*AUTOREGINPUT*/
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  equal;                  // From comp of comp.v
  wire                  greater;                // From comp of comp.v
  wire                  less;                   // From comp of comp.v
  wire                  signed_greater;         // From comp of comp.v
  wire                  signed_less;            // From comp of comp.v
  // End of automatics
  wire [31:0]           src_1;
  wire [31:0]           src_2;
  
  assign src_1 = forwarding_rs1 ? alu_res : rs1_data;
  assign src_2 = forwarding_rs2 ? alu_res : rs2_data;

  comp comp (/*AUTOINST*/
             // Outputs
             .equal                     (equal),
             .less                      (less),
             .greater                   (greater),
             .signed_less               (signed_less),
             .signed_greater            (signed_greater),
             // Inputs
             .src_1                     (src_1),
             .src_2                     (src_2));
    
  assign pc_write = (cond_branch && branch) || fast_jump;
  assign pc_next = (fast_jump ? immJ : immB) + pc;

  always @ (*) begin
    case (branch_condition)
      `BRANCH_EQ           : cond_branch = equal;
      `BRANCH_NEQ          : cond_branch = !equal;
      `BRANCH_LESS         : cond_branch = less;
      `BRANCH_GREATER      : cond_branch = greater;
      `BRANCH_LESS_SIGN    : cond_branch = signed_less;
      `BRANCH_GREATER_SIGN : cond_branch = signed_greater;
      default              : cond_branch = equal;
    endcase
  end
    
endmodule // bdc 
