   
class FetchOutputPacket;

	string 	name;
	reg [15:0] pc2cmp;
	reg [15:0] npc2cmp;
	reg IMem_rd2cmp;
	
		
	extern function new(string name = "FetchOutputPacket");
    
endclass

function FetchOutputPacket::new(string name = "FetchOutputPacket");
	this.name = name;
endfunction
