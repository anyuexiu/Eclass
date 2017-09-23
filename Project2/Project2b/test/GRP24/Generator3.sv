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


						else if(i==8)
						begin
						pkt2send.Instr_dout =  16'he02e;      
						pkt2send.Data_dout  = 16'd900;
						end
						

						else if(i==9)
						begin
						pkt2send.Instr_dout =  16'h1000;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						
						
						
						else if(i==10)
						begin
						pkt2send.Instr_dout =  16'he22e;      
						pkt2send.Data_dout  = 16'd900;
						end
						

						
						else if(i==11)
						begin
						pkt2send.Instr_dout =  16'h1241;      
						pkt2send.Data_dout  = 16'd950;
						end					
						
	
						
						else if(i==12)
						begin
						pkt2send.Instr_dout =  16'he42e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						
						
						else if(i==13)
						begin
						pkt2send.Instr_dout =  16'h1482;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						
						
						else if(i==14)
						begin
						pkt2send.Instr_dout =  16'he62e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						
						
						else if(i==15)
						begin
						pkt2send.Instr_dout =  16'h16c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
						
						
						else if(i==16)
						begin
						pkt2send.Instr_dout =  16'he82e;      
						pkt2send.Data_dout  = 16'd900;
						end

						else if(i== 17)
						begin
						pkt2send.Instr_dout =  16'h1904;     
						pkt2send.Data_dout  = 16'd900;
						end
						
																
						
						else if(i== 18)
						begin
						pkt2send.Instr_dout =  16'hea2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 19)
						begin
						pkt2send.Instr_dout =  16'h1b45;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 20)
						begin
						pkt2send.Instr_dout =  16'hec2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 21)
						begin
						pkt2send.Instr_dout =  16'h1d86;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 22)
						begin
						pkt2send.Instr_dout =  16'hee2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 23)
						begin
						pkt2send.Instr_dout =  16'h1fc7;     
						pkt2send.Data_dout  = 16'd950;
						end



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
 
  		
	
