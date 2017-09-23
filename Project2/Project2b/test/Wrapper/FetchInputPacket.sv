class FetchInputPacket;

	string 	name;
	reg enable_updatePC_in;
	reg enable_fetch_in;
	reg [15:0] taddr_in;
	reg br_taken_in;		
	extern function new(string name = "FetchInputPacket");
    
endclass

function FetchInputPacket::new(string name = "FetchInputPacket");
	this.name = name;
endfunction

