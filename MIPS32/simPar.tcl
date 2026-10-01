if {$argc != 1} {
    puts "Missing Instruction Memory File ... Exiting"
} else {
    set outputDir ./sim_output
    file delete -force $outputDir
    file mkdir $outputDir
    cd $outputDir

    # exec xvlog --sv ../../commonFunctions.sv
    exec xvlog ../../instructionMemory.v 
    exec xvlog ../../decoder.v -i ../../commonFunctions.vh
    exec xvlog ../../execute.v -i ../../commonFunctions.vh
    exec xvlog ../../dataMemory.v -i ../../commonFunctions.vh
    exec xvlog ../../topModule.v
    # exec xvlog -i ../../commonFunctions.vh
    exec xvlog --sv ../../tb.sv

    set INSTR_FILE [lindex $argv 0]
    puts "instr file: $INSTR_FILE"

    exec xelab -debug typical -top tb -generic "instr_file=$INSTR_FILE" -snapshot sim_snapshot

    exec xsim sim_snapshot -gui -tclbatch ../sim_commands.tcl
}


