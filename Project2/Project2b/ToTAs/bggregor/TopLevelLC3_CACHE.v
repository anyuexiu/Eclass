module LC3_Cache (clock, reset, pc, instrmem_rd, Instr_dout, complete_instr  /*,  
				rrdy, rdrdy, wacpt, rrqst, rdacpt, wrqst, offdata  */
			);
	
	input		clock, reset;
	input		complete_instr;
	output	[15:0] 	pc;
	output		instrmem_rd; 
	input	[15:0]	Instr_dout;
	
	//input		rrdy, rdrdy, wacpt;
	//output		rrqst, rdacpt, wrqst;
	//inout	[15:0]	offdata;
		
			
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
	
	LC3 lc3 	(		
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
				
endmodule
