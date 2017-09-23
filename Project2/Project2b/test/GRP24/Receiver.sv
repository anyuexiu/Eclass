`include "ReceiverBase.sv"
class Receiver extends ReceiverBase;

  	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	rx_out_box;		// mailbox for Packet objects To Scoreboard 
   	

	extern function new(string name = "Receiver",rx_box_type rx_out_box, virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
   	extern virtual task start();
endclass

//Fetch , Decode , Exe , WB , Con passed along with Execute interface

function Receiver::new(string name = "Receiver", rx_box_type rx_out_box, virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
  
  super.new(name, LC3,Fetch,Decode,Exe,WB,Con);
  this.rx_out_box = rx_out_box;

endfunction

task Receiver::start();
	$display($time, "ns:  [RECEIVER]  RECEIVER STARTED");
	@ (LC3.cb); // to cater to the one cycle delay in the pipeline
	fork
		forever
		begin
			
			@ (LC3.cb);
			recv();
			rx_out_box.put(pkt_cmp);
			$display($time, "ns:   [RECEIVER -> GETPAYLOAD]   Payload Obtained");
		end	
	join_none
endtask

