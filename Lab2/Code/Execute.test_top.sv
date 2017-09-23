
module Execute_test_top;
	parameter simulation_cycle = 10;

	reg  SysClock;
	// make an instance of an interface which DERIVES its behaviour off of a boolean clock
	Execute_io top_io(SysClock); 	
	// make an instance of the testing program which DRIVES the behaviour of the interface
	Execute_test test(top_io);   	
	// instantiate the DUT whose signal inputs have their protocol/behavior controlled by the 
	// interface. 
	Top dut(					// make an instance 
		.clock	(top_io.clock), 
		.enable_ex	(top_io.enable_ex),
		.reset	(top_io.reset), 
		.src1(top_io.src1),   
		.src2(top_io.src2),
	   	.imm	(top_io.imm),
		.control_in	(top_io.control_in),
		.mem_data_read_in	(top_io.mem_data_read_in), 
		.mem_data_write_out	(top_io.mem_data_write_out),
		.mem_write_en	(top_io.mem_write_en),
		.aluout	(top_io.aluout),
		.carry	(top_io.carry)
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
