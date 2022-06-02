/*
 MEMORY (_m) pipeline stage
 */
module memory
(
 input         rst_n,
 input         clk,
 // from execute stage:
 input         pc_write_e,
 input         rd_write_e,
 input [1:0]   rd_write_src_e,
 input         mem_write_e,
 input [4:0]   rd_e,
 input [31:0]  pc_e,
 input [31:0]  alu_res_e,
 input [31:0]  mem_data_e,
 input [31:0]  csr_data_e,
 // to writeback stage:
 output        pc_write_m,
 output [31:0] pc_next_addr_m,
 output        rd_write_m,
 output [1:0]  rd_write_src_m,
 output [4:0]  rd_m,
 output [31:0] pc_m,
 output [31:0] alu_res_m,
 output [31:0] mem_read_data_m,
 output [31:0] csr_data_m,
 // to data memory:
 output [31:0] mem_write_data,
 output [31:0] mem_addr,
 output        mem_write,
 input         mem_valid,
 input [31:0]  mem_read_data,
 // to hazard unit:
 input         stall_m,
 output        mem_valid_m
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            alu_res_m;
  reg [31:0]            csr_data_m;
  reg [31:0]            pc_m;
  reg                   pc_write_m;
  reg [4:0]             rd_m;
  reg                   rd_write_m;
  reg [1:0]             rd_write_src_m;
  // End of automatics
  reg                   mem_write_m;
  reg [31:0]            mem_data_m;

  assign pc_next_addr_m = alu_res_m;

  // memory interface:
  assign mem_write_data = mem_data_m;
  assign mem_addr = alu_res_m;
  assign mem_write = mem_write_m;

  assign mem_read_data_m = mem_read_data;
  assign mem_valid_m = mem_valid;
          
  // PIPELINE:
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc_write_m     <= 0;
      rd_write_m     <= 0;
      rd_write_src_m <= 0;
      mem_write_m    <= 0;
      rd_m           <= 0;
      pc_m           <= 0;
      alu_res_m      <= 0;
      mem_data_m     <= 0;
      csr_data_m     <= 0;
    end else if (!stall_m) begin
      pc_write_m     <= pc_write_e;
      rd_write_m     <= rd_write_e;
      rd_write_src_m <= rd_write_src_e;
      mem_write_m    <= mem_write_e;
      rd_m           <= rd_e;
      pc_m           <= pc_e;
      alu_res_m      <= alu_res_e;
      mem_data_m     <= mem_data_e;
      csr_data_m     <= csr_data_e;
    end
  end // always @ (posedge clk or negedge rst_n)
  
endmodule // memory

