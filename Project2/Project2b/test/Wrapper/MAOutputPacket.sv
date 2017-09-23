class MAOutputPacket;

	string 	name;
	reg 	[15:0] 	Data_addr2cmp;
  	reg 	[15:0] 	Data_din2cmp;
  	reg 			Data_rd2cmp;
  	reg 	[15:0] 	memout2cmp;
	
	
		
	extern function new(string name = "MAOutputPacket");
    
endclass

function MAOutputPacket::new(string name = "MAOutputPacket");
	this.name = name;
endfunction

