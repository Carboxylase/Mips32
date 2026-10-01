# open_project MIPS32.xpr
# set_property file_type {Verilog Header} [get_files ./../commonFunctions.vh]

if {$argc != 1} {
    puts "Missing Instruction Memory File ... Exiting"
} else {

    set INSTR_FILE [lindex $argv 0]
    puts "instr file: $INSTR_FILE"

    # synth_design -top topModule -flatten_hierarchy full -generic "instr_file=../Binary/Addiu_Binary.mem"
    synth_design -top topModule -flatten_hierarchy none -generic "instr_file=$INSTR_FILE"

    report_utilization -file utilization.txt

    report_timing > timing.txt

    opt_design

    place_design -directive Default
    write_checkpoint -force post_place.dcp

    report_utilization -file post_route_utilization.rpt

    write_checkpoint -force post_route.dcp
}