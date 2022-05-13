/*
 Instruction Memory
 */
module imem
#(parameter SIZE = 64)
(
 input  [31:0] addr, // instruction address
 output [31:0] data  // instruction value
 );

  reg [31:0]   mem [SIZE];
  
  assign data = mem[addr];
  
  initial begin
    $readmemh("program.hex", mem);
  end  

endmodule // imem
