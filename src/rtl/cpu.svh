// ------------
// INCLUDE FILE's
`ifndef _CPU_COMMANDS
`define _CPU_COMMANDS

//ALU commands
`define ALUOP_ADD     3'b000
`define ALUOP_OR      3'b001
`define ALUOP_SRL     3'b010
`define ALUOP_SLL     3'b011
`define ALUOP_SLTU    3'b100
`define ALUOP_SUB     3'b101
`define ALUOP_SRC1    3'b111

// MUXes 
`define ALUSRC1_RS2  2'b00
`define ALUSRC1_IMMI 2'b01
`define ALUSRC1_IMMS 2'b10
`define ALUSRC1_IMMU 2'b11

`define ALUSRC2_PC  1'b1
`define ALUSRC2_RS1 1'b0

`define RDSRC_PC    2'b00
`define RDSRC_ALU   2'b01
`define RDSRC_MEM   2'b10

// BRANCH
`define BRANCH_EQ           3'b000
`define BRANCH_NEQ          3'b001
`define BRANCH_LESS         3'b010
`define BRANCH_GREATER      3'b011
`define BRANCH_LESS_SIGN    3'b100
`define BRANCH_GREATER_SIGN 3'b101

// instruction opcode
`define RVOP_ADDI   7'b0010011

`define RVOP_BEQ    7'b1100011
`define RVOP_BNE    7'b1100011
`define RVOP_BLT    7'b1100011
`define RVOP_BGE    7'b1100011
`define RVOP_BLTU   7'b1100011
`define RVOP_BGEU   7'b1100011

`define RVOP_LUI    7'b0110111
`define RVOP_ADD    7'b0110011
`define RVOP_OR     7'b0110011
`define RVOP_SRL    7'b0110011
`define RVOP_SLL    7'b0110011
`define RVOP_SLTU   7'b0110011
`define RVOP_SUB    7'b0110011
`define RVOP_LW     7'b0000011
`define RVOP_SW     7'b0100011
`define RVOP_JAL    7'b1101111
`define RVOP_JALR   7'b1100111
`define RVOP_AUIPC  7'b0010111

// instruction funct3
`define RVF3_ADDI   3'b000

`define RVF3_BEQ    3'b000
`define RVF3_BNE    3'b001
`define RVF3_BLT    3'b100
`define RVF3_BGE    3'b101
`define RVF3_BLTU   3'b110
`define RVF3_BGEU   3'b111

`define RVF3_ADD    3'b000
`define RVF3_OR     3'b110
`define RVF3_SRL    3'b101
`define RVF3_SLL    3'b001
`define RVF3_SLTU   3'b011
`define RVF3_SUB    3'b000
`define RVF3_LW     3'b010
`define RVF3_SW     3'b010
`define RVF3_JALR   3'b000

`define RVF3_ANY    3'b???

// instruction funct7
`define RVF7_ADD    7'b0000000
`define RVF7_OR     7'b0000000
`define RVF7_SRL    7'b0000000
`define RVF7_SLL    7'b0000000
`define RVF7_SLTU   7'b0000000
`define RVF7_SUB    7'b0100000
`define RVF7_ANY    7'b???????
// ------------
`endif
