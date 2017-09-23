`include "data_defs.v"
module Controller_Pipeline(	clock, reset, IR, bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2, complete_data, complete_instr,
							Instr_dout, NZP, psr, IR_Exec,
							enable_fetch, enable_decode, enable_execute, enable_writeback, enable_updatePC, 
							br_taken, mem_state
						);

	input			clock, reset;	
	input			complete_data, complete_instr;
	input	[15:0]	IR, IR_Exec;
	input	[2:0]	psr, NZP;
	input	[15:0]	Instr_dout;
	output			bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2;
	output			enable_fetch, enable_decode, enable_execute, enable_writeback, enable_updatePC;
	output	[1:0]	mem_state;
	output			br_taken;
	
	reg		[1:0]	mem_state;
	reg		[4:0]	enables;
	
	reg		[4:0]	prev_enables;
	reg		[4:0]	state, next_state;
	
	reg				bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2;
	reg		[15:0]	prev_IR;
	reg				stall_pipe;
	reg		[2:0]	bubble_count;
	wire			control_instr_dout;
	wire	[4:0] 	enables_temp;
	reg				inc_count, reset_count;
	reg				br_taken;
	
	reg		[1:0]	mem_ctrl_Cstate, mem_ctrl_Nstate;
	
`protect
	wire			deassert_enable_writeback, deassert_enable_writeback1, deassert_enable_writeback2;
	reg				processing_branch;
	wire    [2:0]   sr_store;
	assign 	enables_temp = (deassert_enable_writeback==0)?enables: {enables[4:1],1'b0};
	assign	{enable_updatePC, enable_fetch, enable_decode, enable_execute, enable_writeback}	= (stall_pipe)? 5'b0: enables_temp;

	`ifdef BUG10DONEANDDUSTEDWITH
	assign	control_instr_dout = ((Instr_dout[13:12] == 2'b00) && (Instr_dout != 16'h0000))?1'b1:1'b0;
	`else
	assign	control_instr_dout = ((Instr_dout[13:12] == 2'b00))?1'b1:1'b0; // BUG10 ... DIFFICULTY 2
    `endif
	`ifdef BUG11DONEANDDUSTEDWITH
    assign  sr_store   = IR[11:9]; 
    `else
    assign  sr_store   = IR[2:0] ; // BUG11 DIFFICULTY 2
	`endif
	
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
	
	always @ (posedge clock)
	begin
		if(reset_counter)
		begin
			bubble_count <= 0; 
		end
		else if (!stall_pipe && inc_count)
		begin
			bubble_count <= bubble_count + 1;
		end
	end
	
	always @ (*)
	begin
		case(state)	
			5'd0:	begin		// this is the reset state 
						next_state		<=	1;
						//mem_state		<=	3;	
						bypass_alu_1	<=	0;	bypass_alu_2	<= 0; 	
						bypass_mem_1	<=0; bypass_mem_2	<= 0;
						processing_branch = 0;
						inc_count <= 0;
						reset_count <= 0;
						br_taken <= 0;
						if(complete_instr)
						begin
							enables		<=	5'b11000;	
							next_state		<=	1;
						end
						else 
						begin
							enables		<= 5'b01000; // do not update the PC until we get the instruction for the old PC	
							next_state		<=	0;
						end
//						enables			<=	5'b11000;	
						end
			5'd1:	begin	
						if(complete_instr)
						begin
							if(control_instr_dout) // check for Control Instruction
							begin
								enables		<= 5'b00100;
								processing_branch <= 1;
								inc_count = 1; reset_count = 0;
							end	
							else // for the rest of the instructions
							begin
								enables		<=	5'b11100;	// go ahead and decode the stuff that was fetched at the reset PC 
								inc_count = 0; reset_count = 0;
								processing_branch <= 0;
							end
						end
						else 
						begin
							enables		<= 5'b01100; 	
							inc_count = 0; reset_count = 0;
							processing_branch <= 0;
						end
						next_state		<=	2;
						//mem_state		<=	3;	
						bypass_alu_1	<=	0;	bypass_alu_2	<= 0; 	
						bypass_mem_1	<=0; bypass_mem_2	<= 0;
						br_taken <= 0;
					end
			5'd2:	begin		
						
 						next_state	<=	2;
						//mem_state 	<= 	3;

						/*******************************************************************************************
								
									CREATION OF ENABLE_EXECUTE AND ENABLE_WRITEBACK TO CATER FOR NO-OP
						
						*******************************************************************************************/						
						
						if(IR == 16'h0000)	begin
							enables[1:0] = {1'b0, prev_enables[1]};
						end
						else begin
							enables[1:0] = {prev_enables[2:1]};
						end
						/*******************************************************************************************
								
									CREATION OF ENABLE_[UPDATEPC/FETCH/DECODE] WHILE CATERING FOR BRANCH/JMP
						
						*******************************************************************************************/						
						`ifdef BUG42DONEANDDUSTEDWITH
						if((complete_instr || processing_branch) && !stall_pipe) begin 
						`else 
						if(complete_instr && !stall_pipe) begin 
						`endif
							if(!control_instr_dout) begin // check to see if the value out of mem is a control instruction or not 
								enables[4:2] = {1'b1, 1'b1, prev_enables[3]};
								reset_count = 0; inc_count = 0;
								br_taken = 0;
								processing_branch <= 0;
							end
							else begin 
							// control instruction .. now need to make sure that we wait 3 cycles before asserting en_fetch
							// and 2 cycles before asserting en_updatePC
								`ifdef BUG43DONEANDDUSTEDWITH
								if(bubble_count ==3'd2) begin 	// BUG43 DIFFICULTY 2
								`else
								if(bubble_count ==3'd3) begin 	
								`endif									
									// need to make branch_taken high
									processing_branch <= 1;
									`ifdef BUG12DONEANDDUSTEDWITH
									if(|(psr & NZP)) begin 
										br_taken = 1;
										`ifdef BUG45DONEANDDUSTEDWITH
										enables[4:2] = {1'b1, 1'b0, prev_enables[3]}; 
										`else
										enables[4:2] = {1'b1, 1'b1, prev_enables[3]}; // BUG45 DIFFICULY 2
										`endif
                                    end
                                    // JMP BUG END 
									`else 
                                    if(Instr_dout[15:12] == 4'b1100) begin
										$display($time, "  JMP SEEN");
                                        if(|(psr & {1'b0, NZP[1], NZP[0]})) begin// BUG12 DIFFICULTY 3 
											$display($time, " JMP BR TAKEN");
    										br_taken = 1;
											`ifdef BUG45DONEANDDUSTEDWITH
											enables[4:2] = {1'b1, 1'b0, prev_enables[3]}; 
											`else
											enables[4:2] = {1'b1, 1'b1, prev_enables[3]}; // BUG45 DIFFICULY 2
											`endif
										end
                                        else begin
										    br_taken = 0;
										    `ifdef BUG13DONEANDDUSTEDWITH
											enables[4:2] = {1'b0, 1'b0, prev_enables[3]}; // change "LINE B" AS WELL .. LINE A ..
											`else 
											enables[4:2] = {1'b1, 1'b0, prev_enables[3]};
											`endif
                                        end
                                    end
                                    else if(|(psr & NZP))begin
										$display($time, "  BR TAKEN FOR BRANCH INSTR");
										br_taken = 1;
										`ifdef BUG45DONEANDDUSTEDWITH
										enables[4:2] = {1'b1, 1'b0, prev_enables[3]}; 
										`else
										enables[4:2] = {1'b1, 1'b1, prev_enables[3]}; // BUG45 DIFFICULY 2
										`endif
                                    end
                                    `endif
									else begin
										br_taken = 0;
										`ifdef BUG13DONEANDDUSTEDWITH
										enables[4:2] = {1'b0, 1'b0, prev_enables[3]};
										`else
										enables[4:2] = {1'b1, 1'b0, prev_enables[3]}; // BUG13 DIFFICULTY 3 .. 
										`endif
									end
									reset_count = 0; inc_count = 1;
								end
								`ifdef BUG43DONEANDDUSTEDWITH
								else if(bubble_count == 3'd3)begin // BUG43 DIFFICULTY 2
								`else
								else if(bubble_count == 3'd4)begin // the updated PC value is now going to be fetched
								`endif
									enables[4:2] = {1'b1, 1'b1, prev_enables[3]};
									reset_count = 1; inc_count = 0; // normal operations resume until next control instruction
									br_taken = 0;
									processing_branch <= 0;
								end
								else begin
									reset_count = 0; inc_count = 1;
									enables[4:2] = {1'b0, 1'b0, prev_enables[3]};
									br_taken = 0;
									processing_branch <= 1;
								end
							end	//if(!control_i
						end
						else begin // complete_instr takes precedence over control or not .. the output from IMem is invalid without complete
							enables[4:2] = {1'b0, 1'b1, 1'b0};
							reset_count = 0; inc_count = 0;
							br_taken = 0;
							processing_branch <= 0;
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
								if(prev_IR[13:12] == 2'b01)
								begin
									bypass_alu_1	<=	1; bypass_alu_2 	<= 	1; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
								end
								else if (prev_IR[13:12] == 2'b10) // LOAD INSTRUCTIONS 
								begin
									if(prev_IR[15:14] == 2'b11)begin // consider LEA to be a ALU type instr
										`ifdef BUG14DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;									
										`else
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	1;bypass_mem_2	<= 	0; // BUG14 DIFFICULTY 1/2									
										`endif
									end
									else begin
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	1;									
									end
								end	
								else begin
									bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
								end
								//else 
								//begin
									//$display("[CONTROLLER] BYPASS FOR SRC2");
								//end								
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
										`ifdef BUG15DONEANDDUSTEDWITH
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	0;bypass_mem_2	<= 	1; // BUG15 DIFFICULTY 1/2									
										`endif
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
										`ifdef BUG16DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	1;bypass_mem_2	<= 	0; // BUG16 DIFFICULTY 1/2									
										`endif
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
							`ifdef BUG44DONEANDDUSTEDWITH
							if ((IR[8:6] == prev_IR[11:9]) && (IR[15:14] == 2'b11)) // BUG24 DIFFICULTY 3 ERRONEOUS ONLY FOR CERTAIN BR CASES
							`else
							if ((IR[8:6] == prev_IR[11:9]))// present src1 = prev DR and instruction is a JMP
							`endif
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
										`ifdef BUG17DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	1; bypass_mem_2	<= 	0; // BUG17 DIFFICULTY 1/2									
										`endif
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
								
													BYPASSES FOR LOAD INSTRUCTIONS
						
						*******************************************************************************************/
						`ifdef BUG39DONEANDDUSTEDWITH
						else if ((IR[13:12] == 2'b10)&&(IR[15:14] == 2'b01)) // Load Instructions
						`else
						else if ((IR[13:12] == 2'b10))
						`endif
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
										`ifdef BUG18DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	1;bypass_mem_2	<= 	0; // BUG18 DIFFICULTY 1/2									
										`endif
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
							`ifdef BUG37DONEANDDUSTEDWITH
							if ((IR[8:6] == prev_IR[11:9]) && (sr_store == prev_IR[11:9])&&(IR[15:14] == 2'b01))// present BaseR = prev DR  && present SR = prev DR
							`else
							if ((IR[8:6] == prev_IR[11:9]) && (sr_store == prev_IR[11:9]))
							`endif
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
										`ifdef BUG19DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	1;bypass_mem_2	<= 	1; // BUG19 DIFFICULTY 1/2									
										`endif
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
							`ifdef BUG38DONEANDDUSTEDWITH
							else if ((IR[8:6] == prev_IR[11:9])&&(IR[15:14] == 2'b01)) // baseR equals prev DR 
							`else
							else if ((IR[8:6] == prev_IR[11:9]))
							`endif
							begin
								if(prev_IR[13:12] == 2'b01)// prev instr was ALU instruction
								begin
									bypass_alu_1	<=	1; bypass_alu_2 	<= 	0; bypass_mem_1	<= 	0; bypass_mem_2	<= 	0;
								end
								else if (prev_IR[13:12] == 2'b10) // prev instr was LOAD instruction
								begin
									if (prev_IR[15:14] == 2'b11) // prev instr LEA 
									begin
										`ifdef BUG20DONEANDDUSTEDWITH
										bypass_alu_1	<=	1; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	1;bypass_mem_2	<= 	0; // BUG20 DIFFICULTY 1/2									
										`endif
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
										`ifdef BUG21DONEANDDUSTEDWITH
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	1;bypass_mem_1	<= 	0;bypass_mem_2	<= 	0;			
										`else						
										bypass_alu_1	<=	0; bypass_alu_2 	<= 	0;bypass_mem_1	<= 	0;bypass_mem_2	<= 	1; // BUG21 DIFFICULTY 1/2									
										`endif
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
	
	always @ (*)
	begin
		case(mem_ctrl_Cstate) 
			2'd3: begin // reset state 
					if(((IR_Exec[13:12] == 2'b11) || ((IR_Exec[13:12] == 2'b10))) && (IR_Exec[15:14] != 2'b11) ) 	
					begin
					// if a Load (!LEA) or Store is seen at the output of the Excute then go ahead  
					// and stall the entire pipeline and begin moving to the correct states
 						stall_pipe <= 1;
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
								`ifdef BUG27DONEANDDUSTEDWITH
								mem_ctrl_Nstate <= 0;
								mem_state <= 0;
								`else
								mem_ctrl_Nstate <= 1; // BUG27
								mem_state <= 1;
								`endif
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
						stall_pipe <= 0;
						mem_state <= 3;
					end
											
				end // end case 2'd3
			2'd1: begin // indirect addressing
					stall_pipe <= 1;
					`ifdef BUG22DONEANDDUSTEDWITH
					if(complete_data)begin
					`else
					if(!complete_data)begin	// BUG 22 DIFFICULTY 2
					`endif
						if((IR_Exec[13:12] == 2'b11)) begin // if its a store indirect
							`ifdef BUG26DONEANDDUSTEDWITH
							mem_ctrl_Nstate <= 2; // go to mem write state
							mem_state <= 2;
							`else
							mem_ctrl_Nstate <= 1; // BUG26 
							mem_state <= 1;
							`endif
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
					`ifdef BUG23DONEANDDUSTEDWITH
					if(complete_data) begin
					`else
					if(!complete_data) begin// BUG 23 DIFFICULTY 2
					`endif
						mem_ctrl_Nstate <= 3;
						mem_state = 3;
						stall_pipe <= 0;
					end
					else begin
						mem_ctrl_Nstate <= 2;
						mem_state = 2;
						stall_pipe = 1;
					end
				end
		
			2'd0: begin
					`ifdef BUG24DONEANDDUSTEDWITH
					if(complete_data) begin
					`else 
					if(!complete_data) begin// BUG 24 DIFFICULTY 2
					`endif
						mem_ctrl_Nstate <= 3;
						mem_state = 3;
						stall_pipe <= 0;
					end
					else begin
						mem_ctrl_Nstate <= 0;
						mem_state = 0;
						stall_pipe = 1;						
					end
				end
			default: begin
						mem_ctrl_Nstate <= 3;
						mem_state = 3;
						stall_pipe <= 0;					
				end
		
		endcase
	
	
	end

	// should not write any to register file for Stores to Memory and for JMP/BR
	`ifdef BUG25DONEANDDUSTEDWITH
	assign	deassert_enable_writeback2 = (complete_data && (mem_ctrl_Cstate == 2'd2))?1:0;
	`else 
	assign	deassert_enable_writeback2 = (complete_data && (mem_ctrl_Cstate == 2'd2))?0:0;
	`endif
	assign	deassert_enable_writeback1 = (bubble_count == 2'd2)?1:0;
	assign	deassert_enable_writeback = (deassert_enable_writeback2 || deassert_enable_writeback1)?1:0; 
	
			
	always @ (posedge clock)
	begin
		if(reset)
		begin
			prev_enables 	<= 0;
			prev_IR 	<= 0;
		end
		else if(!stall_pipe)
		begin
			prev_enables 	<=	enables;
			prev_IR		<= IR;
		end
	end
`endprotect

endmodule
