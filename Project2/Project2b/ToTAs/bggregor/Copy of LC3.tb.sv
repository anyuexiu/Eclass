`include "data_defs.vp"

program LC3_test(LC3_io.TB LC3,CacheController_Probe_if cachecontroller_io , ProcInterface_Probe_if procinterface_io,
		ValidArray_Probe_if validarray_io, CacheData_Probe_if cachedata_io, MemInterface_Probe_if meminterface_io
		, Fetch_Probe_if fetch_io,Decode_Probe_if decode_io ,
		Control_Probe_if control_io, WriteBack_Probe_if writeback_io ,
		Execute_Probe_if execute_io,MemAccess_Probe_if memaccess_io);
	parameter   reg_wd    	=   16;
	
	int run_n_times;
	
	// All global variables here
	
	
	
	// End global variables
	
	
		// Instantiation of objects
	Generator  	generator;	// generator object
	Driver     	drvr;		// driver objects
	Scoreboard 	sb;		// scoreboard object
	Receiver 	rcvr;		// Receiver Object
		// End instantiation of objects
	
	
	initial begin
		run_n_times = 15000;
	generator = new("Generator", run_n_times);
		
		// Constructors of objects
		sb = new("scoreboard", cachecontroller_io , procinterface_io, validarray_io, cachedata_io, meminterface_io , fetch_io , decode_io ,control_io, writeback_io, execute_io, memaccess_io); 
					// FOR THE SCOREBOARD .. There is not need for addition of a 
					// input set during new
		drvr = new("drvr[0]", generator.in_box, sb.driver_mbox, LC3, sb.s2d_out_box);
		rcvr = new("rcvr[0]", sb.receiver_mbox, LC3);
		// End constructors of objects
		
		reset();
				
			// Start ojects
		generator.start();
		drvr.start(); 
		sb.start();
		rcvr.start();
		
		repeat(run_n_times) @(LC3.cb);
			// Done with Simulation
		
	end	
	
	
	task reset();
		
		LC3.cb.complete_instr <= 1;
		//LC3.cb.complete_data <= 1;
		@(LC3.cb);
		
		$display ($time, "Design Reset Start");
		LC3.cb.reset<= 1'b1; // test1
		@(LC3.cb);
		
//		GModel_Fetch();
//		GModel_Decode();
//		GModel_Controller();
//		GModel_Writeback();
//		GModel_Execute();
		
		@(LC3.cb);
		
		LC3.cb.complete_instr	<=      1;
		//LC3.cb.complete_data	<=      1;
		//LC3.cb.DMem_dout	<=	16'h0;
		
		LC3.cb.reset<= 1'b0;
		
		
		
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5020;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5220;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5420;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5620;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5820;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5a20;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5c20;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h5e20;
		@(LC3.cb);
	/*	LC3.cb.Instr_dout	<=	16'h0480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h0480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h0480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h0480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h2282;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hb282;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'hc480;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h9282;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h9282;
		@(LC3.cb);
		LC3.cb.Instr_dout	<=	16'h3382;
		@(LC3.cb);
	*/	repeat(4) @(LC3.cb);
		
				
		LC3.cb.reset<= 1'b1; // test1
		
		@(LC3.cb);
		
//		GModel_Fetch();
//		GModel_Decode();
//		GModel_Controller();
//		GModel_Writeback();
//		GModel_Execute();
	
		LC3.cb.reset<= 1'b0;
		
	endtask


	
endprogram	
	
	
	
