/*
 FETCH (_f) pipeline part
 */
module fetch
(
 input         rst_n,
 input         clk,
 // memory interface:
 output [31:0] im_addr,
 input [31:0]  im_data,
 // pipeline interface
 input         branch_d,
 input [31:0]  branch_next_addr_d,
 input         pc_write_m,
 input [31:0]  pc_next_addr_m,
 input         stall_f,
 output [31:0] instruction_f,
 output [31:0] pc_f
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [31:0]            pc_f;
  // End of automatics
  reg [31:0]            pc_next;
  wire [31:0]           im_addr;
  
  assign im_addr = pc_f >> 2;
  assign instruction_f = im_data;
  
  always @ (*) begin
    if (pc_write_m)
      pc_next = pc_next_addr_m;
    else if (branch_d)
      pc_next = branch_next_addr_d;
    else if (!stall_f)
      pc_next = pc_f + 3'd4;
    else
      pc_next = pc_f;
  end
  
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
      pc_f <= 0;
    else
      pc_f <= pc_next;
  end

endmodule // fetch
// Local Variables:
// verilog-library-directories:("../modules")
// End: