class CtrlInputPacket;

	string 	name;
	reg complete_data_in;
	reg complete_instr_in;
	reg [15:0] IR_dut_in;
	reg [15:0] IR_ctrl_in;	
	reg [15:0] IR_Exec_in;
	reg [2:0] NZP_in;
	reg [2:0] psr_in;	
	extern function new(string name = "CtrlInputPacket");
    
endclass

function CtrlInputPacket::new(string name = "CtrlInputPacket");
	this.name = name;
endfunction

