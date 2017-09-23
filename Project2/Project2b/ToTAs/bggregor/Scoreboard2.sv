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
	//  ProcInterface Golden Model Variables
	
	
	// ValidArray Golden Model Variables
logic [0:0]	valid_g;
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
	//  CacheData Golden Model Variables
	
	
	//  MemInterface Golden Model Variables
logic [0:0]	rrqst_g, rdacpt_g, wrqst_g;

logic [0:0]	miss_mem, rrqst_mem, rdacpt_mem, wrqst_mem;
logic [15:0]	addr_mem, din_mem, offdata_mem;
	//  MemInterface Golden Model Variables
	
	
	int in;
	
	
	
		
	string   name;			// unique identifier
	Packet pkt1 = new();
	Packet pkt_sent = new();	// Packet object from Driver
	OutputPacket   pkt2cmp = new();		// Packet object from Receiver
  	virtual CacheController_Probe_if cachecontroller_ports ;
	virtual ProcInterface_Probe_if procinterface_ports;
	virtual ValidArray_Probe_if validarray_ports;
	virtual CacheData_Probe_if cachedata_ports;
	virtual MemInterface_Probe_if meminterface_ports;
	
	
	typedef mailbox #(Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers

  	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	
	typedef mailbox #(Packet) s2d_box_type;
  	s2d_box_type 	s2d_out_box;		// mailbox for Packet objects To Driver
	
	extern function new(string name = "Scoreboard", virtual CacheController_Probe_if cachecontroller_ports , virtual
	ProcInterface_Probe_if procinterface_ports, virtual ValidArray_Probe_if validarray_ports, virtual CacheData_Probe_if
	cachedata_ports, virtual MemInterface_Probe_if meminterface_ports);
		
	extern virtual task start();
	extern virtual task check();
	extern virtual task GModel_CacheController();
	extern virtual task GModel_ProcInterface();
	extern virtual task GModel_ValidArray();
	extern virtual task GModel_CacheData();
	extern virtual task GModel_MemInterface();
endclass

function Scoreboard::new(string name, virtual CacheController_Probe_if cachecontroller_ports , virtual ProcInterface_Probe_if
procinterface_ports, virtual ValidArray_Probe_if validarray_ports, virtual CacheData_Probe_if cachedata_ports, virtual
MemInterface_Probe_if meminterface_ports );
	this.s2d_out_box = new;
	this.name = name;
	this.cachecontroller_ports	= cachecontroller_ports;//PROBECHANGE
	this.procinterface_ports	= procinterface_ports;
	this.validarray_ports		= validarray_ports;
	this.cachedata_ports		= cachedata_ports;
	this.meminterface_ports		= meminterface_ports;
	
	if (driver_mbox == null) 
		driver_mbox = new();
	if (receiver_mbox == null) 
		receiver_mbox = new();
	this.driver_mbox = driver_mbox;
	this.receiver_mbox = receiver_mbox;
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
	
	check(); 
	//#5;
		forever 
		begin	
			//if(receiver_mbox.try_get(pkt2cmp))
			// begin
	//			$display ($time, "[SCOREBOARD] Grabbing Data From both Driver and Receiver");

				in=1;
				GModel_CacheController();
				GModel_ProcInterface();
				GModel_ValidArray();
				GModel_CacheData();
				GModel_MemInterface();
				check();
								
				in=0;
			
			//#2;
				receiver_mbox.get(pkt2cmp);
				//driver_mbox.get(pkt_sent);
			#1;			
				GModel_CacheController();
				GModel_ProcInterface();
				GModel_ValidArray();
				GModel_CacheData();
				GModel_MemInterface();
				
				check();
			#1;
				
			//end
			//else begin
			//	#1;
			//end
		end
		
	join_none
	$display ($time, "[SCOREBOARD] Forking of Process Finished");
endtask


parameter reg_wd = 16;

task Scoreboard::check();

//		$display ($time, "\n[CHECK] Checker - Begin new check");
/*****************************************************************************************************************************************************/
	// CACHE_CONTROLLER TESTING
//	$display($time,"[CTRL inputs]		reset=%h,macc=%h, miss=%h, rd=%h, wacpt=%h, rdrdy=%h, rrdy=%h",reset_ctl,macc_ctl,miss_ctl,rd_ctl,wacpt_ctl,rdrdy_ctl);
//	$display($time,"[CTRL output]		state=%h, count=%h",state,count);

//		if(state_g !== state) $display("\n%d  [ERROR_CONTROLLER] Expected state = %h Observed state = %h\n",$time,state_g, state_ctl);
//		if(count_g !== count) $display("\n%d  [ERROR_CONTROLLER] Expected count = %h Observed count = %h\n",$time,count_g, count_ctl);
//*****************************************************************************************************************************************************/
	// PROC_INTERFACE TESTING
//	$display($time,"[PROC_INTERFACE inputs]	 rd = %h, addr = %h, blockdata = %h, miss = %h, state = %h",rd_proc,addr_proc,blockdata_proc,miss_proc,state_proc);
//	$display($time,"[PROC_INTERFACE output]	 complete = %h, dout = %h , state = %h", procinterface_ports.complete,
//	procinterface_ports.dout,procinterface_ports.state);

//if(complete_g!==procinterface_ports.complete) $display("\n%d  [ERROR_PROC_INTERFACE] Expected complete = %4h ; Observed complete = %h\n", $time, complete_g ,procinterface_ports.complete);
//if(dout_g!==procinterface_ports.dout) $display("\n%d  [ERROR_PROC_INTERFACE] Expected dout = %4h ; Observed dout = %h\n",
//$time, dout_g, procinterface_ports.dout );

/*****************************************************************************************************************************************************/
	// VALID_ARRAY TESTING
	$display($time,"[VALID_ARRAY inputs] reset = %h index = %h state = %h ",reset_val,index_val,state_val);
	$display($time,"[VALID_ARRAY output] valid = %h",validarray_ports.valid);

		if(valid_g!==validarray_ports.valid && in)  $display("\n%d  [VALID_ARRAY] Expected valid = %4h ; Observed valid = %h\n", $time,valid_g ,validarray_ports.valid);
//*****************************************************************************************************************************************************/
	// CACHE_DATA TESTING
//     $display($time,"[CACHE_DATA inputs] rd = %h, addr = %h, din = %h, count = %h, state = %h, valid = %h, offdata = %h",rd_cdata,addr_cdata,din_cdata,count_cdata,state_cdata,valid_cdata,offdata_cdata);
//     $display($time,"[CACHE_DATA output] miss = %h, blockdata =%h",miss,blockdata)

//		if(miss!=miss_g)  $display("\n%d  [CACHE_DATA Expected miss = %h ; Observed miss = %h\n",$time, miss_g ,miss; 
//		if(blockdata_g!==blockdata)  $display("\n%d  [CACHE_DATA Expected blockdata   = %h ; Observed blockdata  = %h\n",$time,blockdata_g,blockdata);

//*****************************************************************************************************************************************************/
	// MEM_INTERFACE TESTING
//	$display($time,"[MEM_INTERFACE inputs] state = %h, addr = %h, din = %h, miss = %h",state_mem,addr_mem,din_mem,miss_mem);
//	$display($time,"[MEM_INTERFACE output] rrqst = %h, rdacpt = %h, wrqst = %h, offdata = %h",rrpst,rdacpt,wrqst,offdata);

//		if(rrqst_g!==rrqst)  $display("\n%d  [MEM_INTERFACE Expected rrqst = %h ; Observed rrqst = %h\n",$time,rrqst_g,rrqst);
//		if(rdacpt_g!==rdacpt)  $display("\n%d  [MEM_INTERFACE Expected rdacpt = %h ; Observed rdacpt = %h\n",$time,rdacpt_g,rdacpt);
//		if(wrqst_g!==wrqst])  $display("\n%d  [MEM_INTERFACE Expected wrqst = %h ; Observed wrqst = %h\n",$time,wrqst_g,wrqst);
//		if(offdata_g!==offdata) $display("\n%dMEM_INTERFACE Expected offdata = %h, Observed offdata = %h\n",$time,offdata_g,offdata);
	
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
	end
	else begin
		
		
	end
endtask

task Scoreboard::GModel_ProcInterface();
	
	if(in) begin
	
 rd_proc =	 procinterface_ports.rd;
 miss_proc = 	 procinterface_ports.miss;
 addr_proc= 	 procinterface_ports.addr;
 blockdata_proc= procinterface_ports.blockdata;
 state_proc= 	 procinterface_ports.state;
		
	end
	else begin

      if(rd_proc && complete_g)
      case(addr_proc[1:0])
        2'd0: dout_g=blockdata_proc[15:0];
	2'd1: dout_g=blockdata_proc[31:16];
	2'd2: dout_g=blockdata_proc[47:32];
	2'd3: dout_g=blockdata_proc[63:48];
      endcase

 
    if((state_proc==0 && miss_proc==0 && rd_proc==1) || state_proc==8)
      complete_g=1;
    else
      complete_g =0;


		
	end
endtask
	
task Scoreboard::GModel_ValidArray();
	
	if(in) begin
	
	reset_val = validarray_ports.reset;
	index_val = validarray_ports.index;
	state_val = validarray_ports.state;		
	end
	else begin
	
	if(reset_val == 1)
	
          temp_va = 16'b0;
	  
        else
         begin
	  if(state_val==4'b1000)
	    temp_va[index_val] = 1'b1;
	  else
	    temp_va = temp_va;
	  
	  
	    valid_g = temp_va[index_val];	
         end
  
 
		
	end
endtask	
	
task Scoreboard::GModel_CacheData();
	
	if(in) begin
		rd_cdata    = cachedata_ports.rd;
		addr_cdata  = cachedata_ports.addr;
		count_cdata = cachedata_ports.count;
		state_cdata = cachedata_ports.state;
		valid_cdata = cachedata_ports.valid;
		offdata_cdata = cachedata_ports.offdata;		
		
	end
	else begin
		
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	end
endtask

task Scoreboard::GModel_MemInterface();
	
	if(in) begin
		
		
	end
	else begin
		
		
	end
endtask
