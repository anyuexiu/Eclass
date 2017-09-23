`include "data_defs.vp"
module Fetch(	clock, reset, enable_updatePC, enable_fetch, pc, 
				npc_out, instrmem_rd, taddr, br_taken);
				
  	input 			clock, reset, br_taken, enable_fetch, enable_updatePC;
  	input 	[15:0] 	taddr;
  	output 	[15:0] 	pc, npc_out;   // current and next PC
  	output 			instrmem_rd;
	
  	reg 	[15:0] 	ipc;        // internal PC
  	wire 	[15:0] 	muxout;
`protect
    wire    [15:0]  npc_int;
    always @(posedge clock)
    if(reset==1)
  	`ifdef BUG1DONEANDDUSTEDWITH
       		ipc<=16'h3000;  // always start from x3000 and cannot be changed
  	`else 
       		ipc<=16'h3001;  // always start from x3000 and cannot be changed
	`endif
    else
    begin
      	if(enable_updatePC) // MODIFICATION_RAVI .. change this to enable_UpPC 
        	ipc	<=	muxout;
      	else
        	ipc	<=	ipc;
    end
  
    assign 	muxout=(br_taken)?taddr: npc_int;
  	
    `ifdef BUG2DONEANDDUSTEDWITH
  	assign 	npc_int=ipc+1; 
    `else 
  	assign 	npc_int=ipc+2; 
    `endif
	
    `ifdef BUG4DONEANDDUSTEDWITH
	assign 	npc_out  = npc_int;
    `else
        assign 	npc_out  = npc_int+2;
    `endif
    
	
	
    	assign	pc	=	ipc;
  
  	
    `ifdef BUG3DONEANDDUSTEDWITH		
		//`ifdef BUG4DONEANDDUSTEDWITH
  	assign	instrmem_rd  = (enable_fetch)?1'b1: 1'bz;
		//`else
  		//	assign	instrmem_rd  = (enable_fetch)?1'bz: 1'b1;
		//`endif	
    `else 
  	assign	instrmem_rd  = (enable_fetch)?1'b1: 1'b0;
    `endif
  
`endprotect
  								// it is achieved by the control of the pc value
endmodule










