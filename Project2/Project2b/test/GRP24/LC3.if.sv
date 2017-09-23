interface LC3_io(input bit clock);
  	logic		reset;
  	logic 	[15:0]  pc;
	logic  		complete_data;
	logic  		complete_instr;
	
	logic	[15:0]  Instr_dout ,Data_dout,Data_addr,Data_din;
	logic   	instrmem_rd,Data_rd;      
  							

  	clocking cb @(posedge clock);
    	default input #0 output #0;

		output 	Instr_dout;
   		output  Data_dout;
		output  complete_data;
		output complete_instr;
   		input	pc;
		input 	Data_din;
		
		input   Data_addr,Data_rd;
		input   instrmem_rd;
   			
  	endclocking

  	modport TB(clocking cb, output reset  ); //asynchronous signals not in the clocking block
endinterface


interface Fetch_Probe_if(	input 	bit 		clock,						//all signals for the Fetch Block
				input 	logic [15:0] 	taddr,
				input 	logic [15:0] 	pc, 
				input 	logic [15:0] 	npc_out,
				input 	logic 		instrmem_rd , 
				input 	logic 		br_taken, 
				input 	logic 		enable_fetch, 
				input 	logic 		enable_updatePC
				);

  	clocking cb @(posedge clock);
    	default input #1 output #1;

				input    		taddr;
				input    		pc; 
				input   		npc_out;
				input   		instrmem_rd ; 
				input  			br_taken; 
				input   		enable_fetch; 
				input   		enable_updatePC;
   			
  	endclocking

endinterface

interface Decode_Probe_if (
				input 	bit 		clock,						//all signals for the Decode Block
 				input 	logic [15:0] 	dout,
 				input 	logic [15:0] 	npc_in,
				input 	logic  		enable_decode,
				input 	logic [15:0] 	IR,
				input 	logic [15:0] 	npc_out,
				input 	logic [5:0]  	E_Control,
				input 	logic [1:0] 	W_Control,
				input 	logic 		Mem_Control
				//input   logic [2:0]     psr
				); 
				
  	clocking cb @(posedge clock);
    	default input #1 output #1;

			        input    dout;
 				input    npc_in;
				input    enable_decode;
				input    IR;
				input    npc_out;
				input    E_Control;
				input    W_Control;
				input   Mem_Control;
   			      //  input   psr;
  	endclocking					
endinterface
				
				
interface Execute_Probe_if (  
			      input bit 			clock,							//all signals for the Execute Block
			      input logic 			enable_execute,
			      input logic [1:0] 		W_Control_in,
			      input logic [5:0] 		E_Control,
			      input logic [15:0] 		IR,
			      input logic [15:0] 		npc,
			      input logic [15:0] 		VSR1, 
			      input logic [15:0]		VSR2,
			      input logic [15:0] 		aluout, 
			      input logic [15:0]		pcout,
			      input logic [1:0] 		W_Control_out,
			      input logic [2:0] 		sr1, 
			      input logic [2:0]			sr2, 
			      input logic [2:0]			dr,
			      input logic 			bypass_alu_1,
			      input logic			bypass_alu_2,
			      input logic 			bypass_mem_1,
			      input logic			bypass_mem_2,
			      input logic [15:0]		Mem_Bypass_Val,
			      input logic [15:0]		M_Data,
			      input logic [15:0]		IR_Exec,
			      input logic [2:0] 		NZP,
			      input logic 			Mem_Control_in,
			      input logic 			Mem_Control_out
			      );
			      
  	clocking cb @(posedge clock);
    	default input #1 output #1;
			      
			      input   		enable_execute;
			      input    		W_Control_in;
			      input    		E_Control;
			      input    		IR;
			      input    		npc;
			      input   		VSR1; 
			      input   		VSR2;
			      input    		aluout; 
			      input   		pcout;
			      input    		W_Control_out;
			      input    		sr1; 
			      input   		sr2; 
			      input   		dr;
			      input   		bypass_alu_1;
			      input  		bypass_alu_2;
			      input   		bypass_mem_1;
			      input  		bypass_mem_2;
			      input   		Mem_Bypass_Val;
			      input   		M_Data;
			      input   		IR_Exec;
			      input    		NZP;
			      input   		Mem_Control_in;
			      input   		Mem_Control_out ;
   			
  	endclocking			      
endinterface			    
			      				
interface Writeback_Probe_if ( 
		               input bit 		clock,						////all signals for the Writeback Block
			       input logic [15:0]	aluout,
			       input logic [1:0]	W_Control,
			       input logic [15:0]	pcout,
			       input logic [15:0]	d1,
			       input logic [15:0]	d2,
			       input logic [2:0]	sr1,
			       input logic [2:0]	sr2,
			       input logic [2:0]	dr,
			       input logic [2:0]	psr,
			       input logic  		enable_writeback,
			       input logic [15:0]	memout,
			       input logic [15:0]       npc,
			       /////////////////////////////MemAcess/////////////////////	////all signals for the MemAccess Block
			       input logic [1:0] 	mem_state,
			       input logic 	  	M_Control,
			       input logic [15:0] 	M_Data,
			       input logic [15:0] 	M_Addr,
			       input logic [15:0] 	memout_MA,
			       input logic [15:0] 	Data_addr,
			       input logic [15:0] 	Data_din,
			       input logic [15:0] 	Data_dout,
			       input logic 	   	Data_rd
			       );
			     
	clocking cb @(posedge clock);
    	default input #1 output #1;
			       
			       input 		aluout;
			       input 		W_Control;
			       input 		pcout;
			       input 		d1;
			       input 		d2;
			       input 		sr1;
			       input 		sr2;
			       input 		dr;
			       input 		psr;
			       input 		enable_writeback;
			       input 		memout;
			       input 	        npc;
			       ////////////////////////////////////MemAcessss
			       input  		mem_state;
			       input  		M_Control;
			       input  		M_Data;
			       input  		M_Addr;
			       input  		memout_MA;
			       input  		Data_addr;
			       input  		Data_din;
			       input  		Data_dout;
			       input  		Data_rd;	
   			
  	endclocking			
endinterface

interface Controller_Probe_if (
				input bit 	clock,							////all signals for the Controller Block
				input logic     complete_data,
				input logic[15:0] IR,
				input logic 	br_taken,
				input logic 	complete_instr,
				input logic 	enable_fetch,
				input logic 	enable_decode,
				input logic 	enable_execute,
				input logic 	enable_writeback,
				input logic 	enable_updatePC,
				input logic 	bypass_alu_1,
			      	input logic	bypass_alu_2,
			      	input logic 	bypass_mem_1,
			      	input logic	bypass_mem_2,
				input logic [1:0] mem_state,
				input logic [2:0]	psr,
				input logic [2:0]	NZP,
				input logic [15:0]     IR_Exec,
				input logic [15:0]     Instr_dout
				);						       
	clocking cb @(posedge clock);
    	default input #1 output #1;
				
				input 	complete_data;
				input   IR;	
				input   br_taken;		       
				input   complete_instr;
				input   enable_fetch;
				input   enable_decode;
				input   enable_execute;
				input   enable_writeback;
				input   enable_updatePC; 
			        input   bypass_alu_1;
			      	input  	bypass_alu_2;
			      	input   bypass_mem_1;
			      	input  	bypass_mem_2;
				input   mem_state;
				input	psr;
				input   Instr_dout;
				input   IR_Exec;
				input   NZP;
   			
  	endclocking			       
endinterface			       	

