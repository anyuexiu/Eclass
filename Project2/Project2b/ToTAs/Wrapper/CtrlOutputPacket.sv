class CtrlOutputPacket;

	string 	name;
	reg enable_updatePC2cmp;
	reg enable_fetch2cmp;
	reg enable_decode2cmp;
	reg enable_execute2cmp;
	reg enable_writeback2cmp;
	reg bypass_alu_12cmp;
	reg bypass_alu_22cmp;
	reg bypass_mem_12cmp;
	reg bypass_mem_22cmp;
	reg [1:0] mem_state2cmp;
	reg br_taken2cmp;
		
	extern function new(string name = "CtrlOutputPacket");
    
endclass

function CtrlOutputPacket::new(string name = "CtrlOutputPacket");
	this.name = name;
endfunction




