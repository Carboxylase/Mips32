# Mips32

This is an implementation of the MIPS32 ISA for Coprocessor 0 intended to be run on an FPGA.
This design incorporates a 5-stage pipeline (Fetch - Decode - Execute - Memory Access - Writeback) running at 100 Mhz.

There were several challenges to avoid data hazards and meeting timing for instructions with a large critical path.

Data hazards largely come from requests to access the CPU register file in the Execute stage when the data has not reached the Writeback stage.
Pipelined feed-forward wires were added before data was provided to the Execute module.
The outgoing requested CPU registers from the Decoder module were compared with the feed-forward wires to determine if there was a read-after-write hazard and the correct value is sent to the Execute Module.
This avoided adding NOP "bubbles" the pipeline and saves up to 2 cycles.

A larger improvement to the performance was made to long executing instructions.
Default multiplication and division operators in Verilog generates an inefficient circuit.
Using the default operators the clock would need to be less than 1 Mhz.
The work around was to split the operation into 32 cycles, using the Booth's algorithm for multiplication and division.
This implementation uses stalling in the Fetch and Decode sections to hold the two instructions after the multiplication and division operation to save 2 cycles.
Further optimizations were made with the lower and higher multiplication and division instructions.
The result of multiplying or dividing two 32-bit values result in a 64-bit value.
So capturing the entire result in the CPU registers requires two instructions for the upper and lower 32 bits.
By saving which operands were used, instead of computing the same result twice for 64 cycles. the result will be saved after computing it for the first time.
In the future if the result needs to be accessed again to return the other 32 bits, then the result can be given in 1 cycle, saving 31 cycles.

# Vivado Build and Execute
The Vivado .xpr file can be found in the MIPS32 sub-directory. There are several scripts that can be run from the Vivado TCL console in GUI mode.

simPar.tcl: will launch a standalone simulation.
synImp.tcl: will synthesize and implement the desing - used to check the compliance of the design with the FPGA architecutre.
genBits.tcl: will synthesize and implement the design, then generate the bit stream and flash the FPGA.

# Verilator Build

Inside the project directory, run:

chmod +x build.sh

./build.sh

# Verilator Execute and Testing

Test files are located in the Assembly and Binary directory. The Binary files that correspond to the Assembly file will share the same name with "_Binary" appended to the end.

Inside the project directory, run:

obj_dir/VtopModyle +instr_file=Binary/[Binary File Name]

