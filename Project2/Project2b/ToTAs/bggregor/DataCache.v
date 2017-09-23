
/***************************************
*
* COPYRIGHT \copyright 2004
* Xun Liu and Rhett Davis
* NC State University
* ALL RIGHTS RESERVED
*
* NOTES: Solution for ECE 406 Lab #4
*
* REVISION HISTORY
*    Date      Programmer    Description
*    Fall 2005 Xun Liu       Original Solution
*    4/10/06   Rhett Davis   Revised for Spr. '06
* 
*****************************************/

// table for valid bits
// CacheRAM is the non-synthesizable SRAM for
// the Cache.  It is used to store tags and
// data.  The size is 16x74
// tag is 10-bit
// data includes 4 words i.e., 64 bits
// 
module DataCache(clock, addr, din, rd, dout, complete,
	rrqst, rrdy, rdrdy, rdacpt, offdata, wrqst, wacpt, reset, macc);
  input clock, reset;

  	// Processor interface
  	input rd, macc;
  	input [15:0] addr, din;
  	output [15:0] dout;
  	output complete;

  	// Off-chip Memory Interface
  	input rrdy, rdrdy, wacpt;
  	output rrqst, rdacpt, wrqst;
  	inout [15:0] offdata;

  	// Internal Signals
  	wire [3:0] state;
  	wire [1:0] count;
  	wire valid, miss, update_valid;
  	wire [63:0] blockdata;   


  	CacheController ctrl(	.clock(clock), .reset(reset), .state(state), .count(count), 
  							.miss(miss), .rd(rd), .macc(macc), .rrdy(rrdy), 
  							.rdrdy(rdrdy), .wacpt(wacpt)//, .update_valid(update_valid)
  						);
  	ProcInterface_Data procif(	.clock(clock), .rd(rd), .addr(addr), .dout(dout), 
  							.complete(complete), .state(state), .miss(miss), 
                       		.blockdata(blockdata)
                       	);
  	MemInterface memif	(	.state(state), .addr(addr), .din(din), .offdata(offdata), 
  							.miss(miss), .rrqst(rrqst), .rdacpt(rdacpt), .wrqst(wrqst)
  						);
  	ValidArray valarr	(	.clock(clock), .reset(reset), .valid(valid), .index(addr[5:2]), 
  							.state(state)//, .update_valid(update_valid)
  						);
  	CacheData cdata		(	.clock(clock), .state(state), .count(count), .valid(valid), 
  							.miss(miss), .rd(rd), .addr(addr), .din(din), .blockdata(blockdata), 
  							.offdata(offdata)
  						);

endmodule

       