module Controller_Pipeline(	clock, reset, IR, 
				bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2, 
				complete_data, complete_instr,
				Instr_dout, NZP, psr, IR_Exec,
				enable_fetch, enable_decode, enable_execute, enable_writeback, enable_updatePC, 
				br_taken, mem_state, D_macc
				);

   input				clock, reset;	
   input				complete_data, complete_instr;
   input [15:0] 		IR, IR_Exec;
   input [2:0] 			psr, NZP;
   input [15:0] 		Instr_dout;
   output				bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2;
   output				enable_fetch, enable_decode, enable_execute, enable_writeback, enable_updatePC;
   output [1:0] 		mem_state;
   output				br_taken;
   output				D_macc;
   
   reg [1:0] 			mem_state;
   reg [4:0] 			enables;
   
   reg [4:0] 			prev_enables;
   reg [4:0] 			state, next_state;
   
   reg					bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2;
   reg [15:0] 			prev_IR;
   wire					stall_pipe;
   reg [2:0] 			bubble_count;
   reg 					control_instr_dout;
   wire [4:0] 			enables_temp1, enables_temp2;
   reg					inc_count, reset_count;
   reg					br_taken;
   
   reg [1:0] 			mem_ctrl_Cstate, mem_ctrl_Nstate;
   wire 				deassert_enable_writeback, deassert_enable_decode, deassert_enable_writeback1, deassert_enable_writeback2;
   wire					processing_branch;
   
`protect
   //wire				control_instr_dout;
   //wire 			deassert_enable_writeback, deassert_enable_writeback1, deassert_enable_writeback2;
   //reg				processing_branch;
   	wire [2:0] 			sr_store;
   	assign 			enables_temp1 = (deassert_enable_writeback==0)?enables: {enables[4:1],1'b0};
   	assign 			enables_temp2 = (deassert_enable_decode == 0)?enables_temp1: {enables_temp1[4:3],1'b0, enables_temp1[1:0]};
   	//assign 			{enable_updatePC, enable_fetch, enable_decode, enable_execute, enable_writeback}	= (stall_pipe)? {1'b0, enables_temp2[3], 3'b000}: enables_temp2;
   	assign 			{enable_updatePC, enable_fetch, enable_decode, enable_execute, enable_writeback}	= (stall_pipe)? {5'b00000}: enables_temp2;
	
   	assign		D_macc = stall_pipe;
			
	
   	always @(reset or Instr_dout) begin
     	if (reset) begin
			control_instr_dout <=1'b0;
     	end
     	else begin
			if ((Instr_dout[13:12] == 2'b00) && (Instr_dout != 16'h0000)) begin
	   			control_instr_dout <=1'b1;
			end
			else begin
	   			control_instr_dout <=1'b0;
			end
     	end
   	end
   
   	assign 			sr_store   = IR[11:9]; 
   
   	always @ (posedge clock)
    begin
		if(reset)
	  	begin
	     	state	<=	0;
	  	end
		else if (!stall_pipe)
		begin			
	     	state 	<=	next_state;
	  	end
	end
   
   	assign	reset_counter = reset | reset_count;
   
   	always @ (posedge clock) begin
		if((reset_counter) || ( bubble_count == 3 && complete_instr == 1)) begin
			bubble_count <= 0; 
		end
		else if (!stall_pipe && inc_count) begin
	     	bubble_count <= bubble_count + 1;
	  	end
  	end
	
  	assign	processing_branch = (control_instr_dout && (bubble_count < 3)) ? 1:0;
//  	always @ (*) begin
//		if (control_instr_dout && (bubble_count < 3)) begin
//			processing_branch <= 1;
//		end		
//		else begin
//			processing_branch <= 0;
//		end
//	end 
	  
   	always @ (*) begin
		case(state)	
	  	5'd0:	begin		// this is the reset state 
	     	next_state		<=	1;
	     	//mem_state		<=	3;	
	     	bypass_alu_1	<=	0;	bypass_alu_2	<= 0; 	
	     	bypass_mem_1	<=0; bypass_mem_2	<= 0;
	     	//processing_branch = 0;
	     	inc_count = 0;
	     	reset_count = 0;
	     	br_taken <= 0;
	     	if(complete_instr)begin
		  		enables		<=	5'b11000;	
		  		next_state		<=	1;
	       	end
	     	else begin
		  		enables		<= 5'b01000; // do not update the PC until we get the instruction for the old PC	
		  		next_state		<=	0;
	       	end
	     //						enables			<=	5'b11000;	
	  	end
	  	5'd1:	begin	
	     	if(complete_instr) begin
		  		if(control_instr_dout) // check for Control Instruction
		    	begin
		       		enables		<= 5'b00100;
		       		//processing_branch <= 1;
		       		inc_count <= 1; reset_count <= 0;
		    	end	
		  		else // for the rest of the instructions
		    	begin
		       		enables		<=	5'b11100;	// go ahead and decode the stuff that was fetched at the reset PC 
		       		inc_count <= 0; reset_count <= 0;
		       		//processing_branch <= 0;
		    	end
	       	end
	     	else begin
		  		enables		<= 5'b01100; 	
		  		inc_count <= 0; reset_count <= 0;
		  		//processing_branch <= 0;
	       	end
	     	next_state		<=	2;
	     	bypass_alu_1	<=	0;	bypass_alu_2	<= 0; 	
	     	bypass_mem_1	<=0; bypass_mem_2	<= 0;
	     	br_taken = 0;
	  	end
	  	5'd2:	begin		
	     
	     /*******************************************************************************************
	      
	      CREATION OF ENABLE_EXECUTE AND ENABLE_WRITEBACK TO CATER WITH NO-OP
	      
	      *******************************************************************************************/						
 	     	next_state	<=	2;
 	     	
	     	if(IR == 16'h0000)	begin
				enables[1:0] <= {1'b0, prev_enables[1]};
	     	end
	     	else begin
				enables[1:0] <= {prev_enables[2:1]};
	     	end
	     
	     	/*******************************************************************************************
	      
	      	CREATION OF ENABLE_[UPDATEPC/FETCH/DECODE] WHILE CATERING FOR BRANCH/JMP
	      
	      	*******************************************************************************************/						
	     	if((complete_instr || processing_branch) && !stall_pipe) begin 
			   	if(!control_instr_dout) begin // check to see if the value out of mem is a control instruction or not 
			      	enables[4:2] <= {1'b1, 1'b1, prev_enables[4]}; //PROJECT 2 CHANGE 
			      	reset_count <= 0; 
			      	inc_count <= 0;
			      	br_taken <= 0;
//			      	processing_branch <= 0;
			   	end
			   	else begin 
			      // control instruction .. now need to make sure that we wait 3 cycles before asserting en_fetch
			      // and 2 cycles before asserting en_updatePC
			      	if(bubble_count ==3'd2) begin 	
				    // need to make branch_taken high
//				    	processing_branch <= 1;
				    	if(|(psr & NZP)) begin 
				       		br_taken <= 1;
	 			       		//enables[4:2] = {1'b1, 1'b0, prev_enables[3]}; 
	 			       		enables[4:2] <= {1'b1, 1'b0, 1'b0};//PROJECT 2 CHANGE
	                  	end
					 	else begin
					    	br_taken = 0;
					    	//enables[4:2] <= {1'b0, 1'b0, prev_enables[3]};
							enables[4:2] <= {1'b0, 1'b0, 1'b0};//PROJECT 2 CHANGE

					 	end
				    	reset_count <= 0; 
				    	inc_count <= 1;
				 	end
				 	else if(bubble_count == 3'd3)begin 
					 	//enables[4:2] = {1'b1, 1'b1, prev_enables[3]}; // This causes error because the decode should only happen when complete is high
					 	enables[4:2] <= {1'b0, 1'b1, 1'b0}; //PROJECT 2 CHANGE 
					 	reset_count <= 0; 
					 	inc_count <= 1; // normal operations resume until next control instruction
					 	br_taken <= 0;
//					 	processing_branch <= 0;
				      	end
					else begin
					 	reset_count <= 0; 
					 	inc_count <= 1;
					  	enables[4:2] <= {1'b0, 1'b0, prev_enables[3]};
					  	br_taken <= 0;
//					  	processing_branch <= 1;
					end
				end	//if(!control_i
		   	end
		    else begin // complete_instr takes precedence over control or not .. the output from IMem is invalid without complete
			 	//enables[4:2] = {1'b0, 1'b1, 1'b0};
			 	enables[4:2] <= {1'b0, 1'b1, prev_enables[4]};//PROJECT 2 CHANGE
			 	reset_count <= 0; 
			 	inc_count <= 0;
			 	br_taken <= 0;
			 	//processing_branch <= 0;
		 	end
		      
		      /*******************************************************************************************
		       
		       BYPASSES FOR ALU INSTRUCTIONS
		       
		       *******************************************************************************************/						
			if (IR[13:12] == 2'b01) // ALU Instructions
			begin
			   	//$display("[CONTROLLER] ALU INSTRUCTION FOUND");
			   	// check for dependency and if so then set the right bypass value
			 	if ((IR[8:6] == prev_IR[11:9]) && ((IR[2:0] == prev_IR[11:9]) && (IR[5]==0))) // present src1 = src2 = prev DR
			    begin
				//$display("[CONTROLLER] BYPASS FOR SRC1 and SRC2");
					if(prev_IR[13:12] == 2'b01) begin
				     	bypass_alu_1	<=	1; bypass_alu_2 	<= 	1; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				  	end
					else if (prev_IR[13:12] == 2'b10) // LOAD INSTRUCTIONS 
				  	begin
				     	if(prev_IR[15:14] == 2'b11)begin // consider LEA to be a ALU type instr
							bypass_alu_1	<=	1; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;									
				     	end
				  		else begin
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	1;									
				     	end
				  	end	
				  	else begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				    end
			 	end
			   	else if ((IR[2:0] == prev_IR[11:9]) && (IR[5]==0))// present src2 = prev DR
			  	begin
				//$display("[CONTROLLER] BYPASS FOR SRC2");
					if(prev_IR[13:12] == 2'b01) // prev instr was ALU instruction
				  	begin
				   		bypass_alu_1	<=	0;bypass_alu_2 	<= 	1; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				  	end
					else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
				  	begin
				     	if(prev_IR[15:14] == 2'b11)begin // consider LEA to be a ALU type instr
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
				     	end
				     	else begin
							bypass_alu_1	<=	0;bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	1;
				     	end
				  	end									
				   	else begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				  	end
			 	end
				else if ((IR[8:6] == prev_IR[11:9]))// present src1 = prev DR
				begin
				     //$display("[CONTROLLER] BYPASS FOR SRC1");
				   	if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
				  	begin
					  	bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				  	end
				  	else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
				  	begin
					  	if (prev_IR[15:14] == 2'b11) // prev instr LEA 
					    begin
					       bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
					    end
					  	else begin // all other loads
					     	bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	0;
					  	end
				 	end									
					else begin
					     bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end
				end
				else 
				begin
					bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				end
			end
		      
		      /*******************************************************************************************
		       
		       BYPASSES FOR CONTROL INSTRUCTIONS
		       
		       *******************************************************************************************/						
			else if ((IR[13:12] == 2'b00) && (IR != 16'h0000)) // Control Instructions
			begin // there is a need for bypass values for the JMP instruction 
			   	if ((IR[8:6] == prev_IR[11:9]) && (IR[15:14] == 2'b11)) 
			  	begin
				  //$display("[CONTROLLER] BYPASS FOR SRC1");
				  	if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
				    begin
				       bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				    end
				  	else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
				    begin
				       	if (prev_IR[15:14] == 2'b11) // prev instr LEA 
					 	begin
						    bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
						end
				    	else begin // all other loads
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	0;
				     	end
				  	end		
					else 
					begin
					    bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end							
			   	end	
			   	else 
			    begin
					bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
			  	end					
			end //if (IR[13:12] == 2'b01) // ALU Instructions

		      /*******************************************************************************************
		       
		       BYPASSES FOR LOAD INSTRUCTIONS
		       
		       *******************************************************************************************/
			else if ((IR[13:12] == 2'b10)&&(IR[15:14] == 2'b01)) // Load Instructions
			begin
				// The only register sourced is BaseR which is IR[8:6]
				if ((IR[8:6] == prev_IR[11:9]))// present BaseR = prev DR 
				begin
					//$display("[CONTROLLER] BYPASS FOR SRC1");
				    if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
					begin
						bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end
				    else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
					begin
					 	if (prev_IR[15:14] == 2'b11) // prev instr LEA 
					    begin
						 	bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
					   	end
					    else begin // all other loads
					       bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	0;
					    end
					end		
					else 
					begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end							
				end						
				else 
				begin
					bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				end					
			end
		      /*******************************************************************************************
		       
		       BYPASSES FOR STORE INSTRUCTIONS
		       
		       *******************************************************************************************/
			else if ((IR[13:12] == 2'b11)) // store Instructions
			begin
				// The possible dependencies are with IR[8:6] = BaseR and IR[11:9] = SR
				if ((IR[8:6] == prev_IR[11:9]) && (sr_store == prev_IR[11:9])&&(IR[15:14] == 2'b01))// present BaseR = prev DR  && present SR = prev DR
				begin
					//$display("[CONTROLLER] BYPASS FOR SRC1");
					if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
					begin
						bypass_alu_1	<=	1; bypass_alu_2 	<= 	1; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end
					else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
					begin
						if (prev_IR[15:14] == 2'b11) // prev instr LEA 
						begin
							bypass_alu_1	<=	1; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
						end
						else begin // all other loads
						   	bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	1;
						end
					end		
					else 
					begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end							
				end	
				else if ((IR[8:6] == prev_IR[11:9])&&(IR[15:14] == 2'b01)) // baseR equals prev DR 
				begin
					if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
					begin
						bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end
					else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
					begin
						if (prev_IR[15:14] == 2'b11) // prev instr LEA 
						begin
							bypass_alu_1	<=	1; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
						end
						else begin // all other loads
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	0;
						end
					end		
					else 
					begin
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end						
				end					
				//else if ((IR[11:9] == prev_IR[11:9])) // SR equals prev DR
				else if ((sr_store == prev_IR[11:9])) // SR equals prev DR
				begin
					if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
					begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	1; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end
					else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
					begin
						if (prev_IR[15:14] == 2'b11) // prev instr LEA 
						begin
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
						end
						else begin // all other loads
							bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	1;
						end
					end		
					else 
					begin
						bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
					end						
				end					
				else 
				begin
					bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
				end					
			end
			else //non reachable state
			begin
				bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
			end				
		      
		end
		default:	begin
		     //mem_state	<=	3;	
			bypass_alu_1	<=	0;	bypass_alu_2	<= 0; bypass_mem_1	<=0; bypass_mem_2	<= 0;								
		 	enables	<=	0;	
		end	
		endcase
	end

   
   	always @ (posedge clock)
   	begin
		if(reset) begin
	   		mem_ctrl_Cstate <= 3;
		end
		else begin
	   		mem_ctrl_Cstate <= mem_ctrl_Nstate;
		end
  	end
   
   	always @ (mem_ctrl_Cstate or IR_Exec or complete_data)
  	begin
		case(mem_ctrl_Cstate) 
	  	2'd3: begin // reset state 
	     	if(((IR_Exec[13:12] == 2'b11) || ((IR_Exec[13:12] == 2'b10))) && (IR_Exec[15:14] != 2'b11) ) 	
	       	begin
		  // if a Load (!LEA) or Store is seen at the output of the Excute then go ahead  
		  // and stall the entire pipeline and begin moving to the correct states
	 		  	//stall_pipe <= 1;
			  	if(IR_Exec[15:14] == 2'b10) begin // if indirect read/write 
			     	mem_ctrl_Nstate <= 1;
			     	mem_state <= 1;
			  	end
			  	else begin
			     	if(IR_Exec[13:12] == 2'b11) begin // stores 
						mem_ctrl_Nstate <= 2;
						mem_state <= 2;
			   		end
			  		else if (IR_Exec[13:12] == 2'b10) begin // loads
						mem_ctrl_Nstate <= 0;
						mem_state <= 0;
			   		end
					else begin
						mem_ctrl_Nstate <= 3;
				   		mem_state <= 3;
						$display("INVALID STATE");
					end
				end						
	    	end		
	     	else begin 
				mem_ctrl_Nstate <= 3;
				//stall_pipe <= 0;
				mem_state <= 3;
	     	end	     
	  	end // end case 2'd3
	  	2'd1: begin // indirect addressing
	   		//stall_pipe <= 1;
	     	if(complete_data)begin
		   		if((IR_Exec[13:12] == 2'b11)) begin // if its a store indirect
		      		mem_ctrl_Nstate <= 2; // go to mem write state
		      		mem_state <= 2;
		   		end
		   		else if((IR_Exec[13:12] == 2'b10)) begin
		      		mem_ctrl_Nstate <= 0; // go to mem read state
		      		mem_state <= 0;
		   		end
				else begin
			   		mem_ctrl_Nstate <= 3; //INVALID
			   		mem_state <= 3;
				end
			end
			else begin
		   		mem_ctrl_Nstate <= 1; // stay in same state until complete is asserted
		   		mem_state <= 1;
			end	
		end
		2'd2: begin // write memory state
			if(complete_data) begin
		      	mem_ctrl_Nstate <= 3;
		      	mem_state = 3;
		      	//stall_pipe <= 0;
		   	end
		   	else begin
		      	mem_ctrl_Nstate <= 2;
		      	mem_state = 2;
		      	//stall_pipe = 1;
		   	end
		end
		
		2'd0: begin
			if(complete_data) begin
			 	mem_ctrl_Nstate <= 3;
			 	mem_state = 3;
			 	//stall_pipe <= 0;
		  	end
		  	else begin
			 	mem_ctrl_Nstate <= 0;
			 	mem_state = 0;
			 	//stall_pipe = 1;						
		  	end
		end	
		default: begin
		  	mem_ctrl_Nstate <= 3;
		  	mem_state = 3;
		  	//stall_pipe <= 0;					
		end	  
		endcase
	end
	assign 	stall_pipe = (((mem_ctrl_Cstate == 2'd0) && (complete_data == 0))||((mem_ctrl_Cstate == 2'd2) && (complete_data == 0)) ||
							(((IR_Exec[13:12] == 2'b11) || ((IR_Exec[13:12] == 2'b10))) && (IR_Exec[15:14] != 2'b11) &&(mem_ctrl_Cstate == 2'd3)) ||
							(mem_ctrl_Cstate == 2'd1)
							) ? 1'b1 : 1'b0;
   // should not write any to register file for Stores to Memory and for JMP/BR
   assign	deassert_enable_writeback2 = (complete_data && (mem_ctrl_Cstate == 2'd2))?1:0;
   assign	deassert_enable_writeback1 = (bubble_count == 2'd2)?1:0;
   assign	deassert_enable_writeback = (deassert_enable_writeback2 || deassert_enable_writeback1)?1:0; 
   assign	deassert_enable_decode = (bubble_count == 3)?1:0; 
   
   
   	always @ (posedge clock) begin
		if(reset)
	  	begin
	     	prev_enables 	<= 0;
	     	prev_IR 	<= 0;
	  	end
		else if(!stall_pipe) begin
	     	prev_enables 	<=	enables_temp2;
	     	prev_IR		<= IR;
	  	end
     end

`endprotect

endmodule
