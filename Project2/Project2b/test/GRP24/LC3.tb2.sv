program LC3_test(LC3_io.TB LC3 , Fetch_Probe_if Fetch  , Decode_Probe_if Decode ,Execute_Probe_if Exe , Writeback_Probe_if WB , Controller_Probe_if Con , TA_Probe_io ta_probe_if); //ADDITION BY TA););
	
	
	Generator  	generator;	// generator object
	Driver     	drvr;		// driver objects
	Scoreboard 	sb;			// scoreboard object
	Receiver 	rcvr;		// Receiver Object
	
	// ADDITION BY TA
		Cover_SB 		Cov_Inst;
		Monitor			Mon_Inst;

	
	Packet 	pkt_sent = new();
	int 	number_packets;
	
	initial begin
		number_packets = 500;
        generator = new("Generator", number_packets);
		sb = new("sb[0]",null , null ,LC3, Fetch,Decode,Exe,WB,Con); // NOTE THAT THERE ARE DEFAULT VALUES FOR THE NEW FUNCTION 
					// FOR THE SCOREBOARD 
		drvr = new("drvr[0]", generator.in_box, sb.driver_mbox ,LC3 , Fetch);
		rcvr = new("rcvr[0]", sb.receiver_mbox, LC3, Fetch,Decode,Exe,WB,Con);
		
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
		
		
		sb.start();
		generator.start();
		
		
		//ADDITION BY TA
		Mon_Inst.start();
		Cov_Inst.start();
		
		drvr.start(); 
		rcvr.start();
		
		reset();
		//reset();
		
		//check the reset values of the outputs of all modules
		
		// FETCH block
		
		if ( Fetch.cb.pc != 16'h3000)
		$display ($time,":ns [ERROR on RESET] pc = %h", Fetch.cb.pc);
		if ( Fetch.cb.npc_out != 16'h3001)
		$display ($time,":ns [ERROR on RESET] npc = %h", Fetch.cb.npc_out);
		
		
		//DECODE block
		
		if ( Decode.cb.IR != 16'h0 )
		$display ($time,":ns [ERROR on RESET] IR = %h", Decode.cb.IR);
		if ( Decode.cb.E_Control != 16'h0 )
		$display ($time,":ns [ERROR on RESET] IR = %h", Decode.cb.E_Control);
		if ( Decode.cb.W_Control != 16'h0 )
		$display ($time,":ns [ERROR on RESET] IR = %h", Decode.cb.W_Control);
		if ( Decode.cb.Mem_Control != 16'h0 )
		$display ($time,":ns [ERROR on RESET] IR = %h", Decode.cb.Mem_Control);
		

		//EXECUTE block
	        
		if ( Exe.cb.W_Control_out != 2'b0 )
		$display ($time,":ns [ERROR on RESET] W_Control_out = %h", Exe.cb.W_Control_out);
		if ( Exe.cb.Mem_Control_out != 1'b0)
		$display ($time,":ns [ERROR on RESET] W_Control_out = %h", Exe.cb.Mem_Control_out);
		if ( Exe.cb.aluout != 16'b0)
		$display ($time,":ns [ERROR on RESET] aluout = %h", Exe.cb.aluout);
		if ( Exe.cb.aluout != 16'b0)
		$display ($time,":ns [ERROR on RESET] aluout = %h", Exe.cb.aluout);
		if ( Exe.cb.dr != 3'b0)
		$display ($time,":ns [ERROR on RESET] dr = %h", Exe.cb.dr);
		if ( Exe.cb.sr1 != 3'b0)
		$display ($time,":ns [ERROR on RESET] aluout = %h", Exe.cb.sr1);
		if ( Exe.cb.sr2 != 3'b0)
		$display ($time,":ns [ERROR on RESET] aluout = %h", Exe.cb.sr2);
		if ( Exe.cb.IR_Exec != 16'b0)
		$display ($time,":ns [ERROR on RESET] IR_Exec = %h", Exe.cb.IR_Exec);
		if ( Exe.cb.NZP != 3'b0)
		$display ($time,":ns [ERROR on RESET] NZP = %h", Exe.cb.NZP);
		if ( Exe.cb.M_Data != 16'b0)
		$display ($time,":ns [ERROR on RESET] M_Data = %h", Exe.cb.M_Data);
		
		// WRITEBACK and MEMACCESS blocks
		
		if ( WB.cb.d1 != 16'b0)
		$display ($time,":ns [ERROR on RESET] VSR1 = %h", WB.cb.d1);
		if ( WB.cb.d2 != 16'b0)
		$display ($time,":ns [ERROR on RESET] VSR1 = %h", WB.cb.d2);
		if ( WB.cb.psr != 16'b0)
		$display ($time,":ns [ERROR on RESET] psr = %h", WB.cb.psr);
		
		if ( WB.cb.Data_addr != 16'bz)
		$display ($time,":ns [ERROR on RESET] DMem_addr = %h", WB.cb.Data_addr);
		if ( WB.cb.Data_din != 16'bz)
		$display ($time,":ns [ERROR on RESET] DMem_din = %h", WB.cb.Data_din);
		if ( WB.cb.Data_rd != 1'bz)
		$display ($time,":ns [ERROR on RESET] DMem_rd = %h", WB.cb.Data_rd);
		if ( WB.cb.memout_MA != 16'b0)
		$display ($time,":ns [ERROR on RESET] memout = %h", WB.cb.memout_MA);
		
		//Control signals
		if ( Con.cb.enable_fetch != 1'b1)
		$display ($time,":ns [ERROR on RESET] enable_fetch = %h", Con.cb.enable_fetch);
		if ( Con.cb.enable_updatePC != 1'b1)
		$display ($time,":ns [ERROR on RESET] enable_updatePC = %h", Con.cb.enable_updatePC);
		if ( Con.cb.enable_decode != 1'b0)
		$display ($time,":ns [ERROR on RESET] enable_decode = %h", Con.cb.enable_decode);
		if ( Con.cb.enable_execute != 1'b0)
		$display ($time,":ns [ERROR on RESET] enable_execute = %h", Con.cb.enable_execute);
		if ( Con.cb.enable_writeback != 1'b0)
		$display ($time,":ns [ERROR on RESET] enable_writeback = %h", Con.cb.enable_writeback);
		if ( Con.cb.br_taken != 1'b0)
		$display ($time,":ns [ERROR on RESET] br_taken = %h", Con.cb.br_taken);
		if ( Con.cb.mem_state != 3)
		$display ($time,":ns [ERROR on RESET] mem_state = %h", Con.cb.mem_state);
		if ( Con.cb.bypass_alu_1 != 1'b0)
		$display ($time,":ns [ERROR on RESET] bypass_alu_1 = %h", Con.cb.bypass_alu_1);
		if ( Con.cb.bypass_alu_2 != 1'b0)
		$display ($time,":ns [ERROR on RESET] bypass_alu_2 = %h", Con.cb.bypass_alu_2);
		if ( Con.cb.bypass_mem_1 != 1'b0)
		$display ($time,":ns [ERROR on RESET] bypass_mem_1 = %h", Con.cb.bypass_mem_1);
		if ( Con.cb.bypass_mem_2 != 1'b0)
		$display ($time,":ns [ERROR on RESET] bypass_mem_2 = %h", Con.cb.bypass_mem_2);

		
		

    	repeat(number_packets+1) @(LC3.cb);
		$display($time, "WE ARE DONE .. GO HOME AND SLEEP!!! .. ACTUALLY NOT YET .. ");
  	end

	task reset();
		$display ($time, "ns:  [RESET]  Design Reset Start");
		LC3.reset 				<= 1'b1; 
	  	LC3.cb.complete_instr 		<= 1'b1;  //complete_instr and completer_data are high throughout simulation
		LC3.cb.complete_data		<= 1'b1;
		repeat(5) @(LC3.cb);
	
		LC3.reset 				<= 1'b0;
		$display ($time, "ns:  [RESET]  Design Reset End");
	
	endtask
	
endprogram
