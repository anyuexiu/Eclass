class ExOutputPacket;

	string 	name;
	reg [1:0] W_Control_out2cmp;
	reg  Mem_Control_out2cmp;
	reg [15:0] aluout2cmp;
	reg [2:0] dr2cmp;
	reg [2:0] sr12cmp;
	reg [2:0] sr22cmp;
	reg [15:0] imm52cmp;
	reg alucarry2cmp;
	reg [2:0] NZP2cmp;
	reg [15:0] IR_Exec2cmp;
	reg [15:0] M_Data2cmp;
	reg [15:0] offset62cmp, offset92cmp, offset112cmp;
		
	extern function new(string name = "ExOutputPacket");
    
endclass

function ExOutputPacket::new(string name = "ExOutputPacket");
	this.name = name;
endfunction

