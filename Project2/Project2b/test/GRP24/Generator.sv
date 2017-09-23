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
						pkt2send.Instr_dout =  16'h202e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==9)
						begin
						pkt2send.Instr_dout =  16'h1000;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==10)
						begin
						pkt2send.Instr_dout =  16'h1000;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==11)
						begin
						pkt2send.Instr_dout =  16'h1000;      
						pkt2send.Data_dout  = 16'd950;
						end
						
							
						
						else if(i==12)
						begin
						pkt2send.Instr_dout =  16'h222e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==13)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==14)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==15)
						begin
						pkt2send.Instr_dout =  16'h1241;      
						pkt2send.Data_dout  = 16'd950;
						end					
						
						
						else if(i==16)
						begin
						pkt2send.Instr_dout =  16'h242e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==17)
						begin
						pkt2send.Instr_dout =  16'h1482;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==18)
						begin
						pkt2send.Instr_dout =  16'h1482;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==19)
						begin
						pkt2send.Instr_dout =  16'h1482;      
						pkt2send.Data_dout  = 16'd950;
						end

						
						
						else if(i==20)
						begin
						pkt2send.Instr_dout =  16'h262e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==21)
						begin
						pkt2send.Instr_dout =  16'h16c3;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==22)
						begin
						pkt2send.Instr_dout =  16'h16c3;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==23)
						begin
						pkt2send.Instr_dout =  16'h16c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
												
						
						else if(i==24)
						begin
						pkt2send.Instr_dout =  16'h282e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==25)
						begin
						pkt2send.Instr_dout =  16'h1904;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==26)
						begin
						pkt2send.Instr_dout =  16'h1904;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==27)
						begin
						pkt2send.Instr_dout =  16'h1904;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
												
						
						else if(i==28)
						begin
						pkt2send.Instr_dout =  16'h2a2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==29)
						begin
						pkt2send.Instr_dout =  16'h1b45;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==30)
						begin
						pkt2send.Instr_dout =  16'h1b45;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==31)
						begin
						pkt2send.Instr_dout =  16'h1b45;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						
						else if(i==32)
						begin
						pkt2send.Instr_dout =  16'h2c2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==33)
						begin
						pkt2send.Instr_dout =  16'h1d86;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==34)
						begin
						pkt2send.Instr_dout =  16'h1d86;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==35)
						begin
						pkt2send.Instr_dout =  16'h1d86;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						
						else if(i==36)
						begin
						pkt2send.Instr_dout =  16'h2e2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==37)
						begin
						pkt2send.Instr_dout =  16'h1fc7;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 38)
						begin
						pkt2send.Instr_dout =  16'h1fc7;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 39)
						begin
						pkt2send.Instr_dout =  16'h1fc7;      
						pkt2send.Data_dout  = 16'd950;
						end
						

						else if(i==40)
						begin
						pkt2send.Instr_dout =  16'h602e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==41)
						begin
						pkt2send.Instr_dout =  16'h5000;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==42)
						begin
						pkt2send.Instr_dout =  16'h5000;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==43)
						begin
						pkt2send.Instr_dout =  16'h5000;      
						pkt2send.Data_dout  = 16'd950;
						end
						
							
						
						else if(i== 44)
						begin
						pkt2send.Instr_dout =  16'h622e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==45)
						begin
						pkt2send.Instr_dout =  16'h5241;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==46)
						begin
						pkt2send.Instr_dout =  16'h5241;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==47)
						begin
						pkt2send.Instr_dout =  16'h5241;      
						pkt2send.Data_dout  = 16'd950;
						end					
						
						
						else if(i==48)
						begin
						pkt2send.Instr_dout =  16'h642e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 49)
						begin
						pkt2send.Instr_dout =  16'h5482;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 50)
						begin
						pkt2send.Instr_dout =  16'h5482;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 51)
						begin
						pkt2send.Instr_dout =  16'h5482;      
						pkt2send.Data_dout  = 16'd950;
						end

						
						
						else if(i==52)
						begin
						pkt2send.Instr_dout =  16'h662e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==53)
						begin
						pkt2send.Instr_dout =  16'h56c3;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==54)
						begin
						pkt2send.Instr_dout =  16'h56c3;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==55)
						begin
						pkt2send.Instr_dout =  16'h56c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
												
						
						else if(i== 56)
						begin
						pkt2send.Instr_dout =  16'h682e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 57)
						begin
						pkt2send.Instr_dout =  16'h5904;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 58)
						begin
						pkt2send.Instr_dout =  16'h5904;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 59)
						begin
						pkt2send.Instr_dout =  16'h5904;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
												
						
						else if(i== 60)
						begin
						pkt2send.Instr_dout =  16'h6a2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 61)
						begin
						pkt2send.Instr_dout =  16'h5b45;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 62)
						begin
						pkt2send.Instr_dout =  16'h5b45;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 63)
						begin
						pkt2send.Instr_dout =  16'h5b45;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						
						else if(i== 64)
						begin
						pkt2send.Instr_dout =  16'h6c2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 65)
						begin
						pkt2send.Instr_dout =  16'h5d86;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 66)
						begin
						pkt2send.Instr_dout =  16'h5d86;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 67)
						begin
						pkt2send.Instr_dout =  16'h5d86;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						
						else if(i== 68)
						begin
						pkt2send.Instr_dout =  16'h6e2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 69)
						begin
						pkt2send.Instr_dout =  16'h5fc7;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 70)
						begin
						pkt2send.Instr_dout =  16'h5fc7;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 71)
						begin
						pkt2send.Instr_dout =  16'h5fc7;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
						else if(i== 72)
						begin
						pkt2send.Instr_dout =  16'ha02e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==73)
						begin
						pkt2send.Instr_dout =  16'h5000;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==74)
						begin
						pkt2send.Instr_dout =  16'h5000;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==75)
						begin
						pkt2send.Instr_dout =  16'h5000;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==76)
						begin
						pkt2send.Instr_dout =  16'h5000;      
						pkt2send.Data_dout  = 16'd950;
						end
						
							
						
						else if(i== 77)
						begin
						pkt2send.Instr_dout =  16'ha22e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==78)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==79)
						begin
						pkt2send.Instr_dout =  16'h1241;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==80)
						begin
						pkt2send.Instr_dout =  16'h1241;      
						pkt2send.Data_dout  = 16'd950;
						end					
						
						
						else if(i==81)
						begin
						pkt2send.Instr_dout =  16'h1241;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						
						else if(i== 82)
						begin
						pkt2send.Instr_dout =  16'ha42e;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 83)
						begin
						pkt2send.Instr_dout =  16'h5482;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 84)
						begin
						pkt2send.Instr_dout =  16'h5482;      
						pkt2send.Data_dout  = 16'd950;
						end

						
				               else if(i==85)
						begin
						pkt2send.Instr_dout =  16'h5482;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i==86)
						begin
						pkt2send.Instr_dout =  16'h5482;     
						pkt2send.Data_dout  = 16'd900;
						end
								
						else if(i==87)
						begin
						pkt2send.Instr_dout =  16'ha62e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i==88)
						begin
						pkt2send.Instr_dout =  16'h56c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
						else if(i==89)
						begin
						pkt2send.Instr_dout =  16'h56c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
						else if(i==90)
						begin
						pkt2send.Instr_dout =  16'h56c3;      
						pkt2send.Data_dout  = 16'd950;
						end						

						else if(i==91)
						begin
						pkt2send.Instr_dout =  16'h56c3;      
						pkt2send.Data_dout  = 16'd950;
						end						
																			
						
						else if(i== 92)
						begin
						pkt2send.Instr_dout =  16'ha82e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 93)
						begin
						pkt2send.Instr_dout =  16'h5904;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 94)
						begin
						pkt2send.Instr_dout =  16'h5904;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 95)
						begin
						pkt2send.Instr_dout =  16'h5904;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 96)
						begin
						pkt2send.Instr_dout =  16'h5904;      
						pkt2send.Data_dout  = 16'd950;
						end
						
												
						
						else if(i== 97)
						begin
						pkt2send.Instr_dout =  16'haa2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 98)
						begin
						pkt2send.Instr_dout =  16'h5b45;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 99)
						begin
						pkt2send.Instr_dout =  16'h5b45;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 100)
						begin
						pkt2send.Instr_dout =  16'h5b45;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 101)
						begin
						pkt2send.Instr_dout =  16'h5b45;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
						
						else if(i== 102)
						begin
						pkt2send.Instr_dout =  16'hac2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 103)
						begin
						pkt2send.Instr_dout =  16'h5d86;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 104)
						begin
						pkt2send.Instr_dout =  16'h5d86;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 105)
						begin
						pkt2send.Instr_dout =  16'h5d86;      
						pkt2send.Data_dout  = 16'd950;
						end
												
						else if(i== 106)
						begin
						pkt2send.Instr_dout =  16'h5d86;      
						pkt2send.Data_dout  = 16'd950;
						end
												
						
						else if(i== 107)
						begin
						pkt2send.Instr_dout =  16'hae2e;      
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 108)
						begin
						pkt2send.Instr_dout =  16'h5fc7;     
						pkt2send.Data_dout  = 16'd950;
						end
						
						else if(i== 109)
						begin
						pkt2send.Instr_dout =  16'h5fc7;     
						pkt2send.Data_dout  = 16'd900;
						end
						
						else if(i== 110)
						begin
						pkt2send.Instr_dout =  16'h5fc7;      
						pkt2send.Data_dout  = 16'd950;
						end						
						
						else if(i== 111)
						begin
						pkt2send.Instr_dout =  16'h5fc7;      
						pkt2send.Data_dout  = 16'd950;
						end
						
						
						
						
						
						
						
						
						
						/*else if(i== 32)
						begin
						pkt2send.Instr_dout =  16'h0000;      
						pkt2send.Data_dout  = 16'h0000;
						end
						
						else if(i==29)
						begin
						pkt2send.Instr_dout =  16'hffff;      
						pkt2send.Data_dout  = 16'hffff;
						end
						
						else if(i== 18)
						begin
						pkt2send.Instr_dout =  16'hff00;      
						pkt2send.Data_dout  = 16'hff00;
						end
						
						else if(i== 19)
						begin
						pkt2send.Instr_dout =  16'hf0f0;      
						pkt2send.Data_dout  = 16'hf0f0;
						end
						
						
						else if(i==18)
						begin
						pkt2send.Instr_dout =  16'b1100110011001100;     
						pkt2send.Data_dout  = 16'b1100110011001100;
						end
						
						else if(i==21)
						begin
						pkt2send.Instr_dout =  16'b1010101010101010;      
						pkt2send.Data_dout  = 16'b1010101010101010;
						end

						
							
						else if(i==23)
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
 
  		
	
