/*
 Constrol Status Register File (CSR)
 */
module csr
(
 input         rst_n,
 input         clk,
 input         csr_wr_en,
 input [2:0]   csr_op,
 input [11:0]  csr_addr,
 input [31:0]  csr_data_in,
 output [31:0] csr_data_out
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            csr_data_out;
  // End of automatics
  
  always @ (*) begin
    csr_data_out <= 0;
  end
  
endmodule // csr
