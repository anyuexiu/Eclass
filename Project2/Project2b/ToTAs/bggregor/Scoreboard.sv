
parameter	AND = 4'h5;
parameter	ADD = 4'h1;
parameter	NOT = 4'h9;
parameter	BR  = 4'h0;
parameter	JMP = 4'hc;
parameter	LD  = 4'h2;
parameter	LDR = 4'h6;
parameter	LDI = 4'ha;
parameter	LEA = 4'he;
parameter	ST  = 4'h3;
parameter	STR = 4'h7;
parameter	STI = 4'hb;



class Scoreboard;
	
	// CacheController Golden Model Variables
logic [0:0]	reset_g, macc_g, rrdy_g, rdrdy_g, wacpt_g, miss_g, rd_g;
logic [1:0]	count_g;
logic [3:0]	state_g;

logic [0:0]	reset_ctl, macc_ctl, rrdy_ctl, rdrdy_ctl, wacpt_ctl, miss_ctl, rd_ctl;
logic [1:0]	count_ctl;
logic [3:0]	state_ctl;
	// CacheController Golden Model Variables
	
	
	//  ProcInterface Golden Model Variables
logic [0:0]	complete_g;
logic [15:0]	addr_g, dout_g;
logic [63:0]	blockdata_g;

logic [0:0]	rd_proc, complete_proc, miss_proc;
logic [15:0]	addr_proc, dout_proc;
logic [63:0]	blockdata_proc;
logic [3:0]	state_proc;
logic [63:0]	tmp_blockdata;
logic [0:0]	tmp_rd;
	//  ProcInterface Golden Model Variables
	
	
	// ValidArray Golden Model Variables
logic [0:0]	valid_g = 0;
logic [3:0]	index_g;

logic [0:0]	reset_val, valid_val;
logic [3:0]	state_val, index_val;
logic	[15:0]   temp_va;
	// ValidArray Golden Model Variables
	
	
	//  CacheData Golden Model Variables
logic [15:0]	din_g, offdata_g;

logic [0:0]	rd_cdata, valid_cdata, miss_cdata;
logic [15:0]	addr_cdata, din_cdata, offdata_cdata;
logic [63:0]	blockdata_cdata;
logic [1:0]	count_cdata;
logic [3:0]	state_cdata;
logic [15:0] block0, block1, block2, block3;
logic [1:0] blocksel0, blocksel1, blocksel2, blocksel3;	



//logic [0:0] ramrd;
	//  CacheData Golden Model Variables
	
	
	//  MemInterface Golden Model Variables
logic [0:0]	rrqst_g, rdacpt_g, wrqst_g;

logic [3:0]	state_mem;	
logic [0:0]	miss_mem, rrqst_mem, rdacpt_mem, wrqst_mem;
logic [15:0]	addr_mem, din_mem, offdata_mem;
	//  MemInterface Golden Model Variables

	// DMem Golden Model
logic [15:0] ram[];
logic [3:0] state = 0;
logic flag = 0, reset;
logic [15:0] readaddr, storedata;
logic [1:0] count = 0;	
logic rrdy, rdrdy, wacpt;
logic rrqst, rdacpt, wrqst;
logic [15:0] data;
logic	[15:0] address;
logic [15:0]	q[$];

//  	input rrqst, rdacpt, wrqst;
//  	output rrdy, rdrdy, wacpt;
//  	inout [15:0] data;
//  	input reset;

	// DMem Golden Model

int debug;	
int in;
logic [73:0] memarray[15:0];	
logic [73:0] ramdata;
logic [0:0] ramrd;

int counter=0;

	real 	coverage_value1, coverage_value2, coverage_value3, coverage_value4, coverage_value5, coverage_value6;

//********************************  ARITHMETIC  ***************************************	
	covergroup LC3_arithmetic; 
		op_cov  : coverpoint pkt_sent.op    { 	bins arith[] = {5,1,9,14};}
		src1_cov: coverpoint pkt_sent.src1  {
			bins zero  = {0};
			bins all[] = {[0:7]};
			}
		src2_cov: coverpoint pkt_sent.src2 {
			bins zero  = {0};
			bins allfs  = {5'b11111};
			bins all[] = {[0:7]};
			}
		dr_cov  : coverpoint pkt_sent.dr   ;
		mode_cov: coverpoint pkt_sent.mode ;
		
		aluin1_cov : coverpoint cachedata_ports.aluin1 {
					bins zero = {0};
					bins allfs = {16'hffff};
					bins special1 = {16'h5555};
					bins special2 = {16'haaaa};
					bins range1 =  {[16'h0000 : 16'h0fff]};
					bins range2 =  {[16'h1000 : 16'h1fff]};
					bins range3 =  {[16'h2000 : 16'h2fff]};
					bins range4 =  {[16'h3000 : 16'h3fff]};
					bins range5 =  {[16'h4000 : 16'h4fff]};
					bins range6 =  {[16'h5000 : 16'h5fff]};
					bins range7 =  {[16'h6000 : 16'h6fff]};
					bins range8 =  {[16'h7000 : 16'h7fff]};
					bins range9 =  {[16'h8000 : 16'h8fff]};
					bins range10 = {[16'h9000 : 16'h9fff]};
					bins range11 = {[16'ha000 : 16'hafff]};
					bins range12 = {[16'hb000 : 16'hbfff]};
					bins range13 = {[16'hc000 : 16'hcfff]};
					bins range14 = {[16'hd000 : 16'hdfff]};
					bins range15 = {[16'he000 : 16'hefff]};
					bins range16 = {[16'hf000 : 16'hffff]};
				}
		aluin2_cov : coverpoint cachedata_ports.aluin2 {
					bins zero = {0};
					bins allfs = {16'hffff};
					bins special1 = {16'h5555};
					bins special2 = {16'haaaa};
					bins range1 =  {[16'h0000 : 16'h0fff]};
					bins range2 =  {[16'h1000 : 16'h1fff]};
					bins range3 =  {[16'h2000 : 16'h2fff]};
					bins range4 =  {[16'h3000 : 16'h3fff]};
					bins range5 =  {[16'h4000 : 16'h4fff]};
					bins range6 =  {[16'h5000 : 16'h5fff]};
					bins range7 =  {[16'h6000 : 16'h6fff]};
					bins range8 =  {[16'h7000 : 16'h7fff]};
					bins range9 =  {[16'h8000 : 16'h8fff]};
					bins range10 = {[16'h9000 : 16'h9fff]};
					bins range11 = {[16'ha000 : 16'hafff]};
					bins range12 = {[16'hb000 : 16'hbfff]};
					bins range13 = {[16'hc000 : 16'hcfff]};
					bins range14 = {[16'hd000 : 16'hdfff]};
					bins range15 = {[16'he000 : 16'hefff]};
					bins range16 = {[16'hf000 : 16'hffff]};
				}
		cx_alu1	: cross aluin1_cov , op_cov;
		cx_alu2	: cross aluin2_cov , op_cov;
				
	endgroup
//********************************  BYPASSES  ***************************************			
	covergroup bypasses;
		op_cov  	: coverpoint cachedata_ports.IR[15:12] { bins s[] = {5 ,1 ,9 ,0 ,12,2 ,6 ,10,14,3 ,7 ,11};}	
			
		
		sr2_dr_cov : coverpoint {cachedata_ports.IR_Exec[11:9],cachedata_ports.IR[2:0]}	
		{ 
			bins s0 = {6'b000000}; bins s1 = {6'b001001}; bins s2 = {6'b010010}; bins s3 = {6'b011011};
			bins s4 = {6'b100100}; bins s5 = {6'b101101}; bins s6 = {6'b110110}; bins s7 = {6'b111111};
			}
		sr1_dr_cov : coverpoint {cachedata_ports.IR_Exec[11:9],cachedata_ports.IR[8:6]}
		{ 
			bins s0 = {6'b000000}; bins s1 = {6'b001001}; bins s2 = {6'b010010}; bins s3 = {6'b011011};
			bins s4 = {6'b100100}; bins s5 = {6'b101101}; bins s6 = {6'b110110}; bins s7 = {6'b111111};
			}
		dr_dr_cov  : coverpoint {cachedata_ports.IR_Exec[11:9],cachedata_ports.IR[11:9]}
		{ 
			bins s0 = {6'b000000}; bins s1 = {6'b001001}; bins s2 = {6'b010010}; bins s3 = {6'b011011};
			bins s4 = {6'b100100}; bins s5 = {6'b101101}; bins s6 = {6'b110110}; bins s7 = {6'b111111};
			}	
		
	cx_IRsrc1_IREXec : cross sr1_dr_cov  ,op_cov;
	cx_IRsrc2_IREXec : cross sr2_dr_cov  ,op_cov;
	cx_IRdr_IREXec   : cross dr_dr_cov   ,op_cov;
	       
	        
	endgroup
//********************************  inputs  ***************************************			
	covergroup cache_inputs;
   //procinterface
rd_cov				:	coverpoint	 pkt_sent2.rd	;
addr_cov			:	coverpoint	 pkt_sent2.addr 	{ option.auto_bin_max = 6; } 
state_cov			:	coverpoint	 pkt_sent2.state	{ bins s[]={0,1,2,3,4,5,6,7,8};}
state_cov2			:	coverpoint	 pkt_sent2.state{ bins t =(0 => 1),( 1=> 2),(2 => 3),(3 => 8),(8 => 0),
										     (0=>4),(4=>5),(5=>6),(6=>7),(7=>8),(8=>0),	
										     (0=>4),(4=>5),(5=>6),(6=>7),(7=>2),(2=>3),(3=>8),(8=>0);	
										  }

miss_cov			:	coverpoint	 pkt_sent2.miss ;
blockdata_cov			:	coverpoint	 pkt_sent2.blockdata[63:0]	{bins b[]= {64'haaaaaaaaaaaaaaaa, 64'h5555555555555555, 64'h0000000000000000,  64'hffffffffffffffff} ;
										 option.auto_bin_max = 10;}
blockdata_addr_cov		:	coverpoint	 pkt_sent2.RAMdata[73:64]	{ option.auto_bin_max = 4;}

cx_proc_interface_1	: cross rd_cov, miss_cov,blockdata_cov;
cx_proc_interface_2	: cross rd_cov, miss_cov,blockdata_addr_cov;

    //validarray 
index_cov			:	coverpoint	 pkt_sent2.index	{bins i[] = {[0:15]};}
//state_cov
cx_validarray1	: cross index_cov , state_cov;
cx_validarray2	: cross index_cov , valid_cov;


    //cachedata 
din_cov				:	coverpoint	 pkt_sent2.din  	{bins b[]= {16'h0000,16'hffff, 16'haaaa , 16'h5555};}  
count_cov			:	coverpoint	 pkt_sent2.count	{ bins c[]={0,1,2,3}; }
valid_cov			:	coverpoint	 pkt_sent2.valid	;
offdata_cov			:	coverpoint	 pkt_sent2.offdata	{bins b[]= {16'h0000,16'hffff, 16'haaaa , 16'h5555};} 
addr_index_cov			:	coverpoint	 pkt_sent2.addr[5:2] 	;
addr_offset_cov			:	coverpoint	 pkt_sent2.addr[1:0] 	;
ramrd_cov			:	coverpoint	 pkt_sent2.ramrd	;
state2_cov			:	coverpoint	 pkt_sent2.state	{ bins s={2};}
state4_cov			:	coverpoint	 pkt_sent2.state	{ bins s={4};}

//state_cov
//rd_cov
//addr_cov
cx_cachedata1	: cross rd_cov , count_cov , valid_cov;
cx_cachedata3	: cross blockdata_cov , ramrd_cov;
cx_cachedata4	: cross blockdata_addr_cov , ramrd_cov;
cx_cachedata5	: cross  din_cov,addr_offset_cov, state4_cov;
cx_cachedata6	: cross  offdata_cov, count_cov ,state2_cov;

   //meminterface 
//state_cov
//din_cov
//addr_cov
//miss_cov
cx_meminterface	: cross miss_cov , din_cov;

   //cachecontroller 
macc_cov			:	coverpoint	 pkt_sent2.macc ;
rrdy2_cov			:	coverpoint	 pkt_sent2.rrdy2	;
rdrdy2_cov			:	coverpoint	 pkt_sent2.rdrdy2;
wacpt2_cov			:	coverpoint	 pkt_sent2.wacpt2	;	
//state_cov
//rd_cov
//miss_cov

	
	endgroup	

//********************************    CACHE   *****************************************		
	covergroup LC3_inputs; 
		
		// execute inputs
		mode_cov: coverpoint pkt_sent.mode ;
		vsr1_cov        : coverpoint pkt_sent2.vsr1 {bins s[] = {16'h0000,16'h1111,16'haaaa,16'h5555};}
		vsr2_cov        : coverpoint pkt_sent2.vsr2 {bins s[] = {16'h0000,16'h1111,16'haaaa,16'h5555};}
	        bypass_alu1_cov	: coverpoint pkt_sent2.bypass_alu_1 ;
   		bypass_alu2_cov	: coverpoint pkt_sent2.bypass_alu_2 ;			 
		bypass_mem1_cov	: coverpoint pkt_sent2.bypass_mem_1 ;
		bypass_mem2_cov	: coverpoint pkt_sent2.bypass_mem_2 ;	
		W_control_cov	: coverpoint pkt_sent2.W_control_in   { bins W[] = {0,1,2}; }
		E_control_cov	: coverpoint pkt_sent2.E_Control { bins E[] = {6'h00,6'h01,6'h11,6'h10,6'h20,6'h06,6'h0c};}
		Mem_control_in_cov : coverpoint pkt_sent2.Mem_control_in;
		IR1_cov  	: coverpoint pkt_sent2.IR[15:12] { bins s[] = {5 ,1 ,9 ,0 ,12,2 ,6 ,10,14,3 ,7 ,11};}
		IR2_cov  	: coverpoint pkt_sent2.IR[11:0] { option.auto_bin_max = 8; }
		enable_execute_cov  : coverpoint pkt_sent2.enable_execute { bins e1= {1};}
		mem_bypass_cov  : coverpoint pkt_sent2.Mem_Bypass_Val { option.auto_bin_max = 6; } 
		dr_in_cov	: coverpoint	pkt_sent2.dr_in  {bins s[] = {16'h0000,16'h1111,16'haaaa,16'h5555};}
		aluin1_cov : coverpoint cachedata_ports.aluin1 {	bins s[] = {16'h0000,16'h1111,16'haaaa,16'h5555};option.auto_bin_max = 8; }
		aluin2_cov : coverpoint cachedata_ports.aluin2 {	bins s[] = {16'h0000,16'h1111,16'haaaa,16'h5555};option.auto_bin_max = 8;}
		// npcin_cov  
		cx_bypass_mem1_mem2 	: cross bypass_mem1_cov ,bypass_mem2_cov ,enable_execute_cov ;
		cx_bypass_alu1_alu2 	: cross bypass_alu1_cov ,bypass_alu2_cov ,enable_execute_cov;
		cx_vsr1_w_control	: cross vsr1_cov, enable_execute_cov;
		cx_vsr2_w_control	: cross vsr2_cov, enable_execute_cov;
		cx_aluin1_E_control	: cross aluin1_cov , E_control_cov;
		cx_aluin2_E_control	: cross aluin2_cov , E_control_cov;
			
		
		//mem_access_inputs
		M_data_cov	: coverpoint pkt_sent2.M_Data{	bins s[] = {16'h0000,16'hffff, 16'haaaa,16'h5555};	    option.auto_bin_max = 8;}								    
		memstate_cov	: coverpoint 		pkt_sent2.mem_state {bins M[] = {[0:3]};}
		M_control_cov	: coverpoint		pkt_sent2.M_Control ;
		M_addr_cov	: coverpoint		pkt_sent2.M_Addr    { option.auto_bin_max = 4; bins a[]={16'h0000,16'hffff}; } 
			
		 
		// Fetch inputs
		enable_updatePC_cov	   : coverpoint  pkt_sent2.enable_updatePC;
		taddr_cov	 	   : coverpoint  pkt_sent2.taddr	 { option.auto_bin_max = 8; }
		br_taken_cov	  	   : coverpoint  pkt_sent2.br_taken	 ;
		enable_fetch_cov	   : coverpoint  pkt_sent2.enable_fetch  ;
		cx_br_taddr 	: cross br_taken_cov,	taddr_cov;	
		
		
		// Decode inputs
		npcin_cov		:	coverpoint	pkt_sent2.npc_in { option.auto_bin_max = 8; }
		enable_decode_cov	:	coverpoint	pkt_sent2.enable_decode	;
				
		
		//writeback inputs
		dr_cov	       	: coverpoint pkt_sent2.dr2 	    ; 
		sr1_cov	       	: coverpoint pkt_sent2.sr1	    ;
		sr2_cov	       	: coverpoint pkt_sent2.sr2	    ;
		W_control_out_cov	       	: coverpoint pkt_sent2.W_control_out  { bins W[] = {0,1,2}; }
		enable_writeback_cov	       	: coverpoint pkt_sent2.enable_writeback {bins s1= {1};}
		memout_access_cov	: coverpoint pkt_sent2.memout {bins s[] = {16'h0000,16'hffff, 16'haaaa,16'h5555};option.auto_bin_max = 8;}
		aluout_writeback_cov : coverpoint pkt_sent2.aluout { option.auto_bin_max = 8; }
		pcout_writeback_cov  : coverpoint pkt_sent2.pcout  { option.auto_bin_max = 8; }
		cx_dr_in_w_control	: cross dr_in_cov , W_control_cov,enable_writeback_cov;
		
		
		//controller inputs
		complete_data_cov : coverpoint pkt_sent2.complete_data { bins s1={1};}
		IR_Exec_cov 	: coverpoint pkt_sent2.IR_Exec[15:12]  { bins s[] = {5 ,1 ,9 ,0 ,12,2 ,6 ,10,14,3 ,7 ,11};}
		NZP_cov		: coverpoint pkt_sent2.NZP ;
		psr_cov		: coverpoint pkt_sent2.psr {bins N[] = { 3'b100 , 3'b010 , 3'b001};}
		//IR_cov
		
		cx_IR_IR_Exe	: cross IR1_cov , IR_Exec_cov ;
		cx_NZP_psr	: cross psr_cov , NZP_cov ; 
		
		
		
	endgroup
	
	
	
		
	string   name;			// unique identifier
	Packet pkt1 = new();
	Packet pkt_sent = new();	// Packet object from Driver
	Packet pkt_sent2 = new();	// Packet for Coverage
	OutputPacket   pkt2cmp = new();		// Packet object from Receiver

  	virtual CacheController_Probe_if cachecontroller_ports ;
	virtual ProcInterface_Probe_if procinterface_ports;
	virtual ValidArray_Probe_if validarray_ports;
	virtual CacheData_Probe_if cachedata_ports;
	virtual MemInterface_Probe_if meminterface_ports;
	//         LC3 interfaces
	virtual Fetch_Probe_if fetch_ports; 			//PROBECHANGE
	virtual Decode_Probe_if  decode_ports;
	virtual Control_Probe_if control_ports;
	virtual WriteBack_Probe_if writeback_ports;
	virtual Execute_Probe_if execute_ports;
	virtual MemAccess_Probe_if memaccess_ports;
	
	
	typedef mailbox #(Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers

  	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	
	typedef mailbox #(Packet) s2d_box_type;
  	s2d_box_type 	s2d_out_box;		// mailbox for Packet objects To Driver
	
	extern function new(string name = "Scoreboard", virtual CacheController_Probe_if cachecontroller_ports , virtual
	ProcInterface_Probe_if procinterface_ports, virtual ValidArray_Probe_if validarray_ports, virtual CacheData_Probe_if
	cachedata_ports, virtual MemInterface_Probe_if meminterface_ports, virtual	Fetch_Probe_if fetch_ports,
	virtual Decode_Probe_if decode_ports, virtual Control_Probe_if control_ports, 
	virtual	WriteBack_Probe_if writeback_ports, virtual Execute_Probe_if execute_ports, virtual MemAccess_Probe_if memaccess_ports);
		
	extern virtual task start();
	extern virtual task check();
	extern virtual task GModel_CacheController();
	extern virtual task GModel_ProcInterface();
	extern virtual task GModel_ValidArray();
	extern virtual task GModel_CacheData();
	extern virtual task GModel_MemInterface();
	extern virtual task GModel_DMem();
	
	
	
endclass

function Scoreboard::new(string name="Scoreboard",  virtual CacheController_Probe_if cachecontroller_ports , virtual ProcInterface_Probe_if
procinterface_ports, virtual ValidArray_Probe_if validarray_ports, virtual CacheData_Probe_if cachedata_ports, virtual
MemInterface_Probe_if meminterface_ports,  virtual Fetch_Probe_if fetch_ports, virtual Decode_Probe_if  decode_ports, virtual Control_Probe_if control_ports, virtual
				WriteBack_Probe_if writeback_ports, virtual Execute_Probe_if execute_ports, virtual MemAccess_Probe_if memaccess_ports );
	
	if (s2d_out_box == null) 
		s2d_out_box = new();
	this.s2d_out_box = s2d_out_box;
	//this.s2d_out_box = new;
	this.name = name;
	this.cachecontroller_ports	= cachecontroller_ports;//PROBECHANGE
	this.procinterface_ports	= procinterface_ports;
	this.validarray_ports		= validarray_ports;
	this.cachedata_ports		= cachedata_ports;
	this.meminterface_ports		= meminterface_ports;
	
	//LC3 interfaes
	this.fetch_ports = fetch_ports;//PROBECHANGE
	this.decode_ports = decode_ports;
	this.control_ports = control_ports;
	this.writeback_ports = writeback_ports;
	this.execute_ports = execute_ports;
	this.memaccess_ports = memaccess_ports;
		
	if (driver_mbox == null) 
		driver_mbox = new();
	if (receiver_mbox == null) 
		receiver_mbox = new();
	this.driver_mbox = driver_mbox;
	this.receiver_mbox = receiver_mbox;
	
	
	LC3_arithmetic = new();
	bypasses = new();
	LC3_inputs = new();
	cache_inputs =  new();
	
	
endfunction

task Scoreboard::start();
	$display ($time, "[SCOREBOARD] Scoreboard Started");
	
	//$display ($time, "[SCOREBOARD] Receiver Mailbox contents = %d", receiver_mbox.num());
	fork
	
	
	GModel_CacheController();
	GModel_ProcInterface();
	GModel_ValidArray();
	GModel_CacheData();
	GModel_MemInterface();
	GModel_DMem();
	
	check(); 
	
		forever 
		begin	
pkt_sent2.old_dr = pkt_sent2.dr;							// USED IN COVERAGE TO TRACK


				in=1;
				//GModel_CacheController();
				//GModel_ProcInterface();
				//GModel_ValidArray();
				//GModel_CacheData();
				//GModel_MemInterface();
				GModel_DMem();
				
			#1
	//			check(); // May need to remove
				//$display($time,"in = 1");				
				in=0;
			if((counter++)==140000) begin
				$display("");
				$display ("			 [SCOREBOARD -> COVERAGE] Coverage Result for LC3_arithmetic	At present = %d", coverage_value1);
				$display ("			 [SCOREBOARD -> COVERAGE] Coverage Result for bypasses	At present = %d", coverage_value2);
				$display ("			 [SCOREBOARD -> COVERAGE] Coverage Result for LC3_inputs	At present = %d", coverage_value3);
				$display ("			 [SCOREBOARD -> COVERAGE] Coverage Result for cache_inputs	At present = %d\n\n", coverage_value4);
			end
				receiver_mbox.get(pkt2cmp);
				driver_mbox.get(pkt_sent);
			#1;			
				//GModel_CacheController();
				//GModel_ProcInterface();
				//GModel_ValidArray();
				//GModel_CacheData();
				//GModel_MemInterface();
				GModel_DMem();
			#1;
				check();
				//$display($time,"in = 0");
			
pkt_sent2.dr2	= execute_ports.dr;				
pkt_sent2.bypass_alu_1 = cachedata_ports.bypass_alu_1;
pkt_sent2.bypass_alu_2 = cachedata_ports.bypass_alu_2;
pkt_sent2.bypass_mem_1 = cachedata_ports.bypass_mem_1;
pkt_sent2.bypass_mem_2 = cachedata_ports.bypass_mem_2;
pkt_sent2.W_control_in = execute_ports.W_control_in ;
pkt_sent2.NZP = cachedata_ports.NZP;
pkt_sent2.psr = writeback_ports.psr;
pkt_sent2.memout = memaccess_ports.memout;
pkt_sent2.M_Data	= execute_ports.M_Data;
pkt_sent2.sr1	= execute_ports.sr1;
pkt_sent2.sr2	= execute_ports.sr2;
pkt_sent2.Mem_control_in = execute_ports.Mem_control_in;
pkt_sent2.enable_updatePC	= fetch_ports.enable_updatePC;
pkt_sent2.taddr			= fetch_ports.taddr	    ;
pkt_sent2.br_taken 		= fetch_ports.br_taken      ;
pkt_sent2.enable_fetch		= fetch_ports.enable_fetch  ;
pkt_sent2.npc_in	= decode_ports.npc_in;
pkt_sent2.dout		= decode_ports.dout  ;
pkt_sent2.enable_decode	= decode_ports.enable_decode;
pkt_sent2.enable_execute= execute_ports.enable_execute;
pkt_sent2.Mem_Bypass_Val= execute_ports.Mem_Bypass_Val;
pkt_sent2.IR = execute_ports.IR;
pkt_sent2.vsr1  = execute_ports.VSR1;
pkt_sent2.vsr2  = execute_ports.VSR2;
pkt_sent2.W_control_out  = writeback_ports.W_control_out;
pkt_sent2.enable_writeback = writeback_ports.enable_writeback;
pkt_sent2.aluout = writeback_ports.aluout;
pkt_sent2.pcout  = writeback_ports.pcout;
pkt_sent2.E_Control = execute_ports.E_Control;
pkt_sent2.mem_state = memaccess_ports.mem_state;
pkt_sent2.M_Control = memaccess_ports.M_Control;
pkt_sent2.M_Addr    = memaccess_ports.M_Addr   ;
pkt_sent2.IR_Exec    = control_ports.IR_Exec   ;
pkt_sent2.complete_data = control_ports.complete_data;
pkt_sent2.dr_in	= writeback_ports.DR_in ;




 //procinterface inputs
pkt_sent2.rd		= procinterface_ports.rd    ;
pkt_sent2.addr		= procinterface_ports.addr  ;
pkt_sent2.state		= procinterface_ports.state ;
pkt_sent2.miss		= procinterface_ports.miss  ;
pkt_sent2.blockdata	= procinterface_ports.blockdata;
pkt_sent2.RAMdata	= procinterface_ports.data;
 
 //validarray inputs
pkt_sent2.index		= validarray_ports.index;
 
  //cachedata inputs
pkt_sent2.din		= cachedata_ports.din   ;
pkt_sent2.count		= cachedata_ports.count ;
pkt_sent2.valid		= cachedata_ports.valid ;
pkt_sent2.offdata	= cachedata_ports.offdata;
pkt_sent2.ramrd		= cachedata_ports.ramrd;

 //meminterface inputs
 
 //cachecontroller inputs
pkt_sent2.macc		= cachecontroller_ports.macc  ;
pkt_sent2.rrdy2		= cachecontroller_ports.rrdy ;
pkt_sent2.rdrdy2	= cachecontroller_ports.rdrdy;
pkt_sent2.wacpt2	= cachecontroller_ports.wacpt;

	   			
		end
		
	join_none
	$display ($time, "[SCOREBOARD] Forking of Process Finished");

endtask


parameter reg_wd = 16;

task Scoreboard::check();

		LC3_arithmetic.sample();
		bypasses.sample();
		LC3_inputs.sample();
		cache_inputs.sample();
		
		coverage_value1 = 	LC3_arithmetic.get_coverage();
		coverage_value2 = 	bypasses.get_coverage();
		coverage_value3 = 	LC3_inputs.get_coverage();
		coverage_value4 = 	cache_inputs.get_coverage();
		
//		$display ($time, "			[SCOREBOARD -> COVERAGE] Coverage Result for cover 1 At present = %d", coverage_value1);
//		$display ($time, "			[SCOREBOARD -> COVERAGE] Coverage Result for cover 2 At present = %d", coverage_value2);
//		$display ($time, "			[SCOREBOARD -> COVERAGE] Coverage Result for cover 3 At present = %d", coverage_value3);
//		$display ($time, "			[SCOREBOARD -> COVERAGE] Coverage Result for cover 4 At present = %d", coverage_value4);


//		$display ($time, "\n[CHECK] Checker - Begin new check");
//$display("\n");
/*****************************************************************************************************************************************************/
	// CACHE_CONTROLLER TESTING
//	$display($time,"[CTRL inputs]		reset=%h,macc=%h, miss=%h, rd=%h, wacpt=%h, rdrdy=%h, rrdy=%h",reset_ctl,macc_ctl,miss_ctl,rd_ctl,wacpt_ctl,rdrdy_ctl,rrdy_ctl);
//	$display($time,"[CTRL output]		state=%h, count=%h",cachecontroller_ports.state,cachecontroller_ports.count);

//		if(state_g !== cachecontroller_ports.state) $display("\n%d  [ERROR_CONTROLLER] Expected state = %h Observed state = %h\n",$time,state_g, cachecontroller_ports.state);
//		if(count_g !== cachecontroller_ports.count) $display("\n%d  [ERROR_CONTROLLER] Expected count = %h Observed count = %h\n",$time,count_g, cachecontroller_ports.count);
/*****************************************************************************************************************************************************/
	// PROC_INTERFACE TESTING
//	$display($time,"[PROC_INTERFACE inputs]	 rd = %h, addr = %h, blockdata = %h, miss = %h, state = %h",rd_proc,addr_proc,blockdata_proc,miss_proc,state_proc);
//	$display($time,"[PROC_INTERFACE output]	 complete = %h, dout = %h",procinterface_ports.complete,procinterface_ports.dout);

//		if(complete_g!==procinterface_ports.complete) $display("\n%d  [ERROR_PROC_INTERFACE] Expected complete = %4h ; Observed complete = %h\n", $time, complete_g ,procinterface_ports.complete);
//		if(dout_g!==procinterface_ports.dout) $display("\n%d  [ERROR_PROC_INTERFACE] Expected dout = %4h ; Observed dout = %h\n", $time, dout_g ,procinterface_ports.dout);
/*****************************************************************************************************************************************************/
	// VALID_ARRAY TESTING
//	$display($time,"[VALID_ARRAY inputs] reset = %h index = %h state = %h ",reset_val,index_val,state_val);
//	$display($time,"[VALID_ARRAY output] valid = %h",validarray_ports.valid);

//		if(valid_g!==validarray_ports.valid && in)  $display("\n%d  [ERROR_VALID_ARRAY] Expected valid = %4h ; Observed valid = %h\n", $time,valid_g ,validarray_ports.valid);
/*****************************************************************************************************************************************************/
	// CACHE_DATA TESTING
//	$display($time,"[CACHE_DATA inputs] rd = %h, addr = %h, din = %h, count = %h, state = %h, valid = %h, offdata = %h",rd_cdata,addr_cdata,din_cdata,count_cdata,state_cdata,valid_cdata,offdata_cdata);
//	$display($time,"[CACHE_DATA output] miss = %h, blockdata =%h, ramrd = %h, blocksel0 = %h, blocksel1 = %h, blocksel2 = %h, blocksel3 = %h, block offset= %h",cachedata_ports.miss,cachedata_ports.blockdata, cachedata_ports.ramrd,blocksel0,blocksel1,blocksel2,blocksel3,addr_cdata[1:0]);

//		if(miss_g!==cachedata_ports.miss)  $display("\n%d  [ERROR_CACHE_DATA Expected miss = %h ; Observed miss = %h\n",$time, miss_g ,cachedata_ports.miss); 
//		if(blockdata_g!==cachedata_ports.blockdata)  $display("\n%d  [ERROR_CACHE_DATA Expected blockdata   = %h ; Observed blockdata  = %h\n",$time,blockdata_g,cachedata_ports.blockdata);
//		if(ramrd!==cachedata_ports.ramrd)$display("\n%d  [ERROR_CACHE_DATA Expected ramrd = %h ; Observed ramrd  = %h\n",$time,ramrd,cachedata_ports.ramrd);
//		if(ramdata!==cachedata_ports.memdata)$display("\n%d  [ERROR_CACHE_DATA Expected ramdata = %h ; Observed ramdata  = %h\n",$time,ramdata,cachedata_ports.memdata);
		
//		if(block0!==cachedata_ports.blockreg[15:0] ) // begin if(state_cdata==5) $display("\n************* BUG 7 **************\n%d\t\t din is written to block0 rather than blockdata when in state 5 -> blocksel0 may be incorrect (i.e. wrong MUX select line",$time);
//			$display("%d  [CACHE_DATA_ERROR Expected block0 = 16'h%h/16'b%b ; Observed block0 = 16'h%h/16'b%b",$time,block0,block0,cachedata_ports.blockreg[15:0],cachedata_ports.blockreg[15:0]);
//			if(state_cdata==5) $display("****************************************\n");
//		end
//		if(block1!==cachedata_ports.blockreg[31:16]) // begin if(state_cdata==5) $display("\n************* BUG 7 **************\n%d\t\t din is written to block1 rather than blockdata when in state 5 -> blocksel1 may be incorrect (i.e. wrong MUX select line",$time);
//			$display("%d  [CACHE_DATA_ERROR Expected block1 = 16'h%h/16'b%b ; Observed block1 = 16'h%h/16'b%b",$time,block1,block1,cachedata_ports.blockreg[31:16],cachedata_ports.blockreg[31:16]);
//			if(state_cdata==5) $display("****************************************\n");
//		end
//		if(block2!==cachedata_ports.blockreg[47:32]) // begin if(state_cdata==5) $display("\n************* BUG 7 **************\n%d\t\t	din is written to block2 rather than blockdata when in state 5 -> blocksel2 may be incorrect (i.e. wrong MUX select line",$time);
//			$display("%d  [CACHE_DATA_ERROR Expected block2 = 16'h%h/16'b%b ; Observed block2 = 16'h%h/16'b%b",$time,block2,block2,cachedata_ports.blockreg[47:32],cachedata_ports.blockreg[47:32]);
//			if(state_cdata==5) $display("****************************************\n");
//		end
//		if(block3!==cachedata_ports.blockreg[63:48]) // begin if(state_cdata==5) $display("\n************* BUG 7 **************\n%d\t\t	din is written to block3 rather than blockdata when in state 5 -> blocksel3 may be incorrect (i.e. wrong MUX select line",$time);
//			$display("%d  [CACHE_DATA_ERROR Expected block3 = 16'h%h/16'b%b ; Observed block3 = 16'h%h/16'b%b",$time,block3,block3,cachedata_ports.blockreg[63:48],cachedata_ports.blockreg[63:48]);
//			if(state_cdata==5) $display("****************************************\n");
//		end	
/*****************************************************************************************************************************************************/
	// MEM_INTERFACE TESTING
//if(state_mem==4)       $display($time,"[MEM_INTERFACE inputs] state = %h, addr = %h, din = %h, miss = %h",state_mem,addr_mem,din_mem,miss_mem);
//if(state_mem==4)       $display($time,"[MEM_INTERFACE output] rrqst = %h, rdacpt = %h, wrqst = %h, offdata = %h",meminterface_ports.rrqst,meminterface_ports.rdacpt,meminterface_ports.wrqst,meminterface_ports.offdata);

//		if(rrqst_g!==meminterface_ports.rrqst)  $display("\n%d  [ERROR_MEM_INTERFACE] Expected rrqst = %h ; Observed rrqst = %h\n",$time,rrqst_g,meminterface_ports.rrqst);
//		if(rdacpt_g!==meminterface_ports.rdacpt)  $display("\n%d  [ERROR_MEM_INTERFACE] Expected rdacpt = %h ; Observed rdacpt = %h\n",$time,rdacpt_g,meminterface_ports.rdacpt);
//		if(wrqst_g!==meminterface_ports.wrqst)  $display("\n%d  [ERROR_MEM_INTERFACE] Expected wrqst = %h ; Observed wrqst = %h\n",$time,wrqst_g,meminterface_ports.wrqst);
//		if(offdata_g!==meminterface_ports.offdata) $display("\n%d[ERROR_MEM_INTERFACE] Expected offdata = %h, Observed offdata = %h\n",$time,offdata_g,meminterface_ports.offdata);
/*****************************************************************************************************************************************************/	

endtask

				
task Scoreboard::GModel_CacheController();
	
	if(in) begin
		reset_ctl = cachecontroller_ports.reset;
		macc_ctl = cachecontroller_ports.macc;
		miss_ctl = cachecontroller_ports.miss;
		rd_ctl = cachecontroller_ports.rd;
	      wacpt_ctl = cachecontroller_ports.wacpt;
	      rdrdy_ctl = cachecontroller_ports.rdrdy;
	      rrdy_ctl = cachecontroller_ports.rrdy;
//		 wacpt_ctl = wacpt;
//		 rdrdy_ctl = rdrdy;
//		 rrdy_ctl = rrdy;
	end
	else begin
		if(reset_ctl || !macc_ctl) begin
			count_g = 0;
			state_g = 0;
		end
		else begin
			case(state_g)
			0: begin
				count_g = 0;
				if(rd_ctl) begin
					if(~miss_ctl) 	state_g = 0;
					else		state_g = 1;
				end
				else	state_g = 4;
			end
			1: begin
				if(rrdy_ctl)	state_g = 2;
				else		state_g = 1;
			end      
			2: begin
				if(rdrdy_ctl) begin
					count_g++;
					state_g = 3;
				end	
				else	state_g = 2;
			end
			3: begin
				if(rdrdy_ctl)	state_g = 3;
				else begin
					if(count_g[1:0]==0)
						state_g = 8;
					else	state_g = 2;
				end
			end
			4: begin
				if(wacpt_ctl)	state_g = 5;
				else		state_g = 4;
			end      
			5: begin
				if(wacpt_ctl)	state_g = 5;
				else 		state_g = 6;
			end      
			6: begin
				if(wacpt_ctl)	state_g = 7;
				else		state_g = 6;
			end
			7: begin
				if(wacpt_ctl)	state_g = 7;
				else begin	
					if(miss_ctl)	state_g = 2;
					else		state_g = 8;
				end
			end      
			8: state_g = 0;
			default:  $display("Wrong State");
			
			endcase 
		end
	end
endtask

task Scoreboard::GModel_ProcInterface();
	
	if(in) begin
		rd_proc = procinterface_ports.rd;
		addr_proc = procinterface_ports.addr;
		blockdata_proc = procinterface_ports.blockdata;
		miss_proc = procinterface_ports.miss;
		state_proc = procinterface_ports.state;
	end
	 else begin
	
		
		if((state_proc==0 && miss_proc==0 && rd_proc==1) || state_proc==8)
		 	complete_g=1;
		else	complete_g =0;
		
		if(rd_proc && complete_g)
			case(addr_proc[1:0])
			2'd0: dout_g=blockdata_proc[15:0];
			2'd1: dout_g=blockdata_proc[31:16];
			2'd2: dout_g=blockdata_proc[47:32];
			2'd3: dout_g=blockdata_proc[63:48];
			endcase
				
	end
endtask
	
task Scoreboard::GModel_ValidArray();
	
	if(in) begin
		reset_val = validarray_ports.reset;
		index_val = validarray_ports.index;
		state_val = validarray_ports.state;
		//validarray_val = validarray_ports.validarr;	
	//end
	//else begin
		if(reset_val == 1)
			temp_va = 0;
		else begin
			if(state_val==8)
				temp_va[index_val] = 1'b1;
			else
				temp_va = temp_va;
			valid_g = temp_va[index_val];	
		end
	end
endtask	
	
task Scoreboard::GModel_CacheData();
logic [1:0] temp_sel;
	
	
	if(in) begin
	
		din_cdata = cachedata_ports.din;
		rd_cdata = cachedata_ports.rd;
		addr_cdata = cachedata_ports.addr;
		count_cdata = cachedata_ports.count;
		state_cdata = cachedata_ports.state;
		valid_cdata = cachedata_ports.valid;
		offdata_cdata = cachedata_ports.offdata;
		
		//ramrd = (state_cdata==3 || (state_cdata==5 && addr_cdata[15:6]==ramdata[73:64]))? 0:1;
		
   	        
		
	//$display($time," count = %h , blockdata = %h , in = 1",cachedata_ports.count,cachedata_ports.blockdata);	
		
	//end
	//else begin
	//$display($time," count = %h , blockdata = %h , in = 0",cachedata_ports.count,cachedata_ports.blockdata);	
	temp_sel = cachedata_ports.count;// + cachedata_ports.addr[1:0];

      if(state_cdata==4)
        case(cachedata_ports.addr[1:0])
	  0:  blocksel0 = 1;
	  1:  blocksel1 = 1;
	  2:  blocksel2 = 1;
	  3:  blocksel3 = 1;
	endcase
      else if(state_cdata==2)
        case(temp_sel)
	  0:  blocksel0 = 0;
	  1:  blocksel1 = 0;
	  2:  blocksel2 = 0;
	  3:  blocksel3 = 0;
	endcase

      else
        begin
	  blocksel0 = 2;
	  blocksel1 = 2;
	  blocksel2 = 2;
	  blocksel3 = 2;
	end

	if(ramrd==1) ramdata = memarray[cachedata_ports.addr[1:0]];
	
	 
      case(blocksel0)
       0:  block0 =offdata_cdata;	  //$display ("1 happend") ;end
       1:  block0 = din_cdata;  	  //$display ("2 happend") ;end
       2:  block0 = state_cdata ==4 ? blockdata_g[15:0] : block0;   //$display ("3 happend") ;end
       default:  block0 = block0;		//$display ("4 happend") ;end
     endcase
   
     case(blocksel1)
       0:  block1 = offdata_cdata;  
       1:  block1 = din_cdata;
       2:  block1 =  state_cdata ==4 ? blockdata_g[31:16]: block1;
       default:  block1 = block1;
     endcase
   
     case(blocksel2)
       0:  block2 =  offdata_cdata;  
       1:  block2 = din_cdata;
       2:  block2 =  state_cdata ==4 ? blockdata_g[47:32]: block2;
       default:  block2 = block2;
     endcase
   
     case(blocksel3)
       0:  block3 = offdata_cdata ;   
       1:  block3 = din_cdata;
       2:  block3 = state_cdata ==4 ? blockdata_g[63:48]: block3;
       default:  block3 = block3;

       endcase
       
       
       end
       else begin
        state_cdata = cachedata_ports.state;
	
	ramrd = (state_cdata==3 || (state_cdata==5 && miss_g==0))? 0:1;
	blockdata_g = cachedata_ports.ramrd ? memarray[cachedata_ports.addr[5:2]] : {block3, block2, block1, block0};  
	if(ramrd==0) memarray[cachedata_ports.addr[5:2]]={addr_cdata[15:6], block3, block2, block1, block0};  
	miss_g = (cachedata_ports.valid==1 && (cachedata_ports.addr[15:6] == memarray[cachedata_ports.addr[5:2]][73:64]))? 0:1;
	

/*
if({block3, block2, block1, block0} !== cachedata_ports.blockreg)  begin
$display($time,"-------------------------------------   BUG   ----------------------------------------");
$display($time, " Expected blockreg = %h , Observed blockreg = %h   , state = %h  , offset =%h",{block3, block2, block1, block0},
cachedata_ports.blockreg , state_cdata , cachedata_ports.addr[1:0]);
$display($time,"------------------------------------------------------------------------------------------");
//end
//else 
//$display($time, " Expected blockreg = Observed blockreg = %h   , state = %h ",{block3, block2, block1, block0}, state_cdata);
*/
     end

endtask

task Scoreboard::GModel_MemInterface();
	
	if(!in) begin
		state_mem = meminterface_ports.state;
		addr_mem = meminterface_ports.addr;
		din_mem = meminterface_ports.din;
		miss_mem = meminterface_ports.miss;
		
		case(state_mem)
			0: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=0; end
			1: begin 
				rrqst_g=1; rdacpt_g=0; wrqst_g=0; end
			2: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=0; end
			3: begin 
				rrqst_g=0; rdacpt_g=1; wrqst_g=0; end
			4: begin 
				rrqst_g=(miss_mem)? 1:0;
				rdacpt_g=0; wrqst_g=1; end
			5: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=0; end
			6: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=1; end
			7: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=0; end
			default: begin 
				rrqst_g=0; rdacpt_g=0; wrqst_g=0; end
			endcase
		
		if(rrqst_g==0)
			if(wrqst_g==0)
				offdata_g = 16'hz;
			else	if(state_mem==6)	offdata_g = din_mem;
				else	offdata_g = addr_mem;
		else 
			offdata_g = addr_mem;
		
/*		case({rrqst_g,wrqst_g})
			0: offdata_g=16'hz;
			1: if(state_mem==6) offdata_g=din_mem;
				else offdata_g=addr_mem;
			2: offdata_g=addr_mem;
			3: offdata_g=addr_mem;
		endcase
*/		
	end
endtask

task Scoreboard::GModel_DMem();

//  	input rrqst, rdacpt, wrqst;
//  	output rrdy, rdrdy, wacpt;
//  	inout [15:0] data;
//  	input reset;
//  	reg rrdy, rdrdy, wacpt;


rrqst = meminterface_ports.rrqst;
rdacpt = meminterface_ports.rdacpt;
wrqst = meminterface_ports.wrqst;

fork	// controller
    if(reset)
   	begin 
		count=0;
		state=0;
   	end
    else
    begin
      	case(state) 
        	0: 	begin
	        	case({rrqst,wrqst})
		    		3: // write miss
		      		begin
//	 					#`handshake2   
	 					readaddr=data;
	 					flag=1;
	 					state=4;
		      		end
		    		2: // read miss
		      		begin	
//	 					#`handshake2	
	 					readaddr=data;
	 					flag=0;
	 					state=1;
		      		end
		   			1: // write hit
		      		begin
//	 					#`handshake2	
	 					readaddr=data;
	 					flag=0;
		 				state=4;
		      		end
		   			0: 
		   			begin
						readaddr=readaddr;
						flag=0;
						state=0;
	              	end
         		endcase
         	end 
			1: begin
				if(rrqst==0) begin
// 					#`handshake2   
 					state=2;
 				end
	   			else begin
	    			state=1;
	    		end
	    	end
			2: begin
// 				#(`mem_latency-`handshake2) 
 				state=3;
 			end
			3: begin
				if(rdacpt)
	  			begin
	     			if(count!=3)begin
 //						#`handshake2	
 						state=7;
           			end
	     			else begin
// 						#`handshake2	
 						state=0;
						debug=5;
           			end
         			count = count+1;
	 			end
	   			else begin
	      			state=3;
            	end
            end
			4: begin
				if(wrqst==0) begin
//					#`handshake2    
					state=5;
				end
	  			else begin 
	  				state=4;
	  			end
	  		end
			5: begin 
				if(wrqst) begin
// 					#`handshake2	
 					storedata=meminterface_ports.offdata;
    				state=6;
	    		end
	   			else begin
	     			state=5;
	     		end
	     	end
			6: begin 
				if(wrqst==0) begin
 	     			if(flag) begin
// 						#(`mem_latency-`handshake2-`handshake2-`handshake2) 	
 						state=3;
 					end
	     			else begin
//						#`handshake2 	
 						state=0;
 					end
 				end
           		else begin
						state=6;
				end
			end
			7: begin
             	if(rdacpt==0)begin 
// 					#`handshake2 	
 					state=3;
 				end
          		else begin
					state=7;
				end
	   		end	
     	endcase
	end

 	case(state)
     	0: begin
			rrdy=0;
	  		rdrdy=0;
	  		wacpt=0;
      	end
     	1: begin
			rrdy=1;
		  	rdrdy=0;
		  	wacpt=0;
      	end
     	3: begin
			rdrdy=1;
	  		rrdy=0;
	  		wacpt=0;
		end
     	4: begin
			rrdy=0;
	  		rdrdy=0;
	  		wacpt=1;
       	end
     	6: begin
			rrdy=0;
	  		rdrdy=0;
	  		wacpt=1;
	  		ram[readaddr]=storedata;
		end
     	default: begin
			rrdy=0;
	  		rdrdy=0;
	  		wacpt=0;
		end
   	endcase
         
	 
	if (state == 3)
	begin 
	 address = {readaddr[15:2],count};
	 if (q.find with (item == address))
		data	=	ram[address] ;
		else
		begin
			data = $urandom_range(0,16'hffff);
//			if(pkt_sent.pkt_cnt>0 && pkt_sent.pkt_cnt<50) data = 16'haaaa;
//			if(pkt_sent.pkt_cnt>=50 && pkt_sent.pkt_cnt<100) data = 16'h5555;
			ram[address] = data;
		end
	end		
	data=(state==3)? data : 16'hz;
join_none
	pkt1.data = data;
	pkt1.rrdy = rrdy;
	pkt1.rdrdy = rdrdy;
	pkt1.wacpt = wacpt;
	s2d_out_box.put(pkt1);
	
//	if (rrdy !== rrdy_ctl ) $display($time,"[MEM_ERROR] Expected rrdy = %h   ,  observed rrdy = %h  , mystate = %h",
//	rrdy_ctl , rrdy, state); 
//	if (rdrdy !== rdrdy_ctl ) $display($time,"[MEM_ERROR] Expected rdrdy = %h   ,  observed rdrdy = %h  , mystate = %h",
//	rdrdy_ctl , rdrdy, state);
//	if (wacpt !== wacpt_ctl ) $display($time,"[MEM_ERROR] Expected wacpt = %h   ,  observed wacpt = %h  , mystate = %h",
//	wacpt_ctl , wacpt, state);
	
	
	
	q.push_back(address);
endtask
