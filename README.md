# Mips32

This is an ongoing implementation of the MIPS32 ISA for Coprocessor 0.

This design incorporates a 5-stage pipeline (Fetch - Decode - Execute - Memory Access - Writeback).

# Phase 1

Implementing the Coprocessor 0 ISA.

# Phase 2

Implementing TLB, Cache, Access Control

# Build

Inside the project directory, run:

chmod +x build.sh

./build.sh

# Execute and Testing

Test files are located in the Assembly and Binary directory. The Binary files that correspond to the Assembly file will share the same name with "_Binary" appended to the end.

Inside the project directory, run:

obj_dir/VtopModyle +instr_file=Binary/[Binary File Name]

