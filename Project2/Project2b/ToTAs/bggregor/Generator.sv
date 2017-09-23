class Generator;
	string  name;		// unique identifier
	Packet  pkt2send;	// stimulus Packet object
	
	//mailbox out_box;// QUESTA QUIRK
    typedef mailbox #(Packet) in_box_type;
	in_box_type in_box;
	
	int		num_packets;
	int 	number_of_runs;
	extern function new(string name = "Generator", int number_of_runs);
	extern virtual task gen();
	extern virtual task start();
endclass

function Generator::new(string name="Generator", int number_of_runs);
	this.name = name;
	this.pkt2send = new();
	this.in_box = new;
	this.num_packets = 0;
	this.number_of_runs = number_of_runs;
			//if (TRACE_ON) $display("[TRACE]%0d %s:%m", $time, name);
			//this.out_box = new[16]; // (ASIDE A): this is for the case when you have multiple ports needing 
    					  	// data in an independent manner .. 
			//foreach(this.out_box[i]) // this is for (ASIDE A)
		    //this.out_box[i] = new();
endfunction

task Generator::gen();
	  
	pkt2send.name = $psprintf("Packet[%0d]", num_packets++);
	if (!pkt2send.randomize()) 
	begin
		$display(" \n%m\n[ERROR]%0d gen(): Randomization Failed!", $time);
		$finish;	
	end
//	pkt2send.enable = $urandom_range(1);		// BG - Changed to always 1
//	$display ($time, " [GENERATOR] Packet Generation done .. Now to put it in Driver mailbox");	

endtask

task Generator::start();
	  $display ($time, "Generator Started");
	  fork
		  for (int i=0; i<number_of_runs || number_of_runs <= 0; i++) 
		  begin
pkt2send.pkt_cnt++; //$display("pkt2send.pkt_cnt=%d",pkt2send.pkt_cnt);		// USED IN COVERAGE TO TRACK
			  gen();
//			  $display($time, " Creating Packet Number %d ", i);
			  begin 
			      Packet pkt = new pkt2send; // what exactly does this do?
				  in_box.put(pkt);
			  end
		  end
//		  $display($time, " Data Generation Finished");
      join_none
endtask
