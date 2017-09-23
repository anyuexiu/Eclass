vlib mti_lib 
setenv MODELSIM modelsim.ini
set WRAPPER_DIR ../Wrapper


vlog *.vp
vlog *.v
#Coverage for Packet 0

vlog -mfcu -sv +incdir+$WRAPPER_DIR $WRAPPER_DIR/Packet.sv $WRAPPER_DIR/FetchInputPacket.sv $WRAPPER_DIR/FetchOutputPacket.sv $WRAPPER_DIR/DecInputPacket.sv $WRAPPER_DIR/DecOutputPacket.sv $WRAPPER_DIR/ExInputPacket.sv $WRAPPER_DIR/ExOutputPacket.sv $WRAPPER_DIR/WBInputPacket.sv $WRAPPER_DIR/WBOutputPacket.sv $WRAPPER_DIR/CtrlInputPacket.sv $WRAPPER_DIR/CtrlOutputPacket.sv $WRAPPER_DIR/MAInputPacket.sv $WRAPPER_DIR/MAOutputPacket.sv $WRAPPER_DIR/CacheInputPacket.sv $WRAPPER_DIR/CacheOutputPacket.sv $WRAPPER_DIR/TA_Probe.if.sv $WRAPPER_DIR/Monitor.sv $WRAPPER_DIR/Cover_SB.sv data_defs.vp Packet0.sv Driver.sv OutputPacket.sv Receiver.sv Scoreboard.sv Generator.sv LC3.tb.sv LC3.test_top.sv LC3.if.sv

vsim  -c -coverage -novopt LC3_test_top
run  5000ns
coverage save ./cov00.ucdb
