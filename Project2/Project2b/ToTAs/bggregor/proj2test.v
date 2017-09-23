`define handshake2 20
`define mem_latency 50

/*
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



module Test_LC3_Cache;

 	reg clock; 
 	reg reset;

 	// Data Cache to Processor Interface
 	wire [15:0] 	Data_addr, Data_din, Data_dout;
 	wire 			Data_rd, D_macc, complete_data;

 	// Data Cache to Off-chip Memory Interface
 	wire 			D_rrqst, D_rrdy, D_rdrdy, D_rdacpt, D_wrqst, D_wacpt;
 	wire [15:0] 	D_data;

 	wire 			I_rrqst, I_rrdy, I_rdrdy, I_rdacpt, I_wrqst, I_wacpt;
 	wire [15:0] 	I_data;

 	wire [15:0]		pc;
 	wire [15:0] 	Instr_dout;
 	wire 			Instr_rd, I_macc, complete_instr;
 	// TEMPORARY INSTRUCTION MEMORY INTERFACE .. maybe we can use the same interface but 
 	// with the change that the read goes to zz's when there is no fetch .. THERE SHOULD
 	// BE NO WRITES TO INSTRUCTION MEMORY.
 	
 	
 	always 
   	#5 clock=~clock;

 	initial begin
    	$readmemh("../LC3/DMem_5.dat",D_Mem.ram);
    	$readmemh("../LC3/IMem_5.dat",I_Mem.ram);
	    clock=0;
    	reset=1;
    	#23 reset=0;
    	#5000
    	//$display("MEM[3009]=%d (35 expected)",mem.ram[16'h3009]);
    	//$display("MEM[300a]=%d (36 expected)",mem.ram[16'h300a]);
    	//$display("MEM[300b]=%h (300c expected)",mem.ram[16'h300b]);
    	//$display("MEM[300c]=%h (0024 expected)",mem.ram[16'h300c]);
    	$finish;
  end
//  	InstrCache 	I_Cache	(	.clock(clock), .addr(pc), .din(16'h0), .rd(Instr_rd), .reset(reset), 
//  						.dout(Instr_dout), .complete(complete_instr), .macc(I_macc), 
//  						
//  						// cache to main memory interface
//						.rrqst(I_rrqst), .rrdy(I_rrdy), .rdrdy(I_rdrdy), .rdacpt(I_rdacpt), 
//						.wrqst(I_wrqst), .wacpt(I_wacpt), .offdata(I_data)  				
//  						
//  				);
//
//  	
//  	Memory I_Mem		(			
//  						.reset(reset), .rrqst(I_rrqst), .rrdy(I_rrdy), .rdrdy(I_rdrdy), 
//  						.rdacpt(I_rdacpt), .data(I_data), .wrqst(I_wrqst), .wacpt(I_wacpt)
//  				);
  	Instr_Memory 	I_Mem 	(	
  							.clock(clock), .addr(pc), .din(16'h0), .rd(Instr_rd), .wr(1'b0),
  							.Instr_dout(Instr_dout), .complete_instr(complete_instr)
  						);
  	
  	LC3 DUT 	(		
  						.clock(clock), .reset(reset), .complete_instr(complete_instr), 
  						.complete_data(complete_data), .pc(pc), .instrmem_rd(Instr_rd), 
  						.Instr_dout(Instr_dout), .Data_addr(Data_addr), .Data_din(Data_din), 
  						.Data_dout(Data_dout), .Data_rd(Data_rd), .D_macc(D_macc), .I_macc(I_macc)
				);

  	DataCache D_Cache	(	
  						.clock(clock), .addr(Data_addr), .din(Data_din), .rd(Data_rd), .reset(reset), 
  						.dout(Data_dout), .complete(complete_data),  .macc(D_macc),
  						
  						// cache to main memory interface
						.rrqst(D_rrqst), .rrdy(D_rrdy), .rdrdy(D_rdrdy), .rdacpt(D_rdacpt), 
						.wrqst(D_wrqst), .wacpt(D_wacpt), .offdata(D_data)
				);
  	Memory D_Mem		(			
  						.reset(reset), .rrqst(D_rrqst), .rrdy(D_rrdy), .rdrdy(D_rdrdy), 
  						.rdacpt(D_rdacpt), .data(D_data), .wrqst(D_wrqst), .wacpt(D_wacpt)
  				);
//  	SimpleLC3 proc(		.clock(clock), .reset(reset), .addr(addr), .din(din), 
//  						.dout(dout), .rd(rd), .macc(macc), .complete(complete)
//  					);
endmodule



*/

