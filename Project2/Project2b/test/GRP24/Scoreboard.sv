class Scoreboard;
	string   name;	
	virtual LC3_io.TB LC3;	// interface signals
	virtual Fetch_Probe_if Fetch ;
	virtual Decode_Probe_if Decode;
	virtual Execute_Probe_if Exe;
	virtual Writeback_Probe_if WB;
	virtual Controller_Probe_if Con;		
	
	
	Packet pkt_sent = new();	// Packet object from Driver
	OutputPacket   pkt_cmp = new();		// Packet object from Receiver
  	
	typedef mailbox #(Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers


	
	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	reg reset;
	reg complete_instr;
	reg complete_data;
	reg [15:0] temp_taddr , Dmem_Addr ,Dmem_din;
	reg 	temp_enable_fetch;
	reg [1:0] memstate;

//////////All output signals of various blocks

	///////////////////////////Fetch

	reg instrmem_rd_fetch_chk = 1'b1; 
//////////////////////////Decode
	/*No asynchronous output*/
/////////////////////////Execute
	reg [2:0] sr1_execute_chk =0;;
	reg [2:0] sr2_execute_chk =0;
/////////////////////////WB
	
	reg [15:0]  VSR1_WB_chk =0;
	reg [15:0]  VSR2_WB_chk =0;
/////////////////////////Memaccess
	reg [15:0] memout_MemAccess_chk = 0;
/////////////////////////Controller
/* No Asynchronous output*/	


///////////////////////Fetch

	reg [15:0] pc_fetch_chk  = 16'h3000;
	reg [15:0] npc_fetch_chk = 16'h3001;	
//////////////////////Decode
	reg  [15:0] IR_decode_chk =0;
	reg  [15:0] npc_out_decode_chk=0;
	reg  [5:0]  E_Control_decode_chk=0;
	reg  [1:0]  W_Control_decode_chk =0;
	reg         Mem_Control_decode_chk =0;
/////////////////////Execute
	reg  [2:0] W_Control_out_execute_chk =0;
	reg 	   Mem_Control_out_execute_chk =0;
	reg  [15:0]  aluout_execute_chk =0; 
	reg  [15:0]  pcout_execute_chk =0;	
	reg  [2:0]   dr_execute_chk =0;
	reg [15:0]   IR_Exec_execute_chk =0;
	reg [2:0]   NZP_execute_chk =0;
	reg [15:0]  M_Data_execute_chk =0;
////////////////////WB	
	reg [2:0] psr_WB_chk =0;
//////////////////////MemAccess
	reg [15:0] DMem_addr_MemAccess_chk = 16'hz;
	reg[15:0] DMem_din_MemAccess_chk =16'hz;
	reg  DMem_rd_MemAccess_chk = 1'bz;
////////////////////////Controller
	reg    enable_fetch_controller_chk = 1,b1;
	reg    enable_decode_controller_chk =1;;
	reg    enable_execute_controller_chk =1;
	reg    enable_writeback_controller_chk =1;
	reg    enable_updatePC_controller_chk = 1; 
	reg    bypass_alu_1_controller_chk =0;
	reg   	bypass_alu_2_controller_chk =0;
	reg    bypass_mem_1_controller_chk =0;
	reg   	bypass_mem_2_controller_chk =0;	
	reg    br_taken_controller_chk =0;
	reg [1:0] mem_state_controller_chk =3;
	
	

	
	extern function new(string name = "Scoreboard", out_box_type driver_mbox = null, rx_box_type receiver_mbox = null,virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
	extern virtual task start();
	extern virtual task check();
	extern virtual task check_Toplevel();
	extern virtual task check_Fetch();
	extern virtual task check_Decode();
	extern virtual task check_Execute();
	extern virtual task check_WB();
	extern virtual task check_MemAccess();
	extern virtual task check_Controller();
	
	real 	coverage_value1, coverage_value2, coverage_value3 ,coverage_value4 , coverage_value5 , coverage_value6 , coverage_value7 , coverage_value8 , coverage_value9;
	

	
	covergroup Top;
		Instr_dout_cov: coverpoint 	pkt_sent.Instr_dout[15:12]{
		// Covering all the instructions
		
		bins zero = {0};
		
		bins one = {[0:'1]} iff( (pkt_sent.Instr_dout[15:12] == 4'h1) && (pkt_sent.Instr_dout[5] == 1'b0) );
		bins one_imm = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h1) && (pkt_sent.Instr_dout[5] == 1'b1));
		//bins one_check = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h1)&& (pkt_sent.Instr_dout[5] == 1'b0) && (pkt_sent.Instr_dout[4:3] != 2'b0));//should never get this coverage
		
		bins five = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h5) && (pkt_sent.Instr_dout[5] == 1'b0));
		bins five_imm = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h5) && (pkt_sent.Instr_dout[5] == 1'b1));
		//bins five_check = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h5)&& (pkt_sent.Instr_dout[5] == 1'b0) && (pkt_sent.Instr_dout[4:3] != 2'b0));//should never get this coverage
		
		bins nine = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h9) && (pkt_sent.Instr_dout[5:0] == 6'b111111));
		//bins nine_check = {[0:'1]} iff((pkt_sent.Instr_dout[15:12] == 4'h9) && (pkt_sent.Instr_dout[5:0] != 6'b111111));//should never get this coverage
		
		bins two = {2};
		bins six = {6};
		bins ten = {10};
		bins three = {3};
		bins seven = {7};
		bins eleven = {11};
		bins twelve = {12};
		bins fourteen = {14};
		
		illegal_bins bad_val = {4,8,13,15};
		}
		
		Instr_dout_swap_stuck_cov: coverpoint 	pkt_sent.Instr_dout{
		//Find stck at 0 and 1 faults and also see swapping of lines 
		bins zeros = {16'b0};
		bins ones = {16'hffff};
		bins special11 = {16'hff00};
		bins special22 = {16'hf0f0};
		bins special33 = {16'b1100110011001100};
		bins special44 = {16'b1010101010101010};
		}
		
				
		Data_dout_swap_stuck_cov: coverpoint 	pkt_sent.Data_dout{
		//Find stck at 0 and 1 faults and also see swapping of lines 
		bins zeros = {16'h0};
		bins ones = {16'hffff};
		bins special11 = {16'hff00};
		bins special22 = {16'hf0f0};
		bins special33 = {16'b1100110011001100};
		bins special44 = {16'b1010101010101010};
		}
		
		
		Instr_cov:coverpoint pkt_sent.Instr_dout[15:12] {
		
		bins sequence7 = (1,5,9 => 1,5,9 => 1,5,9); // 3 ALU  continious ALU instruction
		bins sequence6 = (3,7,11,2,6,10 => 3,7,11,2,6,10 => 3,7,11,2,6,10 );  //Three continious memory operations 
		bins sequence1 = (0,12 => 0,12 => 0,12 => 0,12); // Control followed by control
		
		bins sequence8 = (3,7,11,2,6,10 => 3,7,11,2,6,10 => 1,5,9 );   //Mem Mem Alu
		bins sequence9 = (3,7,11,2,6,10 => 1,5,9 => 1,5,9 );   //Mem Alu Alu
		
		bins sequence10 = ( 1,5,9 => 3,7,11,2,6,10 => 3,7,11,2,6,10  ); //Alu Mem Mem  
		bins sequence11 = (1,5,9 => 1,5,9 => 3,7,11,2,6,10  ); //Alu Alu Mem
		
		
		bins sequence2 = (6,12 => 0,12);  //Memory followed by control (Most Important)
		bins sequence3 = (10 => 0,12); 
		bins sequence4 = (3,7 => 0,12); 
		bins sequence5 = (11 => 0,12);
		
		bins sequence12 = (3,7,11,2,6,10 => 1,5,9 => 0,12 ); // Mem Alu Cont
		
		}
		
		
	reset_cov: coverpoint reset {
	
	bins all = (1 => 1 => 1=> 1 => 1 =>0);
	
	
	}
	
	
	
	complete_data_cov: coverpoint complete_data {
	
	illegal_bins bad_val = {0};
	
	
	}
	
	complete_instr_cov: coverpoint complete_instr {
	
	illegal_bins bad_val = {0};
	
	
	}
	
		
	endgroup
	
	covergroup Controller;
	
	IR_Exec_cov: 		coverpoint pkt_cmp.IR_Exec_execute[15:12]{
	
	//ALU instructions ----- The other values are kind of not imp as they are taken care in instr_dout
	bins one = {1};
	bins five = {5};
	bins nine = {9};
	bins fourteen = {14};
	
	bins two = {2};
	bins six = {6};
	bins ten = {10};
	
		
	bins zero = {0};
	bins twelve = {12};
	
	bins three = {3};
	bins seven = {7};
	bins eleven = {11};
	
	
	}
	
	Instr_dout_con_cov:	coverpoint pkt_sent.Instr_dout[15:12]
	{
	
	bins one = {1};
	bins five = {5};
	bins nine = {9};
	bins fourteen = {14};
	
	bins two = {2};
	bins six = {6};
	bins ten = {10};
	
		
	bins zero = {0};
	bins twelve = {12};
	
	bins three = {3};
	bins seven = {7};
	bins eleven = {11};
	
	}
	
	IR_decode_con_cov:	coverpoint pkt_cmp.IR_decode[15:12]
	{
	
	bins one = {1};
	bins five = {5};
	bins nine = {9};
	bins fourteen = {14};
	
	bins two = {2};
	bins six = {6};
	bins ten = {10};
	
		
	bins zero = {0};
	bins twelve = {12};
	
	bins three = {3};
	bins seven = {7};
	bins eleven = {11};
	
	}
	
	
	sr1_IR_cov: 		coverpoint pkt_cmp.IR_decode[8:6] {
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};	

	}
	
	
	
	sr2_IR_stores_cov: 	coverpoint pkt_cmp.IR_decode[11:9]{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}
	
	sr2_IR_ALU_cov: 	coverpoint pkt_cmp.IR_decode[2:0]{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}

	dr_IR_Exec_cov:		coverpoint pkt_cmp.IR_Exec_execute[11:9]{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}
	
	
	NZP_cov : coverpoint pkt_cmp.NZP_execute{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	bins sequence1 = (1,2,3,4,5,6,7 => 0); //checking for synchronously to zero
	
	
	} 
	
		
	psr_cov : coverpoint pkt_cmp.psr_WB{
	
	bins zero     = {2};
	bins negative = {4};
	bins positive = {1};
	illegal_bins bad_val = {0,3,5,6,7};
	
	}
	
		add_bit_cov:  coverpoint pkt_cmp.IR_decode[5]{
	
	bins zero = {0};
	bins one = {1};
	
	}
	
	
	alu_bypass_1_cov: cross  IR_Exec_cov ,sr1_IR_cov ,dr_IR_Exec_cov , IR_decode_con_cov{
	
	
	bins add_alu_bypass1_dep10   =      (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero) && 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
				      	   
	bins add_alu_bypass1_dep11  = 		(binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins add_alu_bypass1_dep12 =       (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins add_alu_bypass1_dep13 = 		(binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins add_alu_bypass1_dep14  =    (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	 bins add_alu_bypass1_dep15  = (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins add_alu_bypass1_dep16  =   (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				          
	bins add_alu_bypass1_dep17 = (binsof(IR_Exec_cov.one) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      

		
	bins and_alu_bypass1_dep10   =      (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero) && 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
				      	   
	bins and_alu_bypass1_dep11  = 		(binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins and_alu_bypass1_dep12 =       (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins and_alu_bypass1_dep13 = 		(binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins and_alu_bypass1_dep14  =    (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	 bins and_alu_bypass1_dep15  = (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins and_alu_bypass1_dep16  =   (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				          
	bins and_alu_bypass1_dep17 = (binsof(IR_Exec_cov.five) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      					   
				   
	
	
	
	bins not_alu_bypass1_dep30   =  (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
	
	bins not_alu_bypass1_dep31 = (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins not_alu_bypass1_dep32 = (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
	bins not_alu_bypass1_dep33 = (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins not_alu_bypass1_dep34   = (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      
	bins not_alu_bypass1_dep35   = (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      
	bins not_alu_bypass1_dep36 =   (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				    
        bins not_alu_bypass1_dep37 =        (binsof(IR_Exec_cov.nine) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
	
	
	
	bins lea_alu_bypass1_dep30   =  (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
	
	bins lea_alu_bypass1_dep31 = (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins lea_alu_bypass1_dep32 = (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
	bins lea_alu_bypass1_dep33 = (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins lea_alu_bypass1_dep34   = (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      
	bins lea_alu_bypass1_dep35   = (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      
	bins lea_alu_bypass1_dep36 =   (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				    
        bins lea_alu_bypass1_dep37 =        (binsof(IR_Exec_cov.fourteen) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
	
			   
					   			   
	
	}
	

	alu_bypass_2_cov: cross IR_Exec_cov ,add_bit_cov , dr_IR_Exec_cov , sr2_IR_stores_cov,sr2_IR_ALU_cov , IR_decode_con_cov{
	
	
	bins add_alu_bypass2_dep10   =      (binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) &&(
						binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins add_alu_bypass2_dep11 =(binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) &&(
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
	
	bins add_alu_bypass2_dep12 =(binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins add_alu_bypass2_dep13 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& (
					binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins add_alu_bypass2_dep14 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins add_alu_bypass2_dep15 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& (
				binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins add_alu_bypass2_dep16 =(binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins add_alu_bypass2_dep17 =(binsof(IR_Exec_cov.one) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&&(		
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
					   
					   
	bins add_alu_bypass2_dep110 =(binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.zero)&& binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					    
	bins add_alu_bypass2_dep111 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.one)&& binsof(dr_IR_Exec_cov.one) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins add_alu_bypass2_dep112 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins add_alu_bypass2_dep113 =  (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.three)&& binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins add_alu_bypass2_dep114 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins add_alu_bypass2_dep115 =  (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	bins add_alu_bypass2_dep116 = (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins add_alu_bypass2_dep117 =  (binsof(IR_Exec_cov.one) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));

	
	
	bins and_alu_bypass2_dep10   =      (binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) && (
						binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins and_alu_bypass2_dep11 =(binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) &&(
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
	
	bins and_alu_bypass2_dep12 =(binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins and_alu_bypass2_dep13 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& (
					binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins and_alu_bypass2_dep14 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins and_alu_bypass2_dep15 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& (
				binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins and_alu_bypass2_dep16 =(binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins and_alu_bypass2_dep17 =(binsof(IR_Exec_cov.five) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&&(		
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
					   
					   
	bins and_alu_bypass2_dep110 =(binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.zero)&& binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					    
	bins and_alu_bypass2_dep111 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.one)&& binsof(dr_IR_Exec_cov.one) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins and_alu_bypass2_dep112 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins and_alu_bypass2_dep113 =  (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.three)&& binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins and_alu_bypass2_dep114 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins and_alu_bypass2_dep115 =  (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	bins and_alu_bypass2_dep116 = (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins and_alu_bypass2_dep117 =  (binsof(IR_Exec_cov.five) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));

	
	bins lea_alu_bypass2_dep10   =      (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) && (
						binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins lea_alu_bypass2_dep11 =(binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) &&(
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
	
	bins lea_alu_bypass2_dep12 =(binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins lea_alu_bypass2_dep13 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& (
					binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins lea_alu_bypass2_dep14 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins lea_alu_bypass2_dep15 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& (
				binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins lea_alu_bypass2_dep16 =(binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins lea_alu_bypass2_dep17 =(binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&&(		
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
					   
					   
	bins lea_alu_bypass2_dep110 =(binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.zero)&& binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					    
	bins lea_alu_bypass2_dep111 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.one)&& binsof(dr_IR_Exec_cov.one) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins lea_alu_bypass2_dep112 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins lea_alu_bypass2_dep113 =  (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.three)&& binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins lea_alu_bypass2_dep114 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins lea_alu_bypass2_dep115 =  (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	bins lea_alu_bypass2_dep116 = (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins lea_alu_bypass2_dep117 =  (binsof(IR_Exec_cov.fourteen) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));

	
	bins not_alu_bypass2_dep10   =      (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& (
						binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins not_alu_bypass2_dep11 =(binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
	
	bins not_alu_bypass2_dep12 =(binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins not_alu_bypass2_dep13 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& (
					binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins not_alu_bypass2_dep14 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins not_alu_bypass2_dep15 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& (
				binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins not_alu_bypass2_dep16 =(binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& (
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins not_alu_bypass2_dep17 =(binsof(IR_Exec_cov.nine) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&&(		
					binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
					   
					   
	bins not_alu_bypass2_dep110 =(binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.zero)&& binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					    
	bins not_alu_bypass2_dep111 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.one)&& binsof(dr_IR_Exec_cov.one) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins not_alu_bypass2_dep112 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins not_alu_bypass2_dep113 =  (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.three)&& binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins not_alu_bypass2_dep114 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins not_alu_bypass2_dep115 =  (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	bins not_alu_bypass2_dep116 = (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins not_alu_bypass2_dep117 =  (binsof(IR_Exec_cov.nine) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	}
	
	
	
	
	
	
	
	mem_bypass_1_cov: cross  IR_Exec_cov ,sr1_IR_cov ,dr_IR_Exec_cov , IR_decode_con_cov{
	
	

	
	bins LD_mem_bypass1_dep10   =      (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
				      	   
	bins LD_mem_bypass1_dep11   = 	(binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins LD_mem_bypass1_dep12   =       (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LD_mem_bypass1_dep13 =          (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LD_mem_bypass1_dep14 = 		 (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LD_mem_bypass1_dep15 = 	   (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LD_mem_bypass1_dep16 =          (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				          
	bins LD_mem_bypass1_dep17 = (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      

	bins LDR_mem_bypass1_dep10   =      (binsof(IR_Exec_cov.two) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
				      	   
	bins LDR_mem_bypass1_dep11   = 	(binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins LDR_mem_bypass1_dep12   =       (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDR_mem_bypass1_dep13 =          (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDR_mem_bypass1_dep14 = 		 (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDR_mem_bypass1_dep15 = 	   (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDR_mem_bypass1_dep16 =          (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				          
	bins LDR_mem_bypass1_dep17 = (binsof(IR_Exec_cov.six) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				   
	bins LDI_mem_bypass1_dep10   =      (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.zero) && binsof(dr_IR_Exec_cov.zero)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve)));
				      	   
	bins LDI_mem_bypass1_dep11   = 	(binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.one) && binsof(dr_IR_Exec_cov.one)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				      	   
	bins LDI_mem_bypass1_dep12   =       (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.two) && binsof(dr_IR_Exec_cov.two)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDI_mem_bypass1_dep13 =          (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.three) && binsof(dr_IR_Exec_cov.three)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDI_mem_bypass1_dep14 = 		 (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.four) && binsof(dr_IR_Exec_cov.four)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDI_mem_bypass1_dep15 = 	   (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.five) && binsof(dr_IR_Exec_cov.five)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				           
	bins LDI_mem_bypass1_dep16 =          (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.six) && binsof(dr_IR_Exec_cov.six)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
				          
	bins LDI_mem_bypass1_dep17 = (binsof(IR_Exec_cov.ten) && binsof(sr1_IR_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& 
					   ( binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five) || binsof(IR_decode_con_cov.nine) || binsof(IR_decode_con_cov.ten) ||
					    binsof(IR_decode_con_cov.eleven)|| binsof(IR_decode_con_cov.twelve))) ;
	
	}
	

	mem_bypass_2_cov: cross IR_Exec_cov ,add_bit_cov , dr_IR_Exec_cov , sr2_IR_stores_cov,sr2_IR_ALU_cov , IR_decode_con_cov{
	
	
	bins LD_mem_bypass2_dep10   =      (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins LD_mem_bypass2_dep11 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				      	   
	bins LD_mem_bypass2_dep12 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LD_mem_bypass2_dep13 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins LD_mem_bypass2_dep14 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				          
	bins LD_mem_bypass2_dep15 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LD_mem_bypass2_dep16 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LD_mem_bypass2_dep17 =(binsof(IR_Exec_cov.two) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				            
					    
	bins LD_mem_bypass2_dep110 = 	(binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.zero) && binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					     
	bins LD_mem_bypass2_dep111 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.one)  && binsof(dr_IR_Exec_cov.one) && ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
       bins LD_mem_bypass2_dep112  =  (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LD_mem_bypass2_dep113  =  (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.three) && binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LD_mem_bypass2_dep114  =  (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LD_mem_bypass2_dep115 = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LD_mem_bypass2_dep116  = (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins LD_mem_bypass2_dep117  =  (binsof(IR_Exec_cov.two) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));

	
	
	bins LDR_mem_bypass2_dep10   =      (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins LDR_mem_bypass2_dep11 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				      	   
	bins LDR_mem_bypass2_dep12 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDR_mem_bypass2_dep13 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins LDR_mem_bypass2_dep14 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				          
	bins LDR_mem_bypass2_dep15 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDR_mem_bypass2_dep16 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDR_mem_bypass2_dep17 =(binsof(IR_Exec_cov.six) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				            
					   
					   
					   
	bins LDR_mem_bypass2_dep110 = 	(binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.zero) && binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					     
	bins LDR_mem_bypass2_dep111 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.one)  && binsof(dr_IR_Exec_cov.one) && ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
       bins LDR_mem_bypass2_dep112  =  (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LDR_mem_bypass2_dep113  =  (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.three) && binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LDR_mem_bypass2_dep114  =  (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LDR_mem_bypass2_dep115 = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LDR_mem_bypass2_dep116  = (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins LDR_mem_bypass2_dep117  =  (binsof(IR_Exec_cov.six) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
				   
	
	
	bins LDI_mem_bypass2_dep10   =      (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.zero) && binsof(dr_IR_Exec_cov.zero) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five)));
				      	   
	bins LDI_mem_bypass2_dep11 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.one) && binsof(dr_IR_Exec_cov.one) && binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				      	   
	bins LDI_mem_bypass2_dep12 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.two) && binsof(dr_IR_Exec_cov.two)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDI_mem_bypass2_dep13 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.three) && binsof(dr_IR_Exec_cov.three)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) ||binsof (IR_decode_con_cov.five))) ;
				           
	bins LDI_mem_bypass2_dep14 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.four) && binsof(dr_IR_Exec_cov.four)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				          
	bins LDI_mem_bypass2_dep15 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.five) && binsof(dr_IR_Exec_cov.five)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDI_mem_bypass2_dep16 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.six) && binsof(dr_IR_Exec_cov.six)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
				           
	bins LDI_mem_bypass2_dep17 =(binsof(IR_Exec_cov.ten) && binsof(sr2_IR_ALU_cov.seven) && binsof(dr_IR_Exec_cov.seven)&& binsof(add_bit_cov.zero)&& (
					   binsof(IR_decode_con_cov.one) || binsof(IR_decode_con_cov.five))) ;
					   
					   
					   
					   
					   
	bins LDI_mem_bypass2_dep110 = 	(binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.zero) && binsof(dr_IR_Exec_cov.zero) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					    binsof(IR_decode_con_cov.eleven)));
					     
	bins LDI_mem_bypass2_dep111 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.one)  && binsof(dr_IR_Exec_cov.one) && ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
       bins LDI_mem_bypass2_dep112  =  (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.two)&& binsof(dr_IR_Exec_cov.two) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LDI_mem_bypass2_dep113  =  (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.three) && binsof(dr_IR_Exec_cov.three) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LDI_mem_bypass2_dep114  =  (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.four)&& binsof(dr_IR_Exec_cov.four) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					     
	bins LDI_mem_bypass2_dep115 = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.five)&& binsof(dr_IR_Exec_cov.five) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
	bins LDI_mem_bypass2_dep116  = (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.six)&& binsof(dr_IR_Exec_cov.six) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
					   
	bins LDI_mem_bypass2_dep117  =  (binsof(IR_Exec_cov.ten) && binsof(sr2_IR_stores_cov.seven)&& binsof(dr_IR_Exec_cov.seven) &&  ( binsof(IR_decode_con_cov.three) || binsof(IR_decode_con_cov.seven) ||
					   binsof(IR_decode_con_cov.eleven)));
	
					   
	}
	
	alu1_by_cov : coverpoint pkt_cmp.bypass_alu_1_controller{
	
	bins zero = {0};
	bins one = {1};
	}
	alu2_by_cov : coverpoint pkt_cmp.bypass_alu_2_controller{
	
	bins zero = {0};
	bins one = {1};
	}
	mem1_by_cov : coverpoint pkt_cmp.bypass_mem_1_controller{
	
	bins zero = {0};
	bins one = {1};
	}
	mem2_by_cov : coverpoint pkt_cmp.bypass_mem_2_controller{
	
	bins zero = {0};
	bins one = {1};
	}
	
	out_bypass_cov:  cross IR_decode_con_cov , IR_Exec_cov , alu1_by_cov , alu2_by_cov , mem1_by_cov , mem2_by_cov {
	
	bins lea_one = binsof(IR_Exec_cov.fourteen) && binsof(alu1_by_cov.one) ;
	bins lea_both =  binsof(IR_Exec_cov.fourteen) && binsof(alu1_by_cov.one) && binsof(alu2_by_cov.one);
	
	bins alu_one = (binsof(IR_Exec_cov.one)||binsof(IR_Exec_cov.five) ||binsof(IR_Exec_cov.nine)) && binsof(alu1_by_cov.one) ;
	bins alu_both =   (binsof(IR_Exec_cov.one)||binsof(IR_Exec_cov.five) ||binsof(IR_Exec_cov.nine)) && binsof(alu1_by_cov.one) && binsof(alu2_by_cov.one);
	
	bins mem_one = (binsof(IR_Exec_cov.two)||binsof(IR_Exec_cov.six) ||binsof(IR_Exec_cov.ten)) && binsof(mem1_by_cov.one) ;
	bins mem_both =   (binsof(IR_Exec_cov.two)||binsof(IR_Exec_cov.six) ||binsof(IR_Exec_cov.ten)) && binsof(mem1_by_cov.one) && binsof(mem2_by_cov.one);
	
	illegal_bins bad_value1 = binsof(alu1_by_cov.one)&&binsof(mem1_by_cov.one);
	illegal_bins bad_value2 = binsof(alu2_by_cov.one)&&binsof(mem2_by_cov.one);
	
	
	}
	
	
	fetch_enable_cov : coverpoint pkt_cmp.enable_fetch_controller{
	
	bins zero = {0};
	bins one = {1};
	
	// ALU ALU ALU 
	bins sequence1 = (1=>1=>1);
	//Mem ALU ALU 
	bins sequence2 = (1=>0=>1); //LD , LDR
	bins sequence3 = (1=>0=>0=>1);
	//Control Control Control Alu Alu Alu
	bins sequence4 = (1=>0=>0=>0=>1);
	
	//Control Control Control Control
	bins sequence5 = (1 => 0 =>0 =>0 => 1 => 0 =>0 =>0 =>1) ;
	
	//Mem Alu Control Control Control
	
	bins sequence6 = (1 =>0 =>0 =>0 =>0 =>1); 
	bins sequence7 = (1 =>0 =>0 =>0 =>0 =>0 =>1); 
	
	
	}

		
	decode_enable_cov : coverpoint pkt_cmp.enable_decode_controller{
	
	bins zero = {0};
	bins one = {1};
	
	// ALU ALU ALU 
	bins sequence1 = (1=>1=>1);
	//Mem ALU ALU 
	bins sequence2 = (1=>0=>1); //LD , LDR
	bins sequence3 = (1=>0=>0=>1);
	//Control Control Control Alu Alu Alu
	bins sequence4 = (1=>0=>0=>0=>1);
	
	//Control Control Control Control
	bins sequence5 = (1 => 0 =>0 =>0 => 1 => 0 =>0 =>0 =>1) ;
	
	//Mem Alu Control Control Control
	
	bins sequence6 = (1 =>0 =>0 =>0 =>0 =>1); 
	bins sequence7 = (1 =>0 =>0 =>0 =>0 =>0 =>1); 
	
	
	}

	execute_enable_cov : coverpoint pkt_cmp.enable_execute_controller{
	
	bins zero = {0};
	bins one = {1};
	
	// ALU ALU ALU 
	bins sequence1 = (1=>1=>1);
	//Mem ALU ALU 
	bins sequence2 = (1=>0=>1); //LD , LDR
	bins sequence3 = (1=>0=>0=>1);
	//Control Control Control Alu Alu Alu
	bins sequence4 = (1=>0=>0=>0=>1);
	
	//Control Control Control Control
	bins sequence5 = (1 => 0 =>0 =>0 => 1 => 0 =>0 =>0 =>1) ;
	
	//Mem Alu Control Control Control
	
	bins sequence6 = (1 =>0 =>1 =>1 =>1 =>0 =>0 =>0 ); 
	bins sequence7 = (1 =>0 =>0 =>1 =>1 =>1 =>0 =>0 =>0); 
	
	
	}
	
	writeback_enable_cov : coverpoint pkt_cmp.enable_writeback_controller{
	
	bins zero = {0};
	bins one = {1};
	
	// ALU ALU ALU 
	bins sequence1 = (1=>1=>1);
	//Mem ALU ALU 
	bins sequence2 = (1=>0=>1); //LD , LDR
	bins sequence3 = (1=>0=>0=>1);
	
	bins sequence8 = (1=>0=>1); //LD , LDR
	bins sequence9 = (1=>0=>0=>1);
	//Control Control Control Alu Alu Alu
		
	//Control Control Control Control
	bins sequence5 = (1 => 0 =>0 =>0 =>0 =>0 => 0 =>0 =>0 =>0) ;
	
	//Mem Alu Control Control Control
	
	bins sequence6 = (1 =>0 =>1 =>1 =>1 =>0 =>0 =>0 =>0); 
	bins sequence7 = (1 =>0 =>0 =>1 =>1 =>1 =>0 =>0 =>0 =>0); 
	
	
	}	
	
	updatePC_enable_cov : coverpoint pkt_cmp.enable_updatePC_controller{
	
	bins zero = {0};
	bins one = {1};
	
	// ALU ALU ALU 
	bins sequence1 = (1=>1=>1);
	//Mem ALU ALU 
	bins sequence2 = (1=>0=>1); //LD , LDR
	bins sequence3 = (1=>0=>0=>1);

	//Control Control Control Alu Alu Alu
	bins sequence4 = (1=>0=>0=>0=>1);
	bins sequence8 = (1=>0=>0=>1=>1); //branch taken
	//Control Control Control Control
	bins sequence5 = (1 => 0 =>0 =>0 =>1 =>0 => 0 ) ;
	bins sequence9 = (1 => 0 =>0 => 1=> 1 =>0 => 0 ) ;//branch taken
	//Mem Alu Control Control Control
	
	bins sequence6 = (1 =>0 =>0 =>0 =>1 ); 
	bins sequence7 = (1 =>0 =>0 =>0 =>0 =>1 =>0 =>0); 
	
	
	}		
	
	br_taken_cov : coverpoint pkt_cmp.br_taken_controller{
	
	bins zero = {0};
	bins one = {1};
	
	}
	
	memstate_cov : coverpoint memstate{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins sequence1 = (3 =>0 =>3);
	bins sequence2 = (3 =>2 =>3);
	bins sequence3 = (3 =>1 => 0 =>3);
	bins sequence4 = (3 =>1 => 2 =>3);
	bins sequence5 = (3 =>3 =>3);
	
	}
	endgroup

covergroup Fetch_cov;

taddr_cov : coverpoint temp_taddr {

bins allfs = {16'hffff};
//Checking that taddr does not go below 3000 
illegal_bins bad_value = { [$:16'h3000] };

}

npc_fetch_cov : coverpoint pkt_cmp.npc_fetch {

bins allfs = {16'hffff};
bins reset_value = {16'h3001};
illegal_bins bad_value = { [$:16'h3000] };
}

pc_fetch_cov : coverpoint pkt_cmp.pc_fetch {

bins allfs = {16'hffff};
bins reset_value = {16'h3000};
illegal_bins bad_value = { [$:16'h2999] };
}

instrmem_rd_fetch_cov : coverpoint pkt_cmp.instrmem_rd_fetch {

bins imp = {1'bz};
bins one = {1'b1};
illegal_bins zero = {0};
}

temp_enable_fetch_cov: coverpoint temp_enable_fetch{
bins zero = {0};
bins one = {1};
}

rd_fetch_cov: cross temp_enable_fetch_cov , instrmem_rd_fetch_cov{

bins zeez = binsof(temp_enable_fetch_cov.zero) && binsof(instrmem_rd_fetch_cov.imp);
bins one = binsof(temp_enable_fetch_cov.one) && binsof(instrmem_rd_fetch_cov.one);
}

 endgroup
 
 covergroup Decode_cov;
 
 alu_control_cov: coverpoint pkt_cmp.E_Control_decode[5:4]{
 
 bins zero = {0};
 bins one = {1};
 bins two = {2};
 illegal_bins bad_value = {3};
 
 }
 
  pcselect1_cov:  coverpoint pkt_cmp.E_Control_decode[3:2]{
 
 bins zero = {0};
 bins one = {1};
 bins two = {2};
 bins three = {3};
 
 }
 
   pcselect2_cov:coverpoint  pkt_cmp.E_Control_decode[1]{
 
 bins zero = {0};
 bins one = {1};
 }
 
    op2select_cov: coverpoint pkt_cmp.E_Control_decode[1]{
 
 bins zero = {0};
 bins one = {1};
 }
 
  Mem_control_cov:coverpoint  pkt_cmp.Mem_Control_decode{
 
 bins zero = {0};
 bins one = {1};

 }
 
  W_control_cov: coverpoint pkt_cmp.W_Control_decode{
 
 bins zero = {0};
 bins one = {1};
 bins two = {2};
  illegal_bins bad_value = {3};
 
 }
 endgroup	

covergroup Execute_cov;

	
	sr1_cov: 	coverpoint pkt_cmp.sr1_execute{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}
	
	sr2_cov: 	coverpoint pkt_cmp.sr2_execute{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}

	dr__cov:		coverpoint pkt_cmp.dr_execute{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins four = {4};
	bins five = {5};
	bins six = {6};
	bins seven = {7};
	
	}
	
	aluout_cov : coverpoint pkt_cmp.aluout_execute{
	
	bins zero = {0};
	bins allfs = {16'hffff};
		//	bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	
        pcout_cov : coverpoint pkt_cmp.pcout_execute{
	
	bins zero = {0};
	bins allfs = {16'hffff};
		//		bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};

	}
	
	Mem_control_exe_cov:coverpoint  pkt_cmp.Mem_Control_out_execute{
 
 	bins zero = {0};
 	bins one = {1};

 	}
 
  	W_control_exe_cov: coverpoint pkt_cmp.W_Control_out_execute{
 
	 bins zero = {0};
	 bins one = {1};
 	bins two = {2};
  	illegal_bins bad_value = {3};
 
 	}
	
	endgroup
	
	covergroup WB_cov;
	
	psr_cov: coverpoint pkt_cmp.psr_WB {
	
	bins four = {4};
	bins two = {2};
	bins one = {1};
	illegal_bins bad_value = {0,3,5,6,7};
	
	}
	
	VSR1_cov: coverpoint pkt_cmp.VSR1_WB {
	
	bins zero = {16'h0};
	bins allfs = {16'hffff};
		//	bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	
	VSR2_cov: coverpoint pkt_cmp.VSR2_WB {
	
	bins zero = {16'h0};
	bins allfs = {16'hffff};
		//	bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	endgroup
	
	covergroup MA_cov;
	memout_cov: coverpoint pkt_cmp.memout_MemAccess {
		
		bins zero = {16'h0};
		//bins allfs = {16'hffff};
		
		//bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	
		DMem_addr_MemAccess_cov: coverpoint Dmem_Addr {
		
		bins zero = {16'h0};
		bins allfs = {16'hffff};
		bins allz  =  {16'hzzzz};
		//bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	
		DMem_din_MemAccess_cov: coverpoint Dmem_din {
		
		bins zero = {16'h0};
		bins allfs = {16'hffff};
		bins allz  =  {16'bzzzzzzzzzzzzzzzz};
		//bins special11 = {16'hff00};
		//bins special22 = {16'hf0f0};
		//bins special33 = {16'b1100110011001100};
		//bins special44 = {16'b1010101010101010};
	
	}
	
		DMem_rd_MemAccess_cov: coverpoint pkt_cmp.DMem_rd_MemAccess {
		
		bins zero = {1'h0};
		bins one = {1'h1};
		bins zeez = {1'hz};

	}
	
	memstate1_cov : coverpoint pkt_cmp.mem_state_controller{
	
	bins zero = {0};
	bins one = {1};
	bins two = {2};
	bins three = {3};
	bins sequence1 = (3 =>0 =>3);
	bins sequence2 = (3 =>2 =>3);
	bins sequence3 = (3 =>1 => 0 =>3);
	bins sequence4 = (3 =>1 => 2 =>3);
	bins sequence5 = (3 =>3 =>3);
	
	}
	
	memstate_cx : cross memstate1_cov, DMem_rd_MemAccess_cov, DMem_din_MemAccess_cov, DMem_addr_MemAccess_cov{
	
	//bins DMem_din_zero1 =  binsof(memstate1_cov.one)  &&  binsof(DMem_din_MemAccess_cov.zero);
	bins DMem_din_zero1 =  binsof(memstate1_cov.zero)  &&  binsof(DMem_din_MemAccess_cov.zero);
	bins DMem_din_zees = binsof(memstate1_cov.three) &&   binsof(DMem_din_MemAccess_cov.allz);
	
	bins DMem_addr_zees = binsof(memstate1_cov.three) &&  binsof (DMem_din_MemAccess_cov.allz);
	bins DMem_rd_zees = binsof(memstate1_cov.three) &&  binsof (DMem_rd_MemAccess_cov.zeez);
	bins DMem_rd_one = binsof(memstate1_cov.zero) &&   binsof(DMem_rd_MemAccess_cov.one);
	bins DMem_rd_zero = binsof(memstate1_cov.two) &&  binsof (DMem_rd_MemAccess_cov.zero);
	
	
	
	}
	
	endgroup
endclass

//All the temporary variables that are required while calculating golden model values and buffering inputs.

//fetch
reg [15:0] temp_npc_in_fetch,temp_pc_fetch,temp1,temp2 ;
reg 	temp_enable_updatePC , temp_br_taken;

//decode
reg temp_enable_decode;
reg [15:0] temp_Instr_dout;
reg [15:0] temp_npc_in ;

//execute
reg temp_enable_execute =0;
reg [15:0] temp_IR_execute =0;
reg    [15:0] imm5 =0, offset9=0,offset6 =0 ,offset11 =0,aluin1=0,aluin2=0 , pcpart1  ,pcpart2  , VSR1_int , VSR2_int;
reg    [1:0] alu_control=0,pcselect1=0;
reg    pcselect2=0, op2select=0;

reg [15:0] temp_IR_Exec;
reg temp_by_alu_1;
reg temp_by_alu_2;
reg temp_by_mem_1;
reg temp_by_mem_2;
reg [5:0] temp_E_Control_execute;
reg [15:0] temp_npc_in_execute ;
reg  temp_Mem_Control_in;
reg [1:0] temp_W_Control_in;
reg [15:0] temp_Mem_Bypass_Val ;
reg [15:0] temp_aluout_execute;
reg [15:0] temp_pcout_execute;
reg [15:0] temp_VSR1_execute;
reg [15:0] temp_VSR2_execute;

//writeback
reg temp_enable_writeback;
reg [15:0] temp_pcout_WB,temp_aluout_WB,temp_memout_WB , DR_in;
reg [1:0] temp_W_Control_WB;
reg    [15:0] Registerfile[8];
reg   [2:0] temp_dr;
reg [2:0] dr, temp_sr1, temp_sr2;


//Controller
reg temp_br_taken_controller;
reg [1:0] count = 0;
reg [3:0] state = 4'd15;
reg [1:0]counter_start =0;
reg [1:0] stall =0 ,stall_1 =0 ,stall_2 = 0;
reg flag =0 ,flag1 = 0;
reg [3:0] counter_control =0;
reg [2:0] branch_out =0;
reg [1:0] temp_mem_state_controller_chk = 2'd3;
reg	    temp_enable_updatePC_controller_chk  =1       ; 	
reg	    temp_enable_fetch_controller_chk      =1    ;
reg	    temp_enable_decode_controller_chk      =0    ;
reg	    temp_enable_execute_controller_chk     =0    ;
reg	    temp_enable_writeback_controller_chk   =0    ;

////Top
reg [15:0] top_Fetch_npc =0;

function Scoreboard::new(string name = "Scoreboard", out_box_type driver_mbox = null, rx_box_type receiver_mbox = null,virtual LC3_io.TB LC3, virtual Fetch_Probe_if Fetch ,virtual Decode_Probe_if Decode, 
	virtual Execute_Probe_if Exe, virtual Writeback_Probe_if WB, virtual Controller_Probe_if Con);
	this.name = name;
	if (driver_mbox == null) 
		driver_mbox = new();
	if (receiver_mbox == null) 
		receiver_mbox = new();	
	this.driver_mbox = driver_mbox;
	this.receiver_mbox = receiver_mbox;
	this.LC3 = LC3;
	this.Fetch = Fetch;
	this.Decode = Decode;
	this.Exe = Exe;
	this.WB = WB;
	this.Con = Con;
	
	Top = new();
	Controller = new();
	Fetch_cov = new();
	Decode_cov = new();
	Execute_cov = new();
	WB_cov = new();
	MA_cov = new();
	

endfunction

task Scoreboard::start();
	$display ($time, "ns:  [SCOREBOARD] Scoreboard Started");
	//Default values already declared
	$display ($time, "ns:  [SCOREBOARD] Receiver Mailbox contents = %d ", receiver_mbox.num());
	
	fork
		forever 
		begin
			while((receiver_mbox.num() == 0))
			begin
				$display ($time, "ns:  [SCOREBOARD] Waiting for Data in Receiver Outbox to be populated");
				#10 ;
			end
			while (receiver_mbox.num()) begin
				$display ($time, "ns:  [SCOREBOARD] Grabbing Data From both Driver and Receiver");
				receiver_mbox.get(pkt_cmp);
				driver_mbox.get(pkt_sent);
                                check();
			end
		end
	join_none
	$display ($time, "[SCOREBOARD] Forking of Process Finished");
endtask

//Check checks the check_TopLevel and other blocks	
task Scoreboard::check();


		reset = LC3.reset;
		complete_data = LC3.cb.complete_instr;
		complete_instr = LC3.cb.complete_instr;
	// COVERAGE ADDITION 
	Top.sample();
	Controller.sample();
	Fetch_cov.sample();
	Decode_cov.sample();
	Execute_cov.sample();
	WB_cov.sample();
	MA_cov.sample();
	

	 
	 
	 coverage_value1 = 	Top.get_coverage();
	  coverage_value2 = 	Controller.get_coverage();
	  coverage_value3 =     Fetch_cov.get_coverage();
	  coverage_value4 =     Decode_cov.get_coverage();
	   coverage_value5 = 	Execute_cov.get_coverage();
	  coverage_value6 =     WB_cov.get_coverage();
	  coverage_value7 =     MA_cov.get_coverage();
	 
	 
	 check_Toplevel();
	  
	  //////////////////Individual Blocks
	  
	  
	  check_Fetch();
	  check_Decode();
	  check_Controller();
	   check_WB();
	  check_Execute();
	   check_MemAccess();
	
	   
	   
	  
	
endtask



task Scoreboard::check_Controller();

//For ALU and LEA calculating bypass_alu_1 and bypass_alu_2 based on IR_Exec and IR

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if((Con.cb.IR_Exec[15:12] == 4'd1) || (Con.cb.IR_Exec[15:12] == 4'd5) || (Con.cb.IR_Exec[15:12] == 4'd9) || (Con.cb.IR_Exec[15:12] == 4'd14))
begin

dr = Con.cb.IR_Exec[11:9];	//register written in IR_Exec

if(Con.cb.IR[15:12] == 4'd1)
begin
	temp_sr1 =  Con.cb.IR[8:6];		//sr1 - value read for ADD
	
	if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;
	else
	bypass_alu_1_controller_chk = 0;
	
	if(Con.cb.IR[5] == 1'b0)
	begin
	temp_sr2 =  Con.cb.IR[2:0];
	
	if(dr == temp_sr2)
	bypass_alu_2_controller_chk = 1;	//sr2 - value read for ADD
	
	else
	bypass_alu_2_controller_chk = 0;
	
	end
	
	
	else
	bypass_alu_2_controller_chk = 0;
	
	
	
end

else if(Con.cb.IR[15:12] == 4'd5)
begin
	temp_sr1 =  Con.cb.IR[8:6];		//sr1 - value read for AND
	if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;
	else
	bypass_alu_1_controller_chk = 0;
	
	if(Con.cb.IR[5] == 1'b0)
	begin
	
	temp_sr2 =  Con.cb.IR[2:0];		//sr2 - value read for ADD
	if(dr == temp_sr2)
	bypass_alu_2_controller_chk = 1;
		 
	
	else 
	bypass_alu_2_controller_chk = 0;
	end
	
	else
	bypass_alu_2_controller_chk = 0;
	
	
end


else if(Con.cb.IR[15:12] == 4'd9)
begin

temp_sr1 =  Con.cb.IR[8:6];			//sr1 - value read for NOT
if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;
else
	bypass_alu_1_controller_chk = 0;	
bypass_alu_2_controller_chk = 0;
end


else if(Con.cb.IR[15:12] == 4'd12)
begin

temp_sr1 =  Con.cb.IR[8:6];			//sr1 - value read for Jump instruction
if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;
else
	bypass_alu_1_controller_chk = 0;	
	
bypass_alu_2_controller_chk = 0;		

end


else if(Con.cb.IR[15:12] == 4'd6)
begin

temp_sr1 =  Con.cb.IR[8:6];			//sr1 - value read for address calculation in LDR 
if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;	
else
	bypass_alu_1_controller_chk = 0;	

bypass_alu_2_controller_chk = 0;
end

else if(Con.cb.IR[15:12] == 4'd3)
begin
temp_sr1 =  Con.cb.IR[8:6];			//sr1 value (default)

temp_sr2 =  Con.cb.IR[11:9];			//sr2 - value read for ST instruction

if(dr == temp_sr2)				
	bypass_alu_2_controller_chk = 1;	
else
	bypass_alu_2_controller_chk = 0;

bypass_alu_1_controller_chk = 0;	
	
end

else if(Con.cb.IR[15:12] == 4'd7)
begin

temp_sr1 =  Con.cb.IR[8:6];			//for STR both sr1 and sr2 are read
if(dr == temp_sr1)
	bypass_alu_1_controller_chk = 1;
else
	bypass_alu_1_controller_chk = 0;	
temp_sr2 =  Con.cb.IR[11:9];
if(dr == temp_sr2)
	bypass_alu_2_controller_chk = 1;	
else
	bypass_alu_2_controller_chk = 0;	

end


else if(Con.cb.IR[15:12] == 4'd11)
begin

bypass_alu_1_controller_chk = 0;

temp_sr2 =  Con.cb.IR[11:9];			//sr2 - value read for STI
if(dr == temp_sr2)
	bypass_alu_2_controller_chk = 1;	
else
	bypass_alu_2_controller_chk = 0;

end

else 
begin 
bypass_alu_1_controller_chk = 1'b0;
bypass_alu_2_controller_chk = 1'b0;

end

end

else 
begin 
bypass_alu_1_controller_chk = 1'b0;
bypass_alu_2_controller_chk = 1'b0;

end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//The same set of dependencies are calculated for IR_Exec is LD , LDR , LDI 

if((Con.cb.IR_Exec[15:12] == 4'd2) || (Con.cb.IR_Exec[15:12] == 4'd6) || (Con.cb.IR_Exec[15:12] == 4'd10) )
begin

dr = Con.cb.IR_Exec[11:9];

if(Con.cb.IR[15:12] == 4'd1)
begin
	temp_sr1 =  Con.cb.IR[8:6];
	
	if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;
	else
	bypass_mem_1_controller_chk = 0;
	
	if(Con.cb.IR[5] == 1'b0)
	begin
	temp_sr2 =  Con.cb.IR[2:0];
	
	if(dr == temp_sr2)
	bypass_mem_2_controller_chk = 1;
	
	else
	bypass_mem_2_controller_chk = 0;
	
	end
	
	else
	
	bypass_mem_2_controller_chk = 0;
	
	
	
end

else if(Con.cb.IR[15:12] == 4'd5)
begin
	temp_sr1 =  Con.cb.IR[8:6];
	if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;
	else
	bypass_mem_1_controller_chk = 0;
	
	if(Con.cb.IR[5] == 1'b0)
	begin
	
	temp_sr2 =  Con.cb.IR[2:0];
	if(dr == temp_sr2)
	bypass_mem_2_controller_chk = 1;
		 
	end
	
	else
	begin 
	bypass_mem_2_controller_chk = 0;
	end
	
	
	
end


else if(Con.cb.IR[15:12] == 4'd9)
begin

temp_sr1 =  Con.cb.IR[8:6];
if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;
else
	bypass_mem_1_controller_chk = 0;	
bypass_mem_2_controller_chk = 0;
end


else if(Con.cb.IR[15:12] == 4'd12)
begin

temp_sr1 =  Con.cb.IR[8:6];	
if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;
else
	bypass_mem_1_controller_chk = 0;	
	
bypass_mem_2_controller_chk = 0;		

end


else if(Con.cb.IR[15:12] == 4'd6)
begin

temp_sr1 =  Con.cb.IR[8:6];	
if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;	
else
	bypass_mem_1_controller_chk = 0;	

bypass_mem_2_controller_chk = 0;
end

else if(Con.cb.IR[15:12] == 4'd3)
begin
temp_sr1 =  Con.cb.IR[8:6];

temp_sr2 =  Con.cb.IR[11:9];

if(dr == temp_sr2)
	bypass_mem_2_controller_chk = 1;	
else
	bypass_mem_2_controller_chk = 0;

bypass_mem_1_controller_chk = 0;	


end	



else if(Con.cb.IR[15:12] == 4'd7)
begin

temp_sr1 =  Con.cb.IR[8:6];
if(dr == temp_sr1)
	bypass_mem_1_controller_chk = 1;
else
	bypass_mem_1_controller_chk = 0;	
temp_sr2 =  Con.cb.IR[11:9];
if(dr == temp_sr2)
	bypass_mem_2_controller_chk = 1;	
else
	bypass_mem_2_controller_chk = 0;	

end


else if(Con.cb.IR[15:12] == 4'd11)
begin

bypass_mem_1_controller_chk = 0;

temp_sr2 =  Con.cb.IR[11:9];	
if(dr == temp_sr2)
	bypass_mem_2_controller_chk = 1;	
else
	bypass_mem_2_controller_chk = 0;

end

else 
begin 
bypass_mem_1_controller_chk = 1'b0;
bypass_mem_2_controller_chk = 1'b0;

end



end
else 
begin 
bypass_mem_1_controller_chk = 1'b0;
bypass_mem_2_controller_chk = 1'b0;

end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Display Error in bypasses

//Comment the if statement to see the values for correct signals

if((bypass_alu_1_controller_chk !== Con.cb.bypass_alu_1) || (bypass_alu_2_controller_chk !== Con.cb.bypass_alu_2))
begin
$display($time,  ":ns [ERROR][INPUTS] IR_Exec = %h  IR = %h  dr = %h  temp_sr1 = %h  temp_sr2 = %h",Con.cb.IR_Exec , Con.cb.IR ,dr , temp_sr1,temp_sr2 );
$display($time , ":ns [ERROR][OUTPUTS]  bypass_alu1 = %h bypass_alu2 = %h", Con.cb.bypass_alu_1,Con.cb.bypass_alu_2);
$display($time , ":ns [ERROR][EXPECTED][OUTPUTS]  bypass_alu1 = %h bypass_alu2 = %h", bypass_alu_1_controller_chk,bypass_alu_2_controller_chk);
end

if((bypass_mem_1_controller_chk !== Con.cb.bypass_mem_1) || (bypass_mem_2_controller_chk !== Con.cb.bypass_mem_2))
begin
$display($time,  ":ns [ERROR][INPUTS] IR_Exec = %h  IR = %h  dr = %h  temp_sr1 = %h  temp_sr2 = %h",Con.cb.IR_Exec , Con.cb.IR ,dr , temp_sr1,temp_sr2 );
$display($time , ":ns [ERROR][OUTPUTS]  bypass_mem1 = %h bypass_mem2 = %h", Con.cb.bypass_mem_1,Con.cb.bypass_mem_2);
$display($time , ":ns [ERROR][EXPECTED][OUTPUTS]  bypass_mem1 = %h bypass_mem2 = %h", bypass_mem_1_controller_chk,bypass_mem_2_controller_chk);
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Look at the priority if's given to get proper mem states

if((temp_mem_state_controller_chk ==0)&&(( Con.cb.IR_Exec[15:12] == 2)  || ( Con.cb.IR_Exec[15:12] == 6) ))
mem_state_controller_chk = 2'd3;

else if(( Con.cb.IR_Exec[15:12] == 2)  || ( Con.cb.IR_Exec[15:12] == 6) )
mem_state_controller_chk = 2'd0;

else if((temp_mem_state_controller_chk ==2)&&(( Con.cb.IR_Exec[15:12] == 7)  || ( Con.cb.IR_Exec[15:12] == 3) ))
mem_state_controller_chk = 2'd3;

else if(( Con.cb.IR_Exec[15:12] == 3)  || ( Con.cb.IR_Exec[15:12] == 7) )
mem_state_controller_chk = 2'd2;

else if ((Con.cb.IR_Exec[15:12] == 10) && (temp_mem_state_controller_chk ==0))
mem_state_controller_chk = 2'd3;

else if ((Con.cb.IR_Exec[15:12] == 10) && (temp_mem_state_controller_chk ==1))
mem_state_controller_chk = 2'd0;

else if((Con.cb.IR_Exec[15:12] == 10))
mem_state_controller_chk = 2'd1; 

else if ((Con.cb.IR_Exec[15:12] == 11) && (temp_mem_state_controller_chk ==2))
mem_state_controller_chk = 2'd3;

else if ((Con.cb.IR_Exec[15:12] == 11) && (temp_mem_state_controller_chk ==1))
mem_state_controller_chk = 2'd2;

else if((Con.cb.IR_Exec[15:12] == 11))
mem_state_controller_chk = 2'd1; 



else 
mem_state_controller_chk = 2'd3;

if(mem_state_controller_chk !== Con.cb.mem_state)
$display($time , ":ns [ERROR] IR _Exec = %h  temp_mem_state = %h  DUT_memstate = %h",Con.cb.IR_Exec,mem_state_controller_chk,Con.cb.mem_state);

temp_mem_state_controller_chk = mem_state_controller_chk; // value bufffered and used for next mamstate calculation


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//br_taken calculation

br_taken_controller_chk = (|(Con.cb.psr & Con.cb.NZP));
if(br_taken_controller_chk  !== Con.cb.br_taken)
$display($time,":ns [ERROR] Instr_Exec = %h br_taken_controller_chk  = %h DUT = %h ",Con.cb.IR_Exec ,br_taken_controller_chk ,Con.cb.br_taken);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//enables for start up behaviour check unless control given
 
    if(counter_start == 0)
 begin
 $display($time , "Check");
 enable_writeback_controller_chk =0;
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =0;
 counter_start =1;
 end
 
 else  if(counter_start == 1)
 begin
 $display($time , "Check");
 enable_writeback_controller_chk =0;
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 counter_start =2;
 end
 
  else  if(counter_start == 2)
 begin
 $display($time , "Check");
 enable_writeback_controller_chk =1;
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 counter_start =3;
 end
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////ENABLES calculation/////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////IR_Exec is a memory operation////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 if(((Con.cb.IR_Exec[15:12] == 4'd3) || (Con.cb.IR_Exec[15:12] == 4'd7))||((Con.cb.IR_Exec[15:12] == 4'd2) || (Con.cb.IR_Exec[15:12] == 4'd6)) || ((Con.cb.IR_Exec[15:12] == 4'd10)
 || (Con.cb.IR_Exec[15:12] == 4'd11)))
 
 begin
branch_out = 0;
 
 //Ifs given in conjugation with flag and counters and with priority to get one stall for ST,STR and two foor STI
 
 if(((Con.cb.IR_Exec[15:12] == 4'd3) || (Con.cb.IR_Exec[15:12] == 4'd7)) && (stall ==0))
 begin
 enable_writeback_controller_chk =0;      //enables are made zero to insert bubble
 enable_fetch_controller_chk =0;
 enable_decode_controller_chk =0;
 enable_updatePC_controller_chk =0;
 enable_execute_controller_chk =0;
 stall =1;
 flag =0;
 flag1 =0;
 $display($time ,":ns Here %h ",stall);
  end 

 else if((stall == 1) && ((Con.cb.IR_Exec[15:12] == 4'd7) || (Con.cb.IR_Exec[15:12] == 4'd3)))
  begin
   $display($time ,":ns Now Here");
 enable_writeback_controller_chk = 0;//// writeback is zero for stalls
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 stall = 0;
 flag = 1;
 end
 
 else if(flag ==1)
 begin
 enable_writeback_controller_chk =1;
 flag =0;
 end 
 

 
 
 
 
 //////////////////////////////////////////STI - bubble for two cycles
 

if((Con.cb.IR_Exec[15:12] == 4'd11)  && (stall ==0))
 begin
 enable_writeback_controller_chk =0;           //enables are made zero to insert bubble
 enable_fetch_controller_chk =0;
 enable_decode_controller_chk =0;
 enable_updatePC_controller_chk =0;
 enable_execute_controller_chk =0;
 stall =1;
 flag1 = 0;
 flag =0;
  end 
 else if((stall == 1) && (Con.cb.IR_Exec[15:12] == 4'd11))
  begin
 enable_writeback_controller_chk =0;
 enable_fetch_controller_chk = 0;
 enable_decode_controller_chk = 0;
 enable_updatePC_controller_chk = 0;
 enable_execute_controller_chk = 0;
 stall = 2;
 end
 


 else if((stall == 2) && (Con.cb.IR_Exec[15:12] == 4'd11))
  begin
 enable_writeback_controller_chk = 0;//// writeback is zero for stalls
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 stall = 0;
 flag1 = 1;
 end
 
  else  if(flag1 ==1)
 begin
 enable_writeback_controller_chk =1;
 flag1 =0;
 end 
 
 
 
 
 
 ///////////////////////////////////////LD and LDR one bubble need to be inserted
 

 if(((Con.cb.IR_Exec[15:12] == 4'd2) || (Con.cb.IR_Exec[15:12] == 4'd6)) && (stall_1 ==0))
 begin
  $display($time ,"I am here 1 LD and LDR stall_1 = %h", stall_1);
 enable_writeback_controller_chk =0;          //enables are made zero to insert bubble
 enable_fetch_controller_chk =0;
 enable_decode_controller_chk =0;
 enable_updatePC_controller_chk =0;
 enable_execute_controller_chk =0;
 stall_1 =1'b1;
 
 flag1 =0;
 flag =0;
 
  end 
 
 
  else if((stall_1 == 1) && ((Con.cb.IR_Exec[15:12] == 4'd2) || (Con.cb.IR_Exec[15:12] == 4'd6)))
  begin
  $display($time ,"I am here 2 LD and LDR");
 enable_writeback_controller_chk =1;
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 stall_1 = 0;

 end

 
 //////////////////////////////////////////LDI two bubbles need to be inserted
 if((Con.cb.IR_Exec[15:12] == 4'd10)  && (stall_2 ==0))
 begin
 $display($time ,"I am here 1");
 enable_writeback_controller_chk =0;			 //enables are made zero to insert bubble
 enable_fetch_controller_chk =0;
 enable_decode_controller_chk =0;
 enable_updatePC_controller_chk =0;
 enable_execute_controller_chk =0;
 stall_2 =1;
  flag1 =0;
 flag =0;
  end 
 else if((stall_2 == 1) && (Con.cb.IR_Exec[15:12] == 4'd10))
  begin
  $display($time ,"I am here2 stall 1 =  %h " , stall_2);
 enable_writeback_controller_chk =0;			 //enables are made zero to insert bubble
 enable_fetch_controller_chk = 0;
 enable_decode_controller_chk = 0;
 enable_updatePC_controller_chk = 0;
 enable_execute_controller_chk = 0;
 stall_2 = 2;
 end
 
 else if((stall_2 == 2) && (Con.cb.IR_Exec[15:12] == 4'd10))
  begin
  $display($time ,"I am here3");
 enable_writeback_controller_chk = 1;
 enable_fetch_controller_chk =1;
 enable_decode_controller_chk =1;
 enable_updatePC_controller_chk =1;
 enable_execute_controller_chk =1;
 stall_2 = 0;
 end

end
 ////////////////////////////////Control Instructions/////////////////////////////////////////////////////
 //If IR_Exec was memory after stall this loop needs to be executed and only after stalls are executed. Hence the condition
 
 if(((Con.cb.Instr_dout[15:12] == 0) || (Con.cb.Instr_dout[15:12] == 4'd12))  && (stall == 0) && (stall_1 == 0 ) && (stall_2 ==0))
begin//1

if(counter_control == 0)
begin//2
enable_fetch_controller_chk	=0;
enable_updatePC_controller_chk = 0;
counter_control =1;
end//2

else if(counter_control == 1)
begin//2
 enable_updatePC_controller_chk = 0;
enable_fetch_controller_chk	=0;
enable_decode_controller_chk   =0;
counter_control = 2;
end//2

else if(counter_control == 2)
begin//2
if(br_taken_controller_chk == 1)
enable_updatePC_controller_chk = 1;
else
enable_updatePC_controller_chk = 0;

enable_fetch_controller_chk	=0;
enable_decode_controller_chk   =0;
 enable_execute_controller_chk = 0;
 enable_writeback_controller_chk = 0;
counter_control = 3;
end//2

else if(counter_control == 3)
begin//2
enable_updatePC_controller_chk = 1;

enable_fetch_controller_chk	= 1;
enable_decode_controller_chk   =0;
 enable_execute_controller_chk = 0;
 enable_writeback_controller_chk = 0;
counter_control = 0;
branch_out = 1;
end//2

end//

//Till this point no Instruction remains a control instruction. 
//counter_control = 0; to take care if another control insteruction is fetched the upper loop will be executed

//The effect because on the previous control instruction should still be propogated even if next fetched instruction is control


if((stall_1 == 0) && (stall_2 == 0) && (stall == 0))
begin
if(branch_out == 1)
begin

enable_updatePC_controller_chk = 1;

enable_fetch_controller_chk	= 1;
enable_decode_controller_chk   =0;
 enable_execute_controller_chk = 0;
 enable_writeback_controller_chk = 0;
 
 branch_out = 2;
end

else if(branch_out == 2 )
begin

enable_decode_controller_chk   = 1;
 branch_out =3;
end

else if(branch_out == 3 )
begin

enable_execute_controller_chk   = 1;
 branch_out =4;
end
 
 else if((branch_out == 4 ) && (counter_control != 3)) // Condition required because next control instruction will bring both execute and writeback to zero
begin

enable_writeback_controller_chk   = 1;
 branch_out =5;
end
 
end 

//Display//////////

if( (Con.cb.enable_writeback !==    enable_writeback_controller_chk) ||(Con.cb.enable_fetch !==    enable_fetch_controller_chk) || (Con.cb.enable_decode !==   
enable_decode_controller_chk) || (Con.cb.enable_updatePC !==    enable_updatePC_controller_chk) || (Con.cb.enable_execute !==    enable_execute_controller_chk))
begin
$display ($time ,":ns [ERROR] enable_fetch =%h enable_decode = %h enable_execute = %h enable_writeback = %h enable_updatePC = %h",
Con.cb.enable_fetch,Con.cb.enable_decode,Con.cb.enable_execute, Con.cb.enable_writeback ,Con.cb.enable_updatePC );
$display ($time ,":ns [ERROR] enable_fetch =%h enable_decode = %h enable_execute = %h enable_writeback = %h enable_updatePC = %h",
enable_fetch_controller_chk ,enable_decode_controller_chk ,enable_execute_controller_chk , enable_writeback_controller_chk  ,enable_updatePC_controller_chk  );
end

endtask	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task Scoreboard::check_MemAccess();
Dmem_Addr = WB.cb.Data_addr;
Dmem_din = WB.cb.Data_din;
memstate = WB.cb.mem_state;
/////////////////////////////////////Mem State = 0
if(WB.cb.mem_state ==0) /////for LD  LDR  and LDI instructions
begin//1

if(WB.cb.M_Control==1'b1) //For LDI
DMem_addr_MemAccess_chk =  WB.cb.Data_dout;
else //For LD and LDR
DMem_addr_MemAccess_chk = WB.cb.M_Addr;


DMem_din_MemAccess_chk =0;

DMem_rd_MemAccess_chk = 1'b1; ////////////Read

memout_MemAccess_chk = WB.cb.Data_dout;////always 
 

end//1

/////////////////////////////////////Mem State = 1
if((WB.cb.mem_state ==1))
begin

DMem_addr_MemAccess_chk = WB.cb.M_Addr;
DMem_din_MemAccess_chk =0;

DMem_rd_MemAccess_chk = 1'b1;
memout_MemAccess_chk = WB.cb.Data_dout;



end


/////////////////////////////////////Mem State = 2
if(WB.cb.mem_state ==2)  //for ST STR STI instructions 
begin//1


if(WB.cb.M_Control==1'b1)  //For STI 
DMem_addr_MemAccess_chk = WB.cb.Data_dout; 
else //For ST and STR
DMem_addr_MemAccess_chk = WB.cb.M_Addr;



DMem_din_MemAccess_chk =WB.cb.M_Data; 

DMem_rd_MemAccess_chk = 1'b0;  //write


memout_MemAccess_chk = WB.cb.Data_dout; //always


end //1

/////////////////////////////////////Mem State = 3
if(WB.cb.mem_state ==3) //
begin
DMem_addr_MemAccess_chk = 16'bz; 
DMem_din_MemAccess_chk =16'bz;
DMem_rd_MemAccess_chk = 1'bz;
memout_MemAccess_chk = WB.cb.Data_dout;
end

if((DMem_addr_MemAccess_chk !== WB.cb.Data_addr) || (DMem_din_MemAccess_chk !== WB.cb.Data_din) || (DMem_rd_MemAccess_chk  !== WB.cb.Data_rd) || (memout_MemAccess_chk !== WB.cb.memout_MA))
begin
$display($time,":ns MemAccess Error");
$display($time,":ns [INPUTS] mem_state = %h  M_Control = %h    M_addr = %h  M_Data = %h   DMem_dout = %h",WB.cb.mem_state,WB.cb.M_Control, WB.cb.M_Addr ,WB.cb.M_Data, WB.cb.Data_dout);
$display($time,":ns [OUTPUTS] DMem_addr = %h  DMem_rd = %h    DMem_din = %h  memout = %h  ",WB.cb.Data_addr, WB.cb.Data_rd ,WB.cb.Data_din, WB.cb.memout_MA);
$display($time,":ns [EXPECTED][OUTPUTS] DMem_addr = %h   DMem_din = %h    DMem_rd = %h  memout = %h   ",DMem_addr_MemAccess_chk, DMem_din_MemAccess_chk ,DMem_rd_MemAccess_chk,memout_MemAccess_chk);
end


endtask	


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

task Scoreboard::check_WB();
///////////////////////////////////////////////Synchronous signals checked with pkt_cmp
if(temp_enable_writeback == 1'b1)
begin
if(pkt_cmp.psr_WB !== psr_WB_chk)
begin
$display("WRITEBACK Bug");
$display("INPUT");
$display($time, ":ns  W_Control_in = %h  pcout = %h aluout = %h  memout = %h dr = %h " ,temp_W_Control_WB, temp_pcout_WB,temp_aluout_WB,temp_memout_WB ,temp_dr);
$display("OUTPUT");
$display($time, ":ns [ERROR] psr = %h ",  pkt_cmp.psr_WB);
$display("EXPECTED");
$display($time, ":ns [ERROR] psr = %h  ",  psr_WB_chk);
end
end

if(WB.cb.enable_writeback == 1'b1)
begin
    
	temp_enable_writeback = WB.cb.enable_writeback;
	temp_pcout_WB = WB.cb.pcout;
	temp_aluout_WB = WB.cb.aluout;
	temp_memout_WB = WB.cb.memout;
	temp_W_Control_WB = WB.cb.W_Control;
	temp_dr = WB.cb.dr;
//////////////////////////////////DR_in calculation	
	if(WB.cb.W_Control ==0)
	begin
	DR_in = WB.cb.aluout;
	end
	
	else if(WB.cb.W_Control == 2'd1)
	begin
	DR_in = WB.cb.memout;
	end
	
	else if(WB.cb.W_Control == 2'd2)
	begin
	DR_in = WB.cb.pcout;
	end
	
/////////////////////////////psr calculation based on DR_in	
	if(DR_in[15] == 1'b1) begin
	psr_WB_chk = 3'b100;
	end
	
	else if((DR_in[15] == 1'b0)&&(DR_in != 16'b0)) begin
	psr_WB_chk = 3'b001;
	end 
	
	else if(DR_in  == 0) begin
	psr_WB_chk = 3'b010;
	end
///////////////////////////////////////VSR1 and VSR2 values	

	VSR1_WB_chk = Registerfile[WB.cb.sr1];
	
	VSR2_WB_chk = Registerfile[WB.cb.sr2];
	
//////////////////// Display	
	if((WB.cb.d1 !== VSR1_WB_chk) || (WB.cb.d2 !== VSR2_WB_chk) )
	begin
	$display($time, ":ns [ERROR][INPUTS] Instr_dout = %h dr = %h  sr1 = %h  sr2 = %h ", Decode.cb.dout,WB.cb.dr , WB.cb.sr1 , WB.cb.sr2);
	$display($time, ":ns [ERROR] [OUTPUTS]  VSR1 = %h  VSR2 = %h\n",WB.cb.d1,WB.cb.d2);
	$display($time, ":ns [ERROR][EXPECTED] VSR1 = %h  VSR2 = %h",VSR1_WB_chk,VSR2_WB_chk);
	end
	
	Registerfile[WB.cb.dr] = DR_in;
	
	


end

endtask	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task Scoreboard::check_Execute();

if(temp_enable_execute == 1'b1)
begin

if(pkt_cmp.W_Control_out_execute !==  W_Control_out_execute_chk)
$display($time ,":ns [ERROR] W_Control_out  DUT = %h  Golden = %h ",pkt_cmp.W_Control_out_execute , W_Control_out_execute_chk); 

if(pkt_cmp.Mem_Control_out_execute !==  Mem_Control_out_execute_chk)
$display($time ,":ns [ERROR]  Mem_Control_out  DUT = %h Golden = %h ",pkt_cmp.Mem_Control_out_execute ,Mem_Control_out_execute_chk);

if(pkt_cmp.dr_execute !==  dr_execute_chk)
$display($time ,":ns ERROR in IR = %h  dr = %h  dr_exp = %h" ,temp_IR_execute , pkt_cmp.dr_execute , dr_execute_chk );

if(pkt_cmp.IR_Exec_execute !==  IR_Exec_execute_chk)
$display($time , ":ns [ERROR] Expected value = %h  Observed value = %h  ", IR_Exec_execute_chk, pkt_cmp.IR_Exec_execute);

if(pkt_cmp.NZP_execute !==  NZP_execute_chk) 
$display($time,":ns ERROR in NZP DUT = %h Golden = %h", pkt_cmp.NZP_execute,NZP_execute_chk);

if((pkt_cmp.pcout_execute !==  pcout_execute_chk) || (pkt_cmp.aluout_execute !==  aluout_execute_chk) ||  (pkt_cmp.M_Data_execute !==  M_Data_execute_chk))
begin
$display($time ,":ns [ERROR][INPUTS] VSR1 = %h VSR2 = %h aluout = %h pcout = %h  npc = %h IR = %h  IR_Exec = %h  ",temp_VSR1_execute,temp_VSR2_execute,temp_aluout_execute,temp_pcout_execute, temp_npc_in_execute, temp_IR_execute , temp_IR_Exec);
$display($time ,":ns [ERROR][INPUTS] bypass_alu_1 = %h  bypass_alu_2 = %h  bypass_mem_1 = %h bypass_mem_2 = %h Mem_by_Val = %h ",temp_by_alu_1,temp_by_alu_2 ,temp_by_mem_1 ,temp_by_mem_2 ,temp_Mem_Bypass_Val );
$display($time ,":ns [ERROR] [OUTPUTS] aluout = %h pcout = %h M_Data = %h " ,  pkt_cmp.aluout_execute, pkt_cmp.pcout_execute ,pkt_cmp.M_Data_execute);
$display($time ,":ns [ERROR][EXPECTED][OUTPUTS]VSR1_int = %h , VSR2_int = %h"  ,VSR1_int , VSR2_int);
$display($time ,":ns [ERROR][EXPECTED][OUTPUTS] aluout = %h pcout = %h M_Data = %h " ,  aluout_execute_chk, pcout_execute_chk ,M_Data_execute_chk);
end


end

else if(temp_enable_execute == 1'b0)
begin 
if(pkt_cmp.NZP_execute !==  NZP_execute_chk)
$display("ERROR in NZP"); 
end



if(Exe.cb.enable_execute == 1'b1)
begin

temp_enable_execute   		=  Exe.cb.enable_execute;
temp_IR_execute       		=  Exe.cb.IR;
temp_IR_Exec 	      		=  Exe.cb.IR_Exec;
temp_by_alu_1	      		=  Exe.cb.bypass_alu_1;
temp_by_alu_2	      		=  Exe.cb.bypass_alu_2;
temp_by_mem_1	      		=  Exe.cb.bypass_mem_1;
temp_by_mem_2	      		=  Exe.cb.bypass_mem_2;
temp_E_Control_execute 		=  Exe.cb.E_Control;
temp_npc_in_execute 	       	=  Exe.cb.npc;
temp_Mem_Control_in	       	=  Exe.cb.Mem_Control_in;
temp_W_Control_in		=  Exe.cb.W_Control_in;
temp_Mem_Bypass_Val 		=  Exe.cb.Mem_Bypass_Val;
temp_aluout_execute		=  Exe.cb.aluout;
temp_pcout_execute		=  Exe.cb.pcout;
temp_VSR1_execute		=  Exe.cb.VSR1;
temp_VSR2_execute		=  Exe.cb.VSR2;		
     

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	W_Control_out_execute_chk  = Exe.cb.W_Control_in;
	
	Mem_Control_out_execute_chk  = Exe.cb.Mem_Control_in;
	
	IR_Exec_execute_chk  = Exe.cb.IR;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	if((Exe.cb.IR[15:12] == 4'd1) || (Exe.cb.IR[15:12] == 4'd5) || (Exe.cb.IR[15:12] == 4'd9))//ALU
	begin 
	NZP_execute_chk = 0;
	end 
	else if ((Exe.cb.IR[15:12] == 4'd2) || (Exe.cb.IR[15:12] == 4'd6) || (Exe.cb.IR[15:12] == 4'd10) || (Exe.cb.IR[15:12] == 4'd14))//Load
	begin
	NZP_execute_chk = 0;
	end
	else if ((Exe.cb.IR[15:12] == 4'd3) || (Exe.cb.IR[15:12] == 4'd7) || (Exe.cb.IR[15:12] == 4'd11))//Stores
	begin
	NZP_execute_chk = 0;
	end
	else if (Exe.cb.IR[15:12] == 4'd0)
	 begin
	 NZP_execute_chk = Exe.cb.IR[11:9];
	 end
	 else if (Exe.cb.IR[15:12] == 4'd12)
	 begin
	 NZP_execute_chk =  3'd7;
	 end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	/////////////////////////////////////Internal Signals 
	alu_control = Exe.cb.E_Control[5:4];
	pcselect1   = Exe.cb.E_Control[3:2];
	pcselect2   = Exe.cb.E_Control[1];
	op2select   = Exe.cb.E_Control[0];
	
	
	imm5 = {{11{Exe.cb.IR[4]}}, Exe.cb.IR[4:0]};
	offset6 = {{10{Exe.cb.IR[5]}}, Exe.cb.IR[5:0]};
	offset9 = {{7{Exe.cb.IR[8]}}, Exe.cb.IR[8:0]};
	offset11 = {{5{Exe.cb.IR[10]}}, Exe.cb.IR[10:0]};

//////////////////////Priority needs to be understood//////////////////////////////////////////////////////////////////////////////////////	
//Calculation of internal VSR1 nad VSR2

	VSR1_int = Exe.cb.VSR1;
	VSR2_int = Exe.cb.VSR2;
	
	if(Exe.cb.bypass_alu_1 == 1'b1) 
	VSR1_int = Exe.cb.aluout;
	
	if((Exe.cb.bypass_alu_1 == 1'b1) && (Exe.cb.IR_Exec[15:12] == 4'd14))
	VSR1_int = Exe.cb.pcout;
	
	
	if(Exe.cb.bypass_alu_2 == 1'b1)
	VSR2_int = Exe.cb.aluout;
	
	if((Exe.cb.bypass_alu_2 == 1'b1) && (Exe.cb.IR_Exec[15:12] == 4'd14))
	VSR2_int = Exe.cb.pcout;
	
	
	if(Exe.cb.bypass_mem_1 == 1'b1) 
	VSR1_int = Exe.cb.Mem_Bypass_Val;
	

	if(Exe.cb.bypass_mem_2 == 1'b1) 
	VSR2_int = Exe.cb.Mem_Bypass_Val;

//////////////////////////////////aluin1 and aluin2 calculations

	if(op2select == 1'b1)
		aluin2 = VSR2_int;
	else if(op2select == 0)
		aluin2 = imm5;


	aluin1 = VSR1_int;
////////////////////////////////////////////////////////////////////////////////////////////////////
//aluout calculations only affected by ALU instructions

	if((Exe.cb.IR[15:12] == 4'd1) || (Exe.cb.IR[15:12] == 4'd5) || (Exe.cb.IR[15:12] == 4'd9))
	
	begin
		if(alu_control == 2'd0)
		begin
		
		aluout_execute_chk = aluin1 + aluin2;
		
		
		end	
		
		if(alu_control == 2'd1)
		begin

		aluout_execute_chk  = aluin1 & aluin2;
			
		

		end
		
		if(alu_control == 2'd2)
		begin
		
		aluout_execute_chk  = ~(aluin1);
		
		end


	end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//pcout calculations only affected by control and memory instructions

	else if ((Exe.cb.IR[15:12] == 4'd2) || (Exe.cb.IR[15:12] == 4'd6) || (Exe.cb.IR[15:12] == 4'd10) || (Exe.cb.IR[15:12] == 4'd14) ||
	(Exe.cb.IR[15:12] == 4'd3) || (Exe.cb.IR[15:12] == 4'd7) || (Exe.cb.IR[15:12] == 4'd11) || (Exe.cb.IR[15:12] == 4'd0) || (Exe.cb.IR[15:12] == 4'd12))//Load Stores and Control
	begin
	
			
		case(pcselect1)
		0: pcpart1 = offset11;
		1: pcpart1 = offset9;
		2: pcpart1 = offset6;
		3: pcpart1 = 0;
		endcase
		
		case(pcselect2)
		0: pcpart2 = VSR1_int;
		1: pcpart2 = Exe.cb.npc;
		endcase
		
		
		pcout_execute_chk = pcpart1 + pcpart2;
		
	end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////M_Data/////////////////////////////////////////////////////////////////////////////////////////////
	
	M_Data_execute_chk = VSR2_int;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	
///////////////////////////////////////////////////dr//////////////////////////////////////////////////////////////////////////////	
	if((Exe.cb.IR[15:12] == 4'd1) || (Exe.cb.IR[15:12] == 4'd5) || (Exe.cb.IR[15:12] == 4'd9)) //ALU
	begin
		dr_execute_chk = Exe.cb.IR[11:9];
	end
	else if ((Exe.cb.IR[15:12] == 4'd2) || (Exe.cb.IR[15:12] == 4'd6) || (Exe.cb.IR[15:12] == 4'd10) || (Exe.cb.IR[15:12] == 4'd14))//Load
	begin
		dr_execute_chk =  Exe.cb.IR[11:9];
	end
	
	else
	begin
	
		dr_execute_chk =  0;
		
	end

/////////////////////////Asynchronous signals	sr1 and sr2 ///////////////////////////////////////////////////////////////////

	sr1_execute_chk = Exe.cb.IR[8:6]; // For All Instruction
	
	//sr2 = IR[2:0] for all ALU instructions else is 0

	if((Exe.cb.IR[15:12] == 4'd1) || (Exe.cb.IR[15:12] == 4'd5) || (Exe.cb.IR[15:12] == 4'd9)) //Alu
	begin
		sr2_execute_chk = Exe.cb.IR[2:0];
	end
	else if ((Exe.cb.IR[15:12] == 4'd3) || (Exe.cb.IR[15:12] == 4'd7) || (Exe.cb.IR[15:12] == 4'd11))//Stores
	begin
		sr2_execute_chk =  Exe.cb.IR[11:9];
	end
	
	else
	begin
	
		sr2_execute_chk =  0;
		
	end
		
	
		if((sr1_execute_chk !== Exe.cb.sr1) || (sr2_execute_chk !== Exe.cb.sr2))	
	begin
	$display($time, ":ns [ERROR][INPUTS] IR = %h  ", Exe.cb.IR);
	$display($time, ":ns [ERROR][EXPECTED]sr1 = %h  sr2 = %h ",sr1_execute_chk,sr2_execute_chk);
	$display($time, ":ns [ERROR][OUTPUTS]  sr1 = %h sr2 = %h \n",Exe.cb.sr1,Exe.cb.sr2);
	end
	
	end
	
	else if (Exe.cb.enable_execute == 1'b0)
	begin
	temp_enable_execute   =  Exe.cb.enable_execute;
	NZP_execute_chk = 0;
	end 


endtask	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task Scoreboard::check_Decode();
//Decode check
if(temp_enable_decode == 1'b1)         begin

if((IR_decode_chk !== pkt_cmp.IR_decode)||
(W_Control_decode_chk !== pkt_cmp.W_Control_decode) ||
(E_Control_decode_chk !== pkt_cmp.E_Control_decode) ||
(Mem_Control_decode_chk !== pkt_cmp.Mem_Control_decode) || (npc_out_decode_chk !== pkt_cmp.npc_out_decode))
begin
$display("Its a DECODE Bug");
$display("The INPUTS are:");
$display("npc_in = %h  enable_decode = %h  Instr_dout = %h ",temp_npc_in ,temp_enable_decode,temp_Instr_dout);
$display("The OUTPUTS are:");
$display($time ,":ns [ERROR] IR = %h W_Control = %b E_Control = %b Mem_Control = %h npc_out = %h",pkt_cmp.IR_decode,pkt_cmp.W_Control_decode,pkt_cmp.E_Control_decode,pkt_cmp.Mem_Control_decode,pkt_cmp.npc_out_decode);
$display("The EXPECTED values");
$display($time ,":ns [ERROR] [EXPECTED] IR = %h W_Control = %b E_Control = %b Mem_Control = %h npc_out = %h",IR_decode_chk,W_Control_decode_chk,E_Control_decode_chk,Mem_Control_decode_chk,npc_out_decode_chk);
end



end 



if(Decode.cb.enable_decode == 1'b1)         begin

temp_enable_decode = Decode.cb.enable_decode;
temp_npc_in  = Decode.cb.npc_in;
temp_Instr_dout = Decode.cb.dout;


//Calculating Mem_Control , W_Control  , E_Control values
npc_out_decode_chk = Decode.cb.npc_in;
IR_decode_chk = Decode.cb.dout;

if(Decode.cb.dout[15:12] == 4'd14)
begin
W_Control_decode_chk = 2'd2;
end

else if((Decode.cb.dout[15:12] == 4'd2)||(Decode.cb.dout[15:12] == 4'd6)||(Decode.cb.dout[15:12] == 4'd10))
begin
W_Control_decode_chk = 2'd1;
end

else
begin
W_Control_decode_chk = 2'd0;
end

if(Decode.cb.dout[15:12] == 4'd1)
begin
	if(Decode.cb.dout[5] == 1'b0)
	begin
		E_Control_decode_chk[5:4] = 2'b0;
		E_Control_decode_chk[3:2] = 2'b0;
		E_Control_decode_chk[1] = 1'b0;
		E_Control_decode_chk[0] = 1'b1;
		Mem_Control_decode_chk = 1'b0;
		 
	end
	else if(Decode.cb.dout[5] == 1'b1)
	begin
		E_Control_decode_chk[5:4] = 2'b0;
		E_Control_decode_chk[3:2] = 2'b0;
		E_Control_decode_chk[1] = 2'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
	end
	
end

if(Decode.cb.dout[15:12] == 4'd5)
begin
	if(Decode.cb.dout[5] == 1'b0)
	begin
		E_Control_decode_chk[5:4] = 2'b01;
		E_Control_decode_chk[3:2] = 2'b00;
		E_Control_decode_chk[1] = 1'b0;
		E_Control_decode_chk[0] = 1'b1;
		Mem_Control_decode_chk = 1'b0;
		 
	end
	else if(Decode.cb.dout[5] == 1'b1)
	begin
		E_Control_decode_chk[5:4] = 2'b01;
		E_Control_decode_chk[3:2] = 2'b0;
		E_Control_decode_chk[1] = 1'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
	end
	
end

if(Decode.cb.dout[15:12] == 4'd9)
begin
		E_Control_decode_chk[5:4] = 2'b10;
		E_Control_decode_chk[3:2] = 2'b0;
		E_Control_decode_chk[1] = 1'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end

if(Decode.cb.dout[15:12] == 4'd14)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] =  1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end



if(Decode.cb.dout[15:12] == 4'd0)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] = 1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end

if(Decode.cb.dout[15:12] == 4'd12)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b11;
		E_Control_decode_chk[1] =  1'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end


if(Decode.cb.dout[15:12] == 4'd2)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] = 1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end

if(Decode.cb.dout[15:12] == 4'd6)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b10;
		E_Control_decode_chk[1] =  1'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end



if(Decode.cb.dout[15:12] == 4'd10)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] = 1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b1;
		 
end

if(Decode.cb.dout[15:12] == 4'd3)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] =  1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end


if(Decode.cb.dout[15:12] == 4'd7)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b10;
		E_Control_decode_chk[1] = 1'b0;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b0;
		 
end

if(Decode.cb.dout[15:12] == 4'd11)
begin
		E_Control_decode_chk[5:4] = 2'b00;
		E_Control_decode_chk[3:2] = 2'b01;
		E_Control_decode_chk[1] =  1'b1;
		E_Control_decode_chk[0] = 1'b0;
		Mem_Control_decode_chk = 1'b1;
		 
end



end//First

endtask


task Scoreboard::check_Fetch();
if(temp_enable_updatePC == 1'b1)
begin
if((pc_fetch_chk !== pkt_cmp.pc_fetch) || (npc_fetch_chk !== pkt_cmp.npc_fetch))
begin
$display("FETCH Bug");
$display("INPUT");
$display($time, ":ns npc = %h  pc = %h enable_updatePC = %h br_taken = %h taddr = %h " , temp_npc_in_fetch , temp_pc_fetch, temp_enable_updatePC ,temp_br_taken , temp_taddr);
$display("OUTPUT");
$display($time, ":ns [ERROR] npc = %h pc = %h ", pkt_cmp.npc_fetch , pkt_cmp.pc_fetch);
$display("EXPECTED");
$display($time, ":ns [ERROR] npc = %h pc = %h ", npc_fetch_chk , pc_fetch_chk);
end
end


temp_enable_fetch = Fetch.cb.enable_fetch;
temp_npc_in_fetch = Fetch.cb.npc_out;
temp_pc_fetch 	  = Fetch.cb.pc;
temp_enable_updatePC = Fetch.cb.enable_updatePC;
temp_br_taken = Fetch.cb.br_taken;
temp_taddr = Fetch.cb.taddr;
/////////////////new pc for if br_taken

if(Fetch.cb.br_taken == 1'b1)
temp1 = Fetch.cb.taddr;
else
temp1 =  temp_npc_in_fetch;

/////// mux output calculation for enable_updatePC
if(Fetch.cb.enable_updatePC == 1'b1)
temp2 = temp1;
else
temp2 = temp_pc_fetch;

//pc and npc
pc_fetch_chk = temp2;
npc_fetch_chk = temp2 +1 ;

//instrmem_rd if high then only new instruction passed down the pipeline
if(temp_enable_fetch  == 1'b1)
instrmem_rd_fetch_chk = 1;
else
instrmem_rd_fetch_chk = 1'bz;

if(instrmem_rd_fetch_chk !== Fetch.cb.instrmem_rd)
begin
$display("FETCH Bug");
$display("INPUT");
$display($time, ":ns enable_fetch = %h " , temp_enable_fetch);
$display("OUTPUT");
$display($time, ":ns [ERROR] instrmem_rd = %h ", Fetch.cb.instrmem_rd);
$display("EXPECTED");
$display($time, ":ns [ERROR] instrmem_rd = %h ",instrmem_rd_fetch_chk );
end


endtask

///////////////////////////////////////////////////////////////Top Level Checker for signal connections
task Scoreboard::check_Toplevel();

//////////////////////////////Fetch 

if(Fetch.cb.enable_fetch !==   Con.cb.enable_fetch)
$display($time , ":ns [ERROR] Fetch.cb.enable_fetch = %h Con.cb.enable_fetch = %h", Fetch.cb.enable_fetch ,Con.cb.enable_fetch); 

if(Fetch.cb.enable_updatePC !==   Con.cb.enable_updatePC)
$display($time , ":ns [ERROR] Fetch.cb.enable_updatePC = %h Con.cb.enable_updatePC = %h", Fetch.cb.enable_updatePC ,Con.cb.enable_updatePC);

if(Fetch.cb.br_taken !==   Con.cb.br_taken)
$display($time , ":ns [ERROR] Fetch.cb.br_taken = %h Con.cb.br_taken = %h", Fetch.cb.br_taken ,Con.cb.br_taken);


/////////////Decode
if(Decode.cb.enable_decode !==   Con.cb.enable_decode)
$display($time , ":ns [ERROR] Decode.cb.enable_decode = %h Con.cb.enable_decode = %h", Decode.cb.enable_decode ,Con.cb.enable_decode);

if(Decode.cb.npc_in !==   Fetch.cb.npc_out)
$display($time , ":ns [ERROR] Decode.cb.npc_in = %h  Fetch.cb.npc_out = %h", Decode.cb.npc_in,Fetch.cb.npc_out ); 


if(Decode.cb.dout !==   LC3.cb.Instr_dout)
$display($time , ":ns [ERROR] Decode.cb.dout = %h  Fetch.cb.npc_out = %h", Decode.cb.dout,LC3.cb.Instr_dout ); 


//////////////////////Execute
if(Exe.cb.enable_execute !==   Con.cb.enable_execute)
$display($time , ":ns [ERROR] Exe.cb.enable_execute = %h Con.cb.enable_execute = %h", Exe.cb.enable_execute ,Con.cb.enable_execute);

if(Exe.cb.bypass_alu_1 !==   Con.cb.bypass_alu_1)
$display($time , ":ns [ERROR] Exe.cb.bypass_alu_1 = %h Con.cb.bypass_alu_1 = %h", Exe.cb.bypass_alu_1 ,Con.cb.bypass_alu_1);

if(Exe.cb.bypass_alu_2 !==   Con.cb.bypass_alu_2)
$display($time , ":ns [ERROR] Exe.cb.bypass_alu_2 = %h Con.cb.bypass_alu_2 = %h", Exe.cb.bypass_alu_2 ,Con.cb.bypass_alu_2);

if(Exe.cb.bypass_mem_2 !==   Con.cb.bypass_mem_2)
$display($time , ":ns [ERROR] Exe.cb.bypass_mem_2 = %h Con.cb.bypass_mem_2 = %h", Exe.cb.bypass_mem_2 ,Con.cb.bypass_mem_2);

if(Exe.cb.bypass_mem_2 !==   Con.cb.bypass_mem_2)
$display($time , ":ns [ERROR] Exe.cb.bypass_mem_2 = %h Con.cb.bypass_mem_2 = %h", Exe.cb.bypass_mem_2 ,Con.cb.bypass_mem_2);

if(Exe.cb.Mem_Control_in !==   Decode.cb.Mem_Control)
$display($time , ":ns [ERROR] Exe.cb.Mem_Control_in "); 

if(Exe.cb.W_Control_in !==   Decode.cb.W_Control)
$display($time , ":ns [ERROR] Exe.cb.Mem_Control_in = %h   Decode.cb.W_Control = %h ",  Exe.cb.Mem_Control_in, Decode.cb.W_Control);
 

if(Exe.cb.E_Control !==   Decode.cb.E_Control)
$display($time , ":ns [ERROR] Exe.cb.E_Control = %h Decode.cb.E_Control = %h ",Exe.cb.E_Control,Decode.cb.E_Control);

if(Exe.cb.npc !==   Decode.cb.npc_out)
$display($time , ":ns [ERROR] Exe.cb.npc = %h Decode.cb.E_Control = %h ",Exe.cb.npc,Decode.cb.npc_out);

if(Exe.cb.IR !==   Decode.cb.IR)
$display($time , ":ns [ERROR] Exe.cb.IR = %h Decode.cb.IR = %h ",Exe.cb.IR,Decode.cb.IR);

if(Exe.cb.Mem_Bypass_Val !==   WB.cb.memout_MA)
$display($time , ":ns [ERROR] Exe.cb.Mem_Bypass_Val = %h WB.cb.memout_MA = %h ",Exe.cb.Mem_Bypass_Val, WB.cb.memout_MA);

if(WB.cb.d1 !== Exe.cb.VSR1 )
$display($time , ":ns [ERROR] WB.cb.d1 =%h  Exe.cb.VSR1  = %h ",Exe.cb.VSR1,WB.cb.d1);

if(WB.cb.d2 !== Exe.cb.VSR2 )
$display($time , ":ns [ERROR] WB.cb.d2 =%h  Exe.cb.VSR2  = %h ",Exe.cb.VSR2,WB.cb.d2);



////////////////////Writeback
if(WB.cb.enable_writeback !==   Con.cb.enable_writeback)
$display($time , ":ns [ERROR] WB.cb.enable_writeback = %h Con.cb.enable_writeback = %h", WB.cb.enable_writeback ,Con.cb.enable_writeback);

if(WB.cb.W_Control !== Exe.cb.W_Control_out  )
$display($time , ":ns [ERROR] WB.cb.W_Control =%h  Exe.cb.W_Control_out  = %h ",Exe.cb.W_Control_out,WB.cb.W_Control);

if(WB.cb.aluout !== Exe.cb.aluout  )
$display($time , ":ns [ERROR] WB.cb.aluout =%h  Exe.cb.aluout  = %h ",Exe.cb.aluout,WB.cb.aluout);

if(WB.cb.pcout !== Exe.cb.pcout  )
$display($time , ":ns [ERROR] WB.cb.pcout =%h  Exe.cb.pcout  = %h ",Exe.cb.pcout,WB.cb.pcout);

if(WB.cb.memout_MA !== WB.cb.memout  )
$display($time , ":ns [ERROR] WB.cb.memout =%h  WB.cb.memout  = %h ",WB.cb.memout,WB.cb.memout_MA);

if(WB.cb.dr !== Exe.cb.dr  )
$display($time , ":ns [ERROR] WB.cb.dr =%h  Exe.cb.dr  = %h ",Exe.cb.dr,WB.cb.dr);

if(WB.cb.sr1 !== Exe.cb.sr1  )
$display($time , ":ns [ERROR] WB.cb.sr1 =%h  Exe.cb.sr1  = %h ",Exe.cb.sr1,WB.cb.sr1);

if(WB.cb.psr !== Con.cb.psr  )
$display($time , ":ns [ERROR] WB.cb.psr =%h  Con.cb.psr  = %h ",WB.cb.psr,Con.cb.psr);

if(WB.cb.sr2 !== Exe.cb.sr2  )
$display($time , ":ns [ERROR] WB.cb.sr2 =%h  Exe.cb.sr2  = %h ",Exe.cb.pcout,WB.cb.sr2);
/////////////////MemAccess
if(WB.cb.M_Control !== Exe.cb.Mem_Control_out  )
$display($time , ":ns [ERROR] WB.cb.M_Control =%h  Exe.cb.Mem_Control_out  = %h ",WB.cb.M_Control , Exe.cb.Mem_Control_out);

if(WB.cb.M_Data !== Exe.cb.M_Data )
$display($time , ":ns [ERROR] WB.cb.M_Data =%h  Exe.cb.M_Data  = %h ",WB.cb.M_Data , Exe.cb.M_Data);

if(WB.cb.M_Addr !== Exe.cb.pcout )
$display($time , ":ns [ERROR] WB.cb.M_Addr =%h  Exe.cb.pcout  = %h ",WB.cb.M_Addr , Exe.cb.pcout);

if(WB.cb.Data_dout !== LC3.cb.Data_dout )
$display($time , ":ns [ERROR] WB.cb.Data_dout =%h  LC3.cb.Data_dout = %h ",WB.cb.Data_dout , LC3.cb.Data_dout);

if(WB.cb.mem_state !== Con.cb.mem_state)
$display($time , ":ns [ERROR] WB.cb.mem_state =%h Con.cb.mem_state  = %h ",WB.cb.mem_state ,Con.cb.mem_state);

////////////////////Remaining CONTROLLER signals

if(Con.cb.complete_data !== LC3.cb.complete_data )
$display($time , ":ns [ERROR] Con.cb.complete_data =%h  LC3.cb.complete_data  = %h ",Con.cb.complete_data , LC3.cb.complete_data);

if(Con.cb.complete_instr !== LC3.cb.complete_instr )
$display($time , ":ns [ERROR] Con.cb.complete_instr =%h  LC3.cb.complete_instr  = %h ",Con.cb.complete_instr , LC3.cb.complete_instr);

if(Con.cb.IR !== Decode.cb.IR)
$display($time , ":ns [ERROR] Con.cb.IR =%h  Decode.cb.IR  = %h ",Con.cb.IR , Decode.cb.IR);

if(Con.cb.IR_Exec !== Exe.cb.IR_Exec)
$display($time , ":ns [ERROR] Con.cb.IR_Exec =%h  Exe.cb.IR_Exec  = %h ",Con.cb.IR_Exec , Exe.cb.IR_Exec);

if(Con.cb.Instr_dout !== Decode.cb.dout)
$display($time , ":ns [ERROR] Con.cb.Instr_dout =%h  Decode.cb.dout  = %h ",Con.cb.Instr_dout , Decode.cb.dout);

if(Con.cb.psr !== WB.cb.psr)
$display($time , ":ns [ERROR] Con.cb.psr =%h  WB.cb.psr  = %h ",Con.cb.psr , WB.cb.psr);

if(Con.cb.NZP !== Exe.cb.NZP)
$display($time , ":ns [ERROR] Con.cb.NZP =%h  Exe.cb.NZP  = %h ",Con.cb.NZP , Exe.cb.NZP);

endtask



