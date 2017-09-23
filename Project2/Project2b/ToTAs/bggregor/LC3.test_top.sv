
module LC3_test_top;
	parameter simulation_cycle = 10;
	parameter reg_wd = 16;
	reg  SysClock;
	// make an instance of an interface which DERIVES its behaviour off of a boolean clock
	LC3_io top_io(SysClock); 	
	// make an instance of the testing program which DRIVES the behaviour of the interface
	  	
	// instantiate the DUT whose signal inputs have their protocol/behavior controlled by the 
	// interface. 
	

CacheController_Probe_if cachecontroller_io(	dut.D_Cache.ctrl.reset,
						dut.D_Cache.ctrl.macc,
						dut.D_Cache.ctrl.miss,
						dut.D_Cache.ctrl.rd,
						dut.D_Cache.ctrl.state,
						dut.D_Cache.ctrl.count,
						dut.D_Cache.ctrl.rrdy,
						dut.D_Cache.ctrl.rdrdy,
						dut.D_Cache.ctrl.wacpt
	);

ProcInterface_Probe_if procinterface_io(	dut.D_Cache.procif.rd,
						dut.D_Cache.procif.addr,
						dut.D_Cache.procif.dout,
						dut.D_Cache.procif.complete,
						dut.D_Cache.procif.state,
						dut.D_Cache.procif.miss,
						dut.D_Cache.procif.blockdata,
						dut.D_Cache.cdata.cram.data
	);

ValidArray_Probe_if validarray_io(		dut.D_Cache.valarr.reset,
						dut.D_Cache.valarr.index,
						dut.D_Cache.valarr.state,
						dut.D_Cache.valarr.valid,
						dut.D_Cache.valarr.validarr
						
	);

CacheData_Probe_if cachedata_io(		dut.D_Cache.cdata.rd,
						dut.D_Cache.cdata.addr,
						dut.D_Cache.cdata.din,
						dut.D_Cache.cdata.count,
						dut.D_Cache.cdata.state,
						dut.D_Cache.cdata.valid,
						dut.D_Cache.cdata.miss,
						dut.D_Cache.cdata.blockdata,
						dut.D_Cache.cdata.offdata,
						dut.D_Cache.cdata.cram.rd,
						dut.D_Cache.cdata.cram.data,
						dut.D_Cache.cdata.blockreg,
				 dut.lc3.Ex.W_Control_out,
			     	 dut.lc3.Ex.Mem_Control_out,
			     	 dut.lc3.Ex.W_Control_in,
			    	 dut.lc3.Ex.Mem_Control_in,
			    	 dut.lc3.Ex.aluout,
			    	 dut.lc3.Ex.M_Data,
			    	 dut.lc3.Ex.dr,
			     	 dut.lc3.Ex.sr1,
			      	 dut.lc3.Ex.sr2,
			      	 dut.lc3.Ex.Mem_Bypass_Val,
				 dut.lc3.Ex.E_Control,
				 dut.lc3.Ex.IR,
				 dut.lc3.Ex.VSR1,
				 dut.lc3.Ex.VSR2,
				 dut.lc3.Ex.bypass_alu_1,
				 dut.lc3.Ex.bypass_alu_2,
				 dut.lc3.Ex.bypass_mem_1,
				 dut.lc3.Ex.bypass_mem_2,
				 dut.lc3.Ex.enable_execute,
				 dut.lc3.Ex.npc,
				 dut.lc3.Ex.reset,
				 dut.lc3.Ex.IR_Exec,
				 dut.lc3.Ex.NZP,
				 dut.lc3.Ex.alu.aluin1, 
				 dut.lc3.Ex.alu.aluin2
						
	);

MemInterface_Probe_if meminterface_io(		dut.D_Cache.memif.state,
						dut.D_Cache.memif.addr,
						dut.D_Cache.memif.din,
						dut.D_Cache.memif.miss,
						dut.D_Cache.memif.offdata,
						dut.D_Cache.memif.wrqst,
						dut.D_Cache.memif.rdacpt,
						dut.D_Cache.memif.rrqst
	);



Fetch_Probe_if fetch_io (  	    dut.lc3.Fetch.pc,
				    dut.lc3.Fetch.npc_out,
				    dut.lc3.Fetch.instrmem_rd,
				    dut.lc3.Fetch.enable_updatePC  ,
				    dut.lc3.Fetch.taddr,
				    dut.lc3.Fetch.br_taken,
				    dut.lc3.Fetch.enable_fetch,
				    dut.lc3.Fetch.reset 

	);
	
Decode_Probe_if decode_io (							
			    	   dut.lc3.Dec.IR,
			   	   dut.lc3.Dec.npc_out,
			   	   dut.lc3.Dec.npc_in,
			   	   dut.lc3.Dec.W_Control,
			   	   dut.lc3.Dec.Mem_Control,
			   	   dut.lc3.Dec.E_Control,
			   	   dut.lc3.Dec.dout,
				   dut.lc3.Dec.enable_decode,
				   dut.lc3.Dec.reset,
				   dut.lc3.Dec.clock
			);
			
Control_Probe_if control_io (   
				 dut.lc3.Ctrl.IR,
        			 dut.lc3.Ctrl.enable_updatePC,
        			 dut.lc3.Ctrl.enable_fetch,
        			 dut.lc3.Ctrl.enable_decode,
        			 dut.lc3.Ctrl.enable_execute ,
        			 dut.lc3.Ctrl.enable_writeback,
        			 dut.lc3.Ctrl.bypass_alu_1,
        			 dut.lc3.Ctrl.bypass_alu_2,
        			 dut.lc3.Ctrl.bypass_mem_1,
      				 dut.lc3.Ctrl.bypass_mem_2,
      				 dut.lc3.Ctrl.complete_data,
      			         dut.lc3.Ctrl.complete_instr,
      			         dut.lc3.Ctrl.mem_state,
			         dut.lc3.Ctrl.Instr_dout 	,
			         dut.lc3.Ctrl.IR_Exec		,
			         dut.lc3.Ctrl.psr      ,
			         dut.lc3.Ctrl.NZP	,
			         dut.lc3.Ctrl.br_taken		,
			         dut.lc3.Ctrl.reset
			        
			        
				
      			);				
		
Execute_Probe_if execute_io (
			     	 dut.lc3.Ex.W_Control_out,
			     	 dut.lc3.Ex.Mem_Control_out,
			     	 dut.lc3.Ex.W_Control_in,
			    	 dut.lc3.Ex.Mem_Control_in,
			    	 dut.lc3.Ex.aluout,
			    	 dut.lc3.Ex.M_Data,
			    	 dut.lc3.Ex.dr,
			     	 dut.lc3.Ex.sr1,
			      	 dut.lc3.Ex.sr2,
			      	 dut.lc3.Ex.Mem_Bypass_Val,
				 dut.lc3.Ex.E_Control,
				 dut.lc3.Ex.IR,
				 dut.lc3.Ex.VSR1,
				 dut.lc3.Ex.VSR2,
				 dut.lc3.Ex.bypass_alu_1,
				 dut.lc3.Ex.bypass_alu_2,
				 dut.lc3.Ex.bypass_mem_1,
				 dut.lc3.Ex.bypass_mem_2,
				 dut.lc3.Ex.enable_execute,
				 dut.lc3.Ex.npc,
				 dut.lc3.Ex.reset,
				 dut.lc3.Ex.IR_Exec,
				 dut.lc3.Ex.NZP,
				 dut.lc3.Ex.alu.aluin1, 
				 dut.lc3.Ex.alu.aluin2
			);
						
WriteBack_Probe_if writeback_io (			
        			 dut.lc3.WB.d1,
        			 dut.lc3.WB.d2,
        			 dut.lc3.WB.psr,
        			 dut.lc3.WB.pcout,
        			 dut.lc3.WB.memout,
				 dut.lc3.WB.aluout,
        			 dut.lc3.WB.RF.R0,
        			 dut.lc3.WB.RF.R1,
        			 dut.lc3.WB.RF.R2,
      				 dut.lc3.WB.RF.R3,
      				 dut.lc3.WB.RF.R4,
      				 dut.lc3.WB.RF.R5,
      				 dut.lc3.WB.RF.R6,
      				 dut.lc3.WB.RF.R7,
				 dut.lc3.WB.W_Control,
				 dut.lc3.WB.enable_writeback,
				 dut.lc3.WB.npc,
				 dut.lc3.WB.dr,
				 dut.lc3.WB.sr1,
				 dut.lc3.WB.sr2,
				 dut.lc3.WB.reset,
				 dut.lc3.WB.DR_in
				 
				 
						
			);

MemAccess_Probe_if memaccess_io (
				dut.lc3.MemAccess.mem_state,
				dut.lc3.MemAccess.M_Control,
				dut.lc3.MemAccess.M_Data,
				dut.lc3.MemAccess.M_Addr,
				dut.lc3.MemAccess.Data_dout,
				dut.lc3.MemAccess.Data_addr,
				dut.lc3.MemAccess.Data_rd,
				dut.lc3.MemAccess.Data_din,
				dut.lc3.MemAccess.memout
			);			

			
//**********************************************************************************************				  
//*************************************ADDITION BY TA BEGIN ************************************		
//**********************************************************************************************				  
		  
		TA_Probe_io TA_probe_if( //ADDITION BY TA
		//Fetch In
		.enable_updatePC_in(dut.lc3.Fetch.enable_updatePC),
     	.enable_fetch_in(dut.lc3.Fetch.enable_fetch),
    	.taddr_in(dut.lc3.Fetch.taddr),
    	.br_taken_in(dut.lc3.Fetch.br_taken),
		
    	//Fetch Out
    	.pc2cmp(dut.lc3.Fetch.pc),
    	.npc2cmp(dut.lc3.Fetch.npc_out),
    	.IMem_rd2cmp(dut.lc3.Fetch.instrmem_rd),
		
    	//Decode In
//		.IMem_dout_in(dut.lc3.Instr_dout),
		.IMem_dout_in(dut.lc3.Dec.dout),
		.npc_in_in(dut.lc3.Dec.npc_in),
//		.psr_in(dut.lc3.Dec.psr),
		.enable_decode_in(dut.lc3.Dec.enable_decode),
		
		//Decode Out
		.IR2cmp(dut.lc3.Dec.IR),
		.npc_out2cmp(dut.lc3.Dec.npc_out),
		.E_control2cmp(dut.lc3.Dec.E_Control),
		.W_control2cmp(dut.lc3.Dec.W_Control),
		.Mem_control2cmp(dut.lc3.Dec.Mem_Control),
		
		//Execute In
		.enable_execute_in(dut.lc3.Ex.enable_execute),
		.E_control_in(dut.lc3.Ex.E_Control),
		.bypass_alu_1_in(dut.lc3.Ex.bypass_alu_1),
		.bypass_alu_2_in(dut.lc3.Ex.bypass_alu_2),
		.bypass_mem_1_in(dut.lc3.Ex.bypass_mem_1),
		.bypass_mem_2_in(dut.lc3.Ex.bypass_mem_2),
		.IR_in(dut.lc3.Ex.IR),
		.ex_npc_in(dut.lc3.Ex.npc),
		.Mem_control_in(dut.lc3.Ex.Mem_Control_in),
		.VSR1_in(dut.lc3.Ex.VSR1),
		.VSR2_in(dut.lc3.Ex.VSR2),
		.mem_bypass_in(dut.lc3.Ex.Mem_Bypass_Val),
		.aluout_prev_in(dut.lc3.Ex.aluout),
		
		//Execute Out
		.W_Control_out2cmp(dut.lc3.Ex.W_Control_out),
		.Mem_Control_out2cmp(dut.lc3.Ex.Mem_Control_out),
		.aluout2cmp(dut.lc3.Ex.aluout),
		.dr2cmp(dut.lc3.Ex.dr),
		.sr12cmp(dut.lc3.Ex.sr1),
		.sr22cmp(dut.lc3.Ex.sr2),
		.NZP2cmp(dut.lc3.Ex.NZP),
		.IR_Exec2cmp(dut.lc3.Ex.IR_Exec),
		.M_Data2cmp(dut.lc3.Ex.M_Data),
		.imm52cmp(dut.lc3.Ex.imm5),
		.offset62cmp(dut.lc3.Ex.offset6), 
		.offset92cmp(dut.lc3.Ex.offset9), 
		.offset112cmp(dut.lc3.Ex.offset11),
		
		//Writeback In
		.enable_wb_in(dut.lc3.WB.enable_writeback),
		.W_Control_wb_in(dut.lc3.WB.W_Control),
		.pcout_wb_in(dut.lc3.WB.pcout),
		.memout_wb_in(dut.lc3.WB.memout),
		.dr_wb_in(dut.lc3.WB.dr),
		.sr1_wb_in(dut.lc3.WB.sr1),
		.sr2_wb_in(dut.lc3.WB.sr2),
		.npc_wb_in(dut.lc3.WB.npc),
		.aluout_wb_in(dut.lc3.WB.aluout),
		.ram_wb_in(dut.lc3.WB.RF.ram),
		
		//Writeback Out
		.VSR12cmp(dut.lc3.WB.d1),
		.VSR22cmp(dut.lc3.WB.d2),
		.psr2cmp(dut.lc3.WB.psr),
		
		//Controller inputs
		.complete_data_in(dut.lc3.Ctrl.complete_data),
		.complete_instr_in(dut.lc3.Ctrl.complete_instr),
		.IR_ctrl_in(dut.lc3.Ctrl.IR),
		.IR_Exec_in(dut.lc3.Ctrl.IR_Exec),
		.NZP_in(dut.lc3.Ctrl.NZP),
		.psr_in(dut.lc3.Ctrl.psr),
		
		//Controller outputs
		.enable_updatePC2cmp(dut.lc3.Ctrl.enable_updatePC),
		.enable_fetch2cmp(dut.lc3.Ctrl.enable_fetch),
		.enable_decode2cmp(dut.lc3.Ctrl.enable_decode),
		.enable_execute2cmp(dut.lc3.Ctrl.enable_execute),
		.enable_writeback2cmp(dut.lc3.Ctrl.enable_writeback),
		.bypass_alu_12cmp(dut.lc3.Ctrl.bypass_alu_1),
		.bypass_alu_22cmp(dut.lc3.Ctrl.bypass_alu_2),
		.bypass_mem_12cmp(dut.lc3.Ctrl.bypass_mem_1),
		.bypass_mem_22cmp(dut.lc3.Ctrl.bypass_mem_2),
		.mem_state2cmp(dut.lc3.Ctrl.mem_state),
		.br_taken2cmp(dut.lc3.Ctrl.br_taken),
		
		//MemAccess Inputs
		.mem_state_in(dut.lc3.MemAccess.mem_state),
		.M_control_in(dut.lc3.MemAccess.M_Control),
		.M_Data_in(dut.lc3.MemAccess.M_Data),
		.M_Addr_in(dut.lc3.MemAccess.M_Addr),
		.Data_dout_in(dut.lc3.MemAccess.Data_dout),
		
		//MemAccess Outputs		
  		.Data_addr2cmp(dut.lc3.MemAccess.Data_addr),
  		.Data_din2cmp(dut.lc3.MemAccess.Data_din),
	 	.Data_rd2cmp(dut.lc3.MemAccess.Data_rd),
  		.memout2cmp(dut.lc3.MemAccess.memout)//,
/*		
  		//Cache Inputs
		.dmac(dut.D_Cache.macc),
		.rd(dut.D_Cache.rd),
		.addr(dut.D_Cache.addr),
		.din(dut.D_Cache.din),
		.rrdy(dut.D_Cache.rrdy),
		.rdrdy(dut.D_Cache.rdrdy),
		.wacpt(dut.D_Cache.wacpt),
		.miss_in(dut.D_Cache.miss),
		.state_in(dut.D_Cache.state),
		.count_in(dut.D_Cache.count),
		.blockdata_in(dut.D_Cache.blockdata),
		.valid_in(dut.D_Cache.valid),
		.offdata_in(dut.D_Cache.offdata),
		.validarr_in(dut.D_Cache.valarr.validarr),
		.memdata_in(dut.D_Cache.cdata.memdata),
		
		//Cache Outpus
		.dout(dut.D_Cache.dout),
		.complete(dut.D_Cache.complete),
		.rrqst(dut.D_Cache.rrqst),
		.rdacpt(dut.D_Cache.rdacpt),
		.wrqst(dut.D_Cache.wrqst),
		.offdata_out(dut.D_Cache.offdata),
		.miss_out(dut.D_Cache.miss),
		.state_out(dut.D_Cache.state),
		.count_out(dut.D_Cache.count),
		.blockdata_out(dut.D_Cache.blockdata),
		.valid_out(dut.D_Cache.valid),
		.validarr_out(dut.D_Cache.valarr.validarr),
		.ramrd_out(dut.D_Cache.cdata.ramrd),
		.blkreg_out(dut.D_Cache.cdata.blockreg)
*/
	);
//**********************************************************************************************				  	
//*************************************ADDITION BY TA END ************************************		
//**********************************************************************************************				  
			
			
	LC3_test test(top_io,  cachecontroller_io , procinterface_io ,validarray_io, cachedata_io, meminterface_io, 
					fetch_io , decode_io ,control_io, writeback_io, execute_io, memaccess_io,
					TA_probe_if // addition by TA
					); 
				// make an instance
	LC3_Cache dut(
		 .clock (top_io.clock),
		.reset (top_io.reset),
		.complete_instr (top_io.complete_instr),
		.Instr_dout (top_io.Instr_dout),
		.pc (top_io.PC),
		.instrmem_rd (top_io.IMem_rd)
		);
		
		
/*	LC3_test test(top_io, fetch_io , decode_io ,control_io, writeback_io, execute_io, memaccess_io); 
	LC3 dut(					// make an instance 
		.clock (top_io.clock),
		.reset (top_io.reset),
		.complete_data (top_io.complete_data),
		.complete_instr (top_io.complete_instr),
		.Data_dout (top_io.DMem_dout),
		.Instr_dout (top_io.Instr_dout),
		.pc (top_io.PC),
		.instrmem_rd (top_io.IMem_rd),
//		.I_din (top_io.IMem_din),
		.Data_din (top_io.DMem_din),
		.Data_rd (top_io.DMem_rd),
		.Data_addr (top_io.DMem_addr)
		
	);
*/
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
