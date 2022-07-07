module dmem
#(parameter SIZE = 256)
(
    input [31:0] addr,
    input write,
    input [31:0] write_data,
    output [31:0] data,
    output valid
);

    reg [31:0] mem [SIZE];
    
    assign data = mem[addr[7:0]];
    assign valid = 1'b1;

    initial begin
      for (int i = 0; i < SIZE; i++) begin
        mem[i] = 0;
      end
    end
    
    always @ (*) begin
        if (write)
            mem[addr[7:0]] = write_data;
    end

endmodule
