
class Scoreboard;
	string   name;				// unique identifier
	
  	typedef mailbox #(Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers
	
	extern function new(string name = "Scoreboard", out_box_type driver_mbox = null);
endclass

function Scoreboard::new(string name = "Scoreboard", out_box_type driver_mbox = null);
	this.name = name;
	if (driver_mbox == null) 
		driver_mbox = new();
	this.driver_mbox = driver_mbox;
endfunction

