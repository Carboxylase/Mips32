synth_design -top topModule -flatten_hierarchy none -generic "instr_file=../Binary/Mul_Muh_Binary.txt"

report_utilization -file utilization.txt

report_timing > timing.txt

opt_design

place_design -directive Default

route_design -directive Default

write_checkpoint -force post_place.dcp

report_utilization -file post_route_utilization.rpt

write_checkpoint -force post_route.dcp

write_bitstream -force topModule.bit

# Disconnect previous hardware connections
# disconnect_hw_server
# close_hw_manager

# Connect to FPGA through USB/JTAG
open_hw_manager
connect_hw_server
open_hw_target

# Show detected devices
get_hw_devices

# Select the FPGA
set hw_device [get_hw_devices xc7z020_1]

# Load bitstream
set_property PROGRAM.FILE [file normalize "topModule.bit"] $hw_device

# Program FPGA
program_hw_devices $hw_device

# Refresh
refresh_hw_device $hw_device

# Close hardware connection
close_hw_target
disconnect_hw_server
close_hw_manager