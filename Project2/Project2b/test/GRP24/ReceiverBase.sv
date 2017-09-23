class ReceiverBase;
	
	virtual LC3_io.TB LC3;	// interface signals
	virtual Fetch_Probe_if Fetch ;
	virtual Decode_Probe_if Decode;
	virtual Execute_Probe_if Exe;
	virtual Writeback_Probe_if WB;
	virtual Controller_Probe_if Con;

	
	
	string   name;		// unique identifier

	OutputPacket    pkt_cmp	;	// actual Packet object
	
	///////////////////////////Fetch
	reg instrmem_rd_fetch_cmp ;
	//////////////////////////Decode
	/*No asynchronous output*/
	/////////////////////////Execute
	reg [2:0] sr1_execute_cmp;
	reg [2:0] sr2_execute_cmp;
	/////////////////////////WB

	reg [15:0]  VSR1_WB_cmp;
	reg [15:0]  VSR2_WB_cmp;
	/////////////////////////Memaccess
	reg [15:0] memout_MemAccess_cmp;//////////////////////Check the name *
		//////////////////////MemAccess
	reg [15:0] DMem_addr_MemAccess_cmp;
	reg[15:0] DMem_din_MemAccess_cmp;
	reg  DMem_rd_MemAccess_cmp;
	/////////////////////////Controller
	/* No Asynchronous output*/
	
	///////////////////////Fetch

	reg [15:0] pc_fetch_cmp ;
	reg [15:0] npc_fetch_cmp;	
	//////////////////////Decode
	reg  [15:0] IR_decode_cmp;
	reg  [15:0] npc_out_decode_cmp;
	reg  [6:0]  E_Control_decode_cmp;
	reg  [1:0]  W_Control_decode_cmp;
	reg         Mem_Control_decode_cmp;
	/////////////////////Execute
	reg  [2:0] W_Control_out_execute_cmp;
	reg 	   Mem_Control_out_execute_cmp;
	reg  [15:0]  aluout_execute_cmp;
	reg  [15:0]  pcout_execute_cmp;	
	reg  [2:0]   dr_execute_cmp;
	reg [15:0]   IR_Exec_execute_cmp;
	reg [2:0]   NZP_execute_cmp;
	reg [15:0]  M_Data_execute_cmp;
	////////////////////WB	
		reg [2:0] psr_WB_cmp;

	////////////////////////Controller
	reg    enable_fetch_controller_cmp;
	reg    enable_decode_controller_cmp;
	reg    enable_execute_controller_cmp;
	reg    enable_writeback_controller_cmp;
	reg    enable_updatePC_controller_cmp; 
	reg    bypass_alu_1_controller_cmp;
	reg   	bypass_alu_2_controller_cmp;
	reg    bypass_mem_1_controller_cmp;
	reg   	bypass_mem_2_controller_cmp;	
	reg    br_taken_controller_cmp;
	reg [1:0] mem_state_controller_cmp;		
	
	
	
	
	int pkt_cnt = 0;
	

	extern function new(string name = "ReceiverBase", virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
	extern virtual task recv();
	extern virtual task get_payload();
endclass

function ReceiverBase::new(string name = "ReceiverBase", virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
	this.name = name;
	this.LC3 = LC3;
	this.Fetch = Fetch;
	this.Decode = Decode;
	this.Exe = Exe;
	this.WB = WB;
	this.Con = Con;
	
	pkt_cmp = new();

endfunction

//All output signals  to be sent in the Outpacket pkt_cmp

task ReceiverBase::recv();
	get_payload();
	
	pkt_cmp.name = $psprintf("rcvdPkt[%0d]", pkt_cnt++);
	pkt_cmp.instrmem_rd_fetch	=instrmem_rd_fetch_cmp;
	pkt_cmp.sr1_execute		=sr1_execute_cmp;
	pkt_cmp.sr2_execute    		=sr2_execute_cmp;
	pkt_cmp.VSR1_WB    		= VSR1_WB_cmp;
	pkt_cmp.VSR2_WB   		= VSR2_WB_cmp;
	pkt_cmp.memout_MemAccess           = memout_MemAccess_cmp;
	
	pkt_cmp.pc_fetch      =pc_fetch_cmp  ;
	pkt_cmp.npc_fetch      =npc_fetch_cmp ; 	
	//////////////////////Decode
	pkt_cmp.IR_decode      =IR_decode_cmp ;
	pkt_cmp.npc_out_decode	  =npc_out_decode_cmp ;
	pkt_cmp.E_Control_decode      =E_Control_decode_cmp ;
	pkt_cmp.W_Control_decode      =W_Control_decode_cmp ;
	pkt_cmp.Mem_Control_decode      =Mem_Control_decode_cmp ;
	/////////////////////Execute
	pkt_cmp.W_Control_out_execute      =W_Control_out_execute_cmp ;
	pkt_cmp.Mem_Control_out_execute      =Mem_Control_out_execute_cmp ;
	pkt_cmp.aluout_execute      =aluout_execute_cmp ;
	pkt_cmp.pcout_execute      =pcout_execute_cmp ;	
	pkt_cmp.dr_execute      =dr_execute_cmp ;
	pkt_cmp.IR_Exec_execute      = IR_Exec_execute_cmp ;
	pkt_cmp.NZP_execute      =NZP_execute_cmp ;
	pkt_cmp.M_Data_execute      =M_Data_execute_cmp ;
	////////////////////WB	
        pkt_cmp.psr_WB      =psr_WB_cmp;
	//////////////////////MemAccess
	pkt_cmp.DMem_addr_MemAccess      =DMem_addr_MemAccess_cmp;
	pkt_cmp.DMem_din_MemAccess      =DMem_din_MemAccess_cmp ;
	pkt_cmp.DMem_rd_MemAccess      =DMem_rd_MemAccess_cmp;
	////////////////////////Controller
	pkt_cmp.enable_fetch_controller      =enable_fetch_controller_cmp ;
	pkt_cmp.enable_decode_controller      =enable_decode_controller_cmp ;
	pkt_cmp.enable_execute_controller      =enable_execute_controller_cmp;
	pkt_cmp.enable_writeback_controller      =enable_writeback_controller_cmp ;
	pkt_cmp.enable_updatePC_controller      =enable_updatePC_controller_cmp ; 
	pkt_cmp.bypass_alu_1_controller      =bypass_alu_1_controller_cmp  ;
	pkt_cmp.bypass_alu_2_controller      =bypass_alu_2_controller_cmp ;
	pkt_cmp.bypass_mem_1_controller      =bypass_mem_1_controller_cmp ;
	pkt_cmp.bypass_mem_2_controller      =bypass_mem_2_controller_cmp ;	
	pkt_cmp.br_taken_controller      =br_taken_controller_cmp ;
        pkt_cmp.mem_state_controller      =mem_state_controller_cmp ; 
	
	
	
endtask

task ReceiverBase::get_payload();

	/////////////////////////Fetch
	instrmem_rd_fetch_cmp = Fetch.cb.instrmem_rd;

	/////////////////////////Execute
	sr1_execute_cmp      = Exe.cb.sr1;
	sr2_execute_cmp      = Exe.cb.sr2;
	/////////////////////////WB
	 VSR1_WB_cmp = WB.cb.d1;
	 VSR2_WB_cmp = WB.cb.d2;
	/////////////////////////Memaccess
	memout_MemAccess_cmp = WB.cb.memout_MA ;

	
	pc_fetch_cmp  = Fetch.cb.pc;
	npc_fetch_cmp = Fetch.cb.npc_out; 	
	//////////////////////Decode
	IR_decode_cmp = Decode.cb.IR;
	npc_out_decode_cmp = Decode.cb.npc_out;
	E_Control_decode_cmp = Decode.cb.E_Control;
	W_Control_decode_cmp = Decode.cb.W_Control;
	Mem_Control_decode_cmp = Decode.cb.Mem_Control;
	/////////////////////Execute
	W_Control_out_execute_cmp = Exe.cb.W_Control_out;
	Mem_Control_out_execute_cmp = Exe.cb.Mem_Control_out;
	aluout_execute_cmp = Exe.cb.aluout;
	pcout_execute_cmp = Exe.cb.pcout;	
	dr_execute_cmp = Exe.cb.dr;
	IR_Exec_execute_cmp = Exe.cb.IR_Exec;
	NZP_execute_cmp = Exe.cb.NZP;
	M_Data_execute_cmp  = Exe.cb.M_Data;
	////////////////////WB	
	psr_WB_cmp = WB.cb.psr;
	//////////////////////MemAccess
	DMem_addr_MemAccess_cmp = WB.cb.M_Addr;
	DMem_din_MemAccess_cmp = WB.cb.M_Data;
	DMem_rd_MemAccess_cmp = WB.cb.Data_rd;
	////////////////////////Controller
	enable_fetch_controller_cmp  = Con.cb.enable_fetch;
	enable_decode_controller_cmp = Con.cb.enable_decode;
	enable_execute_controller_cmp = Con.cb.enable_execute;
	enable_writeback_controller_cmp = Con.cb.enable_writeback;
	enable_updatePC_controller_cmp = Con.cb.enable_updatePC; 
	bypass_alu_1_controller_cmp  = Con.cb.bypass_alu_1;
	bypass_alu_2_controller_cmp = Con.cb.bypass_alu_2;
	bypass_mem_1_controller_cmp = Con.cb.bypass_mem_1;
	bypass_mem_2_controller_cmp = Con.cb.bypass_mem_2;	
	br_taken_controller_cmp = Con.cb.br_taken;
        mem_state_controller_cmp = Con.cb.mem_state; 

endtask


