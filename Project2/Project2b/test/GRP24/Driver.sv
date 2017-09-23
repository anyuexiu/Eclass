`include "DriverBase.sv"
class Driver extends DriverBase;
  //mailbox in_box;	// Generator mailbox // QUESTA QUIRK
  typedef mailbox #(Packet) in_box_type;
  in_box_type in_box = new;
  //mailbox out_box;	// Scoreboard mailbox // QUESTA QUIRK
  typedef mailbox #(Packet) out_box_type;
  out_box_type out_box = new;
  //semaphore sem[];	// output port arbitration

  extern function new(string name = "Driver", in_box_type in_box, out_box_type out_box, virtual LC3_io.TB LC3 ,virtual Fetch_Probe_if Fetch); //Fetch passed for DriverBase
  extern virtual task start();
endclass

function Driver::new(string name= "Driver", in_box_type in_box, out_box_type out_box, virtual LC3_io.TB LC3 ,virtual Fetch_Probe_if Fetch);
  super.new(name, LC3, Fetch);
  this.in_box = in_box;
  this.out_box = out_box;
endfunction

task Driver::start(); 
	int packets_sent = 0;
	$display ($time, "ns:  [DRIVER] Driver Started");
    fork
	    forever
	    begin
	      		in_box.get(pkt2send); // grab the packet in the q
			packets_sent++;
		  	$display ($time, "[DRIVER] Sending in new packet BEGIN");
		  	this.payload_Instr_dout = pkt2send.Instr_dout;
		  	this.payload_complete_data = 1'b1;  //This is always 1 
		  	this.payload_complete_Instr = 1'b1; //This is always 1
		  	this.payload_Data_dout = 	pkt2send.Data_dout;  
      			
				
 	     		send();
	 		
			$display ($time, "ns:  [DRIVER] Sending in new packet END");
			$display ($time, "ns:  [DRIVER] Number of packets sent = %d", packets_sent);
	     		out_box.put(pkt2send);
			$display ($time,  "ns:  [DRIVER] The number of Packets in the Generator Mailbox = %d", in_box.num());
			
			
			if(in_box.num() == 0)
			begin
				break;
			end
		  	@(LC3.cb);
	    end
	join_none	
endtask

