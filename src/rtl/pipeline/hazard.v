/*
 Hazard Control Unit
 */
module hazard
(
 // bypass (for execute stage):
 input        rd_write_m,
 input [4:0]  rd_m, 
 input        rd_write_w,
 input [4:0]  rd_w,
 input [4:0]  rs1_e,
 input [4:0]  rs2_e,
 output [1:0] forwarding_rs1_e,
 output [1:0] forwarding_rs2_e,
 // stall (fetch & decode stages):
 input        pc_write_d,
 input        pc_write_e,
 input        pc_write_m,
 input [1:0]  rd_write_src_e,
 input [1:0]  rd_write_src_m,
 input [4:0]  rd_e,
 input [4:0]  rs1_d,
 input [4:0]  rs2_d,
 input        mem_valid_m,
 output       stall_f,
 output       stall_d,
 output       stall_e,
 output       stall_m,
 output       flush_d,
 output       flush_e,
 // branch execute pause:
 input        branch,
 input        branch_d,
 input        mem_to_reg_m,
 input        rd_write_e,
 output       forwarding_rs1_d,
 output       forwarding_rs2_d
 );

  wire        lw_stall;          // stall, when execute load word insturction
  wire        branch_stall;      // stall, while branch calculating
  wire        jump_stall;        // stall, while jumping
  wire        memory_read_stall; // stall, while read data memory
    
  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [1:0]             forwarding_rs1_e;
  reg [1:0]             forwarding_rs2_e;
  // End of automatics

  always @ (*) begin
    if (rd_write_m && rs1_e == rd_m) begin
      forwarding_rs1_e = 2'b10;
    end else if (rd_write_w && rs1_e == rd_w) begin
      forwarding_rs1_e = 2'b01;
    end else begin
      forwarding_rs1_e = 2'b00;
    end
  end

  always @ (*) begin
    if (rd_write_m && rs2_e == rd_m) begin
      forwarding_rs2_e = 2'b10;
    end else if (rd_write_w && rs2_e == rd_w) begin
      forwarding_rs2_e = 2'b01;
    end else begin
      forwarding_rs2_e = 2'b00;
    end
  end

  assign mem_to_reg = rd_write_src_e == `RDSRC_MEM;
  assign lw_stall = ((rd_e == rs1_d) || (rd_e == rs2_d)) && mem_to_reg  ;
  assign branch_stall = (branch && rd_write_e && (rd_e == rs1_d || rd_e == rs2_d))
                     || (branch && rd_write_m && (rd_m == rs1_d || rd_m == rs2_d));
  assign jump_stall = pc_write_d || pc_write_e || pc_write_m;
  assign memory_read_stall = (rd_write_src_m == `RDSRC_MEM) && !mem_valid_m;
      
  assign stall_d = lw_stall || branch_stall || memory_read_stall;
  assign stall_f = lw_stall || branch_stall || memory_read_stall;
  assign stall_e = memory_read_stall;
  assign stall_m = memory_read_stall;
              
  assign flush_e = lw_stall || branch_stall;
  assign flush_d = branch_d || jump_stall;
        
  assign forwarding_rs1_d = (rs1_d == rd_m) && rd_write_m;
  assign forwarding_rs2_d = (rs2_d == rd_m) && rd_write_m;
    
endmodule // hazard 
