module Fetch(clock, reset, enable_updatePC, enable_fetch, pc, npc_out, instrmem_rd, taddr, br_taken);
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
       	ipc<=16'h3000;  // always start from x3000 and cannot be changed
    else
    begin
      	if(enable_updatePC) // MODIFICATION_RAVI .. change this to enable_UpPC 
        	ipc	<=	muxout;
      	else
        	ipc	<=	ipc;
	end
  	assign 	muxout=(br_taken)?taddr: npc_int;
  	assign 	npc_int=ipc+1; 
	assign 	npc_out  = npc_int;
  	assign	pc	=	ipc;
  	assign	instrmem_rd  = (enable_fetch)?1'b1: 1'bz;
  
`endprotect
  								// it is achieved by the control of the pc value
endmodule










