/*
 Instruction Decoder (IDC)
 */
module idc
(
 input [31:0]  instruction, 
 output [4:0]  rs1,    // register source #1 address
 output [4:0]  rs2,    // register source #2 address
 output [4:0]  rd,     // register destination  address
 output [31:0] immI,   // immediate data for I-type command
 output [31:0] immU,   // immediate data for U-type command
 output [31:0] immB,   // immediate data for B-type command
 output [31:0] immS,   // immediate data for S-type command
 output [6:0]  cmd_op, // command operation code
 output [6:0]  func7,  // function 7
 output [2:0]  func3   // function 3  
 );

  wire [31:0]  instr;  
  assign instr  = instruction;

  assign rs1    = instr[19:15];
  assign rs2    = instr[24:20];
  assign rd     = instr[11: 7];
  assign immI   = {{21{instr[31]}}, instr[31:20]};
  assign immU   = {{11{1'b0}}, instr[31:12]};
  assign immB   = { {20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
  assign immS   = { {22{1'b0}}, instr[31:25], instr[11:7] };
  
  assign cmd_op = instr[6:0];
  assign func7  = instr[31:25];
  assign func3  = instr[14:12];
      
endmodule // idc
