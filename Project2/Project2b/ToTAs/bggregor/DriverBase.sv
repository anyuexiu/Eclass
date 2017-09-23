
class DriverBase;
	virtual   LC3_io.TB LC3;	// interface signal   // why???
	string    name;		// unique identifier
	Packet    pkt2send;		// stimulus Packet object
	Packet 	pkt1;
		
logic [0:0] complete_data;
	reg	[16-1:0]	payload_Instr_dout;
	reg	[0:0]		payload_complete_data, payload_complete_instr;
	reg	[16-1:0]	payload_Data_dout;

	extern function new(string name = "DriverBase", virtual LC3_io.TB LC3);
	extern virtual task send();
	extern virtual task send_payload();
endclass

function DriverBase::new(string name="DriverBase", virtual LC3_io.TB LC3);
	this.name   = name;
	this.LC3 = LC3;
endfunction

task DriverBase::send();
	send_payload();
endtask

task DriverBase::send_payload();
//	$display($time, "Sending Payload Begin");
	//LC3.cb.enable_LC3 	<= 	1'b1;
	
	LC3.cb.Instr_dout	<=	payload_Instr_dout;
	//LC3.cb.complete_data	<=	payload_complete_data;
	LC3.cb.complete_instr	<=	payload_complete_instr;
	//LC3.cb.DMem_dout	<=	payload_Data_dout;
			
	
	// This is where we would be sending the data out into a queue for the Scoreboard
	
endtask
