class ReceiverBase;
	virtual LC3_io.TB LC3;	// interface signals
	string   name;		// unique identifier
	OutputPacket   pkt2cmp;		// actual Packet object

//	reg	[`REGISTER_WIDTH-1:0]	aluout2cmp;
//	reg							mem_en2cmp;
//	reg	[`REGISTER_WIDTH-1:0]	memout2cmp;
//	reg							carry2cmp;


	

	extern function new(string name = "ReceiverBase", virtual LC3_io.TB LC3);
	extern virtual task recv();
	extern virtual task get_payload();
endclass

function ReceiverBase::new(string name="ReceiverBase", virtual LC3_io.TB LC3);
	this.name = name;
	this.LC3 = LC3;
	pkt2cmp = new();
endfunction

task ReceiverBase::recv();
	int pkt_cnt = 0;
	get_payload();
	
	pkt2cmp.name = $psprintf("rcvdPkt[%0d]", pkt_cnt++);
	




endtask

task ReceiverBase::get_payload();
	// Asynchronous values here
		
	
	
	
//	memout2cmp = LC3.cb.mem_data_write_out; //asynchronous value
//	mem_en2cmp = LC3.cb.mem_write_en;
	
	@ (LC3.cb);
	
	// Synchronous values here
//	$display ($time, "[RECEIVER]  Getting Payload");
		// FETCH
		// END FETCH




	
//	aluout2cmp = LC3.cb.aluout;
//	carry2cmp = LC3.cb.carry;
//	$display ($time, "[RECEIVER]  Payload Contents:  Aluout = %h mem_write_en = %d mem_data_write_out = %h", aluout2cmp, mem_en2cmp, memout2cmp);
	// this is a bad example because there are no constructs of variable time for completion
	 //at the negative edge of the the next clock the output should be stable
endtask
