class WBInputPacket;

	string 	name;
	reg enable_wb_in;
	reg [1:0] W_Control_wb_in;
	reg [15:0] pcout_wb_in;
	reg [15:0] memout_wb_in;
	reg [2:0] dr_wb_in;
	reg [2:0] sr1_wb_in;
	reg [2:0] sr2_wb_in;
	reg [15:0] npc_wb_in;
	reg [15:0] aluout_wb_in;
	reg [15:0] ram_wb_in[0:7];		
	extern function new(string name = "WBInputPacket");
    
endclass

function WBInputPacket::new(string name = "WBInputPacket");
	this.name = name;
endfunction

