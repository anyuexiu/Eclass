class WBOutputPacket;

	string 	name;
	reg [15:0] VSR12cmp;
	reg [15:0] VSR22cmp;
	reg [2:0] psr2cmp;
	reg [15:0] ram_out[0:7];
		
	extern function new(string name = "WBOutputPacket");
    
endclass

function WBOutputPacket::new(string name = "WBOutputPacket");
	this.name = name;
endfunction




