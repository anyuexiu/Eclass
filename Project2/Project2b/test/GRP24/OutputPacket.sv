class OutputPacket;

	string name;
///////////////////////////Fetch

	reg instrmem_rd_fetch ;
//////////////////////////Decode
	/*No asynchronous output*/
/////////////////////////Execute
	reg [2:0] sr1_execute;
	reg [2:0] sr2_execute;
/////////////////////////WB
	
	reg [15:0]  VSR1_WB;
	reg [15:0]  VSR2_WB;
/////////////////////////Memaccess
	reg [15:0] memout_MemAccess;
	//////////////////////MemAccess
	reg [15:0] DMem_addr_MemAccess;
	reg[15:0] DMem_din_MemAccess;
	reg  DMem_rd_MemAccess;
/////////////////////////Controller
/* No Asynchronous output*/
///////////////////////Fetch

	reg [15:0] pc_fetch ;
	reg [15:0] npc_fetch;	
//////////////////////Decode
	reg  [15:0] IR_decode;
	reg  [15:0] npc_out_decode;
	reg  [5:0]  E_Control_decode;
	reg  [1:0]  W_Control_decode;
	reg         Mem_Control_decode;
/////////////////////Execute
	reg  [2:0] W_Control_out_execute;
	reg 	   Mem_Control_out_execute;
	reg  [15:0]  aluout_execute;
	reg  [15:0]  pcout_execute;	
	reg  [2:0]   dr_execute;
	reg [15:0]   IR_Exec_execute;
	reg [2:0]   NZP_execute;
	reg [15:0]  M_Data_execute;
////////////////////WB	
	reg [2:0] psr_WB;

////////////////////////Controller
	reg    enable_fetch_controller;
	reg    enable_decode_controller;
	reg    enable_execute_controller;
	reg    enable_writeback_controller;
	reg    enable_updatePC_controller; 
	reg    bypass_alu_1_controller;
	reg   	bypass_alu_2_controller;
	reg    bypass_mem_1_controller;
	reg   	bypass_mem_2_controller;	
	reg    br_taken_controller;
	reg [1:0] mem_state_controller;
	  			
	extern function new(string name = "OutputPacket");
    
endclass

function OutputPacket::new(string name = "OutputPacket");
	this.name = name;
endfunction




