`include "data_defs.vp"

interface LC3_io(input bit clock);
//  	parameter   16    	=   16;

	logic			reset;
	logic			complete_data, complete_instr;
	logic			IMem_rd, DMem_rd;
	logic	[16-1:0]    Instr_dout;
	logic	[16-1:0]    Data_dout, DMem_dout;
	logic	[16-1:0]    IMem_din, DMem_din;
	logic	[16-1:0]    DMem_addr;
	logic	[16-1:0]    PC;
	logic	[0:0]   	rrdy;
	logic	[0:0]	        rdrdy;
	logic	[0:0]	        wacpt;
	logic	[0:0]	        rrqst;
	logic	[0:0]	        rdacpt;
	logic	[0:0]	        wrqst;
	logic	[15:0]	        offdata;
	
 	clocking cb @(posedge clock);
    	default input #1 output #1;
		
		output reset;
		output complete_instr;
		output Instr_dout;
		input  PC;
		input  IMem_rd;
		input  IMem_din;
		
		output rrdy;
		output rdrdy;
		output wacpt;
		input  rrqst;
		input  rdacpt;
		input  wrqst;
		inout  offdata;
		
		/*output reset;
		output complete_data;
		output complete_instr;
		output DMem_dout;
		output Data_dout;
		output Instr_dout;
		input  PC;
		input  IMem_rd;
		input  IMem_din;
		input  DMem_din;
		input  DMem_rd;
		input  DMem_addr;*/

  	endclocking

	modport TB(clocking cb); // test1
endinterface


interface Cache_Probe_if(		input 	logic	[0:0]	rrdy,
					input 	logic	[0:0]	rdrdy,
					input 	logic	[0:0]	wacpt,
					input 	logic	[0:0]	rrqst,
					input 	logic	[0:0]	rdacpt,
					input 	logic	[0:0]	wrqst,
					input 	logic	[15:0]	offdata,
					
					
					output 	logic	[0:0]	macc,
					output 	logic	[0:0]	rd,
					output 	logic	[15:0]	addr,
					output 	logic	[15:0]	din,
					input 	logic	[15:0]	dout,
					input 	logic	[0:0]	complete
					
);
endinterface


interface CacheController_Probe_if(	input 	logic  	[0:0]	reset,
					input 	logic	[0:0]	macc,
					input 	logic	[0:0]	miss,
					input 	logic	[0:0]	rd,
					input 	logic	[3:0]	state,
					input 	logic	[1:0]	count,
					input 	logic	[0:0]	rrdy,
					input 	logic	[0:0]	rdrdy,
					input 	logic	[0:0]	wacpt
	);
endinterface							

interface ProcInterface_Probe_if(	input 	logic	[0:0]	rd,
					input 	logic	[15:0]	addr,
					input 	logic	[15:0]	dout,
					input 	logic	[0:0]	complete,
					input 	logic	[3:0]	state,
					input 	logic	[0:0]	miss,
					input 	logic	[63:0]	blockdata,
					input 	logic	[73:0]	data
	);
endinterface							

interface ValidArray_Probe_if (		input 	logic	[0:0]	reset,
					input 	logic	[3:0]	index,
					input 	logic	[3:0]	state,
					input 	logic	[0:0]	valid,
					input	logic	[15:0]	validarr
	);
endinterface							

interface CacheData_Probe_if (		input 	logic	[0:0]	rd,
					input 	logic	[15:0]	addr,
					input 	logic	[15:0]	din,
					input 	logic	[1:0]	count,
					input 	logic	[3:0]	state,
					input 	logic	[0:0]	valid,
					input 	logic	[0:0]	miss,
					input 	logic	[63:0]	blockdata,
					input 	logic	[15:0]	offdata,
					input	logic	[0:0]	ramrd,
					input   logic	[73:0]  memdata,
					input	logic	[63:0]	blockreg,
					
					
					input	 logic	 [1:0]	W_control_out		,
				input	 logic	 [0:0]	Mem_control_out 	,
				input	 logic   [1:0]	 W_control_in		,
				input	 logic   [0:0]	 Mem_control_in 	,
				input	 logic   [16-1:0]	 aluout 		,
				input	 logic   [16-1:0]	 M_Data		,
				input	 logic   [2:0]  	 dr			,
				input	 logic   [2:0]  	 sr1			,
				input	 logic   [2:0]  	 sr2			,
				input	 logic   [16-1:0]	 Mem_Bypass_Val,
				input 	 logic	 [5:0]	E_Control,
				input	logic	[15:0]	IR,
				input	logic	[15:0]	VSR1,
				input	logic	[15:0]	VSR2,
				input	logic	[0:0]	bypass_alu_1,
				input	logic	[0:0]	bypass_alu_2,
				input	logic	[0:0]	bypass_mem_1,
				input	logic	[0:0]	bypass_mem_2,
				input	logic	[0:0]	enable_execute,
				input 	logic	[15:0]	npc_in,
				input 	logic	[0:0]	reset,
				input	logic	[15:0]	IR_Exec,
				input 	logic	[2:0]	NZP,
				input	logic	[15:0]	aluin1 , aluin2
					
	);
endinterface	
						

interface MemInterface_Probe_if(	input 	logic	[3:0]	state,
					input 	logic	[15:0]	addr,
					input 	logic	[15:0]	din,
					input 	logic	[0:0]	miss,
					input 	logic	[15:0]	offdata,
					input 	logic	[0:0]	wrqst,
					input 	logic	[0:0]	rdacpt,
					input 	logic	[0:0]	rrqst
	);
endinterface							


interface Fetch_Probe_if(	input 	logic	[16-1:0]	pc,
				input 	logic	[16-1:0]	npc_out,
				input 	logic	[0:0]		instrmem_rd,
				input 	logic	[0:0]		enable_updatePC  ,
				input	logic	[16-1:0]	taddr,
				input	logic	[0:0]		br_taken ,
				input	logic	[0:0]		enable_fetch,
				input	logic	[0:0]		reset
							);
endinterface							
interface Decode_Probe_if(							
				input	 logic	  [16-1:0]    IR		,
				input    logic	  [16-1:0]    npc_out		,
				input    logic	  [16-1:0]   	 npc_in		,
				input    logic	  [1:0]   W_Control		,
				input    logic	  [0:0]   Mem_Control		,
				input    logic	  [5:0]   E_Control	,
				input    logic    [16-1:0]    	dout,
				input	 logic	  [0:0]		enable_decode,
				input	 logic	  [0:0] reset	,
				input	 logic	  [0:0]  clock	
										
			);	
endinterface		
	
interface Execute_Probe_if(				
				input	 logic	 [1:0]	W_control_out		,
				input	 logic	 [0:0]	Mem_control_out 	,
				input	 logic   [1:0]	 W_control_in		,
				input	 logic   [0:0]	 Mem_control_in 	,
				input	 logic   [16-1:0]	 aluout 		,
				input	 logic   [16-1:0]	 M_Data		,
				input	 logic   [2:0]  	 dr			,
				input	 logic   [2:0]  	 sr1			,
				input	 logic   [2:0]  	 sr2			,
				input	 logic   [16-1:0]	 Mem_Bypass_Val,
				input 	 logic	 [5:0]	E_Control,
				input	logic	[15:0]	IR,
				input	logic	[15:0]	VSR1,
				input	logic	[15:0]	VSR2,
				input	logic	[0:0]	bypass_alu_1,
				input	logic	[0:0]	bypass_alu_2,
				input	logic	[0:0]	bypass_mem_1,
				input	logic	[0:0]	bypass_mem_2,
				input	logic	[0:0]	enable_execute,
				input 	logic	[15:0]	npc_in,
				input 	logic	[0:0]	reset,
				input	logic	[15:0]	IR_Exec,
				input 	logic	[2:0]	NZP,
				input	logic	[15:0]	aluin1 , aluin2
			);	
endinterface	
		
interface WriteBack_Probe_if (	
				input	 logic	      [16-1:0]    d1		,
				input	 logic	      [16-1:0]    d2		,
				input	 logic        [2:0]	  psr		,
				input	 logic        [16-1:0]    pcout 	,
				input	 logic        [16-1:0]    memout	,
				input	 logic		[15:0]	aluout,
				input	 logic        [16-1:0]    R0		,
				input	 logic        [16-1:0]    R1		,
				input	 logic        [16-1:0]    R2		,
				input	 logic        [16-1:0]    R3		,
				input	 logic        [16-1:0]    R4		,
				input	 logic        [16-1:0]    R5		,
				input	 logic	      [16-1:0]    R6		,
				input	 logic	      [16-1:0]    R7,
				input	logic		[1:0]	W_control_out,
				input	logic		[0:0]   enable_writeback,
				input 	logic		[15:0]	npc,
				input	logic		[2:0]	dr,
				input	logic		[2:0]	sr1,
				input	logic		[2:0]	sr2,
				input	logic		[0:0]	reset,
				input	logic	[15:0]	DR_in
				
			);
endinterface

interface Control_Probe_if (	
				input	 logic    [16-1:0]    IR	       ,
				input	 logic    [0:0]   enable_updatePC      ,
				input	 logic    [0:0]   enable_fetch	       ,
				input	 logic    [0:0]   enable_decode        ,
				input	 logic    [0:0]   enable_execute       ,
				input	 logic    [0:0]   enable_writeback     ,
				input	 logic    [0:0]   bypass_alu_1	       ,
				input	 logic    [0:0]   bypass_alu_2	       ,
				input	 logic    [0:0]   bypass_mem_1	       ,
				input	 logic    [0:0]   bypass_mem_2	       ,
				input	 logic    [0:0]   complete_data        ,
				input	 logic    [0:0]   complete_instr       ,
				input	 logic	  [1:0]	mem_state	,
				input	 logic    [16-1:0] Instr_dout	       ,
				input	 logic    [16-1:0] IR_Exec	       ,
				input	 logic    [2:0]    psr       ,
				input	 logic    [2:0]    NZP	       ,
				input	 logic    [0:0]    br_taken	       ,
				input	 logic    [0:0]    reset	       
			  );   
endinterface

interface MemAccess_Probe_if (
				input	 logic    [1:0]    mem_state,
				input	 logic    [0:0]    M_Control,
				input	 logic    [15:0]    M_Data,
				input	 logic    [15:0]    M_Addr,
				input	 logic    [15:0]    Data_dout,
				input	 logic    [15:0]    Data_addr,
				input	 logic    [0:0]    Data_rd,
				input	 logic    [15:0]    Data_din,
				input	 logic    [15:0]    memout
				);   
endinterface


