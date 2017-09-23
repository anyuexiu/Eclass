class MAInputPacket;

	string 	name;
	reg 	[1:0] 	mem_state_in;
	reg             M_control_in;
	reg     [15:0]  M_Data_in;	
	reg 	[15:0] 	M_Addr_in;
	reg 	[15:0] 	Data_dout_in;
		
	extern function new(string name = "MAInputPacket");
    
endclass

function MAInputPacket::new(string name = "MAInputPacket");
	this.name = name;
endfunction

