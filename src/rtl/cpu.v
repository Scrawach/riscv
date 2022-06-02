module cpu
(
 input         rst_n,
 input         clk,
 // instruction memory
 output [31:0] im_addr,
 input         im_valid,
 input [31:0]  im_data,
 // data memory
 output [31:0] mem_write_data,
 output [31:0] mem_addr,
 output        mem_write,
 input         mem_valid,
 input [31:0]  mem_read_data  
 );

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [3:0]            alu_op_d;               // From decode of decode.v
  wire [31:0]           alu_res_e;              // From execute of execute.v
  wire [31:0]           alu_res_m;              // From memory of memory.v
  wire [1:0]            alu_src1_d;             // From decode of decode.v
  wire                  alu_src2_d;             // From decode of decode.v
  wire                  branch;                 // From decode of decode.v
  wire                  branch_d;               // From decode of decode.v
  wire [31:0]           branch_next_addr_d;     // From decode of decode.v
  wire [31:0]           csr_data_e;             // From execute of execute.v
  wire [31:0]           csr_data_m;             // From memory of memory.v
  wire [2:0]            csr_op_d;               // From decode of decode.v
  wire                  csr_wr_en_d;            // From decode of decode.v
  wire                  flush_d;                // From hazard of hazard.v
  wire                  flush_e;                // From hazard of hazard.v
  wire                  forwarding_rs1_d;       // From hazard of hazard.v
  wire [1:0]            forwarding_rs1_e;       // From hazard of hazard.v
  wire                  forwarding_rs2_d;       // From hazard of hazard.v
  wire [1:0]            forwarding_rs2_e;       // From hazard of hazard.v
  wire [31:0]           immI_d;                 // From decode of decode.v
  wire [31:0]           immS_d;                 // From decode of decode.v
  wire [31:0]           immU_d;                 // From decode of decode.v
  wire [31:0]           instruction_f;          // From fetch of fetch.v
  wire [31:0]           mem_data_e;             // From execute of execute.v
  wire [31:0]           mem_read_data_m;        // From memory of memory.v
  wire                  mem_valid_f;            // From fetch of fetch.v
  wire                  mem_valid_m;            // From memory of memory.v
  wire                  mem_write_d;            // From decode of decode.v
  wire                  mem_write_e;            // From execute of execute.v
  wire [31:0]           pc_d;                   // From decode of decode.v
  wire [31:0]           pc_e;                   // From execute of execute.v
  wire [31:0]           pc_f;                   // From fetch of fetch.v
  wire [31:0]           pc_m;                   // From memory of memory.v
  wire [31:0]           pc_next_addr_m;         // From memory of memory.v
  wire                  pc_write_d;             // From decode of decode.v
  wire                  pc_write_e;             // From execute of execute.v
  wire                  pc_write_m;             // From memory of memory.v
  wire [4:0]            rd_d;                   // From decode of decode.v
  wire [31:0]           rd_data_w;              // From writeback of writeback.v
  wire [4:0]            rd_e;                   // From execute of execute.v
  wire [4:0]            rd_m;                   // From memory of memory.v
  wire [4:0]            rd_w;                   // From writeback of writeback.v
  wire                  rd_write_d;             // From decode of decode.v
  wire                  rd_write_e;             // From execute of execute.v
  wire                  rd_write_m;             // From memory of memory.v
  wire [1:0]            rd_write_src_d;         // From decode of decode.v
  wire [1:0]            rd_write_src_e;         // From execute of execute.v
  wire [1:0]            rd_write_src_m;         // From memory of memory.v
  wire                  rd_write_w;             // From writeback of writeback.v
  wire [4:0]            rs1_d;                  // From decode of decode.v
  wire [31:0]           rs1_data_d;             // From decode of decode.v
  wire [4:0]            rs1_e;                  // From execute of execute.v
  wire [4:0]            rs2_d;                  // From decode of decode.v
  wire [31:0]           rs2_data_d;             // From decode of decode.v
  wire [4:0]            rs2_e;                  // From execute of execute.v
  wire                  stall_d;                // From hazard of hazard.v
  wire                  stall_e;                // From hazard of hazard.v
  wire                  stall_f;                // From hazard of hazard.v
  wire                  stall_m;                // From hazard of hazard.v
  // End of automatics
  
  fetch fetch(/*AUTOINST*/
              // Outputs
              .im_addr                  (im_addr),
              .instruction_f            (instruction_f[31:0]),
              .pc_f                     (pc_f[31:0]),
              .mem_valid_f              (mem_valid_f),
              // Inputs
              .rst_n                    (rst_n),
              .clk                      (clk),
              .im_valid                 (im_valid),
              .im_data                  (im_data),
              .branch_d                 (branch_d),
              .branch_next_addr_d       (branch_next_addr_d[31:0]),
              .pc_write_m               (pc_write_m),
              .pc_next_addr_m           (pc_next_addr_m[31:0]),
              .stall_f                  (stall_f));
  
  decode decode(/*AUTOINST*/
                // Outputs
                .branch_d               (branch_d),
                .branch_next_addr_d     (branch_next_addr_d[31:0]),
                .pc_write_d             (pc_write_d),
                .rd_write_d             (rd_write_d),
                .rd_write_src_d         (rd_write_src_d[1:0]),
                .mem_write_d            (mem_write_d),
                .alu_op_d               (alu_op_d[3:0]),
                .alu_src1_d             (alu_src1_d[1:0]),
                .alu_src2_d             (alu_src2_d),
                .rd_d                   (rd_d[4:0]),
                .rs1_d                  (rs1_d[4:0]),
                .rs2_d                  (rs2_d[4:0]),
                .immU_d                 (immU_d[31:0]),
                .immS_d                 (immS_d[31:0]),
                .immI_d                 (immI_d[31:0]),
                .pc_d                   (pc_d[31:0]),
                .rs1_data_d             (rs1_data_d[31:0]),
                .rs2_data_d             (rs2_data_d[31:0]),
                .csr_wr_en_d            (csr_wr_en_d),
                .csr_op_d               (csr_op_d[2:0]),
                .branch                 (branch),
                // Inputs
                .rst_n                  (rst_n),
                .clk                    (clk),
                .instruction_f          (instruction_f[31:0]),
                .pc_f                   (pc_f[31:0]),
                .mem_valid_f            (mem_valid_f),
                .alu_res_e              (alu_res_e[31:0]),
                .rd_write_w             (rd_write_w),
                .rd_w                   (rd_w[4:0]),
                .rd_data_w              (rd_data_w[31:0]),
                .stall_d                (stall_d),
                .flush_d                (flush_d),
                .forwarding_rs1_d       (forwarding_rs1_d),
                .forwarding_rs2_d       (forwarding_rs2_d));
  
  execute execute(/*AUTOINST*/
                  // Outputs
                  .pc_write_e           (pc_write_e),
                  .rd_write_e           (rd_write_e),
                  .rd_write_src_e       (rd_write_src_e[1:0]),
                  .mem_write_e          (mem_write_e),
                  .rd_e                 (rd_e[4:0]),
                  .pc_e                 (pc_e[31:0]),
                  .alu_res_e            (alu_res_e[31:0]),
                  .mem_data_e           (mem_data_e[31:0]),
                  .csr_data_e           (csr_data_e[31:0]),
                  .rs1_e                (rs1_e[4:0]),
                  .rs2_e                (rs2_e[4:0]),
                  // Inputs
                  .rst_n                (rst_n),
                  .clk                  (clk),
                  .pc_write_d           (pc_write_d),
                  .rd_write_d           (rd_write_d),
                  .rd_write_src_d       (rd_write_src_d[1:0]),
                  .mem_write_d          (mem_write_d),
                  .alu_op_d             (alu_op_d[3:0]),
                  .alu_src1_d           (alu_src1_d[1:0]),
                  .alu_src2_d           (alu_src2_d),
                  .rd_d                 (rd_d[4:0]),
                  .immU_d               (immU_d[31:0]),
                  .immS_d               (immS_d[31:0]),
                  .immI_d               (immI_d[31:0]),
                  .rs1_d                (rs1_d[4:0]),
                  .rs2_d                (rs2_d[4:0]),
                  .pc_d                 (pc_d[31:0]),
                  .rs1_data_d           (rs1_data_d[31:0]),
                  .rs2_data_d           (rs2_data_d[31:0]),
                  .csr_wr_en_d          (csr_wr_en_d),
                  .csr_op_d             (csr_op_d[2:0]),
                  .alu_res_m            (alu_res_m[31:0]),
                  .rd_data_w            (rd_data_w[31:0]),
                  .stall_e              (stall_e),
                  .flush_e              (flush_e),
                  .forwarding_rs1_e     (forwarding_rs1_e[1:0]),
                  .forwarding_rs2_e     (forwarding_rs2_e[1:0]));
  
  memory memory(/*AUTOINST*/
                // Outputs
                .pc_write_m             (pc_write_m),
                .pc_next_addr_m         (pc_next_addr_m[31:0]),
                .rd_write_m             (rd_write_m),
                .rd_write_src_m         (rd_write_src_m[1:0]),
                .rd_m                   (rd_m[4:0]),
                .pc_m                   (pc_m[31:0]),
                .alu_res_m              (alu_res_m[31:0]),
                .mem_read_data_m        (mem_read_data_m[31:0]),
                .csr_data_m             (csr_data_m[31:0]),
                .mem_write_data         (mem_write_data),
                .mem_addr               (mem_addr),
                .mem_write              (mem_write),
                .mem_valid_m            (mem_valid_m),
                // Inputs
                .rst_n                  (rst_n),
                .clk                    (clk),
                .pc_write_e             (pc_write_e),
                .rd_write_e             (rd_write_e),
                .rd_write_src_e         (rd_write_src_e[1:0]),
                .mem_write_e            (mem_write_e),
                .rd_e                   (rd_e[4:0]),
                .pc_e                   (pc_e[31:0]),
                .alu_res_e              (alu_res_e[31:0]),
                .mem_data_e             (mem_data_e[31:0]),
                .csr_data_e             (csr_data_e[31:0]),
                .mem_valid              (mem_valid),
                .mem_read_data          (mem_read_data),
                .stall_m                (stall_m));
  
  writeback writeback(/*AUTOINST*/
                      // Outputs
                      .rd_write_w       (rd_write_w),
                      .rd_w             (rd_w[4:0]),
                      .rd_data_w        (rd_data_w[31:0]),
                      // Inputs
                      .rst_n            (rst_n),
                      .clk              (clk),
                      .rd_write_m       (rd_write_m),
                      .rd_write_src_m   (rd_write_src_m[1:0]),
                      .rd_m             (rd_m[4:0]),
                      .pc_m             (pc_m[31:0]),
                      .alu_res_m        (alu_res_m[31:0]),
                      .mem_read_data_m  (mem_read_data_m[31:0]),
                      .csr_data_m       (csr_data_m[31:0]));
  
  hazard hazard(/*AUTOINST*/
                // Outputs
                .forwarding_rs1_e       (forwarding_rs1_e[1:0]),
                .forwarding_rs2_e       (forwarding_rs2_e[1:0]),
                .stall_f                (stall_f),
                .stall_d                (stall_d),
                .stall_e                (stall_e),
                .stall_m                (stall_m),
                .flush_d                (flush_d),
                .flush_e                (flush_e),
                .forwarding_rs1_d       (forwarding_rs1_d),
                .forwarding_rs2_d       (forwarding_rs2_d),
                // Inputs
                .rd_write_m             (rd_write_m),
                .rd_m                   (rd_m[4:0]),
                .rd_write_w             (rd_write_w),
                .rd_w                   (rd_w[4:0]),
                .rs1_e                  (rs1_e[4:0]),
                .rs2_e                  (rs2_e[4:0]),
                .pc_write_d             (pc_write_d),
                .pc_write_e             (pc_write_e),
                .pc_write_m             (pc_write_m),
                .rd_write_src_e         (rd_write_src_e[1:0]),
                .rd_write_src_m         (rd_write_src_m[1:0]),
                .rd_e                   (rd_e[4:0]),
                .rs1_d                  (rs1_d[4:0]),
                .rs2_d                  (rs2_d[4:0]),
                .mem_valid_f            (mem_valid_f),
                .mem_valid_m            (mem_valid_m),
                .branch                 (branch),
                .branch_d               (branch_d),
                .mem_to_reg_m           (mem_to_reg_m),
                .rd_write_e             (rd_write_e));
        
endmodule // cpu
// Local Variables:
// verilog-library-directories:("./pipeline")
// End:
  
