/*
 Register File (FILE)
 */
module file
(
 input         rst_n, 
 input         clk, 
 input [ 4:0]  rs1_addr, // register source #1 address
 input [ 4:0]  rs2_addr, // register source #2 address
 input [ 4:0]  rd_addr,  // register destination address
 input         rd_write, // write enable
 input [31:0]  rd_data,  // write data
 output [31:0] rs1_data, // register source #1 data output
 output [31:0] rs2_data  // register source #2 data output  
 );

  reg [31:0]   rf [31:0]; // register file
  
  assign rs1_data = rf[rs1_addr];
  assign rs2_data = rf[rs2_addr];

  always @ ( negedge clk or negedge rst_n ) begin
    if ( rst_n == 1'b0 ) begin
      for (int i = 0; i < 32; i++) begin
        rf[i] <= 0;
      end
    end else if ( rd_write && rd_addr != 0 ) begin
        rf[rd_addr] <= rd_data;
    end
  end
  
endmodule // file
