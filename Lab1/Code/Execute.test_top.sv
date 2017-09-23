
module Execute_test_top;
	parameter simulation_cycle = 10;

	reg  SysClock;
	Execute_io top_io(SysClock);
	Execute_test test(top_io);   
	Top dut(
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
		.carry(top_io.carry)
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

  initial begin
    $wlfdumpvars();
  end
endmodule
