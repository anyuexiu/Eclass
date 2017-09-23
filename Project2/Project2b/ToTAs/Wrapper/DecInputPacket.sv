class DecInputPacket;

	string 	name;
	reg [15:0] IMem_dout_in;
	reg [15:0] npc_in_in;
//	reg [2:0] psr_in;
	reg enable_decode_in;		
	extern function new(string name = "DecInputPacket");
    
endclass

function DecInputPacket::new(string name = "DecInputPacket");
	this.name = name;
endfunction

