module cpu_tb;

  /*AUTOREGINPUT*/
  // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
  reg                   clk;                    // To cpu of cpu.v
  reg                   im_valid;               // To cpu of cpu.v
  reg                   rst_n;                  // To cpu of cpu.v
  // End of automatics
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [31:0]           im_addr;                // From cpu of cpu.v
  wire [31:0]           im_data;                // From im of imem.v
  wire [31:0]           mem_addr;               // From cpu of cpu.v
  wire [31:0]           mem_read_data;          // From dm of dmem.v
  wire                  mem_valid;              // From dm of dmem.v
  wire                  mem_write;              // From cpu of cpu.v
  wire [31:0]           mem_write_data;         // From cpu of cpu.v
  // End of automatics
  cpu cpu(/*AUTOINST*/
          // Outputs
          .im_addr                      (im_addr[31:0]),
          .mem_write_data               (mem_write_data[31:0]),
          .mem_addr                     (mem_addr[31:0]),
          .mem_write                    (mem_write),
          // Inputs
          .rst_n                        (rst_n),
          .clk                          (clk),
          .im_valid                     (im_valid),
          .im_data                      (im_data[31:0]),
          .mem_valid                    (mem_valid),
          .mem_read_data                (mem_read_data[31:0]));

  /*imem AUTO_TEMPLATE(
   .\(.*\) (im_\1[]),
   );*/
  imem im (/*AUTOINST*/
           // Outputs
           .data                        (im_data[31:0]),         // Templated
           // Inputs
           .addr                        (im_addr[31:0]));         // Templated

  /*dmem AUTO_TEMPLATE(
   .data (mem_read_data[]),
   .\(.*\) (mem_\1[]),
   );*/
  dmem dm (/*AUTOINST*/
           // Outputs
           .data                        (mem_read_data[31:0]),   // Templated
           .valid                       (mem_valid),             // Templated
           // Inputs
           .addr                        (mem_addr[31:0]),        // Templated
           .write                       (mem_write),             // Templated
           .write_data                  (mem_write_data[31:0]));  // Templated

  assign im_valid = 1;
    
  initial begin : reset
    rst_n <= 1'b0;
    repeat(2) @(negedge clk);
    rst_n <= 1'b1;
  end

  initial begin : main
    repeat(10) @(posedge clk);
    $stop;
  end

  initial begin : clock
    clk <= 1'b0;
    forever #(10) clk = ~clk;
  end
  
endmodule // cpu_tb
// Local Variables:
// verilog-library-directories:("../rtl" "../rtl/cpu" "../rtl/pipeline" "../rtl/modules")
// End:
