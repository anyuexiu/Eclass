module LC3 (	clock, reset, pc, instrmem_rd, Instr_dout, Data_addr, complete_instr, complete_data,  
				Data_din, Data_dout, Data_rd, D_macc, I_macc
			);
	input			clock, reset;
	input			complete_instr, complete_data;
	output	[15:0] 	pc, Data_addr;
	input	[15:0]	Instr_dout, Data_dout;
	
	output			instrmem_rd, Data_rd; 
	output	[15:0]	Data_din;
	output			D_macc, I_macc;
	
	
	wire			enable_updatePC, br_taken,  enable_decode, enable_execute, enable_writeback, enable_fetch;
	wire	[15:0]	npc_out_fetch, taddr, IR, npc_out_dec; 
	wire	[5:0] 	E_Control;
	wire 	[1:0] 	W_Control;													
	wire 			Mem_Control;													


	wire	[15:0]	VSR1, VSR2, aluout, pcout;
	wire	[2:0] 	psr;
   	wire	[1:0] 	W_Control_out;
   	wire			Mem_Control_out;
   	
   	wire	[2:0]	sr1, sr2, dr, NZP;
   	
   	wire	[1:0]	mem_state;
   	wire			M_Control;
   	wire	[15:0]	M_Data, memout;
   	
   	assign 	I_macc = enable_fetch;
	
	Fetch	Fetch (
					.clock(clock), .reset(reset), .enable_updatePC(enable_updatePC), 
					.enable_fetch(enable_fetch), .pc(pc), .npc_out(npc_out_fetch), 
					.instrmem_rd(instrmem_rd), .taddr(pcout), .br_taken(br_taken)
				);

	Decode  Dec (
					.clock(clock), .reset(reset), .enable_decode(enable_decode), 
					.dout(Instr_dout), .E_Control(E_Control), .npc_in(npc_out_fetch), 
					.Mem_Control(Mem_Control), .W_Control(W_Control), 
					.IR(IR), .npc_out(npc_out_dec)
	      		);							
	Execute	Ex	(		
					.clock(clock), .reset(reset), .E_Control(E_Control), .IR(IR), 
					.npc(npc_out_dec), .W_Control_in(W_Control), .Mem_Control_in(Mem_Control), 
					.VSR1(VSR1), .VSR2(VSR2), .enable_execute(enable_execute), 
					.W_Control_out(W_Control_out), .Mem_Control_out(Mem_Control_out), 
					.aluout(aluout), .pcout(pcout), .sr1(sr1), .sr2(sr2), .dr(dr), 
					.M_Data(M_Data), .NZP(NZP)
				); 

	MemAccess	MemAccess (	
					.mem_state(mem_state), .M_Control(Mem_Control_out), .M_Data(M_Data), 
					.M_Addr(pcout), .memout(memout), .Data_addr(Data_addr), .Data_din(Data_din), 
					.Data_dout(Data_dout), .Data_rd(Data_rd)
				);

	Writeback	WB 		(	
					.clock(clock), .reset(reset), .enable_writeback(enable_writeback), 
					.W_Control(W_Control_out), .aluout(aluout), .memout(memout), .pcout(pcout), 
					.npc(npc_out_dec), .sr1(sr1), .sr2(sr2), .dr(dr), .d1(VSR1), .d2(VSR2), .psr(psr)
				);
				
	Controller_Pipeline Ctrl (
					.clock(clock), .reset(reset), .IR(IR), .complete_instr(complete_instr),
					.complete_data(complete_data), .NZP(NZP), .psr(psr), .br_taken(br_taken),
					
					.enable_fetch(enable_fetch), .enable_decode(enable_decode), 
					.enable_execute(enable_execute), .enable_writeback(enable_writeback), 
					.enable_updatePC(enable_updatePC), .mem_state(mem_state)

				);
								
endmodule
