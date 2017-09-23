`include "data_defs.vp"
module Decode(	clock, reset, enable_decode, dout, E_Control, 
				npc_in, Mem_Control, W_Control, IR, npc_out
				); 

   input 				clock, reset, enable_decode;
   input [15:0] 		dout;
   input [15:0] 		npc_in;
   output [1:0] 		W_Control; 
   output 	 		Mem_Control;
   output [5:0] 		E_Control;
   output [15:0] 		IR;
   output [15:0] 		npc_out;
   
   reg [1:0] 			W_Control; 
   reg 				M_Control; 

   reg [1:0] 			inst_type;
   reg 					pc_store;
   reg [1:0] 			pcselect1, alu_control;
   reg 					pcselect2, op2select;
   //reg 			br_taken;

   reg [15:0] 			IR, npc_out;

   
   wire [3:0] 			opcode=dout[15:12];

   //assign	F_Control = br_taken;
   // definition of controls and data
   assign 			Mem_Control	=	M_Control;
   assign 			E_Control	=	{alu_control, pcselect1, pcselect2, op2select};
   //assign 	F_Control	=	br_taken;

`protect
   // Instruction Register
   always @(posedge clock)
     if(reset)
       begin
		IR 		<= 	0;
		npc_out	<=	0;
       end
     else if (enable_decode) //MODIFICATION_RAVI .. change to enable_decode
       begin
			IR		<=	dout;
  			`ifdef BUG5DONEANDDUSTEDWITH
			npc_out	<= 	npc_in;
  			`else
			npc_out	<= 	npc_in + 1;
			`endif
       end	
   
   always @(posedge clock)
     begin
  	if(reset)
  	  inst_type 	<= 2'd0;
  	else if (enable_decode) //MODIFICATION_RAVI .. change to enable_decode
  	  begin
  	     case (opcode[1:0])
      	       2'b00: inst_type	<=	2'd1; // Control Instructions
      	       2'b01: inst_type	<=	2'd0; // ALU Operations
      	       2'b10: inst_type	<=	2'd2; // Load Instructions
      	       2'b11: inst_type	<=	2'd2; // Store Instructions
    	     endcase // case(next_opcode[1:0])
    	  end	
     end  
     
   // Instruction Decode for Execute
   always @(posedge clock) 
     begin
  	if(reset)
  	  begin
  	     alu_control <= 0;
  	     op2select 	<= 0;
  	     pcselect1 	<= 0;
  	     pcselect2 	<= 0;
  	  end	
  	else if (enable_decode) //MODIFICATION_RAVI .. change to enable_decode
  	  begin
`ifdef BUG29DONEANDDUSTEDWITH
       	     case(opcode[1:0])
`else 
             case({opcode[3],opcode[0]})
`endif
	       2'b00: 
	  	 begin  // Control Instructions (BR and JMP only)
		    // E_Control
        	    alu_control	<=	2'd0; // Doesn't matter for Control Instructions
		    op2select	<=	1'b0; // Doesn't matter for Control Instructions
		    case (opcode[3:2])
	       	      2'b00: 
	       		begin        // BR
		  	   pcselect1	<=	2'd1; // select offset9 
	          	   pcselect2	<=	1'b1; // select Next PC
	       		end
	       	      2'b11: 
	       		begin        // JMP
		  	   pcselect1	<=	2'd3; // select 0
	          	   pcselect2	<=	1'b0; // select VSR1
	       		end
	      	      default: 
	      		begin      // Unrecognized opcode
		  	   pcselect1	<=	2'd0;
	          	   pcselect2	<=	1'b0;
	       		end
	     	    endcase // case(opcode[3:2])
	  	 end
	       2'b01: 
	  	 begin // ALU Operations
		    // E_Control
	     	    pcselect1	<=	2'd0; 	// Doesn't matter for ALU Operations
	     	    pcselect2	<=	1'b0; 	// Doesn't matter for ALU Operations

`ifdef BUG7DONEANDDUSTEDWITH
		    	op2select	<=	~dout[5];
`else 
			op2select	<=	dout[5];
`endif
				
	     	  case (opcode[3:2])
`ifdef BUG6DONEANDDUSTEDWITH
	       	      2'b00: alu_control	<= 	2'd0;  	// ADD
	       	      2'b01: alu_control	<=	2'd1;   // AND
`else 
	       	      2'b00: alu_control	<= 	2'd1;  	// ADD
	       	      2'b01: alu_control	<=	2'd0;   // AND
`endif  				  
	       	      2'b10: alu_control	<=	2'd2;   // NOT
	       	      default: alu_control<=	2'd0; 	// Unrecognized opcode
	     	  endcase // case(opcode[3:2])
	       end
	       2'b10: 
	  	  begin // Load Instructions
		    // E_Control
	     	    alu_control	<=	2'd0; // Doesn't matter for Load Instructions
          	    if (opcode[3:2]==2'b01) 
          	      begin               // LDR
		  	 	pcselect1	<=2'd2; // select offset6
		  	 	pcselect2	<=1'd0; // // select VSR1
	       	 	end
	     	    else 
           	      begin               // LD, LDI, and LEA
`ifdef BUG8DONEANDDUSTEDWITH
		  	 	pcselect1	<=	2'd1; // select offset9
`else 
				pcselect1	<=	2'd2; // select offset9
`endif
					
`ifdef BUG9DONEANDDUSTEDWITH
	          	 	pcselect2	<=	1'b1; // select Next PC
`else 
				pcselect2	<=	1'b0; // select Next PC
`endif
	       	      end
             	    op2select<=1'b0; // Doesn't matter for Load Instructions
	  	 end
	       2'b11: 
	  	 begin // Store Instructions (Ignore TRAP)
		    // E_Control
	     	    alu_control<=2'd0; // Doesn't matter for Store Instructions
          	    if (opcode[3:2]==2'b01)
	       	      begin               // STR
		  	 pcselect1	<=2'd2; // select offset6
		  	 
	          	 pcselect2	<=1'b0; // select VSR1
	       	      end
	       	    else 
	       	      begin          // ST, STI, and TRAP (not supported)
		  	 pcselect1	<=	2'd1; // select offset9
	          	 pcselect2	<=	1'b1; // select Next PC
	       	      end
             	    op2select	<=	1'b0; // Doesn't matter for Store Instructions
	  	 end
   	     endcase // case(opcode[1:0])
   	  end // if (enable_decode)
     end
   
   
   // Instruction Decode for Writeback
   always @(posedge clock)
     begin
  	if(reset)
           begin
	   	W_Control <= 2'd0;
	   end
	
	else if (enable_decode) //MODIFICATION_RAVI .. change to enable_decode
  	  begin
       	     case(opcode[1:0])
	       2'b00: 
	  	 begin  // Control Instructions (BR and JMP only)
		    W_Control	<=	2'd0;  // Doesn't matter for Control Instructions
	  	 end
	       2'b01: 
	  	 begin // ALU Operations
`ifdef BUG10DONEANDDUSTEDWITH
	     	    W_Control	<=	2'd0;  // Writeback ALU output
`else 
 		    W_Control	<=	2'd1;
`endif
	  	 end
	       2'b10: 
	  	 begin // Load Instructions
             	    if (opcode[3:2]==2'b11) begin // LEA
`ifdef BUG11DONEANDDUSTEDWITH
             	       	W_Control<=2'd2;      // Writeback Computed Memory Address
`else 
			W_Control<=2'd0; 
`endif
             	    end
	     	    else                    // LD, LDR, and LDI
	       	      W_Control<=2'd1;      // Writeback Memory output
		 end
	       2'b11: 
	  	 begin // Store Instructions (Ignore TRAP)
	       	      W_Control<=2'd0; // Doesn't matter for Store Instructions
		 end
       	     endcase // case(opcode[1:0])
       	  end // if(enable_decode)
     end

   // Instruction Decode for Memory Operations
   always @(posedge clock)
     begin
  	if (reset)
  	  begin
  	     //{load, mem_access_mode, M_Control, pc_store} 	<= 	5'b0; 
	     M_Control <= 0;
  	  end
  	else if (enable_decode) //MODIFICATION_RAVI .. change to enable_decode
  	  begin
       	     case(opcode[1:0])
	       2'b00: 
	  	 begin  // Control Instructions (BR and JMP only)
		    // The following don't matter for Control Instructions
		    //{load, mem_access_mode, M_Control, pc_store} 	<= 	5'b0;
		    M_Control <= 0;
	  	 end
	       2'b01: 
	  	 begin // ALU Operations
	     	    // The following don't matter for ALU Operations
	     	    //{load, mem_access_mode, M_Control, pc_store}	<= 	5'b0;
		    M_Control <= 0;
	  	 end
	       2'b10: 
	  	 begin // Load Instructions
	     	    // C_Control and M_Control
	     	    //load		<=	(opcode[3:2]==2'b10) ? 1 : 0;  // load=1 for LDI
             	    M_Control	<=	(opcode[3:2]==2'b10) ? 1 : 0; // M_Control=1 for LDI
		    //	     		case (opcode[3:2])
		    //	       			2'b10: mem_access_mode		<=	2'd0; // LDI
		    //	       			2'b11: mem_access_mode		<=	2'd3; // LEA
		    //	       			default: mem_access_mode	<=	2'd1; // LD and LDR
		    //	     		endcase // case(opcode[3:2])
		    //	     		pc_store	<=	1'b0;  // Doesn't matter for Load Instructions
		 end
	       2'b11: 
	  	 begin // Store Instructions (Ignore TRAP)
	     	    // C_Control and M_Control
	     	    //load		<=	1'b0;  // load=0 for STI, doesn't matter for other ops
             	    M_Control	<=	(opcode[3:2]==2'b10) ? 1 : 0;  // M_Control=1 for STI
	     	    //mem_access_mode	<=	(opcode[3])?0: 2; // mem_access_mode=0 for STI
	     	    //pc_store	<=	0; 	// Doesn't matter for Store Instructions
		 end
       	     endcase // case(opcode[1:0])
       	  end // if(enable_decode)
     end
    
 `endprotect
   
endmodule
