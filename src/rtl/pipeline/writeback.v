/*
 WRITEBACK (_w) pipeline stage
 */
module writeback
(
 input         rst_n,
 input         clk,
 // from memory stage:
 input         rd_write_m,
 input [1:0]   rd_write_src_m,
 input [4:0]   rd_m,
 input [31:0]  pc_m,
 input [31:0]  alu_res_m,
 input [31:0]  mem_read_data_m,
 // to decode stage (write to register file):
 output        rd_write_w,
 output [4:0]  rd_w,
 output [31:0] rd_data_w
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            rd_data_w;
  reg [4:0]             rd_w;
  reg                   rd_write_w;
  // End of automatics
  reg [1:0]             rd_write_src_w;
  reg [31:0]            pc_w;
  reg [31:0]            alu_res_w;
  reg [31:0]            mem_read_data_w;

  //assign rd_data_w = rd_write_src_w ? mem_read_data_w : alu_res_w;

  always @ (*) begin
    case (rd_write_src_w)
      `RDSRC_PC  : rd_data_w = pc_w + 4;
      `RDSRC_ALU : rd_data_w = alu_res_w;
      `RDSRC_MEM : rd_data_w = mem_read_data_w;
      default    : rd_data_w = alu_res_w;
    endcase // case (rd_write_src_w)
  end
  
  // PIPELINE:
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_write_w      <= 0;
      rd_w            <= 0;
      rd_write_src_w  <= 0;
      pc_w            <= 0;
      alu_res_w       <= 0;
      mem_read_data_w <= 0;
    end else begin
      rd_write_w      <= rd_write_m;
      rd_w            <= rd_m;
      rd_write_src_w  <= rd_write_src_m;
      pc_w            <= pc_m;
      alu_res_w       <= alu_res_m;
      mem_read_data_w <= mem_read_data_m;
    end
  end // always @ (posedge clk or negedge rst_n)
  
endmodule // writeback

