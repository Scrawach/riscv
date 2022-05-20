/*
 FETCH (_f) pipeline part
 */
module fetch
#( parameter BOOT_ADDRESS = 32'h00_00_00_00)
(
 input         rst_n,
 input         clk,
 // memory interface:
 output [31:0] im_addr,
 input         im_valid,
 input [31:0]  im_data,
 // pipeline interface
 input         branch_d,
 input [31:0]  branch_next_addr_d,
 input         pc_write_m,
 input [31:0]  pc_next_addr_m,
 input         stall_f,
 output [31:0] instruction_f,
 output [31:0] pc_f,
 output        mem_valid_f
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            pc_f;
  // End of automatics
  reg [31:0]            pc_next;
  wire [31:0]           im_addr;
  
  assign im_addr = pc_f >> 2;
  assign instruction_f = im_data;
  assign mem_valid_f = im_valid;
    
  always @ (*) begin
    if (stall_f)
      pc_next = pc_f;
    if (pc_write_m)
      pc_next = pc_next_addr_m;
    else if (branch_d)
      pc_next = branch_next_addr_d;
    else
      pc_next = pc_f + 3'd4;
  end
  
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
      pc_f <= BOOT_ADDRESS;
    else
      pc_f <= pc_next;
  end

endmodule // fetch
// Local Variables:
// verilog-library-directories:("../modules")
// End:
