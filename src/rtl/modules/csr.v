/*
 Constrol Status Register File (CSR)
 */
module csr
(
 input         rst_n,
 input         clk,
 input         csr_wr_en,
 input [2:0]   csr_op,
 input [4:0]   csr_uimm,
 input [11:0]  csr_addr,
 input [31:0]  csr_data_in,
 output [31:0] csr_data_out
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            csr_data_out;
  // End of automatics
  reg [31:0]            wr_data;
  reg [31:0]            debug;
  
  wire [31:0]           in_data;

  assign in_data = csr_op[2] == `CSR_IMM ? { 27'b0, csr_uimm } : csr_data_in;       
  
  always @ (*) begin
    case (csr_op[1:0])
      `CSR_NOP : wr_data = csr_data_out;
      `CSR_RW  : wr_data = in_data;
      `CSR_RS  : wr_data = csr_data_out |  in_data;
      `CSR_RC  : wr_data = csr_data_out & ~in_data;
    endcase
  end

  always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      csr_data_out <= 32'h0;
    end else begin
      case (csr_addr)
        12'd777  : csr_data_out = debug;
        default  : csr_data_out = 32'h0;
      endcase // case (csr_addr)
    end
  end

  always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      debug <= 32'h0;
    end else if (csr_addr == 12'd777) begin
      debug <= wr_data;
    end
  end
  
endmodule // csr
