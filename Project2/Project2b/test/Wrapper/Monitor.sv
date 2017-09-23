class Monitor;
	virtual   LC3_io.TB LC3;	// interface signal 
	virtual TA_Probe_io  ports;
	
	string    name;						// unique identifier
	Instruction_Packet    pkt2send;		// stimulus Packet object
	Instruction_Packet    pkt_p1;
  	reg [15:0]	instruction;
  	
	//the inbox for the driver are the packets from the generator
  	typedef mailbox #(Instruction_Packet) in_box_type;
  	in_box_type in_box;

	//mailbox for fetch stage inputs
  	typedef mailbox #(FetchInputPacket) fetch_inbox_type;
  	fetch_inbox_type fetch_box_in;
  	//mailbox for decode stage inputs
  	typedef mailbox #(DecInputPacket) dec_inbox_type;
  	dec_inbox_type dec_box_in;
  	//mailbox for execute stage inputs
  	typedef mailbox #(ExInputPacket) ex_inbox_type;
  	ex_inbox_type ex_box_in;
  	//mailbox for writeback stage inputs
  	typedef mailbox #(WBInputPacket) wb_inbox_type;
  	wb_inbox_type wb_box_in;
  	//mailbox for controller stage inputs
  	typedef mailbox #(CtrlInputPacket) ctrl_inbox_type;
  	ctrl_inbox_type ctrl_box_in;
  	//mailbox for mem access stage inputs
  	typedef mailbox #(MAInputPacket) ma_inbox_type;
  	ma_inbox_type ma_box_in;
  	//mailbox for cache stage inputs
  	//typedef mailbox #(CacheInputPacket) cache_inbox_type;
  	//cache_inbox_type cache_box_in; 
  	
	//mailbox for fetch stage outputs
	typedef mailbox #(FetchOutputPacket) fetch_outbox_type;
	fetch_outbox_type fetch_box_out;
	//mailbox for decode stage outputs
	typedef mailbox #(DecOutputPacket) dec_outbox_type;
	dec_outbox_type dec_box_out;
	//mailbox for execute stage outputs
	typedef mailbox #(ExOutputPacket) ex_outbox_type;
	ex_outbox_type ex_box_out;
	//mailbox for writeback stage outputs
	typedef mailbox #(WBOutputPacket) wb_outbox_type;
	wb_outbox_type wb_box_out;
	//mailbox for controller stage outputs
	typedef mailbox #(CtrlOutputPacket) ctrl_outbox_type;
	ctrl_outbox_type ctrl_box_out;
	//mailbox for mem access stage outputs
	typedef mailbox #(MAOutputPacket) ma_outbox_type;
	ma_outbox_type ma_box_out;
	
	//typedef mailbox #(CacheOutputPacket) cache_outbox_type;
	//cache_outbox_type cache_box_out;
	
	FetchInputPacket fetch_pkt_in;
	DecInputPacket dec_pkt_in;
	ExInputPacket ex_pkt_in;
	WBInputPacket wb_pkt_in;
	CtrlInputPacket ctrl_pkt_in;
	MAInputPacket ma_pkt_in;
	//CacheInputPacket cache_pkt_in;
	
	FetchOutputPacket fetch_pkt_out;
	DecOutputPacket dec_pkt_out;
	ExOutputPacket ex_pkt_out;
	WBOutputPacket wb_pkt_out;
	CtrlOutputPacket ctrl_pkt_out;
	MAOutputPacket ma_pkt_out;
	//CacheOutputPacket cache_pkt_out;


	reg [15:0] instr_d1;

  extern function new(
  			string name = "Monitor", virtual LC3_io.TB LC3, 
  			virtual TA_Probe_io  ports, 
  			in_box_type in_box,
  			 	
			fetch_inbox_type fetch_mbox, dec_inbox_type dec_mbox, 
			ex_inbox_type ex_mbox, wb_inbox_type wb_mbox,
			ctrl_inbox_type ctrl_mbox, ma_inbox_type ma_mbox,
			//cache_inbox_type cache_box,
			
			fetch_outbox_type fetch_out_box, dec_outbox_type dec_out_box,
			ex_outbox_type ex_out_box, wb_outbox_type wb_out_box,
			ctrl_outbox_type ctrl_out_box, ma_outbox_type ma_out_box//,
			//cache_outbox_type cache_out_box 
			
			);
   	
	extern virtual task start();


	extern virtual task create_snapshot();
	extern virtual task create_instr_packet();
	
	extern virtual task get_fetch_inputs();
	extern virtual task get_dec_inputs();
	extern virtual task get_ex_inputs();
	extern virtual task get_wb_inputs();
	extern virtual task get_ctrl_inputs();
	extern virtual task get_ma_inputs();
	//extern virtual task get_cache_inputs();
	
	extern virtual task get_fetch_payload();
	extern virtual task get_fetch_async_payload();
	extern virtual task get_dec_payload();
	extern virtual task get_ex_async_payload();
	extern virtual task get_ex_payload();
	extern virtual task get_wb_payload();
	extern virtual task get_wb_async_payload();
	extern virtual task get_ctrl_payload();
	extern virtual task get_ma_payload();
	extern virtual task get_ma_async_payload();
	//extern virtual task get_cache_payload();
	//extern virtual task get_cache_async_payload();

endclass

function Monitor::new(			string name = "Monitor", virtual LC3_io.TB LC3,									
								virtual TA_Probe_io ports, 
								in_box_type in_box, 
								
								fetch_inbox_type fetch_mbox, dec_inbox_type dec_mbox,
								ex_inbox_type ex_mbox, wb_inbox_type wb_mbox,
								ctrl_inbox_type ctrl_mbox, ma_inbox_type ma_mbox,
								//cache_inbox_type cache_box,
								
								fetch_outbox_type fetch_out_box,  dec_outbox_type dec_out_box,
								ex_outbox_type ex_out_box,	wb_outbox_type wb_out_box,	
								ctrl_outbox_type ctrl_out_box, ma_outbox_type ma_out_box//, 
								//cache_outbox_type cache_out_box	
				
					);
	
	this.name = name;
	this.LC3 = LC3;
	this.ports = ports;
	
	
	pkt2send = new();
	fetch_pkt_in = new();
	dec_pkt_in = new();
	ex_pkt_in = new();
	wb_pkt_in = new();
	ctrl_pkt_in = new();
	ma_pkt_in = new();
	//cache_pkt_in = new();
	
	fetch_pkt_out = new();
	dec_pkt_out = new();
	ex_pkt_out = new();
	wb_pkt_out = new();
	ctrl_pkt_out = new();
	ma_pkt_out = new();
	//cache_pkt_out = new();

	this.in_box = in_box ; 	
	this.fetch_box_in = fetch_mbox;
  	this.dec_box_in = dec_mbox;
  	this.ex_box_in = ex_mbox;
  	this.wb_box_in = wb_mbox;
  	this.ctrl_box_in = ctrl_mbox;
  	this.ma_box_in = ma_mbox;
  	//this.cache_box_in = cache_box;
  
  	this.fetch_box_out = fetch_out_box;
  	this.dec_box_out = dec_out_box;
  	this.ex_box_out = ex_out_box;
  	this.wb_box_out = wb_out_box;
  	this.ctrl_box_out = ctrl_out_box;
  	this.ma_box_out = ma_out_box;
  	//this.cache_box_out = cache_out_box;
  
  
endfunction
task Monitor::start();
	$display( $time,  "  TA MONITOR STARTED");
    fork
	    forever
	    begin
	    	$display( $time,  " [TA MONITOR] CREATING SNAPSHOT");
	    	create_snapshot();
	    	$display( $time,  " [TA MONITOR] FINISHED CREATING SNAPSHOT");
	    	in_box.put(pkt2send);
	    	
			fetch_box_in.put(fetch_pkt_in);
			dec_box_in.put(dec_pkt_in);
			ex_box_in.put(ex_pkt_in);
			wb_box_in.put(wb_pkt_in);
			ctrl_box_in.put(ctrl_pkt_in);
			ma_box_in.put(ma_pkt_in);
			//cache_box_in.put(cache_pkt_in);
			
			dec_box_out.put(dec_pkt_out);
			ex_box_out.put(ex_pkt_out);
			wb_box_out.put(wb_pkt_out);
			ctrl_box_out.put(ctrl_pkt_out);
			ma_box_out.put(ma_pkt_out);
			//cache_box_out.put(cache_pkt_out);	
			fetch_box_out.put(fetch_pkt_out);
			$display( $time,  " [TA MONITOR] MAILBOXES FILLED");
		end
	join_none
endtask
task Monitor::create_snapshot();
	@ (LC3.cb);
//	$display ($time, "[RECEIVER]  Getting Payload");
	#3;
	create_instr_packet();
	// at this point we can grab the instruction being sent in as well 
	get_fetch_inputs();
	get_dec_inputs();
	get_ex_inputs();
	get_wb_inputs();
	get_ctrl_inputs();	
	get_ma_inputs();
	//get_cache_inputs();
	
	// NEED A METHOD OF GETTING THE INSTRUCTION SENT IN ... 
	
	
	get_fetch_payload();
	get_dec_payload();
	get_ex_payload();
	get_wb_payload();
	//get_cache_payload();

	
endtask

	task Monitor::create_instr_packet(); 
/*
   	rand bit [2:0] src1;
   	rand bit [2:0] src2;
   	rand bit [2:0] dest;
   	rand bit [3:0] opcode;
   	rand bit [4:0] imm;
   	rand bit imm_en;
   	rand bit noop_en;
   	rand bit [8:0] pcOffset9;
   	rand bit [5:0] pcOffset6;
   	rand bit [2:0] branchCondition;
   	rand bit [2:0] base;
   	bit [15:0] instr;
      case(opcode)
	`BR: instr = {4'b0000, branchCondition, pcOffset9}; //BR
	`ADD: instr = {4'b0001, dest, src1, imm_en, (imm_en?imm:{2'b00, src2})};
 //ADD
	`LD: instr = {4'b0010, dest, pcOffset9}; //LD
	`ST: instr = {4'b0011, src1, pcOffset9}; //ST
	//No 4 case!
	`AND: instr = {4'b0101, dest, src1, imm_en, (imm_en?imm:{2'b00, src2})};
 //AND
	`LDR: instr = {4'b0110, dest, base, pcOffset6}; //LDR
	`STR: instr = {4'b0111, src1, base, pcOffset6}; //STR
	//No 8 case!
	`NOT: instr = {4'b1001, dest, src1, 6'b111111}; //NOT
	`LDI: instr = {4'b1010, dest, pcOffset9}; //LDI
	`STI: instr = {4'b1011, src1, pcOffset9}; //STI
	`JMP: instr = {7'b1100000, base, 6'b000000}; //JMP
	//No 13 case!
	`LEA: instr = {4'b1110, dest, pcOffset9}; //LEA

*/	
	instruction = ports.IMem_dout_in;
  	case(instruction[15:12])
		`BR: begin 	
				pkt2send.opcode = 4'b0000; 
				pkt2send.branchCondition = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:0];  
			end//BR
		`ADD: begin
				pkt2send.opcode = 4'b0001; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.src1 = instruction[8:6]; 
				pkt2send.imm_en = instruction[5]; 
				pkt2send.src2 = instruction[2:0];
				pkt2send.imm = instruction[4:0];//ADD
			end
 
		`LD: begin
				pkt2send.opcode = 4'b0010;
				pkt2send.dest = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:0]; //LD
			end
		`ST: begin 
				pkt2send.opcode = 4'b0011; 
				pkt2send.src1 = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:0]; //ST
			end
	//No 4 case!
		`AND: begin
				pkt2send.opcode = 4'b0101; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.src1 = instruction[8:6]; 
				pkt2send.src2 = instruction[2:0];
				pkt2send.imm = instruction[4:0];//AND
			end
 
		`LDR: begin
				pkt2send.opcode = 4'b0110; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.base = instruction[8:6]; 
				pkt2send.pcOffset6 = instruction[5:0]; //LDR
			end
		`STR: begin
				pkt2send.opcode = 4'b0111; 
				pkt2send.src1 = instruction[11:9]; 
				pkt2send.base = instruction[8:6]; 
				pkt2send.pcOffset6 = instruction[5:0]; //LDR
			end
	//No 8 case!
		`NOT: begin
				pkt2send.opcode = 4'b1001; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.src1 = instruction[8:6]; 
			end
		`LDI: begin
				pkt2send.opcode = 4'b1010; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:6]; //LDI
			end
		`STI: begin
				pkt2send.opcode = 4'b1011; 
				pkt2send.src1 = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:6]; //STI
			end
		`JMP: begin
				pkt2send.opcode = 4'b1100; 
				pkt2send.base = instruction[8:6];//JMP
			end
	//No 13 case!
		`LEA: begin 
				pkt2send.opcode = 4'b1110; 
				pkt2send.dest = instruction[11:9]; 
				pkt2send.pcOffset9 = instruction[8:0]; //LEA
			end	
		endcase
	endtask
	
	
	task Monitor::get_fetch_inputs();
//		$display($time, " [FETCH INPUT SAMPLE]");
		fetch_pkt_in = new();
		fetch_pkt_in.enable_updatePC_in = ports.enable_updatePC_in;
		fetch_pkt_in.enable_fetch_in = ports.enable_fetch_in;
		fetch_pkt_in.taddr_in = ports.taddr_in;
		fetch_pkt_in.br_taken_in = ports.br_taken_in;
		
	endtask
		
	task Monitor::get_dec_inputs();
//		$display($time, " [DECODE INPUT SAMPLE]");
		dec_pkt_in = new();
		dec_pkt_in.IMem_dout_in = ports.IMem_dout_in;
		dec_pkt_in.npc_in_in = ports.npc_in_in;
//		dec_pkt.psr_in = ports.psr_in;
		dec_pkt_in.enable_decode_in = ports.enable_decode_in;
//		$display($time, " [DECODE ENABLE SAMPLE] ENABLE: %h", dec_pkt.enable_decode_in);
		
	endtask
	
	task Monitor::get_ex_inputs();
	//	$display($time, " [EXECUTE INPUT SAMPLE]");
		ex_pkt_in = new();
		ex_pkt_in.enable_execute_in = ports.enable_execute_in;
		ex_pkt_in.E_control_in = ports.E_control_in;
		ex_pkt_in.bypass_alu_1_in = ports.bypass_alu_1_in;
		ex_pkt_in.bypass_alu_2_in = ports.bypass_alu_2_in;
		ex_pkt_in.bypass_mem_1_in = ports.bypass_mem_1_in;
		ex_pkt_in.bypass_mem_2_in = ports.bypass_mem_2_in;
		ex_pkt_in.IR_in = ports.IR_in;
		ex_pkt_in.ex_npc_in = ports.ex_npc_in;
		ex_pkt_in.Mem_control_in = ports.Mem_control_in;
		//ex_pkt.W_control_in = ports.W_Control_in;
		ex_pkt_in.VSR1_in = ports.VSR1_in;
		ex_pkt_in.VSR2_in = ports.VSR2_in;
		ex_pkt_in.mem_bypass_in = ports.mem_bypass_in;
		ex_pkt_in.aluout_prev_in = ports.aluout_prev_in;

	endtask
		
	task Monitor::get_wb_inputs();
	//	$display($time, " [WRITEBACK INPUT SAMPLE]");
		wb_pkt_in = new();
		wb_pkt_in.enable_wb_in = ports.enable_wb_in;
		wb_pkt_in.W_Control_wb_in = ports.W_Control_wb_in;
		wb_pkt_in.pcout_wb_in = ports.pcout_wb_in;
		wb_pkt_in.memout_wb_in = ports.memout_wb_in;
		wb_pkt_in.dr_wb_in = ports.dr_wb_in;
		wb_pkt_in.sr1_wb_in = ports.sr1_wb_in;
		wb_pkt_in.sr2_wb_in = ports.sr2_wb_in;
		wb_pkt_in.npc_wb_in = ports.npc_wb_in;
		wb_pkt_in.aluout_wb_in = ports.aluout_wb_in;
		wb_pkt_in.ram_wb_in = ports.ram_wb_in;
		
	endtask
		
	task Monitor::get_ctrl_inputs();
		ctrl_pkt_in = new();
		ctrl_pkt_in.complete_data_in = ports.complete_data_in;
		ctrl_pkt_in.complete_instr_in = ports.complete_instr_in;
		ctrl_pkt_in.IR_ctrl_in = ports.IR_ctrl_in;
		ctrl_pkt_in.IR_Exec_in = ports.IR_Exec_in;
		ctrl_pkt_in.NZP_in = ports.NZP_in;
		ctrl_pkt_in.psr_in = ports.psr_in;
		ctrl_pkt_in.IR_dut_in = ports.IMem_dout_in;
	endtask
	
	task Monitor::get_ma_inputs();
		ma_pkt_in = new();
		ma_pkt_in.mem_state_in = ports.mem_state_in;
		ma_pkt_in.M_control_in = ports.M_control_in;
		ma_pkt_in.M_Data_in = ports.M_Data_in;
		ma_pkt_in.M_Addr_in = ports.M_Addr_in;
		ma_pkt_in.Data_dout_in = ports.Data_dout_in;
		
	endtask
/*	
	task Monitor::get_cache_inputs();
		cache_pkt_in = new();
		cache_pkt_in.dmac = ports.dmac;
		cache_pkt_in.rd = ports.rd;
		cache_pkt_in.addr = ports.addr;
		cache_pkt_in.din = ports.din;
		cache_pkt_in.rrdy = ports.rrdy;
		cache_pkt_in.rdrdy = ports.rdrdy;
		cache_pkt_in.wacpt = ports.wacpt;
		cache_pkt_in.miss_in = ports.miss_in;
		cache_pkt_in.state_in = ports.state_in;
		cache_pkt_in.count_in = ports.count_in;
		cache_pkt_in.blockdata_in = ports.blockdata_in;
		cache_pkt_in.valid_in = ports.valid_in;
		cache_pkt_in.offdata_in = ports.offdata_in;
		cache_pkt_in.validarr_in = ports.validarr_in;
		cache_pkt_in.memdata_in = ports.memdata_in;
		cache_pkt_in.blkreg_in = ports.blkreg_out;
		cache_pkt_in.ramrd_in = ports.ramrd_out;
	endtask
*/
	
	task Monitor::get_fetch_payload();
//		$display($time, "    [Sample FETCH outputs]");
		fetch_pkt_out.pc2cmp = ports.pc2cmp;
		fetch_pkt_out.npc2cmp = ports.npc2cmp;
	endtask
	
	task Monitor::get_fetch_async_payload();
//		$display($time, "    [Sample FETCH outputs]");
		fetch_pkt_out = new();
		fetch_pkt_out.IMem_rd2cmp = ports.IMem_rd2cmp;
	endtask

	task Monitor::get_dec_payload();
//		$display($time, "    [Sample DECODE outputs]");
		dec_pkt_out = new();
		dec_pkt_out.IMem_dout_in = ports.IMem_dout_in;
		dec_pkt_out.IR2cmp = ports.IR2cmp;
		dec_pkt_out.npc_out2cmp = ports.npc_out2cmp;
		dec_pkt_out.E_control2cmp = ports.E_control2cmp;
		dec_pkt_out.W_control2cmp = ports.W_control2cmp;
		dec_pkt_out.Mem_control2cmp = ports.Mem_control2cmp;
	endtask
	
	task Monitor::get_ex_payload();
//		$display($time, "    [Sample EXECUTE outputs]");
		ex_pkt_out.W_Control_out2cmp = ports.W_Control_out2cmp;
		ex_pkt_out.Mem_Control_out2cmp = ports.Mem_Control_out2cmp;
		ex_pkt_out.aluout2cmp = ports.aluout2cmp;
		ex_pkt_out.dr2cmp = ports.dr2cmp;
		ex_pkt_out.NZP2cmp = ports.NZP2cmp;
		ex_pkt_out.IR_Exec2cmp = ports.IR_Exec2cmp;
		ex_pkt_out.M_Data2cmp = ports.M_Data2cmp;
	endtask
	
	task Monitor::get_ex_async_payload();
//		$display($time, "    [Sample EXECUTE outputs]");
		ex_pkt_out = new();
		ex_pkt_out.sr12cmp = ports.sr12cmp;
		ex_pkt_out.sr22cmp = ports.sr22cmp;
		ex_pkt_out.imm52cmp = ports.imm52cmp;
		ex_pkt_out.offset62cmp = ports.offset62cmp;
		ex_pkt_out.offset92cmp = ports.offset92cmp;
		ex_pkt_out.offset112cmp = ports.offset112cmp;
	endtask
	
	task Monitor::get_wb_payload();
//		$display($time, "    [Sample WRITEBACK outputs]");
		wb_pkt_out.psr2cmp = ports.psr2cmp;
		wb_pkt_out.ram_out = ports.ram_wb_in; //reuse this connection to the ram
	endtask
	
	task Monitor::get_wb_async_payload();
//		$display($time, "    [Sample WRITEBACK outputs]");
		wb_pkt_out = new();
		wb_pkt_out.VSR12cmp = ports.VSR12cmp;
		wb_pkt_out.VSR22cmp = ports.VSR22cmp;
	endtask
	
	task Monitor::get_ctrl_payload();
		ctrl_pkt_out = new();
		ctrl_pkt_out.enable_updatePC2cmp = ports.enable_updatePC2cmp;
		ctrl_pkt_out.enable_fetch2cmp = ports.enable_fetch2cmp;
		ctrl_pkt_out.enable_decode2cmp = ports.enable_decode2cmp;
		ctrl_pkt_out.enable_execute2cmp = ports.enable_execute2cmp;
		ctrl_pkt_out.enable_writeback2cmp = ports.enable_writeback2cmp;
		ctrl_pkt_out.bypass_alu_12cmp = ports.bypass_alu_12cmp;
		ctrl_pkt_out.bypass_alu_22cmp = ports.bypass_alu_22cmp;
		ctrl_pkt_out.bypass_mem_12cmp = ports.bypass_mem_12cmp;
		ctrl_pkt_out.bypass_mem_22cmp = ports.bypass_mem_22cmp;
		ctrl_pkt_out.mem_state2cmp = ports.mem_state2cmp;
		ctrl_pkt_out.br_taken2cmp = ports.br_taken2cmp;
	endtask
	
	task Monitor::get_ma_payload();
//		ma_pkt.Data_addr2cmp = ports.Data_addr2cmp;
//		ma_pkt.Data_din2cmp = ports.Data_din2cmp;
//		ma_pkt.Data_rd2cmp = ports.Data_rd2cmp;
//		ma_pkt.memout2cmp = ports.memout2cmp;
		
	endtask
	
	task Monitor::get_ma_async_payload();
		ma_pkt_out = new();
		ma_pkt_out.memout2cmp = ports.memout2cmp;
		ma_pkt_out.Data_addr2cmp = ports.Data_addr2cmp;
		ma_pkt_out.Data_din2cmp = ports.Data_din2cmp;
		ma_pkt_out.Data_rd2cmp = ports.Data_rd2cmp;
		ma_pkt_out.memout2cmp = ports.memout2cmp;
		
	endtask
/*
	task Monitor::get_cache_payload();
		cache_pkt_out.dout = ports.dout;
		cache_pkt_out.complete = ports.complete;
		cache_pkt_out.miss_out = ports.miss_out;
		cache_pkt_out.state_out = ports.state_out;
		cache_pkt_out.count_out = ports.count_out;
		cache_pkt_out.blockdata_out = ports.blockdata_out;
//		cache_pkt.valid_out = ports.valid_out;
		cache_pkt_out.validarr_out = ports.validarr_out;
		cache_pkt_out.blkreg_out = ports.blkreg_out;
	endtask

	task Monitor::get_cache_async_payload();
		cache_pkt_out = new();
		cache_pkt_out.rrqst = ports.rrqst;
		cache_pkt_out.rdacpt = ports.rdacpt;
		cache_pkt_out.wrqst = ports.wrqst;
		cache_pkt_out.offdata_out = ports.offdata_out;
		cache_pkt_out.ramrd_out = ports.ramrd_out;
		cache_pkt_out.valid_out = ports.valid_out;
	endtask
*/