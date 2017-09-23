//**********************************************************************************************				  
//*************************************ADDITION BY TA BEGIN ************************************		
//**********************************************************************************************				  
		  
		TA_Probe_io TA_probe_if( //ADDITION BY TA
		//Fetch In
		.enable_updatePC_in(LC3_Cache.dut.Fetch.enable_updatePC),
     	.enable_fetch_in(LC3_Cache.dut.Fetch.enable_fetch),
    	.taddr_in(LC3_Cache.dut.Fetch.taddr),
    	.br_taken_in(LC3_Cache.dut.Fetch.br_taken),
		
    	//Fetch Out
    	.pc2cmp(LC3_Cache.dut.Fetch.pc),
    	.npc2cmp(LC3_Cache.dut.Fetch.npc_out),
    	.IMem_rd2cmp(LC3_Cache.dut.Fetch.instrmem_rd),
		
    	//Decode In
//		.IMem_dout_in(LC3_Cache.dut.Instr_dout),
		.IMem_dout_in(LC3_Cache.dut.Dec.dout),
		.npc_in_in(LC3_Cache.dut.Dec.npc_in),
//		.psr_in(LC3_Cache.dut.Dec.psr),
		.enable_decode_in(LC3_Cache.dut.Dec.enable_decode),
		
		//Decode Out
		.IR2cmp(LC3_Cache.dut.Dec.IR),
		.npc_out2cmp(LC3_Cache.dut.Dec.npc_out),
		.E_control2cmp(LC3_Cache.dut.Dec.E_Control),
		.W_control2cmp(LC3_Cache.dut.Dec.W_Control),
		.Mem_control2cmp(LC3_Cache.dut.Dec.Mem_Control),
		
		//Execute In
		.enable_execute_in(LC3_Cache.dut.Ex.enable_execute),
		.E_control_in(LC3_Cache.dut.Ex.E_Control),
		.bypass_alu_1_in(LC3_Cache.dut.Ex.bypass_alu_1),
		.bypass_alu_2_in(LC3_Cache.dut.Ex.bypass_alu_2),
		.bypass_mem_1_in(LC3_Cache.dut.Ex.bypass_mem_1),
		.bypass_mem_2_in(LC3_Cache.dut.Ex.bypass_mem_2),
		.IR_in(LC3_Cache.dut.Ex.IR),
		.ex_npc_in(LC3_Cache.dut.Ex.npc),
		.Mem_control_in(LC3_Cache.dut.Ex.Mem_Control_in),
		.VSR1_in(LC3_Cache.dut.Ex.VSR1),
		.VSR2_in(LC3_Cache.dut.Ex.VSR2),
		.mem_bypass_in(LC3_Cache.dut.Ex.Mem_Bypass_Val),
		.aluout_prev_in(LC3_Cache.dut.Ex.aluout),
		
		//Execute Out
		.W_Control_out2cmp(LC3_Cache.dut.Ex.W_Control_out),
		.Mem_Control_out2cmp(LC3_Cache.dut.Ex.Mem_Control_out),
		.aluout2cmp(LC3_Cache.dut.Ex.aluout),
		.dr2cmp(LC3_Cache.dut.Ex.dr),
		.sr12cmp(LC3_Cache.dut.Ex.sr1),
		.sr22cmp(LC3_Cache.dut.Ex.sr2),
		.NZP2cmp(LC3_Cache.dut.Ex.NZP),
		.IR_Exec2cmp(LC3_Cache.dut.Ex.IR_Exec),
		.M_Data2cmp(LC3_Cache.dut.Ex.M_Data),
		.imm52cmp(LC3_Cache.dut.Ex.imm5),
		.offset62cmp(LC3_Cache.dut.Ex.offset6), 
		.offset92cmp(LC3_Cache.dut.Ex.offset9), 
		.offset112cmp(LC3_Cache.dut.Ex.offset11),
		
		//Writeback In
		.enable_wb_in(LC3_Cache.dut.WB.enable_writeback),
		.W_Control_wb_in(LC3_Cache.dut.WB.W_Control),
		.pcout_wb_in(LC3_Cache.dut.WB.pcout),
		.memout_wb_in(LC3_Cache.dut.WB.memout),
		.dr_wb_in(LC3_Cache.dut.WB.dr),
		.sr1_wb_in(LC3_Cache.dut.WB.sr1),
		.sr2_wb_in(LC3_Cache.dut.WB.sr2),
		.npc_wb_in(LC3_Cache.dut.WB.npc),
		.aluout_wb_in(LC3_Cache.dut.WB.aluout),
		.ram_wb_in(LC3_Cache.dut.WB.RF.ram),
		
		//Writeback Out
		.VSR12cmp(LC3_Cache.dut.WB.d1),
		.VSR22cmp(LC3_Cache.dut.WB.d2),
		.psr2cmp(LC3_Cache.dut.WB.psr),
		
		//Controller inputs
		.complete_data_in(LC3_Cache.dut.Ctrl.complete_data),
		.complete_instr_in(LC3_Cache.dut.Ctrl.complete_instr),
		.IR_ctrl_in(LC3_Cache.dut.Ctrl.IR),
		.IR_Exec_in(LC3_Cache.dut.Ctrl.IR_Exec),
		.NZP_in(LC3_Cache.dut.Ctrl.NZP),
		.psr_in(LC3_Cache.dut.Ctrl.psr),
		
		//Controller outputs
		.enable_updatePC2cmp(LC3_Cache.dut.Ctrl.enable_updatePC),
		.enable_fetch2cmp(LC3_Cache.dut.Ctrl.enable_fetch),
		.enable_decode2cmp(LC3_Cache.dut.Ctrl.enable_decode),
		.enable_execute2cmp(LC3_Cache.dut.Ctrl.enable_execute),
		.enable_writeback2cmp(LC3_Cache.dut.Ctrl.enable_writeback),
		.bypass_alu_12cmp(LC3_Cache.dut.Ctrl.bypass_alu_1),
		.bypass_alu_22cmp(LC3_Cache.dut.Ctrl.bypass_alu_2),
		.bypass_mem_12cmp(LC3_Cache.dut.Ctrl.bypass_mem_1),
		.bypass_mem_22cmp(LC3_Cache.dut.Ctrl.bypass_mem_2),
		.mem_state2cmp(LC3_Cache.dut.Ctrl.mem_state),
		.br_taken2cmp(LC3_Cache.dut.Ctrl.br_taken),
		
		//MemAccess Inputs
		.mem_state_in(LC3_Cache.dut.MemAccess.mem_state),
		.M_control_in(LC3_Cache.dut.MemAccess.M_Control),
		.M_Data_in(LC3_Cache.dut.MemAccess.M_Data),
		.M_Addr_in(LC3_Cache.dut.MemAccess.M_Addr),
		.Data_dout_in(LC3_Cache.dut.MemAccess.Data_dout),
		
		//MemAccess Outputs		
  		.Data_addr2cmp(LC3_Cache.dut.MemAccess.Data_addr),
  		.Data_din2cmp(LC3_Cache.dut.MemAccess.Data_din),
	 	.Data_rd2cmp(LC3_Cache.dut.MemAccess.Data_rd),
  		.memout2cmp(LC3_Cache.dut.MemAccess.memout)//,
/*		
  		//Cache Inputs
		.dmac(LC3_Cache.D_Cache.macc),
		.rd(LC3_Cache.D_Cache.rd),
		.addr(LC3_Cache.D_Cache.addr),
		.din(LC3_Cache.D_Cache.din),
		.rrdy(LC3_Cache.D_Cache.rrdy),
		.rdrdy(LC3_Cache.D_Cache.rdrdy),
		.wacpt(LC3_Cache.D_Cache.wacpt),
		.miss_in(LC3_Cache.D_Cache.miss),
		.state_in(LC3_Cache.D_Cache.state),
		.count_in(LC3_Cache.D_Cache.count),
		.blockdata_in(LC3_Cache.D_Cache.blockdata),
		.valid_in(LC3_Cache.D_Cache.valid),
		.offdata_in(LC3_Cache.D_Cache.offdata),
		.validarr_in(LC3_Cache.D_Cache.valarr.validarr),
		.memdata_in(LC3_Cache.D_Cache.cdata.memdata),
		
		//Cache Outpus
		.dout(LC3_Cache.D_Cache.dout),
		.complete(LC3_Cache.D_Cache.complete),
		.rrqst(LC3_Cache.D_Cache.rrqst),
		.rdacpt(LC3_Cache.D_Cache.rdacpt),
		.wrqst(LC3_Cache.D_Cache.wrqst),
		.offdata_out(LC3_Cache.D_Cache.offdata),
		.miss_out(LC3_Cache.D_Cache.miss),
		.state_out(LC3_Cache.D_Cache.state),
		.count_out(LC3_Cache.D_Cache.count),
		.blockdata_out(LC3_Cache.D_Cache.blockdata),
		.valid_out(LC3_Cache.D_Cache.valid),
		.validarr_out(LC3_Cache.D_Cache.valarr.validarr),
		.ramrd_out(LC3_Cache.D_Cache.cdata.ramrd),
		.blkreg_out(LC3_Cache.D_Cache.cdata.blockreg)
*/		
	);
//**********************************************************************************************				  	
//*************************************ADDITION BY TA END ************************************		
//**********************************************************************************************				  

		TA_probe_if // addition by TA 

		TA_Probe_io ta_probe_if, //ADDITION BY TA
		
		// ADDITION BY TA
		Cover_SB 		Cov_Inst;
		Monitor			Mon_Inst;
	
		// ADDITION BY TA
		Cov_Inst = new("TA_Cover_SB", ta_probe_if); 
		// ADDITION BY TA
		Mon_Inst = new("Monitor", LC3, ta_probe_if, 
        				Cov_Inst.driver_mbox,
	 					Cov_Inst.fetch_in_mbox, Cov_Inst.dec_in_mbox, 
						Cov_Inst.ex_in_mbox, Cov_Inst.wb_in_mbox, 
		                Cov_Inst.ctrl_in_mbox, Cov_Inst.ma_in_mbox, 
		                //Cov_Inst.cache_in_mbox, 
		                
		                Cov_Inst.fetch_out_mbox, Cov_Inst.dec_out_mbox, Cov_Inst.ex_out_mbox, 
		                Cov_Inst.wb_out_mbox, Cov_Inst.ctrl_out_mbox, Cov_Inst.ma_out_mbox//, 
		                //Cov_Inst.cache_out_mbox
		                
		          );
		
		//ADDITION BY TA
		Mon_Inst.start();
		Cov_Inst.start();		
	
