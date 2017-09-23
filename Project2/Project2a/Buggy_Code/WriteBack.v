`include "data_defs.v"
module Writeback(	clock, reset, enable_writeback, W_Control, aluout, memout, pcout, npc, 
					sr1, sr2, dr, d1, d2, psr // connections to register file
				);
  	input 			clock, reset, enable_writeback;
  	input 	[15:0] 	aluout, memout, pcout, npc;
  	input 	[1:0] 	W_Control;
  	
  	input 	[2:0] 	sr1, sr2, dr;     	// source and destination register addresses
  	
  	output	[2:0]	psr;
  	output 	[15:0] 	d1, d2;				// two read port output

  	reg 	[15:0] 	DR_in;      	
	reg		[2:0]	psr;
  	// MODIFICATION_RAVI we can write to the register file here and need a enable_writeback signal somewhere 
  	RegFile RF 	(	.clock(clock), .sr1(sr1), .sr2(sr2), 
  					.din(DR_in), .dr(dr), .wr(enable_writeback),
  					.d1(d1), .d2(d2) 
  				);
  	
`protect
   	always @(W_Control or aluout or memout or pcout or npc)
  	begin
		case(W_Control)
        	0: DR_in<=aluout;
	  		1: DR_in<=memout;
	  		2: DR_in<=pcout;
          	3: DR_in<=npc;
        endcase      	
  	end
 	// Program Status Register
  	always @(posedge clock)
  	begin
       	if (reset)
       	begin
       		psr <= 0;
       	end
       	if (enable_writeback)
       	begin
	      	if(DR_in[15])     // Negative
	         	psr	<=	3'h4;
	      	else if((|DR_in)) // Positive
				psr	<=	3'h1;
	      	else              // Zero
	        	psr	<=	3'h2;
	 	end       	
    end    	
`endprotect
endmodule

// registerfile consists of 8 general purpose registers
module RegFile(clock, wr, sr1, sr2, din, dr, d1, d2); // 

  	input 			clock, wr;
  	input 	[2:0] 	sr1, sr2, dr;     	// source and destination register addresses
  	input 	[15:0] 	din;             	// data will be stored
  	output 	[15:0] 	d1, d2;				// two read port output

  	reg 	[15:0] 	ram [0:7] ;
  	wire 	[15:0] 	R0,R1,R2,R3,R4,R5,R6,R7;

`protect
   	wire	[2:0]	addr1, addr2;
   	wire	[15:0]	data1, data2;
   	
   	`ifdef BUG28DONEANDDUSTEDWITH
   	assign	addr1 = sr1;
   	`else 
   	assign	addr1 = {1'b0, sr1[1:0]}; // BUG 28 DIFFICULTY 2 
   	`endif
   	
   	`ifdef BUG29DONEANDDUSTEDWITH
   	assign	addr2 = sr2;
   	`else
   	assign	addr2 = {1'b0, sr2[1:0]}; // BUG 29 DIFFICULTY 2 
   	`endif
   	
   	assign	data1 = ram[addr1];
   	assign	data2 = ram[addr2];
   	
	`ifdef BUG30DONEANDDUSTEDWITH
  	assign 	d1 = data1;
  	`else 
  	assign	d1 = {data1[15:7], 1'b0, data1[5:0]}; // BUG 30 DIFFICULTY 2 
  	`endif
   
	`ifdef BUG31DONEANDDUSTEDWITH
  	assign 	d2 = data2;
  	`else 
  	assign	d2 = {data2[15:5], 1'b0, data2[3:0]}; // BUG 31 DIFFICULTY 2 
  	`endif
   
  	always @(posedge clock)
    begin
       	if (wr)
	 		ram[dr]<=din;	 
    end

`endprotect
  // These lines are not necessary, but they allow
  // viewing of the the registers in a waveform viewer.
  // They do not affect synthesis.
  	assign 	R0	=	ram[0];
  	assign 	R1	=	ram[1];  
  	assign 	R2	=	ram[2];
  	assign 	R3	=	ram[3];  
  	assign 	R4	=	ram[4];
  	assign 	R5	=	ram[5];  
  	assign 	R6	=	ram[6];
  	assign 	R7	=	ram[7];
   
endmodule
