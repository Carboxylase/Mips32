# synth_design -top topModule -flatten_hierarchy none -generic "instr_file=../Binary/Mul_Muh_Binary.txt"
# open_run synth_1 -name netlist_1
# write_verilog -mode funcsim test_synth

set INSTR_FILE "./Binary/Mul_Muh_Binary.txt"

synth_design -top topModule -flatten_hierarchy none -generic "instr_file=$INSTR_FILE"

report_utilization -file utilization.txt

report_timing > timing.txt

opt_design

place_design -directive Default
# write_checkpoint -force post_place.dcp

route_design

write_verilog -force -mode timesim -sdf_anno true -sdf_file postRoute.sdf post_route_netlist.v

write_sdf -force postRoute.sdf

# set_property -name {xsim.elaborate.xelab.more_options} -value "-generic_top instr_file=$INSTR_FILE" -objects [get_filesets sim_1]

set_property xsim.elaborate.xelab.more_options {} [get_filesets sim_1]

set_property xsim.simulate.runtime 1us [get_filesets sim_1]

launch_simulation -simset sim_1 -mode post-implementation -type timing

# report_utilization -file post_route_utilization.rpt

# write_checkpoint -force post_route.dcp