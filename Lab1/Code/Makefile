
all: create_lib compile simulate

create_lib:
	vlib work

compile:
	vlog -l comp.log -sv *.v *.sv *.vp 

simulate:
	vsim -c -l sim.log -novopt Execute_test_top -do "run -all; log -r *"

clean:
	rm -rf work mti_lib transcript modelsim.ini *.log
