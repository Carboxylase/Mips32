set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {sim_snapshot} -testplusarg instr_file=../../Binary/Addiu_Binary.txt -autoloadwcfg -tclbatch {../sim_commands.tcl}
