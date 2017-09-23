class Generator;

string name;
Packet pkt2send;

typedef mailbox #(Packet) in_box_type;
in_box_type in_box;

int packet_number;
int number_packets;

extern function new(string name = "Generator", int number_packets); 
extern virtual task gen();
extern virtual task start();

endclass



function Generator::new(string name = "Generator", int number_packets);   ///// number of packets sent from tb file 
	this.name = name;
	this.pkt2send = new();
	this.in_box = new;
	this.packet_number = 0 ;
	this.number_packets = number_packets;
endfunction

task Generator::gen();

pkt2send.name = $psprintf("Packet[%0d]", packet_number++);

if(!pkt2send.randomize())
	begin
		$display(" \n %m \n [ERROR] %0d gen(): Randomization Failed !",$time);
		$finish;
//////////////////////////////////////////Look at the enable thingi////////////////
	end

endtask

task Generator::start();  /////////////////this is called in the Execute.tb.sv 
	$display ($time , "ns: [GENERATOR] Generator Started");
	
	
		fork
			  for(int i=0; i<number_packets  || number_packets <= 0; i++)
  				begin 
				
  					//First the directed test inputs are given
						if(i<8)		
						begin
						pkt2send.Instr_dout =  16'h5020 + (i)*16'h240;      ///To initialize R0 to R7 to 0 using AND R# R# #0
						pkt2send.Data_dout  = 16'h1111 + (i) * 16'h1111;
						end

				
						
						else if(i== 08)
						begin
						pkt2send.Instr_dout =  16'h0000;      
						pkt2send.Data_dout  = 16'h0000;
						end
						
						else if(i== 11)
						begin
						pkt2send.Instr_dout =  16'hffff;      
						pkt2send.Data_dout  = 16'hffff;
						end
						
						else if(i== 12)
						begin
						pkt2send.Instr_dout =  16'hff00;      
						pkt2send.Data_dout  = 16'hff00;
						end
						
						else if(i== 13)
						begin
						pkt2send.Instr_dout =  16'hf0f0;      
						pkt2send.Data_dout  = 16'hf0f0;
						end
						
						
						else if(i==14)
						begin
						pkt2send.Instr_dout =  16'b1100110011001100;     
						pkt2send.Data_dout  = 16'b1100110011001100;
						end
						
						else if(i== 17)
						begin
						pkt2send.Instr_dout =  16'b1010101010101010;      
						pkt2send.Data_dout  = 16'b1010101010101010;
						end

						
							
						/*else if(i==23)
						begin
						pkt2send.Instr_dout =  16'hea26;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==24)
						begin
						pkt2send.Instr_dout =  16'h1345;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
					
						else if(i==25)
						begin
						pkt2send.Instr_dout =  16'h222e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==26)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==17)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==18)
						begin
						pkt2send.Instr_dout =  16'h1241;      
						pkt2send.Data_dout  = 16'd950;
						end

						
						else if(i==25)
						begin
						pkt2send.Instr_dout =  16'h1545;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==26)
						begin
						pkt2send.Instr_dout =  16'h1564;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==27)
						begin
						pkt2send.Instr_dout =  16'h202e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==28)
						begin
						pkt2send.Instr_dout =  16'h1000;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==29)
						begin
						pkt2send.Instr_dout =  16'h1000;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==30)
						begin
						pkt2send.Instr_dout =  16'h1000;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
						
						else if(i== 31)
						begin
						pkt2send.Instr_dout =  16'h1000;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==19)
						begin
						pkt2send.Instr_dout =  16'h5283;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==20)
						begin
						pkt2send.Instr_dout =  16'he41e;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==21)
						begin
						pkt2send.Instr_dout =  16'h52c2;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						else if(i==22)
						begin
						pkt2send.Instr_dout =  16'h16e3;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==23)
						begin
						pkt2send.Instr_dout =  16'hb6e3;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==24)
						begin
						pkt2send.Instr_dout =  16'h16e3;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==25)
						begin
						pkt2send.Instr_dout =  16'h1ae3;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==26)
						begin
						pkt2send.Instr_dout =  16'h1d47;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==27)
						begin
						pkt2send.Instr_dout =  16'h3d47;      
						pkt2send.Data_dout  = 16'd950;
						end */
						else
						gen();                         ////// good declaration practice .. object declared innside for loop ... also no arrays or queues between threads 
						
						begin
							Packet pkt = new pkt2send; // copy of pkt2send in the new function , the default value for in_box is 0 
							in_box.put(pkt);    // put blocks till box is full .. in this case its unlimited :) 
						end
  				end
  				$display($time, "ns: [GENERATOR] Generation Finished Creating %d Packets ", number_packets);
  		join_none
 endtask
 
  		
	
