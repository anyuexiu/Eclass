
`define DEBUG 1


class Scoreboard;


	string   name;			
	Packet pkt_sent = new();	// Packet object from Driver
	OutputPacket   pkt_cmp = new();		// Packet object from Receiver
  	
	typedef mailbox #(Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers

  	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	
	reg	[`REGISTER_WIDTH-1:0] 	aluout_chk;
	reg				carry_chk;
	reg			 	mem_en_chk;
	reg	[`REGISTER_WIDTH-1:0] 	memout_chk;
	
	reg	[`REGISTER_WIDTH-1:0]	aluin1_chk, aluin2_chk; 
	reg	[2:0]			opselect_chk;
	reg	[2:0]			operation_chk;	
	reg	[4:0]          	shift_number_chk;
	reg					enable_shift_chk, enable_arith_chk;
	
	reg		[16:0] 		aluout_half_chk;
	
	extern function new(string name = "Scoreboard", out_box_type driver_mbox = null, rx_box_type receiver_mbox = null);
	extern virtual task start();
	extern virtual task check();
	extern virtual task check_memwrite();
	extern virtual task check_arith();
	extern virtual task check_shift();
	extern virtual task check_memread();
	extern virtual task check_preproc();
endclass

function Scoreboard::new(string name = "Scoreboard", out_box_type driver_mbox = null, rx_box_type receiver_mbox = null);
	this.name = name;
	if (driver_mbox == null) 
		driver_mbox = new();
	if (receiver_mbox == null) 
		receiver_mbox = new();
	this.driver_mbox = driver_mbox;
	this.receiver_mbox = receiver_mbox;
endfunction

		
task Scoreboard::start();
	$display ($time, "ns:  [SCOREBOARD] Scoreboard Started");
	aluout_chk = 0;
	carry_chk=0;
	aluin1_chk = 0; 
	aluin2_chk = 0; 
	opselect_chk = 0;
	operation_chk = 0;	
	shift_number_chk = 0;
	enable_shift_chk = 0; 
	enable_arith_chk = 0;	

	memout_chk=0;
	mem_en_chk=0;

	$display ($time, "ns:  [SCOREBOARD] Receiver Mailbox contentains [%d] Packets ", receiver_mbox.num());
	
	fork
		forever 
		begin
			while(receiver_mbox.num() == 0)
			begin
				$display ($time, "ns:  [SCOREBOARD] Waiting for Data in Receiver Outbox to be populated");
				#`CLK_PERIOD;
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



task Scoreboard::check();
		$display($time, "ns:   [CHECKER] Pkt Contents from Driver: src1 = %h, src2 = %h, imm = %h, ", pkt_sent.src1, pkt_sent.src2, pkt_sent.imm);
		$display($time, "ns:   [CHECKER] Pkt Contents from Driver: opselect = %b, immp_regn = %b, operation = %b, ", pkt_sent.opselect_gen, pkt_sent.immp_regn_op_gen, pkt_sent.operation_gen);
		check_memwrite();
		check_arith();
		check_shift();
		check_memread();
		check_preproc();		
	endtask


 /*
 *Task to Verfiy Memory Write Operation 
 */


task Scoreboard::check_memwrite();

	/* Verifiying the Mem Write */
	if ((pkt_sent.opselect_gen == `MEM_WRITE)&& (pkt_sent.immp_regn_op_gen) &&  pkt_sent.enable) begin // Memory Write Operation

		$display($time, "ns:   Starting |||||--<CHECKER MEM WRITE><--|||||");
			mem_en_chk=1;

			memout_chk=pkt_sent.src2;

			$display($time, "ns:  <CHECKER MEM Write>  MEMDATA WRITE OUT: DUT = %h   & Golden Model = %h",pkt_cmp.mem_data_write_out,memout_chk); 
			$display($time, "ns:  <CHECKER MEM Write>  MEMDATA WRITE ENABLE:DUT = %b   & Golden Model = %b",pkt_cmp.mem_write_en,mem_en_chk);	
	              
		
		
			assert(pkt_cmp.mem_write_en==mem_en_chk) 
			else
				$error($time,"ns:\n*********** <CHECKER MEM Write>  ERROR in Mem Write Enable**************\n");

			assert(memout_chk==pkt_cmp.mem_data_write_out) 
			else
				$error($time,"ns:\n*********** <CHECKER MEM Write>  ERROR in Mem Write Data**************\n");	

	end	

endtask



task Scoreboard::check_arith();


	if((enable_arith_chk==0) && (enable_shift_chk==0)) begin

		$display($time, "ns:  <CHECKER ARITH ALU> ALUOUT: DUT = %h   & Golden Model = %h ",pkt_cmp.aluout, aluout_chk);
		assert(pkt_cmp.aluout==aluout_chk) 
		else 
			$error($time,"ns:\n*********** <CHECKER> ALU Out Changed Dispite Enable=0 **************\n");
	end



	if(1 == enable_arith_chk) begin
		$display($time, "ns:  	 <CHECKER ARITH ALU> Golden Incoming Arithmetic enable = %b", enable_arith_chk);
		$display($time, "ns:  	 <CHECKER ARITH ALU> Golden Incoming ALUIN = %h  %h ", aluin1_chk, aluin2_chk);
		$display($time, "ns:  	 <CHECKER ARITH ALU> Golden Incoming CONTROL = %h(opselect)  %h(operation) ", opselect_chk, operation_chk);


		if ((opselect_chk == `ARITH_LOGIC))	// arithmetic
		begin
			
			$display($time, "ns:   Starting |||||--><CHECKER ARITH ALU><--|||||");


			case(operation_chk)
			`ADD : 	begin {carry_chk,aluout_chk} = aluin1_chk + aluin2_chk;	    end
			`HADD: 	begin  {carry_chk,aluout_half_chk} = aluin1_chk[15:0] + aluin2_chk[15:0]; aluout_chk = {{16{aluout_half_chk[15]}},aluout_half_chk[15:0]};		     end 
			`SUB: 	begin   {carry_chk,aluout_chk} = aluin1_chk - aluin2_chk;    	end 
			`NOT: 	begin   aluout_chk = ~aluin2_chk;carry_chk=0;    	end 
			`AND: 	begin   aluout_chk = aluin1_chk & aluin2_chk;carry_chk=0;    	end
			`OR: 	begin   aluout_chk = aluin1_chk | aluin2_chk;carry_chk=0;    	end
			`XOR: 	begin   aluout_chk = aluin1_chk ^ aluin2_chk;carry_chk=0;      	end
			`LHG: 	begin   aluout_chk = {aluin2_chk[15:0],{16{1'b0}}};carry_chk=0;		end
			endcase
			
	
			$display($time, "ns:  <CHECKER ARITH ALU> ALUOUT: DUT = %h   & Golden Model = %h ",pkt_cmp.aluout, aluout_chk);
			$display($time, "ns:  <CHECKER ARITH ALU> CARRY:DUT = %b & Golden Model = %b \n",pkt_cmp.carry_out,carry_chk);

		
			assert(pkt_cmp.aluout==aluout_chk) 
			else 
				$error($time,"ns:\n*********** <CHECKER ARITH ALU> ERROR in ALU out**************\n");
			assert(carry_chk==pkt_cmp.carry_out) 
			else
				$error($time, "ns:\n***********  <CHECKER ARITH ALU> ERROR in CARRY **************\n");
		end
	end

endtask	



  /*
 *SHIFT ALU Checker 
  */


task Scoreboard:: check_shift();

	parameter   reg_wd    	=   `REGISTER_WIDTH;


	reg [`REGISTER_WIDTH-1:0] sign_mask;

		// Initialize mask 

	foreach( sign_mask[i])
		sign_mask[i]=0;

	
	if(1 == enable_shift_chk) begin

		$display($time, "ns:   <CHECKER SHIFT ALU>  Golden Incoming Shift enable = %b", enable_shift_chk);
		$display($time, "ns:   <CHECKER SHIFT ALU>  Golden Incoming IN = %h  ", aluin1_chk);
		$display($time, "ns:   <CHECKER SHIFT ALU>  Golden Incoming Shift Num = %h  ", shift_number_chk);
		$display($time, "ns:   <CHECKER SHIFT ALU>  Golden Incoming CONTROL = %h(opselect)  %h(operation) ", opselect_chk, operation_chk);

		
		if ((opselect_chk == `SHIFT_REG))	// Shift Operation
		begin
			for(int i=reg_wd-1;i>(reg_wd-1-shift_number_chk);i--) // make a mask using the sign bit of aluin1
	 			 sign_mask[i]= aluin1_chk[reg_wd-1];
		  	$display($time, "ns:   Starting |||||--<CHECKER SHIFT ALU><--|||||");

			case(operation_chk)

			`SHLEFTLOG: begin
					if(`DEBUG)
					$display("Inside SHLEFTLOG");
		       			aluout_chk= aluin1_chk << shift_number_chk;
					carry_chk =0;
		                    end
		        `SHLEFTART:begin
					if(`DEBUG)
					$display("Inside SHLEFTART");
					carry_chk=  aluin1_chk[`REGISTER_WIDTH-1];
					aluout_chk= {aluin1_chk << shift_number_chk};
				   end
			`SHRGHTLOG: begin
					   aluout_chk= aluin1_chk >> shift_number_chk;
					   carry_chk=0;
					   if(`DEBUG)
					   $display("Inside SHRGHTLOG");
				     end
			`SHRGHTART:begin
					   aluout_chk= sign_mask|(aluin1_chk[`REGISTER_WIDTH-2:0] >>shift_number_chk);
					   carry_chk=0;
					   if(`DEBUG)
					   $display("Inside SHRGHTART");
			           end		   

			endcase

			$display($time, "ns:  <CHECKER SHIFT ALU> ALUOUT: DUT = %h   & Golden Model = %h ",pkt_cmp.aluout, aluout_chk);
			$display($time, "ns:  <CHECKER SHIFT ALU> CARRY:DUT = %b & Golden Model = %b \n",pkt_cmp.carry_out,carry_chk);


			assert(pkt_cmp.aluout==aluout_chk) 
			else
				$error($time,"ns:\n*********** <CHECKER SHIFT ALU> ERROR in ALU out**************\n");


			assert(pkt_cmp.carry_out==carry_chk)
			else
				$error($time, "ns:\n***********   <CHECKER SHIFT ALU> ERROR in CARRY **************\n");
		end			
	  end
			
 endtask


 /* MEM READ Checker */

task Scoreboard::check_memread();

	if(1 == enable_arith_chk) begin
		if ((opselect_chk == `MEM_READ))	// Memory Read Operation
		begin
			carry_chk=0;
			$display($time, "ns:   <CHECKER MEM READ> Golden Incoming ALUIN = %h  %h ", aluin1_chk, aluin2_chk);
			$display($time, "ns:   <CHECKER MEM READ> Golden Incoming CONTROL = %h(opselect)  %h(operation) ", opselect_chk, operation_chk);
			$display($time, "ns:   Starting |||||--<CHECKER MEM READ><--|||||");
			case(operation_chk)
			
			`LOADBYTE: begin
					aluout_chk={{24{aluin2_chk[7]}},aluin2_chk[7:0]};
				    end

                       `LOADBYTEU: begin
		   			aluout_chk={{24{1'b0}},aluin2_chk[7:0]};
				   end

		       `LOADHALF: begin
			       		aluout_chk={{16{aluin2_chk[15]}},aluin2_chk[15:0]};
				  end
			`LOADHALFU: begin
					aluout_chk={{16{1'b0}},aluin2_chk[15:0]};
				   end
		       `LOADWORD: begin
			       		aluout_chk=aluin2_chk;
				  end
			default:  begin
				$display(" ERROR invalid Operation for MEM READ Isntruction seen !");
				  end
			endcase
			
		
			$display($time, "ns: <CHECKER MEM READ>  ALUOUT: DUT = %h   & Golden Model = %h ",pkt_cmp.aluout,aluout_chk);	
		        assert(pkt_cmp.aluout==aluout_chk) 
			else
				$error($time,"ns:\n*********** <CHECKER MEM READ> ERROR in ALU out**************\n");

			assert(carry_chk==pkt_cmp.carry_out) 
			else
				$error($time,"ns:\n*********** <CHECKER MEM READ> ERROR in Carry**************\n");
			end
		end        
	
endtask
	

task Scoreboard::check_preproc();

	if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && pkt_sent.enable) begin
		enable_arith_chk = 1'b1;
	end
	else begin
		enable_arith_chk = 1'b0;
	end
	
	if ((pkt_sent.opselect_gen == `SHIFT_REG)&& pkt_sent.enable) begin
		enable_shift_chk = 1'b1;
	end
	else begin
		enable_shift_chk = 1'b0;
	end
		
	if (((pkt_sent.opselect_gen == `ARITH_LOGIC)||((pkt_sent.opselect_gen == `MEM_READ) && (pkt_sent.immp_regn_op_gen==1))) && pkt_sent.enable) begin 
		if((1 == pkt_sent.immp_regn_op_gen)) begin
			if (pkt_sent.opselect_gen == `MEM_READ) // memory read operation that needs to go to dest 
				aluin2_chk = pkt_sent.mem_data;
			else // here we assume that the operation must be a arithmetic operation
				aluin2_chk = pkt_sent.imm;
		end
		else begin
			aluin2_chk = pkt_sent.src2;
		end
	end
	
	if(pkt_sent.enable) begin
		aluin1_chk = pkt_sent.src1;
		operation_chk = pkt_sent.operation_gen;
		opselect_chk = pkt_sent.opselect_gen;
	end
	
	if ((pkt_sent.opselect_gen == `SHIFT_REG)&& pkt_sent.enable) begin
		if (pkt_sent.imm[2] == 1'b0) 
			shift_number_chk = pkt_sent.imm[10:6];
		else 
			shift_number_chk = pkt_sent.src2[4:0];
	end
	else 
		shift_number_chk = 0;		
	
	$display($time, "ns:   [CHECK_PREPROC] ALUIN1: DUT = %h   & Golden Model = %h\n", pkt_cmp.aluin1, aluin1_chk);	
	$display($time, "ns:   [CHECK_PREPROC] ALUIN2: DUT = %h   & Golden Model = %h\n", pkt_cmp.aluin2, aluin2_chk);	
	$display($time, "ns:   [CHECK_PREPROC] ENABLE_ARITH: DUT = %b   & Golden Model = %b\n", pkt_cmp.enable_arith, enable_arith_chk);	
	$display($time, "ns:   [CHECK_PREPROC] ENABLE_SHIFT: DUT = %h   & Golden Model = %h\n", pkt_cmp.enable_shift, enable_shift_chk);	
	$display($time, "ns:   [CHECK_PREPROC] OPERATION: DUT = %h   & Golden Model = %h\n", pkt_cmp.operation, operation_chk);	
	$display($time, "ns:   [CHECK_PREPROC] OPSELECT: DUT = %h   & Golden Model = %h\n", pkt_cmp.opselect, opselect_chk);	
	$display($time, "ns:   [CHECK_PREPROC] SHIFT_NUMBER: DUT = %h   & Golden Model = %h\n", pkt_cmp.shift_number, shift_number_chk);	

endtask	

