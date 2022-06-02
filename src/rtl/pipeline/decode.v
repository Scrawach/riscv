/*
 DECODE (_d) pipeline part
 */
module decode
(
 input         rst_n,
 input         clk,
 // from fetch stage:
 input [31:0]  instruction_f,
 input [31:0]  pc_f,
 input         mem_valid_f,
 // from execute stage:
 input [31:0]  alu_res_e,
 // from writeback stage:
 input         rd_write_w,
 input [4:0]   rd_w,
 input [31:0]  rd_data_w,
 // to fetch stage:
 output        branch_d,
 output [31:0] branch_next_addr_d,
 // to execute stage:
 output        pc_write_d,
 output        rd_write_d,
 output [1:0]  rd_write_src_d,
 output        mem_write_d,
 output [3:0]  alu_op_d,
 output [1:0]  alu_src1_d,
 output        alu_src2_d,
 output [4:0]  rd_d,
 output [4:0]  rs1_d,
 output [4:0]  rs2_d,
 output [31:0] immU_d,
 output [31:0] immS_d,
 output [31:0] immI_d,
 output [31:0] pc_d,
 output [31:0] rs1_data_d,
 output [31:0] rs2_data_d,
 output        csr_wr_en,
 output [2:0]  csr_op,
 // hazard control unit:
 input         stall_d,
 input         flush_d,
 input         forwarding_rs1_d,
 input         forwarding_rs2_d,
 output        branch
 );

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [2:0]            branch_condition_d;     // From cu of cu.v
  wire [6:0]            cmd_op_d;               // From idc of idc.v
  wire                  fast_jump;              // From cu of cu.v
  wire [2:0]            func3_d;                // From idc of idc.v
  wire [6:0]            func7_d;                // From idc of idc.v
  wire [31:0]           immB_d;                 // From idc of idc.v
  wire [31:0]           immJ_d;                 // From idc of idc.v
  // End of automatics
    
  reg [31:0]            instruction_d;
  reg [31:0]            pc_d;

  /*idc AUTO_TEMPLATE(
   .\(.*\) (\1_d[]),
   );*/
  idc idc (/*AUTOINST*/
           // Outputs
           .rs1                         (rs1_d[4:0]),            // Templated
           .rs2                         (rs2_d[4:0]),            // Templated
           .rd                          (rd_d[4:0]),             // Templated
           .immI                        (immI_d[31:0]),          // Templated
           .immU                        (immU_d[31:0]),          // Templated
           .immB                        (immB_d[31:0]),          // Templated
           .immS                        (immS_d[31:0]),          // Templated
           .immJ                        (immJ_d[31:0]),          // Templated
           .cmd_op                      (cmd_op_d[6:0]),         // Templated
           .func7                       (func7_d[6:0]),          // Templated
           .func3                       (func3_d[2:0]),          // Templated
           // Inputs
           .instruction                 (instruction_d[31:0]));   // Templated

  /*cu AUTO_TEMPLATE(
   .branch    (branch),
   .cond_zero (cond_zero),
   .fast_jump (fast_jump),
   .\(.*\)    (\1_d[]),
   );*/
  cu cu (/*AUTOINST*/
         // Outputs
         .pc_write                      (pc_write_d),            // Templated
         .rd_write                      (rd_write_d),            // Templated
         .rd_write_src                  (rd_write_src_d[1:0]),   // Templated
         .mem_write                     (mem_write_d),           // Templated
         .alu_op                        (alu_op_d[3:0]),         // Templated
         .alu_src1                      (alu_src1_d[1:0]),       // Templated
         .alu_src2                      (alu_src2_d),            // Templated
         .fast_jump                     (fast_jump),             // Templated
         .branch                        (branch),                // Templated
         .branch_condition              (branch_condition_d[2:0]), // Templated
         // Inputs
         .cmd_op                        (cmd_op_d[6:0]),         // Templated
         .func3                         (func3_d[2:0]),          // Templated
         .func7                         (func7_d[6:0]));          // Templated

  /*file AUTO_TEMPLATE(
   .rs1_data(rs1_data_d),
   .rs2_data(rs2_data_d),
   .rd_addr(rd_w),
   .rd_write(rd_write_w),
   .rd_data(rd_data_w),
   .rs1_addr(rs1_d),
   .rs2_addr(rs2_d),
   );*/
  file file (/*AUTOINST*/
             // Outputs
             .rs1_data                  (rs1_data_d),            // Templated
             .rs2_data                  (rs2_data_d),            // Templated
             // Inputs
             .rst_n                     (rst_n),
             .clk                       (clk),
             .rs1_addr                  (rs1_d),                 // Templated
             .rs2_addr                  (rs2_d),                 // Templated
             .rd_addr                   (rd_w),                  // Templated
             .rd_write                  (rd_write_w),            // Templated
             .rd_data                   (rd_data_w));             // Templated

  /*bdc AUTO_TEMPLATE(
   .\(.*\)    (\1_d[]),
   .branch    (branch),
   .fast_jump (fast_jump),
   .alu_res(alu_res_e),
   .pc_write(branch_d),
   .pc_next(branch_next_addr_d),
   );*/
  bdc bdc (/*AUTOINST*/
           // Outputs
           .pc_write                    (branch_d),              // Templated
           .pc_next                     (branch_next_addr_d),    // Templated
           // Inputs
           .branch                      (branch),                // Templated
           .fast_jump                   (fast_jump),             // Templated
           .branch_condition            (branch_condition_d[2:0]), // Templated
           .immJ                        (immJ_d[31:0]),          // Templated
           .immB                        (immB_d[31:0]),          // Templated
           .pc                          (pc_d[31:0]),            // Templated
           .rs1_data                    (rs1_data_d[31:0]),      // Templated
           .rs2_data                    (rs2_data_d[31:0]),      // Templated
           .forwarding_rs1              (forwarding_rs1_d),      // Templated
           .forwarding_rs2              (forwarding_rs2_d),      // Templated
           .alu_res                     (alu_res_e));             // Templated
  
  // PIPELINE:
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      instruction_d <= 0;
      pc_d          <= 0;
    end else if (stall_d) begin
      instruction_d <= instruction_d;
      pc_d          <= pc_d;
    end else if (flush_d) begin
      instruction_d <= 0;
      pc_d          <= 0;
    end else begin
      instruction_d <= instruction_f;
      pc_d          <= pc_f;
    end
  end

endmodule // decode
// Local Variables:
// verilog-library-directories:("../modules")
// End:
