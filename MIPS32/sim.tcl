set outputDir ./sim_output
file delete -force $outputDir
file mkdir $outputDir
cd $outputDir

exec xvlog --sv ../../commonFunctions.sv
exec xvlog --sv ../../instructionMemory.sv 
exec xvlog --sv ../../decoder.sv
exec xvlog --sv ../../execute.sv
exec xvlog --sv ../../dataMemory.sv
exec xvlog --sv ../../topModule.sv
exec xvlog --sv ../../tb.sv

exec xelab -debug typical -top tb -snapshot sim_snapshot

exec xsim sim_snapshot --testplusarg "instr_file=../../Binary/Addiu_Binary.txt" -gui -tclbatch ../sim_commands.tcl