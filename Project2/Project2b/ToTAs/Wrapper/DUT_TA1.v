`define handshake2 30
`define mem_latency 100
/***************************************
*
* COPYRIGHT \copyright 2004
* Xun Liu and Rhett Davis
* NC State University
* ALL RIGHTS RESERVED
*
* NOTES:
*
* REVISION HISTORY
*    Date     Programmer    Description
*    11/10/04 Xun Liu       ECE406 Lab3 LC3
*    3/26/05  Rhett Davis   Revised Lab3
*    4/10/06  Rhett Davis   Revised for Lab#4
*    11/11/07 Ravi Jenkal	Revised for Pipelined LC3 but with only Data Cache
* 
*****************************************/

//`include "proj2.v"
//`include "./LC3/TopLevelLC3.v"

// The Memory module is the offchip memory.
// The handshake2 delay represents 2 handshake times.
// The mem_latency delay represents the memory latency.
// You can assume handshake2 > 2*(clock period) and mem_latency > 3*handshake2.
// This memory do not use the system clock.

module Memory(reset, rrqst, rrdy, rdrdy, rdacpt, data, wrqst, wacpt);
  	input rrqst, rdacpt, wrqst;
  	output rrdy, rdrdy, wacpt;
  	inout [15:0] data;
  	input reset;
  	reg rrdy, rdrdy, wacpt;

  	reg [15:0] ram[65535:0];
  	reg [3:0] state;
  	reg flag;
  	reg [15:0] readaddr, storedata;
  	reg [1:0] count;
  	integer debug;

  	// controller
  	always @(reset or rrqst or rdacpt or wrqst or state)
    if(reset)
   	begin 
		count<=0;
		state<=0;
   	end
    else
    begin
      	case(state) 
        	0: 	begin
	        	case({rrqst,wrqst})
		    		3: // write miss
		      		begin
	 					#`handshake2   
	 					readaddr<=data;
	 					flag<=1;
	 					state<=4;
		      		end
		    		2: // read miss
		      		begin	
	 					#`handshake2	
	 					readaddr<=data;
	 					flag<=0;
	 					state<=1;
		      		end
		   			1: // write hit
		      		begin
	 					#`handshake2	
	 					readaddr=data;
	 					flag=0;
		 				state<=4;
		      		end
		   			0: 
		   			begin
						readaddr<=readaddr;
						flag=0;
						state<=0;
	              	end
         		endcase
         	end 
			1: begin
				if(rrqst==0) begin
 					#`handshake2   
 					state<=2;
 				end
	   			else begin
	    			state<=1;
	    		end
	    	end
			2: begin
 				#(`mem_latency-`handshake2) 
 				state<=3;
 			end
			3: begin
				if(rdacpt)
	  			begin
	     			if(count!=3)begin
 						#`handshake2	
 						state<=7;
           			end
	     			else begin
 						#`handshake2	
 						state<=0;
						debug=5;
           			end
         			count <= count+1;
	 			end
	   			else begin
	      			state<=3;
            	end
            end
			4: begin
				if(wrqst==0) begin
					#`handshake2    
					state<=5;
				end
	  			else begin 
	  				state<=4;
	  			end
	  		end
			5: begin 
				if(wrqst) begin
 					#`handshake2	
 					storedata<=data;
    				state<=6;
	    		end
	   			else begin
	     			state<=5;
	     		end
	     	end
			6: begin 
				if(wrqst==0) begin
 	     			if(flag) begin
 						#(`mem_latency-`handshake2-`handshake2-`handshake2) 	
 						state	<=3;
 					end
	     			else begin
 						#`handshake2 	
 						state	<=0;
 					end
 				end
           		else begin
						state	<=6;
				end
			end
			7: begin
             	if(rdacpt==0)begin 
 					#`handshake2 	
 					state<=3;
 				end
          		else begin
					state<=7;
				end
	   		end	
     	endcase
	end

 	// behavior
 	always @(state or storedata)
   	case(state)
     	0: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=0;
      	end
     	1: begin
		  	rrdy<=1;
		  	rdrdy<=0;
		  	wacpt<=0;
      	end
     	3: begin
	  		rdrdy<=1;
	  		rrdy<=0;
	  		wacpt<=0;
		end
     	4: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=1;
       	end
     	6: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=1;
	  		ram[readaddr]<=storedata;
		end
     	default: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=0;
		end
   	endcase

  	assign data=(state==3)? ram[{readaddr[15:2],count}] : 16'hz;

endmodule
module Instr_Memory(clock, addr, din, rd, wr, Instr_dout, complete_instr);
  	input 			clock, rd, wr;
  	input 	[15:0] 	addr, din;
  	output 	[15:0] 	Instr_dout;
  	output 			complete_instr;

  	reg 	[15:0] 	ram[65535:0];
  	reg 	[15:0] 	Instr_dout;
   
  	assign complete_instr	=1;

  	always @(posedge clock)
   	if(rd) 
    begin
		Instr_dout	<=	ram[addr];
   	end
   	else if (wr)
   	begin
		ram[addr]	<=	din;
    end
endmodule



module DUT_TA1 (	clock, reset, pc, instrmem_rd, Instr_dout, complete_instr,I_macc,rrdy, rdrdy, wacpt,D_macc,rrqst,  rdacpt, wrqst,offdata);
	
	
	input			clock, reset;
	input			complete_instr;
	output	[15:0] 	pc;
	output			instrmem_rd; 
	input	[15:0]	        Instr_dout;
	output I_macc;
 
        output D_macc,rrqst,  rdacpt, wrqst;
	input rrdy, rdrdy, wacpt;
	inout [15:0] offdata;
 	
	// Data Cache to Processor Interface
 	
	wire [15:0] 	Data_addr, Data_din, Data_dout;
 	wire 			Data_rd;

 	// Data Cache to Off-chip Memory Interface
 	//wire 			D_rrqst, D_rrdy, D_rdrdy, D_rdacpt, D_wrqst, D_wacpt;
 	wire [15:0] 	D_data;

 	wire 			I_rrqst, I_rrdy, I_rdrdy, I_rdacpt, I_wrqst, I_wacpt;
 	wire [15:0] 	I_data;
        wire complete_data;

 	
 	// TEMPORARY INSTRUCTION MEMORY INTERFACE .. maybe we can use the same interface but 
 	// with the change that the read goes to zz's when there is no fetch .. THERE SHOULD
 	// BE NO WRITES TO INSTRUCTION MEMORY.
 	

  	
  	LC3 LC3 	(		
  						.clock(clock), .reset(reset), .complete_instr(complete_instr), 
  						.complete_data(complete_data), .pc(pc), .instrmem_rd(Instr_rd), 
  						.Instr_dout(Instr_dout), .Data_addr(Data_addr), .Data_din(Data_din), 
  						.Data_dout(Data_dout), .Data_rd(Data_rd), .D_macc(D_macc), .I_macc(I_macc)
				);

  	DataCache CACHE	(	
  						.clock(clock), .addr(Data_addr), .din(Data_din), .rd(Data_rd), .reset(reset), 
  						.dout(Data_dout), .complete(complete_data),  .macc(D_macc),
  						
  						// cache to main memory interface
						.rrqst(rrqst), .rrdy(rrdy), .rdrdy(rdrdy), .rdacpt(rdacpt), 
						.wrqst(wrqst), .wacpt(wacpt), .offdata(offdata)
				);
  	//Memory D_Mem		(			
  	//					.reset(reset), .rrqst(D_rrqst), .rrdy(D_rrdy), .rdrdy(D_rdrdy), 
  	//					.rdacpt(D_rdacpt), .data(D_data), .wrqst(D_wrqst), .wacpt(D_wacpt)
  	//			);
endmodule




