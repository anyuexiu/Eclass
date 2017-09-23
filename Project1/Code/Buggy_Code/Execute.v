`include "data_defs.vp"
module Execute(		clock, reset, E_Control, IR, npc, W_Control_in, Mem_Control_in, 
					VSR1, VSR2, enable_execute,  W_Control_out, Mem_Control_out, 
					NZP, aluout, pcout, sr1, sr2, dr, M_Data
			); 	// MODIFICATION_RAVI Need in put in the bypass that could 
   // be either VSR1 or VSR2. Need controls for that as well. 

   input				clock, reset, enable_execute;
   input [1:0] 			W_Control_in;													
   input 				Mem_Control_in;													
   input [5:0] 			E_Control;
   input [15:0] 		IR;
   input [15:0] 		npc;
   input [15:0] 		VSR1, VSR2;
//   input			bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2; //bypass1 and bypass2 allow for the use of bypass values for either VSR1 or VSR2 
   output [15:0] 		aluout, pcout;
   output [1:0] 		W_Control_out;
   output				Mem_Control_out;
   output [2:0] 		NZP;
   
   output [2:0] 		sr1, sr2, dr;
   output [15:0] 		M_Data;
   
   reg [2:0] 			sr1, sr2, dr;
   reg [1:0] 			W_Control_out;
   reg					Mem_Control_out;
   reg [15:0] 			M_Data;
   reg [15:0]                   pcout;

   wire [15:0] 			offset11, offset9, offset6, imm5, trapvect8;
   wire [1:0] 			pcselect1, alu_control, alu_control_temp;
   wire 				pcselect2, op2select;
   reg [15:0] 			addrin1, addrin2, aluin1_temp, aluin2_temp;
   wire 				alucarry; 		// overflow checking not implemented
   wire [15:0] 			VSR1_int, VSR2_int;
   wire 				alu_or_pc; 
   wire [15:0] 			aluin1, aluin2;
   reg [2:0] 			NZP;
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
		   `ifdef BUG12DONEANDDUSTEDWITH
	       sr2	<=	IR[2:0];
		   `else 
		   sr2	<=	IR[3:1];
		   `endif
	    end
	  2'b10: 
	    begin // Load Instructions
	       // Register File Control
	       sr1	<=	IR[8:6];  // needed for LDR, doesn't matter for LD, LDI, LEA
		   `ifdef BUG13DONEANDDUSTEDWITH
	       sr2	<=	3'd0; // Doesn't matter for Load Instructions
		   `else
		   sr2	<=	3'd1;		   
		   `endif
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
		   `ifdef BUG14DONEANDDUSTEDWITH
		      dr	<=	IR[11:9];
			`else 
		      dr	<=	IR[10:8];
			`endif
		   end
		 2'b10: 
		   begin // Load Instructions
		   `ifdef BUG15DONEANDDUSTEDWITH
		      dr	<=	IR[11:9];
			`else
		      dr	<=	IR[12:10];
			`endif
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
	  	end
		`ifdef BUG16DONEANDDUSTEDWITH
		else if (enable_execute)
		`else
		else if (1)
		`endif
	  	begin
	     	W_Control_out 	<= 	W_Control_in;
	     	Mem_Control_out <= 	Mem_Control_in;
	       	M_Data			<=	VSR2_int;
	  	end	  		 
     end
   `ifdef BUG17DONEANDDUSTEDWITH
   assign {alu_control_temp, pcselect1, pcselect2, op2select}=E_Control;
   `else 
   assign {alu_control_temp, pcselect2, pcselect1, op2select}=E_Control;
   `endif
   
   //assign alu_or_pc = (IR[13:12] == 2'b01)? 1'b1: 1'b0;
   assign alu_or_pc = 1'b1;
   // ALU OPERATIONS   	
   assign VSR1_int = VSR1;
   
   assign VSR2_int = VSR2;
   
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
	 	//if((IR[15:12] == 4'b0000) || (IR[15:12] == 4'b1100) || (IR[13:12] == 2'b10) || (IR[13:12] == 2'b11)) begin
	 	if((IR[15:12] == 4'b0000) || (IR[15:12] == 4'b1100) ) begin
			addrin2 = npc - 1;
		end
		else begin 
       		addrin2=npc;
		end
   	else
		addrin2=VSR1_int;


   // CHANGED assign pcout=addrin1+addrin2; // this could be done using the alu controls and using the alu itself
   // assign	pcout	=	aluout;
        always @(posedge clock)
        if (reset)begin
                pcout <= 0;
        end
        else if (enable_execute)begin
                pcout <= addrin1 + addrin2;
        end
   
`endprotect

endmodule

module extension(ir, offset11, offset9, offset6, trapvect8, imm5);
   input 	[15:0] 	ir;
   output [15:0] 	offset11, offset9, offset6, trapvect8, imm5;

`protect
   assign 		offset11		={{5{ir[10]}}, ir[10:0]};
   `ifdef BUG18DONEANDDUSTEDWITH
   assign 		offset9 		={{7{ir[8]}}, ir[8:0]};
   `else 
   assign 		offset9 		={{8{ir[7]}}, ir[7:0]};
   `endif
   assign 		offset6		={{10{ir[5]}}, ir[5:0]};
   
   `ifdef BUG19DONEANDDUSTEDWITH
   assign 		imm5			={{11{ir[4]}}, ir[4:0]};
   `else 
   assign 		imm5			={{12{ir[3]}}, ir[3:0]};
   `endif
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
    	    0: {alucarry,aluout}	<= aluin1+ aluin2;
			`ifdef BUG20DONEANDDUSTEDWITH
    	    1: {alucarry,aluout}	<= {1'b0, aluin1&aluin2};
			`else
    	    1: {alucarry,aluout}	<= {1'b0 , {aluin1 & {aluin2[15:7],aluin2[5], aluin2[6], aluin2[4:0]}}};
			`endif
    	    2: {alucarry,aluout}	<= {1'b0, ~aluin1};
    	    default: {alucarry,aluout}	<=~(aluin1^aluin2);
   	  endcase
       end	
`endprotect
endmodule // ALU
