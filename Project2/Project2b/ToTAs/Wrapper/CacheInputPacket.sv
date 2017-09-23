class CacheInputPacket;

	string 	name;
	
	reg dmac;
	reg rd;
	reg [15:0] addr;
	reg [15:0] din;
	reg rrdy;
	reg rdrdy;
	reg wacpt;
	reg miss_in;
	reg [3:0] state_in;
	reg [1:0] count_in;
	reg [63:0] blockdata_in;
	reg valid_in;
	reg [15:0] offdata_in;
	reg [15:0] validarr_in;
	reg [73:0] memdata_in;
	reg [63:0] blkreg_in;
	reg ramrd_in;
	
	extern function new(string name = "CacheInputPacket");
    
endclass

function CacheInputPacket::new(string name = "CacheInputPacket");
	this.name = name;
endfunction

