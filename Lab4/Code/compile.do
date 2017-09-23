



#		Arjun Bangre

#	 Do file for Compilation of all Verilog and System verilog Files

#	 Running this file - simulates the Execute_test_top



# Compile the verilog Files

	vlog *.vp
	vlog *.v

## Compile System Verilog Files

vlog -mfcu -sv data_defs.v Packet.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard.sv Generator.sv Execute.tb.sv Execute.test_top.sv Execute.if.sv

## Simulate the Test Top Module 


vsim -novopt -sv_seed 460123497   Execute_test_top
	

