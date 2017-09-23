class Packet;

static int pkt_cnt=0;
static int old_dr;

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

     complete_data  inside {1};
     complete_instr dist {1}; // {1:=10,0:=1};
     Data_dout inside {[1:500]};
     
   		op	dist {0:=1,12:=1,1:=11,5:=11,9:=11,10:=1,2:=1,6:=1,12:=1,14:=1, 7:=1, 11:=1, 3:=1} ;  //{12:=1,0:=2,1:=14,5:=12,9:=11,10:=2,14:=2,6:=1,2:=1} ;  //{0:=2,1:=5,2:=1,5:=6,10:=2,12:=1,14:=2,6:=1,9:=3, 7:=6, 11:=7, 3:=6} ;  //{1:=10,5:=10,9:=10,0:=1,12:=1,2:=1,3:=1,6:=1}; //{[0:3],[5:7],[9:12],14};//{0,1,5,9,12}; //{[0:3],[5:7],[9:12],14}; //{0,1,5,9}; // {0,2,10,14,3,11,6 };   //   //{[0:3],[5:12],14};

//		op	dist {0:=1,2:=1,10:=1,14:=1,3:=1,11:=1, 6:= 10 };
		dr	inside{[0:7]};
		src1	inside{[0:7]};
		mode	inside{0,1};
		src2 	inside{[0:31]};
		//if (op == 9) src2 == 31 ; 
         }
	 
	 //constraint c2 {op   inside { }
	 
	// constraint c2 { /* src2[2:0] != src1;*/  /* dr != src1;*/  }
    
   extern function new(string name = "Packet");
endclass    
    
function Packet::new(string name="Packet");
    this.name = name;
endfunction
