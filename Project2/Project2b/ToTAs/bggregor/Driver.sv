`include "DriverBase.sv"
class Driver extends DriverBase;

					logic [15:0] IR_q[$];			// ADDED FOR DRIVER SUPPORT - BG
					
  //mailbox in_box;	// Generator mailbox // QUESTA QUIRK
  typedef mailbox #(Packet) in_box_type;
  in_box_type in_box = new;
  //mailbox out_box;	// Scoreboard mailbox // QUESTA QUIRK
  typedef mailbox #(Packet) out_box_type;
  out_box_type out_box = new;
  
  typedef mailbox  #(Packet) in_box_type_sb;
  in_box_type_sb in_box_sb = new;
  
	
	
  //semaphore sem[];	// output port arbitration

  extern function new(string name = "Driver", in_box_type in_box, out_box_type out_box, virtual LC3_io.TB LC3, in_box_type_sb in_box_sb);
  extern virtual task start();
endclass

function Driver::new(string name="Driver", in_box_type in_box, out_box_type out_box, virtual LC3_io.TB LC3, in_box_type_sb in_box_sb );
  super.new(name, LC3);
  //this.sem = sem;
  this.in_box = in_box;
  this.out_box = out_box;
  this.in_box_sb = in_box_sb;
endfunction

task Driver::start();
	reg	[6:0]	control_in_temp;
	int get_flag = 10; 
	int packets_sent = 0;

//	***************************	CUT BELOW HERE	 *****************************			//	
	reg [15:0] prev_IR = 16'h0000;
	reg [15:0] curr_IR = 16'h0000;
	reg [15:0] IR_Exec = 16'h0000;
//	***************************	CUT ABOVE HERE	 *****************************			//		
	
	$display ($time, "Driver Started");

repeat(2) IR_q.push_back(16'h5020);			//IR_q.push_back(16'h);

//IR_q.push_back(16'h6a29);
//IR_q.push_back(16'hc729);


//IR_q.push_back(16'he000);
//IR_q.push_back(16'h7000);

    fork
	    forever
	    begin   
	    
	      	in_box.get(pkt2send); // grab the packet in the q
//do not need anymore		in_box_sb.get(pkt1);
 in_box_sb.get(pkt1);
			packets_sent++;


//	***************************	CUT BELOW HERE	 *****************************			//
			if(IR_q.size == 0) begin	// check if queue is empty
				IR_Exec = prev_IR;
				prev_IR = curr_IR;
				curr_IR = {pkt2send.op,pkt2send.dr,pkt2send.src1,pkt2send.mode,pkt2send.src2};
//$display("curr_IR = %h and prev_IR = %h and IR_Exec = %h",curr_IR,prev_IR,IR_Exec);
							// First two are special cases
				if(curr_IR[15:12] == 4'b0000 || curr_IR[15:12] == 4'b1100) 	begin
					if(curr_IR == 0) begin
						IR_q.push_front(curr_IR);
	//					$display("BR or JMP and NOOP instrucution...Adding 1...q.size = %h",IR_q.size); 
					end
					else begin
						repeat(4) IR_q.push_front(curr_IR);	// BR and JMP instructions
						if(prev_IR[15:13]==3'b101)
							IR_q.push_front(curr_IR);
						if(prev_IR[13]==1 && prev_IR[15:12] != 4'he)
							IR_q.push_front(curr_IR);
						if(IR_Exec[15:13] == 3'b001 || IR_Exec[15:13] == 3'b011) begin	
							repeat(1) IR_q.push_front(curr_IR);	// LD, LDR, ST, and STR instructions
	//						$display("LD,LDR,ST,or STR instrucution...Adding 1...q.size = %h",IR_q.size); 
						end

						if(IR_Exec[15:13] == 3'b101) 	begin			
								repeat(2) IR_q.push_back(curr_IR);	// LDI and STI instructions
	//						$display("LDI or STI instrucution...Adding 2...q.size = %h",IR_q.size); 
						end
					prev_IR = curr_IR;

					end
				end
				else begin

					if(IR_Exec[15:13] == 3'b001 || IR_Exec[15:13] == 3'b011) begin	
						repeat(2) IR_q.push_front(curr_IR);	// LD, LDR, ST, and STR instructions
	//					$display("LD,LDR,ST,or STR instrucution...Adding 2...q.size = %h",IR_q.size); 
					end

					if(IR_Exec[15:13] == 3'b101) 	begin			
						repeat(3) IR_q.push_back(curr_IR);	// LDI and STI instructions
	//					$display("LDI or STI instrucution...Adding 3...q.size = %h",IR_q.size); 
					end

				end


					// Ensure current packet went in
			if(IR_q.size == 0) IR_q.push_back(curr_IR);

			end

			



			if(pkt2send.complete_instr == 1)
			this.payload_Instr_dout		= IR_q.pop_front;
//	***************************	CUT ABOVE HERE	 *****************************			//


			//this.payload_complete_data	= pkt2send.complete_data;
			this.payload_complete_instr	= 1'b1; //pkt2send.complete_instr;
			//this.payload_Data_dout		= pkt2send.Data_dout;
	
		
	      	//sem[this.da].get(1);
 	     	send();
//	 		$display ($time, "[DRIVER] Sending in new packet END");
//			$display ($time, "[DRIVER] Number of packets sent = %d", packets_sent);
	     	out_box.put(pkt2send);
//			$display ($time,  "[DRIVER] The number of Packets in the Generator Mailbox = %d", in_box.num());
			if(in_box.num() == 0)
			begin
				break;
			end
		  	@(LC3.cb);
	      //sem[this.da].put(1);
	    end
	join_none	
//	$display ($time,  "[DRIVER] DRIVER Forking of process is finished");	
  //join_none CHANGED AUG 7
endtask

