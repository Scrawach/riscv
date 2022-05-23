main = main
arch = rv32i

assembly:
	riscv32-unknown-elf-gcc -march=$(arch) -S $(main).c -o $(main).S
	
--compile-elf-file:
	riscv32-unknown-elf-gcc -nostartfiles -march=$(arch) $(main).c -o $(main)
	
--compile-binary-file: --compile-elf-file
	riscv32-unknown-elf-objcopy -O binary $(main) $(main).bin
	
--dump: 
	od -t x4 -v -An -w4 $(main).bin > $(main).dump
	
--toHex: 
	cut -c2- $(main).dump > $(main).hex
	
compile: assembly --compile-binary-file --dump --toHex clean

clean:
	rm -rf $(main) $(main).o $(main).bin $(main).dump
