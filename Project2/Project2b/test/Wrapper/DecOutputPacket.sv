class DecOutputPacket;

	string 	name;
	reg [15:0] IMem_dout_in;
	reg [15:0] IR2cmp;
	reg [15:0] npc_out2cmp;
	reg [5:0] E_control2cmp;
	reg [1:0] W_control2cmp;
	reg Mem_control2cmp;
		
	extern function new(string name = "DecOutputPacket");
    
endclass

function DecOutputPacket::new(string name = "DecOutputPacket");
	this.name = name;
endfunction

