class OutputPacket;

	string 	name;
		// Outputs of LC3
	logic			IMem_rd, DMem_rd;
	logic	[16-1:0]	IMem_din, DMem_din;
	logic	[16-1:0]	DMem_addr;
	logic	[16-1:0]	PC;
	
	
		// Outputs of FETCH
	//logic	[16-1:0]	npc;		//asynchronous
	//logic	[16-1:0]	pc;
	//logic	[0:0]		Imem_rd;	//asynchronous
	
		// Outputs of DECODE
	
		// Outputs of EXECUTE
	
		// Outputs of CONTROLLER
		
		// Outputs of WRITEBACK
		
	extern function new(string name = "OutputPacket");
    
endclass

function OutputPacket::new(string name="OutputPacket");
	this.name = name;
endfunction
