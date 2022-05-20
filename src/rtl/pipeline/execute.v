/*
 EXECUTE (_e) pipeline stage
 */
module execute
(
 input         rst_n,
 input         clk,
 // from decode stage:
 input         pc_write_d,
 input         rd_write_d,
 input [1:0]   rd_write_src_d,
 input         mem_write_d,
 input [2:0]   alu_op_d,
 input [1:0]   alu_src1_d,
 input         alu_src2_d,
 input [4:0]   rd_d,
 input [31:0]  immU_d,
 input [31:0]  immS_d,
 input [31:0]  immI_d,
 input [4:0]   rs1_d,
 input [4:0]   rs2_d,
 input [31:0]  pc_d,
 input [31:0]  rs1_data_d,
 input [31:0]  rs2_data_d,
 // to memory stage:
 output        pc_write_e,
 output        rd_write_e,
 output [1:0]  rd_write_src_e,
 output        mem_write_e,
 output [4:0]  rd_e,
 output [31:0] pc_e,
 output [31:0] alu_res_e,
 output [31:0] mem_data_e,
 // from memory stage:
 input [31:0]  alu_res_m,
 // from writeback stage:
 input [31:0]  rd_data_w,
 // hazard control unit:
 input         stall_e,
 input         flush_e,
 input [1:0]   forwarding_rs1_e,
 input [1:0]   forwarding_rs2_e,
 output [4:0]  rs1_e,
 output [4:0]  rs2_e
 );
  
  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            pc_e;
  reg                   pc_write_e;
  // End of automatics
  reg                   rd_write_e;
  reg [1:0]             rd_write_src_e;
  reg                   mem_write_e;
  reg [2:0]             alu_op_e;
  reg [2:0]             alu_src1_e;
  reg                   alu_src2_e;
  reg [4:0]             rd_e;
  reg [31:0]            immU_e;
  reg [31:0]            immS_e;
  reg [31:0]            immI_e;
  reg [4:0]             rs1_e;
  reg [4:0]             rs2_e;
  reg [31:0]            rs1_data_e;
  reg [31:0]            rs2_data_e;
  reg [31:0]            rs1_data;
  reg [31:0]            rs2_data;
  reg [31:0]            src_a;
  reg [31:0]            src_b;
      
  /*alu AUTO_TEMPLATE(
   .result(alu_res_e),
   .op_code(alu_op_e),
   .src_b(rs1_data),
   );*/
  alu alu (/*AUTOINST*/
           // Outputs
           .result                      (alu_res_e),             // Templated
           // Inputs
           .src_a                       (src_a),
           .src_b                       (src_b),              // Templated
           .op_code                     (alu_op_e));              // Templated
  
  always @(*) begin
    src_b = rs2_data;
    case (alu_src1_e)
      2'b00: src_b = rs2_data;
      2'b01: src_b = immI_e;
      2'b10: src_b = immS_e;
      2'b11: src_b = immU_e;
    endcase
  end

  always @(*) begin
    src_a = alu_src2_e ? pc_e : rs1_data;
  end
  
  always @(*) begin
    rs1_data = rs1_data_e;
    case (forwarding_rs1_e)
      2'b00: rs1_data = rs1_data_e;
      2'b01: rs1_data = rd_data_w;
      2'b10: rs1_data = alu_res_m;
    endcase
  end

  always @(*) begin
    rs2_data = rs2_data_e;
    case (forwarding_rs2_e)
      2'b00: rs2_data = rs2_data_e;
      2'b01: rs2_data = rd_data_w;
      2'b10: rs2_data = alu_res_m;
    endcase
  end

  assign mem_data_e = rs2_data;
  
  // PIPELINE:
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n || flush_e) begin
      pc_write_e     <= 0;
      rd_write_e     <= 0;
      rd_write_src_e <= 0;
      mem_write_e    <= 0;
      alu_op_e       <= 0;
      alu_src1_e     <= 0;
      alu_src2_e     <= 0;
      rd_e           <= 0;
      immU_e         <= 0;
      immS_e         <= 0;
      immI_e         <= 0;
      rs1_e          <= 0;
      rs2_e          <= 0;
      pc_e           <= 0;
      rs2_data_e     <= 0;
      rs1_data_e     <= 0;
    end else if (!stall_e) begin
      pc_write_e     <= pc_write_d;
      rd_write_e     <= rd_write_d;
      rd_write_src_e <= rd_write_src_d;
      mem_write_e    <= mem_write_d;
      alu_op_e       <= alu_op_d;
      alu_src1_e     <= alu_src1_d;
      alu_src2_e     <= alu_src2_d;
      rd_e           <= rd_d;
      immU_e         <= immU_d;
      immS_e         <= immS_d;
      immI_e         <= immI_d;
      rs1_e          <= rs1_d;
      rs2_e          <= rs2_d;
      pc_e           <= pc_d;
      rs2_data_e     <= rs2_data_d;
      rs1_data_e     <= rs1_data_d;
    end
  end

endmodule // execute
// Local Variables:
// verilog-library-directories:("../modules")
// End:
