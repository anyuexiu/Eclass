
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

LC3_test test(top_io,  cachecontroller_io , procinterface_io ,validarray_io, cachedata_io, meminterface_io, fetch_io , decode_io ,control_io, writeback_io, execute_io, memaccess_io); 
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
