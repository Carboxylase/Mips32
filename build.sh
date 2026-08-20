verilator --binary -j 0 -I ./commonFunctions.vh -Wall --top-module topModule topModule.v

verilator --trace --cc -exe -Wall testbench.cpp topModule.v -Ginstr_file="\"$1\""

cat >> obj_dir/VtopModule.mk <<'EOF'

verilated_vcd_c.o: ${VERILATOR_ROOT}/include/verilated_vcd_c.cpp
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<

VK_GLOBAL_OBJS += verilated_vcd_c.o

EOF

make -j -C obj_dir -f VtopModule.mk VtopModule