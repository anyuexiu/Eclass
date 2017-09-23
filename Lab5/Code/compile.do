



#		Arjun Bangre

#	 Do file for Compilation of all Verilog and System verilog Files

#	 Running this file - simulates the Execute_test_top



# Compile the verilog Files

	vlog *.vp
	vlog *.v

## Compile System Verilog Files

vlog -mfcu -sv data_defs.v Packet_abangre1.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard_coverage.sv Generator.sv Execute.tb.sv Execute.test_top.sv Execute.if.sv

## Simulate the Test Top Module 


vsim -coverage -novopt -sv_seed 129610023857   Execute_test_top
	

run 2500ns

coverage save ./abangre_opwords.ucdb


restart -f

## Compile System Verilog Files

vlog -mfcu -sv data_defs.v Packet_abangre2.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard_coverage.sv Generator.sv Execute.tb.sv Execute.test_top.sv Execute.if.sv

## Simulate the Test Top Module 


vsim -coverage -novopt -sv_seed 22333544885 Execute_test_top
	

run 4500ns

coverage save ./abangre_arith_shift_memrd.ucdb

##restart -f

## Compile System Verilog Files

##vlog -mfcu -sv data_defs.v Packet_abangre3.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard_coverage.sv Generator.sv Execute.tb.sv Execute.test_top.sv Execute.if.sv

## Simulate the Test Top Module 


##vsim -coverage -novopt -sv_seed 1029387562610 Execute_test_top
	

##run 3000ns

##coverage save ./abangre_shift.ucdb


vcover merge Lab5.ucdb ./abangre_arith_shift_memrd.ucdb ./abangre_opwords.ucdb






