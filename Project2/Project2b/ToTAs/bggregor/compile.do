vlib mti_lib
setenv MODELSIM modelsim.ini

vlog *.v *.vp
vlog -mfcu -sv Packet_X.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard.sv Generator.sv LC3.tb.sv LC3.test_top.sv LC3.if.sv
vsim -coverage -novopt -sv_seed 75354 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp1.ucdb

vsim -coverage -novopt -sv_seed 52336 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp2.ucdb

vsim -coverage -novopt -sv_seed 38184 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp3.ucdb

vsim -coverage -novopt -sv_seed 9354 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp4.ucdb

vsim -coverage -novopt -sv_seed 3267 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp5.ucdb

vsim -coverage -novopt -sv_seed 89365 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp6.ucdb

vsim -coverage -novopt -sv_seed 98465 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp7.ucdb

vsim -coverage -novopt -sv_seed 2275 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp8.ucdb

vsim -coverage -novopt -sv_seed 36484 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp9.ucdb

vsim -coverage -novopt -sv_seed 19451 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp10.ucdb

vsim -coverage -novopt -sv_seed 11158 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp11.ucdb

vsim -coverage -novopt -sv_seed 18454 LC3_test_top
run 500ns
run 140000ns
coverage save ./temp12.ucdb


vcover merge grp26coverage.ucdb temp1.ucdb temp2.ucdb temp3.ucdb temp4.ucdb temp5.ucdb temp6.ucdb temp7.ucdb temp8.ucdb temp9.ucdb temp10.ucdb temp11.ucdb temp12.ucdb
rm temp1.ucdb
rm temp2.ucdb
rm temp3.ucdb
rm temp4.ucdb
rm temp5.ucdb
rm temp6.ucdb
rm temp7.ucdb
rm temp8.ucdb
rm temp9.ucdb
rm temp10.ucdb
rm temp11.ucdb
rm temp12.ucdb

vsim -viewcov /afs/eos.ncsu.edu/lockers/workspace/ece/ece745/002/grp26/Project2/grp26coverage2.ucdb 
