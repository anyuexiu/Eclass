`include "data_defs.v"
module Fetch(clock, reset, enable_updatePC, enable_fetch, pc, npc_out, instrmem_rd, taddr, br_taken);
  	input 			clock, reset, br_taken, enable_fetch, enable_updatePC;
  	input 	[15:0] 	taddr;
  	//input [3:0] 	state;
  	output 	[15:0] 	pc, npc_out;   // current and next PC
  	output 			instrmem_rd;
	
  	//reg		[15:0]	npc_out;
  	reg 	[15:0] 	ipc;        // internal PC
  	wire 	[15:0] 	muxout;
`protect
    wire    [15:0]  npc_int;
  	always @(posedge clock)
  	if(reset==1)
       	ipc<=16'h3000;  // always start from x3000 and cannot be changed
    else
    begin
      	if(enable_updatePC) // MODIFICATION_RAVI .. change this to enable_UpPC 
        	ipc	<=	muxout;
      	else
        	ipc	<=	ipc;
	end
  //assign rd=(state==7 || state==8 || state==9)?1'bz:1;
  //assign pc=(state==7 || state==8 || state==9)?16'hzzzz:ipc;
  	assign 	muxout=(br_taken)?taddr: npc_int;
  	`ifdef BUG1DONEANDDUSTEDWITH
  	assign 	npc_int=ipc+1; // BUG 1 DIFFICULTY 1 
  	`else
  	assign	npc_int = ipc; 
  	`endif
	assign npc_out  = npc_int;
//  	always @ (posedge clock)
//  	begin
//  		if(reset) begin
//  			npc_out	<=	0;
//  		end
//  		else if(enable_fetch) begin
//  			npc_out	<=	npc_int; // modification from last time
//  		end
//  	end
  	assign	pc	=	ipc;
  	assign	instrmem_rd 	=	enable_fetch;
  
  //assign	instrmem_rd 	= 1; 	// in this case the control of the memory read is un-necessary given that 
`endprotect
  								// it is achieved by the control of the pc value
endmodule










