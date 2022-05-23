/*
 Control Unit (CU)
 */
module cu
(
 input [6:0]  cmd_op,
 input [2:0]  func3,
 input [6:0]  func7,
 output       pc_write,
 output       rd_write,
 output [1:0] rd_write_src,
 output       mem_write,
 output [3:0] alu_op,
 output [1:0] alu_src1,
 output       alu_src2,
 output       fast_jump,
 output       branch,
 output [2:0] branch_condition
 );

  /*AUTOREG*/
  // Beginning of automatic regs (for this module's undeclared outputs)
  reg [3:0]             alu_op;
  reg [1:0]             alu_src1;
  reg                   alu_src2;
  reg                   branch;
  reg [2:0]             branch_condition;
  reg                   fast_jump;
  reg                   mem_write;
  reg                   pc_write;
  reg                   rd_write;
  reg [1:0]             rd_write_src;
  // End of automatics
  // cond_zero: BEQ (1'b0) or BNE (1'b1); 

  always @ ( * ) begin
    pc_write         = 1'b0;
    rd_write         = 1'b0;
    alu_op           = `ALUOP_ADD;
    rd_write_src     = `RDSRC_ALU;
    mem_write        = 1'b0;
    branch           = 1'b0;
    branch_condition = 3'b000;
    fast_jump        = 1'b0;
    alu_src1         = 2'b00;
    alu_src2         = 1'b0;

    casez ( { func7, func3, cmd_op } )
      // U-Type:
      { `RVF7_ANY,  `RVF3_ANY,  `RVOP_LUI  } : begin rd_write = 1'b1; alu_op = `ALUOP_SRC1; alu_src1 = `ALUSRC1_IMMU; end
      { `RVF7_ANY,  `RVF3_ANY,  `RVOP_AUIPC} : begin rd_write = 1'b1; alu_op = `ALUOP_ADD; alu_src1 = `ALUSRC1_IMMU; rd_write_src = `RDSRC_ALU; alu_src2 = `ALUSRC2_PC; end
      
      // J-Type:
      { `RVF7_ANY,  `RVF3_ANY,  `RVOP_JAL  } : begin rd_write = 1'b1; alu_op = `ALUOP_SRC1; fast_jump = 1'b1; rd_write_src = `RDSRC_PC;  end
      // I-Type:
      { `RVF7_ANY,  `RVF3_JALR, `RVOP_JALR } : begin rd_write = 1'b1; alu_op = `ALUOP_ADD; alu_src1 = `ALUSRC1_IMMI; pc_write = 1'b1; rd_write_src = `RDSRC_PC; end

      // B-Type:
      { `RVF7_ANY,  `RVF3_BEQ,   `RVOP_BEQ  } : begin branch = 1'b1; branch_condition = `BRANCH_EQ;           end
      { `RVF7_ANY,  `RVF3_BNE,   `RVOP_BNE  } : begin branch = 1'b1; branch_condition = `BRANCH_NEQ;          end
      { `RVF7_ANY,  `RVF3_BLT,   `RVOP_BLT  } : begin branch = 1'b1; branch_condition = `BRANCH_LESS_SIGN;    end
      { `RVF7_ANY,  `RVF3_BGE,   `RVOP_BGE  } : begin branch = 1'b1; branch_condition = `BRANCH_GREATER_SIGN; end
      { `RVF7_ANY,  `RVF3_BLTU,  `RVOP_BLTU } : begin branch = 1'b1; branch_condition = `BRANCH_LESS;         end
      { `RVF7_ANY,  `RVF3_BGEU,  `RVOP_BGEU } : begin branch = 1'b1; branch_condition = `BRANCH_GREATER;      end

      // I-Type:
      { `RVF7_ANY,  `RVF3_LW,  `RVOP_LW } : begin rd_write = 1'b1; alu_op = `ALUOP_ADD; alu_src1 = `ALUSRC1_IMMI; rd_write_src = `RDSRC_MEM; end
      // S-Type:
      { `RVF7_ANY,  `RVF3_SW,  `RVOP_SW } : begin alu_src1 = `ALUSRC1_IMMS; mem_write = 1'b1; end

      // I-Type:
      { `RVF7_ANY,  `RVF3_ADDI,  `RVOP_ADDI  } : begin rd_write = 1'b1; alu_op = `ALUOP_ADD;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_ANY,  `RVF3_SLTI,  `RVOP_SLTI  } : begin rd_write = 1'b1; alu_op = `ALUOP_SLT;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_ANY,  `RVF3_SLTIU, `RVOP_SLTIU } : begin rd_write = 1'b1; alu_op = `ALUOP_SLTU; alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_ANY,  `RVF3_XORI,  `RVOP_XORI  } : begin rd_write = 1'b1; alu_op = `ALUOP_XOR;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_ANY,  `RVF3_ORI,   `RVOP_ORI   } : begin rd_write = 1'b1; alu_op = `ALUOP_OR;   alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_ANY,  `RVF3_ANDI,  `RVOP_ANDI  } : begin rd_write = 1'b1; alu_op = `ALUOP_AND;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_SLLI, `RVF3_SLLI,  `RVOP_SLLI  } : begin rd_write = 1'b1; alu_op = `ALUOP_SLL;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_SRLI, `RVF3_SRLI,  `RVOP_SRLI  } : begin rd_write = 1'b1; alu_op = `ALUOP_SRL;  alu_src1 = `ALUSRC1_IMMI; end
      { `RVF7_SRAI, `RVF3_SRAI,  `RVOP_SRAI  } : begin rd_write = 1'b1; alu_op = `ALUOP_SRA;  alu_src1 = `ALUSRC1_IMMI; end
      
      // R-Type:
      { `RVF7_ADD,  `RVF3_ADD,   `RVOP_ADD   } : begin rd_write = 1'b1; alu_op = `ALUOP_ADD;  end
      { `RVF7_SUB,  `RVF3_SUB,   `RVOP_SUB   } : begin rd_write = 1'b1; alu_op = `ALUOP_SUB;  end
      { `RVF7_SLL,  `RVF3_SLL,   `RVOP_SLL   } : begin rd_write = 1'b1; alu_op = `ALUOP_SLL;  end
      { `RVF7_SLT,  `RVF3_SLT,   `RVOP_SLT   } : begin rd_write = 1'b1; alu_op = `ALUOP_SLT;  end
      { `RVF7_SLTU, `RVF3_SLTU,  `RVOP_SLTU  } : begin rd_write = 1'b1; alu_op = `ALUOP_SLTU; end
      { `RVF7_XOR,  `RVF3_XOR,   `RVOP_XOR   } : begin rd_write = 1'b1; alu_op = `ALUOP_XOR;  end
      { `RVF7_SRL,  `RVF3_SRL,   `RVOP_SRL   } : begin rd_write = 1'b1; alu_op = `ALUOP_SRL;  end
      { `RVF7_SRA,  `RVF3_SRA,   `RVOP_SRA   } : begin rd_write = 1'b1; alu_op = `ALUOP_SRA;  end
      { `RVF7_OR,   `RVF3_OR,    `RVOP_OR    } : begin rd_write = 1'b1; alu_op = `ALUOP_OR;   end
      { `RVF7_AND,  `RVF3_AND,   `RVOP_AND   } : begin rd_write = 1'b1; alu_op = `ALUOP_AND;  end
    endcase // casez ( { func7, func3, cmd_op } )
  end
  
endmodule // cu
