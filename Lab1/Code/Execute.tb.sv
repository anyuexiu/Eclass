`include "data_defs.v"
//program automatic router_test(router_io.TB router);
program Execute_test(Execute_io.TB Execute);
	parameter   reg_wd    	=   `REGISTER_WIDTH;

	reg	[reg_wd-1:0] 	payload_src1[$];		
	reg	[reg_wd-1:0] 	payload_src2[$];		
	reg	[reg_wd-1:0] 	payload_imm[$];		
	reg [1:0]			operation1;
	reg [2:0]			operation2;
	reg [reg_wd-1:0]	mem_data_read_in;
	reg					immp_regn_in;
	int 	count = 0;
	int 	run_n_times;		// number of packets to test
	initial begin
		run_n_times = 21;
		reset();
		repeat(run_n_times) begin
		$display($time, "Sending Another Packet");
		gen();
		send();
		end
    	repeat(5) @(Execute.cb);
  	end

	task reset();
		$display($time, "RESET BEGIN");		
		Execute.reset 				<= 1'b1;
		Execute.cb.enable_ex 	<= 1'b0;
		repeat(5) @(Execute.cb);
		Execute.reset 				<= 1'b0;
		Execute.cb.enable_ex 	<= 1'b1;
		$display($time, "RESET END");
	endtask

	task gen();
		//generate an arbitrary number of payloads
		repeat($urandom_range(9,12))
		begin 
			$display($time, "		Created Payload Packet");
			payload_src1.push_back($random);
			payload_src2.push_back($random);
			payload_imm.push_back($random);
		end
	endtask

	task send();
		send_payload();
	endtask

	task send_payload();
		Execute.cb.enable_ex 	<= 1'b1;
		Execute.cb.mem_data_read_in <= `REGISTER_WIDTH'hbaad_d00d;
		count  = 0;
		while (payload_src1.size() !=0)
		begin 
		   	if(count <3) 
		   	begin 
			   	Execute.cb.src1	<=	payload_src1.pop_front();
			   	Execute.cb.src2	<=	payload_src2.pop_front();
			   	Execute.cb.imm	<=	payload_imm.pop_front();
				operation1 = $random;
				immp_regn_in = $random;
			   	Execute.cb.control_in	<=	{1'b0, operation1, immp_regn_in, `SHIFT_REG};
		   	end
		   	else if(count <6) 
		   	begin 
			   	Execute.cb.src1	<=	payload_src1.pop_front();
			   	Execute.cb.src2	<=	payload_src2.pop_front();
			   	Execute.cb.imm	<=	payload_imm.pop_front();
				operation2 = $random;
			   	Execute.cb.control_in	<=	{operation2,1'b1,`ARITH_LOGIC};
		   	end
		   	else if(count <9)
		   	begin 
			   	Execute.cb.src1	<=	payload_src1.pop_front();
			   	Execute.cb.src2	<=	payload_src2.pop_front();
			   	Execute.cb.imm	<=	payload_imm.pop_front();
				operation1 = $random;
			   	Execute.cb.control_in	<=	{1'b0,operation1,1'b1,`MEM_READ};
		   	end
		   	else 
		   	begin 
			   	Execute.cb.src1	<=	payload_src1.pop_front();
			   	Execute.cb.src2	<=	payload_src2.pop_front();
			   	Execute.cb.imm	<=	payload_imm.pop_front();
				operation2 = $random;
			   	Execute.cb.control_in	<=	{operation2, 1'b0,`ARITH_LOGIC};
		   	end
		   	count = count + 1;
		   	@(Execute.cb);
			display();
		end
	endtask
	task display();
		$display($time, "ns:  Inputs to ALU: src1 = %h, src2 = %h, imm = %h,  mem_data_read_in = %h,  control_in = %b", 
				Execute.cb.src1, Execute.cb.src2, Execute.cb.imm, Execute.cb.mem_data_read_in, Execute.cb.control_in);
		$display($time, "ns:  OUTPUTS from ALU: aluout = %h, carry = %b, mem_write_en = %b, mem_data_write_out = %h", 
				Execute.cb.aluout, Execute.cb.carry, Execute.cb.mem_write_en, Execute.cb.mem_data_write_out);
	endtask
endprogram
