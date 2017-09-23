module Execute(		clock, reset, E_Control, bypass_alu_1, bypass_alu_2, IR, npc, W_Control_in, Mem_Control_in, 
			VSR1, VSR2, enable_execute, Mem_Bypass_Val, bypass_mem_1, bypass_mem_2, 
			W_Control_out, Mem_Control_out, NZP, IR_Exec, 
			aluout, pcout, sr1, sr2, dr, M_Data); 	// MODIFICATION_RAVI Need in put in the bypass that could 
   // be either VSR1 or VSR2. Need controls for that as well. 

   input			clock, reset, enable_execute;
   input [1:0] 			W_Control_in;													
   input 			Mem_Control_in;													
   input [5:0] 			E_Control;
   input [15:0] 		IR;
   input [15:0] 		npc;
   input [15:0] 		VSR1, VSR2, Mem_Bypass_Val;
   input			bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2; //bypass1 and bypass2 allow for the use of bypass values for either VSR1 or VSR2 
   output [15:0] 		aluout, pcout;
   output [1:0] 		W_Control_out;
   output			Mem_Control_out;
   output [2:0] 		NZP;
   output [15:0] 		IR_Exec;
   
   output [2:0] 		sr1, sr2, dr;
   output [15:0] 		M_Data;
   
   reg [2:0] 			sr1, sr2, dr;
   reg [1:0] 			W_Control_out;
   reg				Mem_Control_out;
   reg [15:0] 			M_Data;

   wire [15:0] 			offset11, offset9, offset6, imm5, trapvect8;
   wire [1:0] 			pcselect1, alu_control, alu_control_temp;
   wire 			pcselect2, op2select;
   reg [15:0] 			addrin1, addrin2, aluin1_temp, aluin2_temp;
   wire 			alucarry; 		// overflow checking not implemented
   wire [15:0] 			VSR1_int, VSR2_int;
   wire 			alu_or_pc; 
   wire [15:0] 			aluin1, aluin2;
   reg [2:0] 			NZP;
   reg [15:0] 			IR_Exec;
   //assign {IR, VSR1, VSR2}=D_Data; // the D_Data values is going to come in from the register file based on the 
   // the sr1 and sr2 values sent to the RF from the Execute. 
   // create the correct sr1 sr2 values for reading the register file
   
   ALU 		alu		(clock, reset, aluin1, aluin2, alu_control, enable_execute, aluout, alucarry);
   extension 	ext		(IR, offset11, offset9, offset6, trapvect8, imm5); // IR and trapvect8 are not used for this project
`protect
   always @ (posedge clock)
     begin
	if(reset) begin
	   NZP = 3'b000;
	end
	else if(enable_execute)begin
	   if(IR[13:12] == 00)
	     begin
		if(IR[15:14] == 2'b00) begin	// CONTROL INSTRUCTIONS
		   NZP = IR[11:9]; 
		end
		else if(IR[15:14] == 2'b11)begin // JMP INSTRUCTION
		   NZP = 3'b111;
		end				
		     else begin
			NZP = 3'b000;
		     end
	     end
	   else begin
	      NZP = 3'b000; 
	   end			
	end
	     else begin
		NZP = 3'b000;
	     end
     end
   
   

   always @(IR) 
     begin
       	case(IR[13:12])
	  2'b00: 
	    begin  // Control Instructions (BR and JMP only)
	       // Register File Control
	       sr1	<=	IR[8:6];
	       sr2	<=	3'd0; // Doesn't matter for Control Instructions
	    end	
	  2'b01: 
	    begin // ALU Operations
	       // Register File Control
	       sr1	<=	IR[8:6];
	       sr2	<=	IR[2:0];
	    end
	  2'b10: 
	    begin // Load Instructions
	       // Register File Control
	       sr1	<=	IR[8:6];  // needed for LDR, doesn't matter for LD, LDI, LEA
	       sr2	<=	3'd0; // Doesn't matter for Load Instructions
	    end
	  2'b11: 
	    begin // Store Instructions (Ignore TRAP)
	       // Register File Control
	       sr1	<=	IR[8:6];    // for STR, doesn't matter for ST, STR, TRAP
	       
	       sr2	<=	IR[11:9];  
	       
	    end
	endcase 
     end
   always @(posedge clock) // MODIFICATION_RAVI .. there is a need to sent these control signals to the units that consume them along the pipeline or to move the decoding into the units that need the controls.
       begin
 	  if(reset)
 	    begin
 	       dr <=	0;
 	    end
 	  else if (enable_execute)
 	    begin
	       case(IR[13:12])
		 2'b00: 
		   begin  // Control Instructions (BR and JMP only)
		      dr	<=	3'd0; // Doesn't matter for Control Instructions
		   end	
		 2'b01: 
		   begin // ALU Operations
		      dr	<=	IR[11:9];
		   end
		 2'b10: 
		   begin // Load Instructions
		      dr	<=	IR[11:9];
		   end
		 2'b11: 
		   begin // Store Instructions (Ignore TRAP)
		      dr	<=	3'd0;        // Doesn't matter for Store Instructions
		   end
	       endcase  		
 	    end
       end

   
   	always @ (posedge clock)
   	begin
		if(reset)
	  	begin
	     	W_Control_out 	<= 	0;
	     	Mem_Control_out <= 	0;
	     	M_Data			<=	0;
	     	IR_Exec			<= 	0;
	  	end
		else if (enable_execute)
	  	begin
	     	W_Control_out 	<= 	W_Control_in;
	     	Mem_Control_out <= 	Mem_Control_in;
	       	M_Data			<=	VSR2_int;
	     	IR_Exec			<= 	IR;
	  	end
		else if (IR == 16'h0000)begin 
			IR_Exec 		<= 0;
		end
	  		 
     end
   
   assign {alu_control_temp, pcselect1, pcselect2, op2select}=E_Control;
   
   assign alu_or_pc = (IR[13:12] == 2'b01)? 1'b1: 1'b0;
   
   // ALU OPERATIONS   	
   assign VSR1_int = (bypass_alu_1)? aluout: (bypass_mem_1)?Mem_Bypass_Val: VSR1;
   
   assign VSR2_int = (bypass_alu_2)? aluout: (bypass_mem_2)?Mem_Bypass_Val: VSR2;
   
   always @(VSR1_int)
     aluin1_temp=VSR1_int;

   always @(op2select or VSR2_int or imm5)
     begin
  	if(op2select)
       	  aluin2_temp=VSR2_int;
    	else
 	  aluin2_temp=imm5;

     end
   
   assign	aluin1 		= alu_or_pc ? aluin1_temp: addrin1;
   assign	aluin2 		= alu_or_pc ? aluin2_temp: addrin2;
   assign 	alu_control = alu_or_pc ? alu_control_temp : 2'b0; 

   always @(pcselect1 or offset11 or offset9 or offset6)
     case(pcselect1)
       0: addrin1	=	offset11;
       1: addrin1	=	offset9;
       2: addrin1	=	offset6;
       3: addrin1	=	0;
     endcase
   
   	always @(pcselect2 or npc or VSR1_int or IR)
   	if(pcselect2)
	 	if((IR[15:12] == 4'b0000) || (IR[15:12] == 4'b1100) || (IR[13:12] == 2'b10) || (IR[13:12] == 2'b11)) begin
	 	//if((IR[15:12] == 4'b0000) || (IR[15:12] == 4'b1100) ) begin
			addrin2 = npc - 1;
		end
		else begin 
       		addrin2=npc;
		end
   	else
		addrin2=VSR1_int;


   // CHANGED assign pcout=addrin1+addrin2; // this could be done using the alu controls and using the alu itself
   assign	pcout	=	aluout;
   
`endprotect

endmodule

module extension(ir, offset11, offset9, offset6, trapvect8, imm5);
   input 	[15:0] 	ir;
   output [15:0] 	offset11, offset9, offset6, trapvect8, imm5;

`protect
   assign 		offset11		={{5{ir[10]}}, ir[10:0]};
   
   assign 		offset9 		={{7{ir[8]}}, ir[8:0]};
   
   assign 		offset6		={{10{ir[5]}}, ir[5:0]};
   
   assign 		imm5			={{11{ir[4]}}, ir[4:0]};
   assign 		trapvect8	={ {8{ir[7]}}, ir[7:0]};
`endprotect
endmodule //extension

module ALU(clock, reset, aluin1, aluin2, alu_control, enable_execute, aluout, alucarry);
   
   input			clock, reset;
   input [15:0] 		aluin1, aluin2;
   input [1:0] 			alu_control;
   input			enable_execute;
   output [15:0] 		aluout;
   output 			alucarry;
   
   reg [15:0] 			aluout;
   reg 				alucarry;

`protect
   always @(posedge clock)
     if (reset)
       begin
  	  alucarry 	<= 0;
  	  aluout		<= 0;
       end
     else if (enable_execute)
       begin
  	  case(alu_control)
    	    0: {alucarry,aluout}	<=aluin1+aluin2;
    	    1: {alucarry,aluout}	<={1'b0, aluin1&aluin2};
    	    2: {alucarry,aluout}	<={1'b0, ~aluin1};
    	    default: {alucarry,aluout}	<=~(aluin1^aluin2);
   	  endcase
       end	
`endprotect
endmodule // ALU
