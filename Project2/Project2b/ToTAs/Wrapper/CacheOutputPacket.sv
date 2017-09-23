class CacheOutputPacket;

	string 	name;
	
	reg [15:0] dout;
	reg complete;
	reg rrqst;
	reg rdacpt;
	reg wrqst;
	reg [15:0] offdata_out;
	reg miss_out;
	reg [3:0] state_out;
	reg [1:0] count_out;
	reg [63:0] blockdata_out;
	reg valid_out;
	reg [15:0] validarr_out;
	reg ramrd_out;
	reg [63:0] blkreg_out;
	
	extern function new(string name = "CacheOutputPacket");
    
endclass

function CacheOutputPacket::new(string name = "CacheOutputPacket");
	this.name = name;
endfunction

