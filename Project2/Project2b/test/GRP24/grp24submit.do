vlog *.vp
vlog *.v
#Coverage for Packet 0

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run  5000ns
coverage save ./cov00.ucdb
restart -f

#Coverage for Packet 0

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator1.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov01.ucdb
restart -f

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator2.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov18.ucdb
restart -f

#Coverage for Packet 0

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator3.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov19.ucdb
restart -f

#Coverage for Packet 0

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator4.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov22.ucdb
restart -f

#Coverage for Packet 0

vlog -mfcu -sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator4.sv LC3.tb4.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 500ns
coverage save ./cov23.ucdb
restart -f

#Coverage for Packet 1

vlog -mfcu -sv data_defs.vp Packet1.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov02.ucdb
restart -f

#Coverage for Packet 2

vlog -mfcu -sv data_defs.vp Packet2.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov03.ucdb
restart -f

#Coverage for Packet 3

vlog -mfcu -sv data_defs.vp Packet3.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov04.ucdb
restart -f

#Coverage for Packet 4

vlog -mfcu -sv data_defs.vp Packet4.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov05.ucdb
restart -f

#Coverage for Packet 5

vlog -mfcu -sv data_defs.vp Packet5.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov06.ucdb
restart -f

#Coverage for Packet 6

vlog -mfcu -sv data_defs.vp Packet6.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov07.ucdb
restart -f


#Coverage for Packet 7

vlog -mfcu -sv data_defs.vp Packet7.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb2.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 5000ns
coverage save ./cov08.ucdb
restart -f

#Coverage for Packet 8

vlog -mfcu -sv data_defs.vp Packet8.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov09.ucdb
restart -f

#Coverage for Packet 9

vlog -mfcu -sv data_defs.vp Packet9.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov10.ucdb
restart -f


#Coverage for Packet 10

vlog -mfcu -sv data_defs.vp Packet10.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov11.ucdb
restart -f

#Coverage for Packet 11

vlog -mfcu -sv data_defs.vp Packet12.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov12.ucdb
restart -f


#Coverage for Packet 12

vlog -mfcu -sv data_defs.vp Packet12.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov13.ucdb
restart -f

#Coverage for Packet 13

vlog -mfcu -sv data_defs.vp Packet13.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb1.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 1000ns
coverage save ./cov14.ucdb
restart -f

#Coverage for Packet 14

vlog -mfcu -sv data_defs.vp Packet14.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb3.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 30000ns
coverage save ./cov15.ucdb
restart -f

#Coverage for Packet 15

vlog -mfcu -sv data_defs.vp Packet15.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb3.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 30000ns
coverage save ./cov16.ucdb
restart -f

#Coverage for Packet 16

vlog -mfcu -sv data_defs.vp Packet16.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 80000ns
coverage save ./cov17.ucdb
restart -f

#Coverage for Packet 17

vlog -mfcu -sv data_defs.vp Packet17.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 80000ns
coverage save ./cov20.ucdb
restart -f

#Coverage for Packet 18

vlog -mfcu -sv data_defs.vp Packet18.sv Driver.sv OutputPacket.sv \
Receiver.sv Scoreboard.sv Generator.sv LC3.tb.sv  \
LC3.test_top.sv LC3.if.sv

vsim -c -coverage -novopt LC3_test_top
run 80000ns
coverage save ./cov21.ucdb


#merge all the coverages into one ucdb file
vcover merge grp24coverage.ucdb  ./cov00.ucdb ./cov01.ucdb  ./cov02.ucdb ./cov03.ucdb ./cov04.ucdb ./cov05.ucdb ./cov06.ucdb ./cov07.ucdb ./cov08.ucdb \
./cov09.ucdb ./cov10.ucdb ./cov11.ucdb ./cov12.ucdb ./cov13.ucdb ./cov14.ucdb ./cov15.ucdb ./cov16.ucdb ./cov17.ucdb ./cov18.ucdb ./cov19.ucdb   \
./cov20.ucdb ./cov21.ucdb ./cov22.ucdb ./cov23.ucdb


