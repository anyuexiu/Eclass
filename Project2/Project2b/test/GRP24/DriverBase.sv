
class DriverBase;
	virtual   LC3_io.TB LC3;	
	virtual Fetch_Probe_if Fetch ;
	string    name;		
	Packet    pkt2send;	

	reg	[15:0] payload_Instr_dout;
	reg	 payload_complete_data;
	reg      payload_complete_Instr;
	reg      payload_Data_dout;

	extern function new(string name = "DriverBase", virtual LC3_io.TB LC3 ,virtual Fetch_Probe_if Fetch);  //Fetch to be passed for instrmem_rd signals
	extern virtual task send();
	extern virtual task send_payload();
	
endclass

function DriverBase::new(string name = "DriverBase", virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch);
	this.name   = name;
	this.LC3 = LC3;
	this.Fetch =  Fetch;
endfunction

task DriverBase::send();
	send_payload();
endtask

task DriverBase::send_payload();
	$display($time, "ns:  [DRIVER] Sending Payload Begin");

////////////////////////////////////instrmem_rd should be high for instruction to be fetched
	
	if(Fetch.cb.instrmem_rd == 1'b1)
			begin
			
	
	LC3.cb.Instr_dout				<=	payload_Instr_dout;
	LC3.cb.complete_data			<=	payload_complete_data;
	LC3.cb.complete_instr			<=	payload_complete_Instr;
	LC3.cb.Data_dout				<=	payload_Data_dout;
			end
	
		
endtask
