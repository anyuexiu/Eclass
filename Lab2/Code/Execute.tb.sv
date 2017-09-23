`include "data_defs.v"
`include "Packet.sv"
program Execute_test(Execute_io.TB Execute);
	parameter   reg_wd    	=   `REGISTER_WIDTH;

	reg	[6:0]			control_in_gen;
	
	Packet 	pkt2send = new();
	Packet 	pkt_sent = new();
	Packet 	pkt2cmp = new();
	
	Packet 	GenPackets[];
	
	Packet 	Inputs[$];
	reg		Enables[$];
	
	reg	[reg_wd-1:0] 	aluout2cmp;
	reg				 	mem_en2cmp;
	reg	[reg_wd-1:0] 	memout2cmp;
	
	reg	[reg_wd-1:0]	aluout_q[$];
	reg	[reg_wd-1:0]	memout_q[$];
	reg					mem_en_q[$];

	int 	count = 0;
	int 	run_n_times;		// number of packets to test
	int 	number_packets = 0;
	int 	packets_sent;
	int 	i, j;

	reg		enable_cmp;
	reg		arith_op, shift_op;
	reg		[31:0]	aluin2, aluout_cmp, aluout_q_val;
	reg		[16:0] aluout_half;


	initial begin
		run_n_times = 21;
		reset();
		repeat(run_n_times) begin
			$display($time, "ns: Sending Another Packet");
			gen();
			fork 
				send(); // in this case it is overkill given that the send and recv functions are single 							
				recv(); // cycle functions. A good example would have run_n_times repetitions of a multi-
						// cycle transaction that would give just cause to forking send and recv threads
			join	
			check();
    	end
    	repeat(5) @(Execute.cb);
  	end

	task reset();
		$display ($time, "ns: RESET START");
		Execute.reset 				<= 1'b1; // test1
	  	Execute.cb.enable_ex 	<= 1'b0; // test1
		repeat(5) @(Execute.cb);
		Execute.cb.enable_ex 	<= 1'b1;
		Execute.reset 				<= 1'b0;
		$display ($time, "ns: RESET END");
	endtask

	task gen();
		//generate an arbitrary number of payloads
		// {operation, immp_regn_op,opselect} = control_in;
		// ------------------NOTE: BEGIN ---------------------------
		// In this case the use of the queues is an overkill 
		// but it is a good idea when a set of values is going to 
		// be sent in together. This works particularly well when you 
		// have to get a inputs together to get a particular corner
		// case or when you have to work with a payload with multiple 
		// sets of data values. Let us persist with this for now. 
		// ------------------NOTE: END ---------------------------
		
		number_packets = $urandom_range(3,12);
		
		GenPackets = new[number_packets];
		for (i=0; i<number_packets; i++) begin
			GenPackets[i] = new();
		end
		for (i=0; i<number_packets; i++)		
		begin
			pkt2send.name = $psprintf("Packet[%0d]", i);
		  	if (!pkt2send.randomize()) 
			begin
				$display("\n%m\n[ERROR]%0d gen(): Randomization Failed!", $time);
				$finish;
			end	
			
			GenPackets[i].src1 = pkt2send.src1;
			GenPackets[i].src2 = pkt2send.src2;
			GenPackets[i].imm = pkt2send.imm;
			GenPackets[i].mem_data = pkt2send.mem_data;
			GenPackets[i].immp_regn_op_gen = pkt2send.immp_regn_op_gen;
			GenPackets[i].operation_gen = pkt2send.operation_gen;
			GenPackets[i].opselect_gen = pkt2send.opselect_gen;
		end
		$display($time, "ns: [GENERATE] Generate Finished Creating %d Packets  ", number_packets);
	endtask

	task send(); // remember there could be further constituents to this task based on how 
				 // the protocol of the DUT might be. Maybe there would be a header, body and finish parts for 		
				 // a more complicated DUT input
		send_payload(); 
	endtask

	task send_payload();
		$display($time, "ns: [DRIVER] Sending Payload Begin");
		Execute.cb.enable_ex 	<= 1'b1;
		packets_sent = 0;
		i = 0;
		while(i < GenPackets.size()) begin
			pkt2send = GenPackets[i];
			$display($time, "ns:   [DRIVER->SENDPAYLOAD] Packets left =%d", (number_packets -i));
			Execute.cb.src1				<=	pkt2send.src1;
			Execute.cb.src2				<=	pkt2send.src2;
			Execute.cb.imm				<=	pkt2send.imm;
			Execute.cb.mem_data_read_in	<=	pkt2send.mem_data;
			Execute.cb.control_in 		<=  {pkt2send.operation_gen, pkt2send.immp_regn_op_gen, pkt2send.opselect_gen};
			packets_sent++;
			Inputs.push_back(pkt2send);
			Enables.push_back(1'b1);
			i++;
		   	@(Execute.cb);
		end
		GenPackets.delete();
		$display($time, "ns: [DRIVER] Sending Payload End");
	endtask
	
	task recv();
		int i;
		$display($time, "ns: [RECEIVER] Receiving Payload Begin");
		@ (Execute.cb); // delay for synchronization with the outputs from DUT
		repeat(number_packets+1) 
		begin
			@ (Execute.cb);
			get_payload();
			$display($time, "ns:   [RECEIVER -> GETPAYLOAD]   Payload Obtained");
		end	
		$display($time, " ns: [RECEIVER]   Receiving Payload End");
	endtask	
	
	task get_payload();			
		aluout2cmp = Execute.cb.aluout;
		mem_en2cmp = Execute.cb.mem_write_en;
		memout2cmp = Execute.cb.mem_data_write_out;
		
		aluout_q.push_back(aluout2cmp);
		memout_q.push_back(memout2cmp);
		mem_en_q.push_back(mem_en2cmp);
	endtask
	
	task check();
		$display($time, "ns: [CHECKER] Checker Start\n\n");		
		aluout_q_val = 0;
		aluin2 = 0;
		arith_op = 0;
		aluout_cmp = 0;
		while (Inputs.size() !=0) begin
		
			check_arith();
			
			pkt_sent = Inputs.pop_front();			
			enable_cmp = Enables.pop_front();
			
			$display($time, "ns:   [CHECKER] Pkt Contents: src1 = %h, src2 = %h, imm = %h, ", pkt_sent.src1, pkt_sent.src2, pkt_sent.imm);
			$display($time, "ns:   [CHECKER] Pkt Contents: opselect = %b, immp_regn = %b, operation = %b, ", pkt_sent.opselect_gen, pkt_sent.immp_regn_op_gen, pkt_sent.operation_gen);
			
			if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && enable_cmp) begin
				arith_op = 1'b1;
			end
			else begin
				arith_op = 1'b0;
			end
			
			if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && enable_cmp) begin 
				if((1 == pkt_sent.immp_regn_op_gen)) begin
					if (pkt_sent.opselect_gen == `MEM_READ) // memory read operation that needs to go to dest 
						aluin2 = pkt_sent.mem_data;
					else // here we assume that the operation must be a arithmetic operation
						aluin2 = pkt_sent.imm;
				end
				else begin
					aluin2 = pkt_sent.src2;
				end
			end			
		end		
		check_arith();
	endtask
	
	task check_arith();
	
		if(1 == arith_op) begin
			if ((pkt_sent.opselect_gen == `ARITH_LOGIC))	// arithmetic
			begin
				case(pkt_sent.operation_gen)
				`ADD : 	begin	aluout_cmp = pkt_sent.src1 + aluin2;	    end
				`HADD: 	begin   {aluout_half} = pkt_sent.src1[15:0] + aluin2[15:0]; aluout_cmp = {{16{aluout_half[16]}},aluout_half[15:0]};	end 
				`SUB: 	begin   aluout_cmp = pkt_sent.src1 - aluin2;    	end 
				`NOT: 	begin   aluout_cmp = ~aluin2;    	end 
				`AND: 	begin   aluout_cmp = pkt_sent.src1 & aluin2;    	end
				`OR: 	begin   aluout_cmp = pkt_sent.src1 | aluin2;    	end
				`XOR: 	begin   aluout_cmp = pkt_sent.src1 ^ aluin2;      	end
				`LHG: 	begin   aluout_cmp = {aluin2[15:0],{16{1'b0}}};		end
				endcase
			end
		end
		aluout_q_val = aluout_q.pop_front();	
		$display($time, "ns:   [CHECKER] ALU Result from DUT = %h   and  ALU Result from Model = %h\n", aluout_q_val, aluout_cmp);	

	endtask
	
endprogram
