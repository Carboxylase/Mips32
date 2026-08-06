# open_project MIPS32.xpr
# set_property file_type {Verilog Header} [get_files ./../commonFunctions.vh]

synth_design -top topModule -flatten_hierarchy full -generic "instr_file=../Binary/Addiu_Binary.mem"

report_utilization -file utilization.txt

report_timing > timing.txt

opt_design

place_design -directive Default
write_checkpoint post_place.dcp

report_utilization -file post_route_utilization.rpt

write_checkpoint post_route.dcp