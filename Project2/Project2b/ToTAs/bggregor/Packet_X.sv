class Packet;

static int pkt_cnt=0;
static int old_dr;
rand	reg	[3:0]	chose;	// 32 options

reg   [15:0]     data ;
reg   [0:0]	 rrdy ;
reg   [0:0]	 rdrdy;
reg   [0:0]	 wacpt;
reg   [0:0]	 bypass_alu_1;
reg   [0:0]	 bypass_alu_2;
reg   [0:0]	 bypass_mem_1;
reg   [0:0]	 bypass_mem_2;
reg   [1:0]	 W_control_in;
reg	[2:0]	NZP;
reg	[15:0] memout , taddr;
reg	[16-1:0]	M_Data;
reg	[2:0]	dr2 ,sr1, sr2 , psr;
reg	[0:0]	Mem_control_in;
reg [0:0]  enable_updatePC  ;
reg [0:0]  br_taken ;
reg [0:0]  enable_fetch;
reg [15:0] npc_in;
reg [15:0] dout,Mem_Bypass_Val , IR, aluout , pcout , vsr1, vsr2; 
reg [0:0]  enable_decode;
reg [0:0]  enable_execute, enable_writeback;
reg [1:0] W_control_out;
reg [5:0] E_Control;
reg [1:0] mem_state;
reg [0:0] M_Control;
reg [15:0] M_Addr, dr_in;


 //procinterface inputs
reg [0:0]   rd;
reg [15:0]  addr;
reg [3:0]   state;
reg [0:0]   miss;
reg [63:0]  blockdata;
reg [73:0]  RAMdata;
 
 //validarray inputs
reg [3:0]   index;
 
  //cachedata inputs
reg [15:0]  din;
reg [1:0]   count;
reg [0:0]   valid;
reg [15:0]  offdata;
reg [0:0]   ramrd;

 //meminterface inputs
 
 //cachecontroller inputs
reg [0:0]   macc;
reg [0:0]   rrdy2;
reg [0:0]   rdrdy2;
reg [0:0]   wacpt2;


reg [0:0]	coverage_value1, coverage_value2, coverage_value3, coverage_value4, coverage_value5, coverage_value6;

reg [15:0] pc;
reg [15:0] IR_Exec;

rand	reg		complete_instr;
rand	reg 		complete_data;
rand	reg	[15:0]	Data_dout;
rand	reg	[3:0]	op;
rand	bit	[2:0]	dr;
rand	reg	[2:0]	src1;
rand	reg		mode;
rand	reg	[4:0]	src2;
//rand	reg	[15:0]	Instr_dout;   
//LC3.cb.Instr_dout       <=  {pkt2send.op,pkt2send.dr,pkt2send.src1,pkt2send.mode,pkt2send.src2};

 string  name;
 
    constraint c1 {
//	complete_data  inside {1};
	complete_instr dist {1}; 
//	Data_dout inside {[16'h0000:16'hffff]};
	
	
	if((pkt_cnt>0 && pkt_cnt<50) || (pkt_cnt>90 && pkt_cnt<170) || (pkt_cnt>210 && pkt_cnt<260)){		// Pure loads for special numbers
		op	 inside     {2};
		dr	 inside{[0:7]};
		src1	 inside{0};
		mode	 inside{0};
		src2	 inside{0};
	}
	else if(pkt_cnt>=300 && pkt_cnt<500){	// Arithmetic only
		op	inside	   {1,5,9,14};
		
		dr	inside{[0:7]};
		mode	inside{0,1};
		src1	inside{[0:7]};
		
		if(op==9)				// All NOT operations
			src2 	inside{31};
		else if((op==1 || op==5) && mode==0) 	// register based ADD and AND
			src2 	inside {[0:7]};
		else 					// immediate based ADD and AND and all LEA operations
			src2	inside{[0:31]};
	}
	else if(pkt_cnt>500 && pkt_cnt<600){	// Control only
		op	inside	   {0,12};
	
		if(op==0){				// BR instructions only
			dr inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{0,1};
			src2 	inside{[0:31]};
		}
		else{					// JMP instructions only
			dr	inside{0};
			src1	inside{[0:7]};
			mode	inside{0};
			src2 	inside{0};
		}	
	}
	else if(pkt_cnt>600 && pkt_cnt<700){	// Load only
		op	inside	   {2,6,10};
	
		dr	inside{[0:7]};
		src1	inside{[0:7]};
		mode	inside{0,1};
		src2 	inside{[0:31]};
	}
	else if(pkt_cnt>700 && pkt_cnt<800){	// Store only
		op	inside	   {3,7,11};
	
		dr	inside{[0:7]};
		src1	inside{[0:7]};
		mode	inside{0,1};
		src2 	inside{[0:31]};
	}
	else if(pkt_cnt>800 && pkt_cnt<1200){	// Special Instructions
   		if(chose>=0 && chose<=2){		// ADDs Rx, Rx, #0/#1/#2/#5/#10
			op	inside	   {1};
			dr	inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{1};
			src2 	inside{0,1,2,5,10};
		}
		else if(chose==3){			// ANDs Rx, Rx, #0/#f
			op	inside	   {5};
			dr	inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{1};
			src2 	inside{0,31};
		}
		else if(chose>=4 && chose<=8){		// Testing low pc offsets
			op	inside	   {0,2,6,10,3,7,11}; 	// BR, Loads,and Stores
			dr	inside{[0:7]};
			
			if(op==6 || op==7) {
				src1	inside{[0:7]};
				mode	inside{0};
				src2 	inside{[0:32]};
			} else {
				src1	inside{0};
				mode	inside{0};
				src2 	inside{[0:32]};
			}
		}
		else if(chose==9) {	// Arithmetic only
		op	inside	   {1,5,9,14};
		
		dr	inside{[0:7]};
		mode	inside{0,1};
		src1	inside{[0:7]};
		
		if(op==9)				// All NOT operations
			src2 	inside{31};
		else if((op==1 || op==5) && mode==0) 	// register based ADD and AND
			src2 	inside {[0:7]};
		else 					// immediate based ADD and AND and all LEA operations
			src2	inside{[0:31]};
		}
		else if(chose==10){
			op	dist	   {0:=1,12:=1,1:=1,5:=1,9:=1,10:=1,2:=1,6:=1, 14:=1, 7:=1, 11:=1, 3:=1};
			dr	inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{0,1};
			src2 	inside{[0:31]};
		}
		else {					// Random
			op	dist	   {0:=1,12:=1,1:=1,5:=1,9:=1,10:=1,2:=5,6:=1, 14:=1, 7:=1, 11:=1, 3:=2};
			dr	inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{0,1};
			src2 	inside{[0:31]};
		}
	}
	else if(pkt_cnt>1200 && pkt_cnt<3000){	// Bypasses
		dr	inside{[0:7]};
		mode	inside{0};	
		
   		if(pkt_cnt>=1000 && pkt_cnt<2250){
			op	dist	   {1:=1,5:=1,9:=2,10:=4,2:=4,6:=4, 14:=4, 7:=4, 11:=4, 3:=4};
			if(op==2||op==10||op==14||op==3||op==11) src1	inside{[0:7]};
			else src1	inside{old_dr};	
			
			if(op==1||op==5) src2   inside{[0:7]};
			else src2 inside{[0:31]};
		}
		else if(pkt_cnt>=2250 && pkt_cnt<3500){
			op	dist	   {1:=1,5:=1,9:=2,10:=4,2:=4,6:=4, 14:=4, 7:=4, 11:=4, 3:=4};
			src1	inside{[0:7]};
			if(op==1||op==5) src2 	inside{old_dr};
			else src2   inside{0};
		}
		else {
			op	inside	   {1,5,9,10,2,6,14,7,11,3};
			src1   inside{old_dr};
			src2   inside{old_dr};
		}	
	
	}
	else if(pkt_cnt>3000 && pkt_cnt<3300){	// Control only
		op	inside	   {0,12};
	
		if(op==0){				// BR instructions only
			dr inside{[0:7]};
			src1	inside{[0:7]};
			mode	inside{0,1};
			src2 	inside{[0:31]};
		}
		else{					// JMP instructions only
			dr	inside{0};
			src1	inside{[0:7]};
			mode	inside{0};
			src2 	inside{0};
		}	
	}
	else{				// Random packets for first several inputs
   		op	inside	   {0,12,1,5,9,10,2,6,14,7,11,3};
	
//		op	dist {0:=1,2:=1,10:=1,14:=1,3:=1,11:=1, 6:= 1 };
		dr	inside{[0:7]};
		src1	inside{[0:7]};
		mode	inside{0,1};
		src2 	inside{[0:31]};
									
	}
    }
	 
	 
    
   extern function new(string name = "Packet");
endclass    
    
function Packet::new(string name="Packet");
    this.name = name;
endfunction
