class ExInputPacket;

	string 	name;
	reg enable_execute_in;
	reg [5:0] E_control_in;
	reg bypass_alu_1_in;
	reg bypass_alu_2_in;
	reg bypass_mem_1_in;
	reg bypass_mem_2_in;
	reg [15:0] IR_in;
	reg [15:0] ex_npc_in;
	reg  Mem_control_in;
	reg [1:0] W_control_in;
	reg [15:0] VSR1_in;
	reg [15:0] VSR2_in;
	reg [15:0] mem_bypass_in;
	reg [15:0] aluout_prev_in;		
	extern function new(string name = "ExInputPacket");
    
endclass

function ExInputPacket::new(string name = "ExInputPacket");
	this.name = name;
endfunction

