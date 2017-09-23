module LC3_test_top;
	parameter simulation_cycle = 10;

	reg  SysClock;
	// make an instance of an interface which DERIVES its behaviour off of a boolean clock
	LC3_io top_io(SysClock); 	
	// make an instance of the testing program which DRIVES the behaviour of the interface
	
	//////////Map the interfaces with respective signals
		
	Fetch_Probe_if Fetch_io (					DUT.clock,
									DUT.Fetch.taddr, 
									DUT.Fetch.pc, 
									DUT.Fetch.npc_out,
									DUT.Fetch.instrmem_rd,
									DUT.Fetch.br_taken,
									DUT.Fetch.enable_fetch,
									DUT.Fetch.enable_updatePC
									
									);
									
								
	Decode_Probe_if Decode_io ( 
									DUT.clock,
									DUT.Dec.dout,
									DUT.Dec.npc_in,
									DUT.Dec.enable_decode,
									DUT.Dec.IR,
									DUT.Dec.npc_out,
									DUT.Dec.E_Control,
									DUT.Dec.W_Control,
									DUT.Dec.Mem_Control
									
									);
	
	Execute_Probe_if  Ex_io ( 					
									DUT.clock,
									DUT.Ex.enable_execute,
									DUT.Ex.W_Control_in,
									DUT.Ex.E_Control,
									DUT.Ex.IR,
									DUT.Ex.npc,
									DUT.Ex.VSR1,
									DUT.Ex.VSR2,
									DUT.Ex.aluout,
									DUT.Ex.pcout,
									DUT.Ex.W_Control_out,
									DUT.Ex.sr1,
									DUT.Ex.sr2,
									DUT.Ex.dr,
									DUT.Ex.bypass_alu_1,
			         					DUT.Ex.bypass_alu_2,
			          					DUT.Ex.bypass_mem_1,
			         					DUT.Ex.bypass_mem_2,
			          					DUT.Ex.Mem_Bypass_Val,
			          					DUT.Ex.M_Data,
			          					DUT.Ex.IR_Exec,
			           					DUT.Ex.NZP,
			          					DUT.Ex.Mem_Control_in,
			          					DUT.Ex.Mem_Control_out 
					);	
					
	Writeback_Probe_if	WB_io  (
									DUT.clock,
									DUT.WB.aluout,
									DUT.WB.W_Control,	
									DUT.WB.pcout,	
									DUT.WB.d1,	
									DUT.WB.d2,	
									DUT.WB.sr1,	
									DUT.WB.sr2,	
									DUT.WB.dr,	
									DUT.WB.psr,	
									DUT.WB.enable_writeback	,
									DUT.WB.memout,
									DUT.WB.npc,
									////////////////////MemAccess
									DUT.MemAccess.mem_state,
									DUT.MemAccess.M_Control,
									DUT.MemAccess.M_Data,
									DUT.MemAccess.M_Addr,
									DUT.MemAccess.memout,
									DUT.MemAccess.Data_addr,
									DUT.MemAccess.Data_din,
									DUT.MemAccess.Data_dout,
									DUT.MemAccess.Data_rd
					);	
					
	Controller_Probe_if    Controller_io (
									DUT.clock,
									DUT.Ctrl.complete_data,
				    					DUT.Ctrl.IR,	
				   					DUT.Ctrl.br_taken,
									DUT.Ctrl.complete_instr,
									DUT.Ctrl.enable_fetch,
									DUT.Ctrl.enable_decode,
									DUT.Ctrl.enable_execute,
									DUT.Ctrl.enable_writeback,
									DUT.Ctrl.enable_updatePC,
									DUT.Ctrl.bypass_alu_1,
			      	 					DUT.Ctrl.bypass_alu_2,
			      	  					DUT.Ctrl.bypass_mem_1,
			      	 					DUT.Ctrl.bypass_mem_2,
				   					DUT.Ctrl.mem_state,
				  					DUT.Ctrl.psr,
				 					DUT.Ctrl.NZP,
				      					DUT.Ctrl.IR_Exec,
				       					DUT.Ctrl.Instr_dout
						);			
																										
		
		
		//**********************************************************************************************				  
//*************************************ADDITION BY TA BEGIN ************************************		
//**********************************************************************************************				  
		  
		TA_Probe_io TA_probe_if( //ADDITION BY TA
		//Fetch In
		.enable_updatePC_in(DUT.Fetch.enable_updatePC),
     	.enable_fetch_in(DUT.Fetch.enable_fetch),
    	.taddr_in(DUT.Fetch.taddr),
    	.br_taken_in(DUT.Fetch.br_taken),
		
    	//Fetch Out
    	.pc2cmp(DUT.Fetch.pc),
    	.npc2cmp(DUT.Fetch.npc_out),
    	.IMem_rd2cmp(DUT.Fetch.instrmem_rd),
		
    	//Decode In
//		.IMem_dout_in(DUT.Instr_dout),
		.IMem_dout_in(DUT.Dec.dout),
		.npc_in_in(DUT.Dec.npc_in),
//		.psr_in(DUT.Dec.psr),
		.enable_decode_in(DUT.Dec.enable_decode),
		
		//Decode Out
		.IR2cmp(DUT.Dec.IR),
		.npc_out2cmp(DUT.Dec.npc_out),
		.E_control2cmp(DUT.Dec.E_Control),
		.W_control2cmp(DUT.Dec.W_Control),
		.Mem_control2cmp(DUT.Dec.Mem_Control),
		
		//Execute In
		.enable_execute_in(DUT.Ex.enable_execute),
		.E_control_in(DUT.Ex.E_Control),
		.bypass_alu_1_in(DUT.Ex.bypass_alu_1),
		.bypass_alu_2_in(DUT.Ex.bypass_alu_2),
		.bypass_mem_1_in(DUT.Ex.bypass_mem_1),
		.bypass_mem_2_in(DUT.Ex.bypass_mem_2),
		.IR_in(DUT.Ex.IR),
		.ex_npc_in(DUT.Ex.npc),
		.Mem_control_in(DUT.Ex.Mem_Control_in),
		.VSR1_in(DUT.Ex.VSR1),
		.VSR2_in(DUT.Ex.VSR2),
		.mem_bypass_in(DUT.Ex.Mem_Bypass_Val),
		.aluout_prev_in(DUT.Ex.aluout),
		
		//Execute Out
		.W_Control_out2cmp(DUT.Ex.W_Control_out),
		.Mem_Control_out2cmp(DUT.Ex.Mem_Control_out),
		.aluout2cmp(DUT.Ex.aluout),
		.dr2cmp(DUT.Ex.dr),
		.sr12cmp(DUT.Ex.sr1),
		.sr22cmp(DUT.Ex.sr2),
		.NZP2cmp(DUT.Ex.NZP),
		.IR_Exec2cmp(DUT.Ex.IR_Exec),
		.M_Data2cmp(DUT.Ex.M_Data),
		.imm52cmp(DUT.Ex.imm5),
		.offset62cmp(DUT.Ex.offset6), 
		.offset92cmp(DUT.Ex.offset9), 
		.offset112cmp(DUT.Ex.offset11),
		
		//Writeback In
		.enable_wb_in(DUT.WB.enable_writeback),
		.W_Control_wb_in(DUT.WB.W_Control),
		.pcout_wb_in(DUT.WB.pcout),
		.memout_wb_in(DUT.WB.memout),
		.dr_wb_in(DUT.WB.dr),
		.sr1_wb_in(DUT.WB.sr1),
		.sr2_wb_in(DUT.WB.sr2),
		.npc_wb_in(DUT.WB.npc),
		.aluout_wb_in(DUT.WB.aluout),
		.ram_wb_in(DUT.WB.RF.ram),
		
		//Writeback Out
		.VSR12cmp(DUT.WB.d1),
		.VSR22cmp(DUT.WB.d2),
		.psr2cmp(DUT.WB.psr),
		
		//Controller inputs
		.complete_data_in(DUT.Ctrl.complete_data),
		.complete_instr_in(DUT.Ctrl.complete_instr),
		.IR_ctrl_in(DUT.Ctrl.IR),
		.IR_Exec_in(DUT.Ctrl.IR_Exec),
		.NZP_in(DUT.Ctrl.NZP),
		.psr_in(DUT.Ctrl.psr),
		
		//Controller outputs
		.enable_updatePC2cmp(DUT.Ctrl.enable_updatePC),
		.enable_fetch2cmp(DUT.Ctrl.enable_fetch),
		.enable_decode2cmp(DUT.Ctrl.enable_decode),
		.enable_execute2cmp(DUT.Ctrl.enable_execute),
		.enable_writeback2cmp(DUT.Ctrl.enable_writeback),
		.bypass_alu_12cmp(DUT.Ctrl.bypass_alu_1),
		.bypass_alu_22cmp(DUT.Ctrl.bypass_alu_2),
		.bypass_mem_12cmp(DUT.Ctrl.bypass_mem_1),
		.bypass_mem_22cmp(DUT.Ctrl.bypass_mem_2),
		.mem_state2cmp(DUT.Ctrl.mem_state),
		.br_taken2cmp(DUT.Ctrl.br_taken),
		
		//MemAccess Inputs
		.mem_state_in(DUT.MemAccess.mem_state),
		.M_control_in(DUT.MemAccess.M_Control),
		.M_Data_in(DUT.MemAccess.M_Data),
		.M_Addr_in(DUT.MemAccess.M_Addr),
		.Data_dout_in(DUT.MemAccess.Data_dout),
		
		//MemAccess Outputs		
  		.Data_addr2cmp(DUT.MemAccess.Data_addr),
  		.Data_din2cmp(DUT.MemAccess.Data_din),
	 	.Data_rd2cmp(DUT.MemAccess.Data_rd),
  		.memout2cmp(DUT.MemAccess.memout)//,
/*		
  		//Cache Inputs
		.dmac(DUT.D_Cache.macc),
		.rd(DUT.D_Cache.rd),
		.addr(DUT.D_Cache.addr),
		.din(DUT.D_Cache.din),
		.rrdy(DUT.D_Cache.rrdy),
		.rdrdy(DUT.D_Cache.rdrdy),
		.wacpt(DUT.D_Cache.wacpt),
		.miss_in(DUT.D_Cache.miss),
		.state_in(DUT.D_Cache.state),
		.count_in(DUT.D_Cache.count),
		.blockdata_in(DUT.D_Cache.blockdata),
		.valid_in(DUT.D_Cache.valid),
		.offdata_in(DUT.D_Cache.offdata),
		.validarr_in(DUT.D_Cache.valarr.validarr),
		.memdata_in(DUT.D_Cache.cdata.memdata),
		
		//Cache Outpus
		.dout(DUT.D_Cache.dout),
		.complete(DUT.D_Cache.complete),
		.rrqst(DUT.D_Cache.rrqst),
		.rdacpt(DUT.D_Cache.rdacpt),
		.wrqst(DUT.D_Cache.wrqst),
		.offdata_out(DUT.D_Cache.offdata),
		.miss_out(DUT.D_Cache.miss),
		.state_out(DUT.D_Cache.state),
		.count_out(DUT.D_Cache.count),
		.blockdata_out(DUT.D_Cache.blockdata),
		.valid_out(DUT.D_Cache.valid),
		.validarr_out(DUT.D_Cache.valarr.validarr),
		.ramrd_out(DUT.D_Cache.cdata.ramrd),
		.blkreg_out(DUT.D_Cache.cdata.blockreg)
*/
	);
//**********************************************************************************************				  	
//*************************************ADDITION BY TA END ************************************		
//**********************************************************************************************				  
			
		
		
		
		
		
								
	// make an instance of the testing program which DRIVES the behaviour of the interface
	LC3_test test(top_io , Fetch_io , Decode_io,  Ex_io, WB_io , Controller_io, TA_probe_if); // addition by TA); );
	// instantiate the DUT whose signal inputs have their protocol/behavior controlled by the 
	// interface. 
	LC3 DUT(					// make an instance 
		.clock	(top_io.clock), 
		.pc	(top_io.pc),
		.reset	(top_io.reset), 
		.complete_data(top_io.complete_data),   
		.complete_instr(top_io.complete_instr),
	   	//.I_macc	(top_io.I_macc),
		//.D_macc	(top_io.D_macc),
		.Data_rd	(top_io.Data_rd), 
		.Instr_dout	(top_io.Instr_dout),
		.Data_dout	(top_io.Data_dout),
		.Data_addr	(top_io.Data_addr),
		.Data_din	(top_io.Data_din),
		.instrmem_rd	(top_io.instrmem_rd)
	);

	initial 
	begin
		SysClock = 0;
		forever 
		begin
			#(simulation_cycle/2)
			SysClock = ~SysClock;
		end
	end
endmodule
