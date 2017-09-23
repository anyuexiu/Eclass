program Execute_test(Execute_io.TB Execute, DUT_probe_if Prober);
	parameter   reg_wd    	=   `REGISTER_WIDTH;

	Generator  	generator;	// generator object
	Driver     	drvr;		// driver objects
	Scoreboard 	sb;			// scoreboard object
	
	Packet 	pkt_sent = new();
	
	reg	[reg_wd-1:0] 	aluout_cmp;
	reg				 	mem_en_cmp;
	reg	[reg_wd-1:0] 	memout_cmp;
	
	reg	[reg_wd-1:0]	aluin1_cmp, aluin2_cmp; 
	reg	[2:0]			opselect_cmp;
	reg	[2:0]			operation_cmp;	
	reg	[4:0]          	shift_number_cmp;
	reg					enable_shift_cmp, enable_arith_cmp;
	reg		enable_cmp;
	
	reg	[reg_wd-1:0] 	aluout_chk;
	reg				 	mem_en_chk;
	reg	[reg_wd-1:0] 	memout_chk;
	
	reg	[reg_wd-1:0]	aluin1_chk, aluin2_chk; 
	reg	[2:0]			opselect_chk;
	reg	[2:0]			operation_chk;	
	reg	[4:0]          	shift_number_chk;
	reg					enable_shift_chk, enable_arith_chk;
	
	reg		[16:0] 		aluout_half_chk;
		

	int 	count = 0;
	int 	number_packets;
	
	initial begin
		number_packets = 21;
        generator = new("Generator", number_packets);
		sb = new(); // NOTE THAT THERE ARE DEFAULT VALUES FOR THE NEW FUNCTION 
					// FOR THE SCOREBOARD 
		drvr = new("drvr[0]", generator.in_box, sb.driver_mbox, Execute);
		reset();
		generator.start();
		drvr.start(); 
		fork 
			recv();
		join
    	repeat(number_packets+1) @(Execute.cb);
		$display($time, "WE ARE DONE .. GO HOME AND SLEEP!!! .. ACTUALLY NOT YET .. ");
  	end

	task reset();
		$display ($time, "ns:  [RESET]  Design Reset Start");
		Execute.reset 				<= 1'b1; 
	  	Execute.cb.enable_ex 		<= 1'b0; 
		repeat(5) @(Execute.cb);
		Execute.cb.enable_ex   	 	<= 1'b1;
		Execute.reset 				<= 1'b0;
		$display ($time, "ns:  [RESET]  Design Reset End");
	endtask

	task recv();
		int i;
		
		aluout_chk = 0;
		
		aluin1_chk = 0; 
		aluin2_chk = 0; 
		opselect_chk = 0;
		operation_chk = 0;	
		shift_number_chk = 0;
		enable_shift_chk = 0; 
		enable_arith_chk = 0;
		
		$display($time, "ns: [RECEIVER] Receiving Payload Begin");
		@ (Execute.cb); // delay for synchronization with the outputs from DUT
		repeat(number_packets+1) 
		begin
			@ (Execute.cb);
			get_payload();
			check();
			$display($time, "ns:   [RECEIVER -> GETPAYLOAD]   Payload Obtained");
		end	
		$display($time, " ns: [RECEIVER]   Receiving Payload End");
	endtask	
	
	task get_payload();			
		aluout_cmp = Execute.cb.aluout;
		mem_en_cmp = Execute.cb.mem_write_en;
		memout_cmp = Execute.cb.mem_data_write_out;		
		
		// get the internals signals of the DUT as well 
		aluin1_cmp = Prober.cb.aluin1; 
		aluin2_cmp = Prober.cb.aluin2; 
		opselect_cmp = Prober.cb.opselect;
		operation_cmp = Prober.cb.operation;	
		shift_number_cmp = Prober.cb.shift_number;
		enable_shift_cmp = Prober.cb.enable_shift; 
		enable_arith_cmp = Prober.cb.enable_arith;		
	endtask
	
	task check();
		$display($time, "ns: [CHECKER] Checker Start\n\n");		
		// Grab packet sent from scoreboard 
		sb.driver_mbox.get(pkt_sent);				
		$display($time, "ns:   [CHECKER] Pkt Contents: src1 = %h, src2 = %h, imm = %h, ", pkt_sent.src1, pkt_sent.src2, pkt_sent.imm);
		$display($time, "ns:   [CHECKER] Pkt Contents: opselect = %b, immp_regn = %b, operation = %b, ", pkt_sent.opselect_gen, pkt_sent.immp_regn_op_gen, pkt_sent.operation_gen);
		check_arith();
		check_preproc();
		
	endtask
	
	task check_arith();
		$display($time, "ns:  	[CHECK_ARITH] Golden Incoming Arithmetic enable = %b", enable_arith_chk);
		$display($time, "ns:  	[CHECK_ARITH] Golden Incoming ALUIN = %h  %h ", aluin1_chk, aluin2_chk);
		$display($time, "ns:  	[CHECK_ARITH] Golden Incoming CONTROL = %h(opselect)  %h(operation) ", opselect_chk, operation_chk);
		if(1 == enable_arith_chk) begin
			if ((opselect_chk == `ARITH_LOGIC))	// arithmetic
			begin
				case(operation_chk)
				`ADD : 	begin	aluout_chk = aluin1_chk + aluin2_chk;	    end
				`HADD: 	begin   {aluout_half_chk} = aluin1_chk[15:0] + aluin2_chk[15:0]; aluout_chk = {{16{aluout_half_chk[16]}},aluout_half_chk[15:0]};	end 
				`SUB: 	begin   aluout_chk = aluin1_chk - aluin2_chk;    	end 
				`NOT: 	begin   aluout_chk = ~aluin2_chk;    	end 
				`AND: 	begin   aluout_chk = aluin1_chk & aluin2_chk;    	end
				`OR: 	begin   aluout_chk = aluin1_chk | aluin2_chk;    	end
				`XOR: 	begin   aluout_chk = aluin1_chk ^ aluin2_chk;      	end
				`LHG: 	begin   aluout_chk = {aluin2_chk[15:0],{16{1'b0}}};		end
				endcase
			end
		end
		$display($time, "ns:   [CHECKER] ALUOUT: DUT = %h   & Golden Model = %h\n", aluout_cmp, aluout_chk);	

	endtask	
	
	task check_preproc();
	
		if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && pkt_sent.enable) begin
			enable_arith_chk = 1'b1;
		end
		else begin
			enable_arith_chk = 1'b0;
		end
		
		if ((pkt_sent.opselect_gen == `SHIFT_REG)&& pkt_sent.enable) begin
			enable_shift_chk = 1'b1;
		end
		else begin
			enable_shift_chk = 1'b0;
		end
			
		if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && pkt_sent.enable) begin 
			if((1 == pkt_sent.immp_regn_op_gen)) begin
				if (pkt_sent.opselect_gen == `MEM_READ) // memory read operation that needs to go to dest 
					aluin2_chk = pkt_sent.mem_data;
				else // here we assume that the operation must be a arithmetic operation
					aluin2_chk = pkt_sent.imm;
			end
			else begin
				aluin2_chk = pkt_sent.src2;
			end
		end
		
		if(pkt_sent.enable) begin
			aluin1_chk = pkt_sent.src1;
			operation_chk = pkt_sent.operation_gen;
			opselect_chk = pkt_sent.opselect_gen;
		end
		
		if ((pkt_sent.opselect_gen == `SHIFT_REG)&& pkt_sent.enable) begin
            if (pkt_sent.imm[2] == 1'b0) 
                shift_number_chk = pkt_sent.imm[10:6];
            else 
                shift_number_chk = pkt_sent.src2[4:0];
        end
        else 
            shift_number_chk = 0;		
		
		$display($time, "ns:   [CHECK_PREPROC] ALUIN1: DUT = %h   & Golden Model = %h\n", aluin1_cmp, aluin1_chk);	
		$display($time, "ns:   [CHECK_PREPROC] ALUIN2: DUT = %h   & Golden Model = %h\n", aluin2_cmp, aluin2_chk);	
		$display($time, "ns:   [CHECK_PREPROC] ENABLE_ARITH: DUT = %b   & Golden Model = %b\n", enable_arith_cmp, enable_arith_chk);	
		$display($time, "ns:   [CHECK_PREPROC] ENABLE_SHIFT: DUT = %h   & Golden Model = %h\n", enable_shift_cmp, enable_shift_chk);	
		$display($time, "ns:   [CHECK_PREPROC] OPERATION: DUT = %h   & Golden Model = %h\n", operation_cmp, operation_chk);	
		$display($time, "ns:   [CHECK_PREPROC] OPSELECT: DUT = %h   & Golden Model = %h\n", opselect_cmp, opselect_chk);	
		$display($time, "ns:   [CHECK_PREPROC] SHIFT_NUMBER: DUT = %h   & Golden Model = %h\n", shift_number_cmp, shift_number_chk);	

	endtask	
endprogram
