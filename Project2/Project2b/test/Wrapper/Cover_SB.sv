class Cover_SB;
	string   name;			// unique identifier
	Instruction_Packet pkt_sent = new();	// Packet object from Driver

	extern virtual task start();
	extern virtual task check_pkt_cvg();
	extern virtual task check_stage_cvg();
	virtual TA_Probe_io  ports; 
	
	FetchInputPacket fetch_in_pkt;
	DecInputPacket dec_in_pkt;
	ExInputPacket ex_in_pkt;
	WBInputPacket wb_in_pkt;
	CtrlInputPacket ctrl_in_pkt;
	MAInputPacket ma_in_pkt;
	//CacheInputPacket cache_in_pkt;
	
	FetchOutputPacket fetch_out_pkt;
	DecOutputPacket dec_out_pkt;
	ExOutputPacket ex_out_pkt;
	WBOutputPacket wb_out_pkt;
	CtrlOutputPacket ctrl_out_pkt;
	MAOutputPacket ma_out_pkt;
	//CacheOutputPacket cache_out_pkt;
	
	/****************************
	*  MAILBOXES FOR INPUTS
	*****************************/
	
	typedef mailbox #(Instruction_Packet) out_box_type;
  	out_box_type driver_mbox;		// mailbox for Packet objects from Drivers

	//mailbox for fetch stage inputs
	typedef mailbox #(FetchInputPacket) fetch_inbox_type;
	fetch_inbox_type fetch_in_mbox;
	//mailbox for decode stage inputs
	typedef mailbox #(DecInputPacket) dec_inbox_type;
	dec_inbox_type dec_in_mbox;
	//mailbox for execute stage inputs
	typedef mailbox #(ExInputPacket) ex_inbox_type;
	ex_inbox_type ex_in_mbox;
	//mailbox for writeback stage inputs
	typedef mailbox #(WBInputPacket) wb_inbox_type;
	wb_inbox_type wb_in_mbox;
	//mailbox for controller stage inputs
	typedef mailbox #(CtrlInputPacket) ctrl_inbox_type;
	ctrl_inbox_type ctrl_in_mbox;
	//mailbox for mem access stage inputs
	typedef mailbox #(MAInputPacket) ma_inbox_type;
	ma_inbox_type ma_in_mbox;
	
	//typedef mailbox #(CacheInputPacket) cache_inbox_type;
	//cache_inbox_type cache_in_mbox;


	/****************************
	*  MAILBOXES FOR OUTPUTS
	*****************************/
  
   //mailbox for fetch stage outputs
	typedef mailbox #(FetchOutputPacket) fetch_outbox_type;
	fetch_outbox_type fetch_out_mbox;
	//mailbox for decode stage outputs
	typedef mailbox #(DecOutputPacket) dec_outbox_type;
	dec_outbox_type dec_out_mbox;
	//mailbox for execute stage outputs
	typedef mailbox #(ExOutputPacket) ex_outbox_type;
	ex_outbox_type ex_out_mbox;
	//mailbox for writeback stage outputs
	typedef mailbox #(WBOutputPacket) wb_outbox_type;
	wb_outbox_type wb_out_mbox;
	//mailbox for controller stage outputs
	typedef mailbox #(CtrlOutputPacket) ctrl_outbox_type;
	ctrl_outbox_type ctrl_out_mbox;
	//mailbox for mem access stage outputs
	typedef mailbox #(MAOutputPacket) ma_outbox_type;
	ma_outbox_type ma_out_mbox;
	
	//typedef mailbox #(CacheOutputPacket) cache_outbox_type;
	//cache_outbox_type cache_out_mbox;
	
	extern function new(string name = "Cover_SB", virtual TA_Probe_io  ports);

	//coverage variables
	real alu_cvg_val, control_cvg_val, memory_cvg_val, combination_cvg_val, fetch_cvg_val, decode_cvg_val, execute_cvg_val;
	real writeback_cvg_val, memaccess_cvg_val, ctrl_cvg_val, proc_if_cvg_val, val_arr_cvg_val;
	real mem_if_cvg_val, cache_cvg_val; //cache_data_cvg_val,  cache_ctl_cvg_val, 

	//add covergroups here
	covergroup ALU_Cov;
	
		src1_cp: coverpoint pkt_sent.src1{
			option.weight = 0;
			type_option.weight = 0;
		}
		
		src2_cp: coverpoint pkt_sent.src2{
			option.weight = 0;
			type_option.weight = 0;
		}
		
		imm_en_cp: coverpoint pkt_sent.imm_en {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		imm_cp: coverpoint pkt_sent.imm{
			option.auto_bin_max = 16;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		imm_spec_cp: coverpoint pkt_sent.imm{
			bins ext_one = {5'b10000};
			bins ext_zero = {5'b01111};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		opcode_cp: coverpoint pkt_sent.opcode {
			bins ADD = {`ADD};
			bins AND = {`AND};
			bins NOT = {`NOT};			
			bins JMP = {`JMP};
			bins LD = {`LD};
			bins LDR = {`LDR};
			bins LDI = {`LDI};
			bins LEA = {`LEA};
			bins ST = {`ST};
			bins STR = {`STR};
			bins STI = {`STI};
			
			bins BR = {[0:'1]} iff(pkt_sent.opcode == `BR && pkt_sent.synthInst() != 16'h0000);
			bins NOP = {[0:'1]} iff(pkt_sent.opcode == `BR && pkt_sent.synthInst() == 16'h0000);
			option.weight = 0;
			type_option.weight = 0;
		}
		
		opcode_alu_cp: coverpoint pkt_sent.opcode {
			bins ALU = {`ADD, `AND, `NOT};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		opcode_add_and_cp: coverpoint pkt_sent.opcode {
			bins ADD_AND = {`ADD,`AND};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		dr_cp: coverpoint pkt_sent.dest {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		r_2_1_1_1: cross dr_cp, opcode_alu_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_1_1_2: cross src1_cp, opcode_alu_cp{
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_1_1_3: cross src2_cp, opcode_add_and_cp, imm_en_cp{
			ignore_bins IMM_ENn = binsof(imm_en_cp) intersect {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_1_1_4: cross imm_cp, opcode_add_and_cp, imm_en_cp{
			ignore_bins IMM_ENn = binsof(imm_en_cp) intersect {0};
			option.weight = 1;
			type_option.weight = 1;
		}
	
		r_2_1_1_5__r_2_1_1_6: cross imm_spec_cp, opcode_add_and_cp, imm_en_cp{
			ignore_bins IMM_ENn = binsof(imm_en_cp) intersect {0};			
			option.weight = 2;
			type_option.weight = 2;
		}
	
	endgroup
	
	covergroup Control_Cov;
		
		opcode_cp: coverpoint pkt_sent.opcode {
			bins BR = {`BR};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		pcoffset9_cp: coverpoint pkt_sent.pcOffset9{
			option.auto_bin_max = 10;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		nzp_cp: coverpoint pkt_sent.branchCondition{
			option.weight = 0;
			type_option.weight = 0;
		}
	
		r_2_2_1_1: cross nzp_cp, opcode_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_2_1_2: cross pcoffset9_cp, opcode_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Memory_Cov;
		
		pcoffset9_cp: coverpoint pkt_sent.pcOffset9{
			option.auto_bin_max = 4;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		pcoffset6_cp: coverpoint pkt_sent.pcOffset6{
			option.auto_bin_max = 4;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		opcode_cp: coverpoint pkt_sent.opcode {
			bins LD_I_A = {`LD, `LDI, `LEA};
			bins LDR = {`LDR};
			bins ST_I = {`ST, `STI};
			bins STR = {`STR};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		dr_cp: coverpoint pkt_sent.dest {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		dr_red_cp: coverpoint pkt_sent.dest {
			option.auto_bin_max = 2;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		baser_cp: coverpoint pkt_sent.base {
			option.auto_bin_max = 2;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		sr_cp: coverpoint pkt_sent.src1 {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		sr_red_cp: coverpoint pkt_sent.src1 {
			option.auto_bin_max = 2;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		r_2_3_1_1: cross pcoffset9_cp, dr_cp, opcode_cp {
			ignore_bins ign = binsof(opcode_cp.LDR) || binsof(opcode_cp.ST_I) || binsof(opcode_cp.STR);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_3_2_1: cross pcoffset9_cp, sr_cp, opcode_cp {
			ignore_bins ign = binsof(opcode_cp.LDR) || binsof(opcode_cp.LD_I_A) || binsof(opcode_cp.STR);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_3_3_1: cross pcoffset6_cp, baser_cp, dr_red_cp, opcode_cp {
			ignore_bins ign = binsof(opcode_cp.LD_I_A) || binsof(opcode_cp.ST_I) || binsof(opcode_cp.STR);
			option.weight = 1;
			type_option.weight = 1;
		} 
		
		r_2_3_4_1: cross pcoffset6_cp, baser_cp, sr_red_cp, opcode_cp {
			ignore_bins ign = binsof(opcode_cp.LD_I_A) || binsof(opcode_cp.ST_I) || binsof(opcode_cp.LDR);
			option.weight = 1;
			type_option.weight = 1;
		}
		

	endgroup
	
	covergroup Combination_Cov;
	
		opcode_cp: coverpoint pkt_sent.opcode {
			bins r241 = {`LDR, `STR, `JMP};
			bins r242 = {`BR, `LD, `LDI, `LEA, `ST, `STI};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		opcode2_cp: coverpoint pkt_sent.opcode {
			bins r243 = {`STR, `LDR};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		baser_cp: coverpoint pkt_sent.base {
			option.weight = 0;
			type_option.weight = 0;
		}
	
		pcoffset9_spec_cp: coverpoint pkt_sent.pcOffset9{
			bins ext_one = {9'b100000000};
			bins ext_zero = {9'b011111111};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		pcoffset6_spec_cp: coverpoint pkt_sent.pcOffset6{
			bins ext_one = {6'b100000};
			bins ext_zero = {6'b011111};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		pcoffset9_cp: coverpoint pkt_sent.pcOffset9{
			option.auto_bin_max = 16;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		pcoffset6_cp: coverpoint pkt_sent.pcOffset6{
			option.auto_bin_max = 16;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		r_2_4_1_1: cross opcode_cp, baser_cp {
			ignore_bins ign = binsof(opcode_cp.r242);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_4_2: cross opcode_cp, pcoffset9_spec_cp{
			ignore_bins ign = binsof(opcode_cp.r241);
			option.weight = 2;
			type_option.weight = 2;
		}
		
		r_2_4_2_2: cross opcode_cp, pcoffset9_cp{
			ignore_bins ign = binsof(opcode_cp.r241);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_4_3: cross opcode2_cp, pcoffset6_spec_cp{
			option.weight = 2;
			type_option.weight = 2;
		}
		
		r_2_4_3_2: cross opcode2_cp, pcoffset6_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_2_4_4_1: coverpoint pkt_sent.opcode {
			bins ADD = {`ADD};
			bins AND = {`AND};
			bins NOT = {`NOT};			
			bins JMP = {`JMP};
			bins LD = {`LD};
			bins LDR = {`LDR};
			bins LDI = {`LDI};
			bins LEA = {`LEA};
			bins ST = {`ST};
			bins STR = {`STR};
			bins STI = {`STI};
			
			bins BR = {[0:'1]} iff(pkt_sent.opcode == `BR && pkt_sent.synthInst() != 16'h0000);
			bins NOP = {[0:'1]} iff(pkt_sent.opcode == `BR && pkt_sent.synthInst() == 16'h0000);
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Fetch_Cov;	
		
		r_3_1_1_1: coverpoint fetch_in_pkt.br_taken_in {
			bins enable_0 = {[0:'1]} iff(fetch_in_pkt.br_taken_in == 1'b0);
			bins enable_1 = {[0:'1]} iff(fetch_in_pkt.br_taken_in == 1'b1 && 
							fetch_out_pkt.npc2cmp != fetch_in_pkt.taddr_in);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_1_1_2: coverpoint fetch_in_pkt.enable_fetch_in {
			bins enable_0 = {0};
			bins enable_1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
	
		r_3_1_1_3: coverpoint fetch_in_pkt.enable_updatePC_in {
			bins enable_update_0 = {0};
			bins enable_update_1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
	endgroup
	
	covergroup Decode_Cov;	
		
		r_3_2_1_1: coverpoint dec_in_pkt.enable_decode_in{
			bins enable_0 = {0};
			bins enable_1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_2_1_2: coverpoint dec_out_pkt.E_control2cmp {
			bins b0 = {6'h00};
			bins b1 = {6'h01};
			bins b3 = {6'h10};
			bins b4 = {6'h11};
			bins b5 = {6'h20};
			bins b6 = {6'h06};
			bins b7 = {6'h0c};
			bins b8 = {6'h08};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_2_1_3: coverpoint dec_out_pkt.Mem_control2cmp {
			bins b0 = {0};
			bins b1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_2_1_4: coverpoint dec_out_pkt.W_control2cmp {
			bins b0 = {2'h0};
			bins b1 = {2'h1};
			bins b3 = {2'h2};
			option.weight = 1;
			type_option.weight = 1;
		}
					
	endgroup

	covergroup Execute_Cov;	
	
		opcode_cp: coverpoint ex_in_pkt.IR_in[15:12] {
			bins r332 = {`ADD};
			bins r333 = {`AND};
			bins r334 = {`NOT};
			bins r335 = {`JMP};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		imm_en_cp: coverpoint ex_in_pkt.IR_in[5] {
			bins zero = {0};
			bins one = {1};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		imm_spec_cp: coverpoint ex_in_pkt.IR_in[4:0] {
			bins zero = {0};
			bins allfs = {5'b11111};
			bins positive = {[0:'1]} iff(ex_in_pkt.VSR1_in[4] == 1'b0);
			bins negative = {[0:'1]} iff(ex_in_pkt.VSR1_in[4] == 1'b1);
			option.weight = 0;
			type_option.weight = 0;
		}
		
		VSR1_spec_cp: coverpoint ex_in_pkt.VSR1_in{ 
			bins zero = {0};
			bins allfs = {16'hffff};
			bins special5 = {16'h5555};
			bins speciala = {16'haaaa};
			bins positive = {[0:'1]} iff(ex_in_pkt.VSR1_in[15] == 1'b0);
			bins negative = {[0:'1]} iff(ex_in_pkt.VSR1_in[15] == 1'b1);
			option.weight = 0;
			type_option.weight = 0; 
		}
		
		VSR2_spec_cp: coverpoint ex_in_pkt.VSR2_in{ 
			bins zero = {0};
			bins allfs = {16'hffff};
			bins special5 = {16'h5555};
			bins speciala = {16'haaaa};
			bins positive = {[0:'1]} iff(ex_in_pkt.VSR2_in[15] == 1'b0);
			bins negative = {[0:'1]} iff(ex_in_pkt.VSR2_in[15] == 1'b1);
			option.weight = 0;
			type_option.weight = 0; 
		}
		
		imm_cp: coverpoint ex_in_pkt.IR_in[4:0] {
			option.auto_bin_max = 4;
			option.weight = 0;
			type_option.weight = 0;
		}
		
		VSR1_cp: coverpoint ex_in_pkt.VSR1_in{ 
			option.auto_bin_max = 4;
			option.weight = 0;
			type_option.weight = 0; 
		}
		
		VSR2_cp: coverpoint ex_in_pkt.VSR2_in{ 
			option.auto_bin_max = 4;
			option.weight = 0;
			type_option.weight = 0; 
		}
			
		r_3_3_1_1: coverpoint ex_in_pkt.enable_execute_in{
			bins enable_0 = {0};
			bins enable_1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_2: coverpoint ex_in_pkt.bypass_alu_1_in {
			bins zero = {[0:'1]} iff(ex_in_pkt.bypass_alu_1_in == 1'b0);
			bins one = {[0:'1]} iff(ex_in_pkt.bypass_alu_1_in == 1'b1 && 
						ex_in_pkt.aluout_prev_in != ex_in_pkt.VSR1_in && 
						(ex_in_pkt.E_control_in == 6'h01 || ex_in_pkt.E_control_in == 6'h00 || 
						ex_in_pkt.E_control_in == 6'h11 || ex_in_pkt.E_control_in == 6'h10 || 
						ex_in_pkt.E_control_in == 6'h20 || ex_in_pkt.E_control_in == 6'h0c || 
						ex_in_pkt.E_control_in == 6'h08)); 
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_3: coverpoint ex_in_pkt.bypass_alu_2_in {
			bins zero = {[0:'1]} iff(ex_in_pkt.bypass_alu_2_in == 1'b0);
			bins one = {[0:'1]} iff(ex_in_pkt.bypass_alu_2_in == 1'b1 && 
						ex_in_pkt.aluout_prev_in != ex_in_pkt.VSR2_in &&
						(ex_in_pkt.E_control_in == 6'h01 || ex_in_pkt.E_control_in == 6'h11));
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_4: cross r_3_3_1_2, r_3_3_1_3 {
			ignore_bins ign = binsof(r_3_3_1_2.zero) || binsof(r_3_3_1_3.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_5: coverpoint ex_in_pkt.bypass_mem_1_in {
			bins zero = {[0:'1]} iff(ex_in_pkt.bypass_mem_1_in == 1'b0);
			bins one = {[0:'1]} iff(ex_in_pkt.bypass_mem_1_in == 1'b1 && 
						ex_in_pkt.mem_bypass_in != ex_in_pkt.VSR1_in && 
						(ex_in_pkt.E_control_in == 6'h01 || ex_in_pkt.E_control_in == 6'h00 || 
						ex_in_pkt.E_control_in == 6'h11 || ex_in_pkt.E_control_in == 6'h10 || 
						ex_in_pkt.E_control_in == 6'h20 || ex_in_pkt.E_control_in == 6'h0c || 
						ex_in_pkt.E_control_in == 6'h08)); 
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_6: coverpoint ex_in_pkt.bypass_mem_2_in {
			bins zero = {[0:'1]} iff(ex_in_pkt.bypass_mem_2_in == 1'b0);
			bins one = {[0:'1]} iff(ex_in_pkt.bypass_mem_2_in == 1'b1 && 
						ex_in_pkt.mem_bypass_in != ex_in_pkt.VSR2_in &&
						(ex_in_pkt.E_control_in == 6'h01 || ex_in_pkt.E_control_in == 6'h11));
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_1_7: cross r_3_3_1_5, r_3_3_1_6 {
			ignore_bins ign = binsof(r_3_3_1_5.zero) || binsof(r_3_3_1_6.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		
		r_3_3_2: cross opcode_cp, VSR1_spec_cp, VSR2_spec_cp, imm_en_cp, imm_spec_cp {
			ignore_bins ign = binsof(opcode_cp.r333) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335);
			
			bins r_3_3_2_1 = binsof(VSR1_spec_cp.allfs) && binsof(VSR2_spec_cp.allfs) && binsof(imm_en_cp.zero);
			bins r_3_3_2_2 = binsof(VSR1_spec_cp.allfs) &&	binsof(imm_spec_cp.allfs) && binsof(imm_en_cp.one);
			bins r_3_3_2_3 = binsof(VSR1_spec_cp.zero) && binsof(VSR2_spec_cp.zero) && binsof(imm_en_cp.zero);
			bins r_3_3_2_4 = binsof(VSR1_spec_cp.zero) && binsof(imm_spec_cp.zero) && binsof(imm_en_cp.one);
			bins r_3_3_2_5 = ((binsof(VSR1_spec_cp.special5) && binsof(VSR2_spec_cp.speciala) || 
								  binsof(VSR1_spec_cp.speciala) && binsof(VSR2_spec_cp.special5)) && 
								  binsof(imm_en_cp.zero));
			bins r_3_3_2_6 = binsof(VSR1_spec_cp.positive) && binsof(VSR2_spec_cp.positive) && binsof(imm_en_cp.zero);
			bins r_3_3_2_7 = binsof(VSR1_spec_cp.positive) && binsof(imm_spec_cp.positive) && binsof(imm_en_cp.one);
			bins r_3_3_2_8 = binsof(VSR1_spec_cp.negative) && binsof(VSR2_spec_cp.negative) && binsof(imm_en_cp.zero);
			bins r_3_3_2_9 = binsof(VSR1_spec_cp.negative) && binsof(imm_spec_cp.negative) && binsof(imm_en_cp.one);
			bins r_3_3_2_10 = ((binsof(VSR1_spec_cp.negative) && binsof(imm_spec_cp.positive) || 
						binsof(VSR1_spec_cp.positive) && binsof(imm_spec_cp.negative)) && binsof(imm_en_cp.one)) ||
						((binsof(VSR1_spec_cp.negative) && binsof(VSR2_spec_cp.positive) || 
						binsof(VSR1_spec_cp.positive) && binsof(VSR2_spec_cp.negative)) && binsof(imm_en_cp.zero));
			option.weight = 10;
			type_option.weight = 10;
		}
		
		r_3_3_2_11: cross opcode_cp, VSR1_cp, VSR2_cp, imm_en_cp {
			ignore_bins ign = binsof(opcode_cp.r333) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335) || binsof(imm_en_cp.one);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_2_12: cross opcode_cp, VSR1_cp, imm_en_cp, imm_cp {
			ignore_bins ign = binsof(opcode_cp.r333) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335) || binsof(imm_en_cp.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_3: cross opcode_cp, VSR1_spec_cp, VSR2_spec_cp, imm_en_cp, imm_spec_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335);
			
			bins r_3_3_3_1 = binsof(VSR1_spec_cp.allfs) && binsof(VSR2_spec_cp.allfs) && binsof(imm_en_cp.zero);
			bins r_3_3_3_2 = binsof(VSR1_spec_cp.allfs) &&	binsof(imm_spec_cp.allfs) && binsof(imm_en_cp.one);
			bins r_3_3_3_3 = binsof(VSR1_spec_cp.zero) && binsof(VSR2_spec_cp.zero) && binsof(imm_en_cp.zero);
			bins r_3_3_3_4 = binsof(VSR1_spec_cp.zero) && binsof(imm_spec_cp.zero) && binsof(imm_en_cp.one);
			bins r_3_3_3_5 = ((binsof(VSR1_spec_cp.special5) && binsof(VSR2_spec_cp.speciala) || 
								  binsof(VSR1_spec_cp.speciala) && binsof(VSR2_spec_cp.special5)) && 
								  binsof(imm_en_cp.zero));
			bins r_3_3_3_6 = ((binsof(VSR1_spec_cp.negative) && binsof(imm_spec_cp.positive) || 
									binsof(VSR1_spec_cp.positive) && binsof(imm_spec_cp.negative)) && binsof(imm_en_cp.one)) ||
									((binsof(VSR1_spec_cp.negative) && binsof(VSR2_spec_cp.positive) || 
									binsof(VSR1_spec_cp.positive) && binsof(VSR2_spec_cp.negative)) && binsof(imm_en_cp.zero));
			option.weight = 6;
			type_option.weight = 6;
		}
		
		r_3_3_3_7: cross opcode_cp, VSR1_cp, VSR2_cp, imm_en_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335) || binsof(imm_en_cp.one);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_3_8: cross opcode_cp, VSR1_cp, imm_en_cp, imm_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335) || binsof(imm_en_cp.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_4: cross opcode_cp, VSR1_spec_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r333) || binsof(opcode_cp.r335);
			
			bins r_3_3_4_1 = binsof(VSR1_spec_cp.allfs);
			bins r_3_3_4_2 = binsof(VSR1_spec_cp.zero);
			bins r_3_3_4_3 = binsof(VSR1_spec_cp.speciala) || binsof(VSR1_spec_cp.special5);
			option.weight = 3;
			type_option.weight = 3;
		}
		
		r_3_3_4_4: cross opcode_cp, VSR1_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r334) || binsof(opcode_cp.r335);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_3_5: cross opcode_cp, VSR1_spec_cp {			
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r333) || binsof(opcode_cp.r334);
			bins r_3_3_5_1 = binsof(VSR1_spec_cp.zero);
			bins r_3_3_5_2 = binsof(VSR1_spec_cp.negative);
			bins r_3_3_5_3 = binsof(VSR1_spec_cp.positive);
			option.weight = 3;
			type_option.weight = 3;
		}
		
		r_3_3_5_4: cross opcode_cp, VSR1_cp {
			ignore_bins ign = binsof(opcode_cp.r332) || binsof(opcode_cp.r333) || binsof(opcode_cp.r334);
			option.weight = 1;
			type_option.weight = 1;
		}
						
	endgroup
	
	covergroup Writeback_Cov;
	
		w_control_cp: coverpoint wb_in_pkt.W_Control_wb_in {
			bins b0 = {0};
			bins b1 = {1};
			bins b2 = {2};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		sr1_cp: coverpoint wb_in_pkt.sr1_wb_in {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		sr2_cp: coverpoint wb_in_pkt.sr2_wb_in {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		dr_cp: coverpoint wb_in_pkt.dr_wb_in {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		r0: coverpoint wb_in_pkt.ram_wb_in[0]{
			bins zero = {16'h0};
		}
		
		VSR1_spec_cp: coverpoint wb_out_pkt.VSR12cmp {
			bins zero = {0};
			bins allfs = {16'hffff};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		VSR2_spec_cp: coverpoint wb_out_pkt.VSR22cmp {
			bins zero = {0};
			bins allfs = {16'hffff};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		diff_cp: coverpoint wb_in_pkt.memout_wb_in {
			bins diff = {[0:'1]} iff(wb_in_pkt.memout_wb_in != wb_in_pkt.pcout_wb_in);
			option.weight = 0;
			type_option.weight = 0;
		}
		
		wr_zero_cp: coverpoint wb_in_pkt.aluout_wb_in {
			bins diff = {[0:'1]} iff(((wb_in_pkt.W_Control_wb_in == 2'b00 || wb_in_pkt.W_Control_wb_in == 2'b10) &&
				wb_in_pkt.aluout_wb_in == 16'h0000) || (wb_in_pkt.W_Control_wb_in == 2'b01 &&
				wb_in_pkt.memout_wb_in == 16'h0000));
			option.weight = 0;
			type_option.weight = 0;
		}
		
		wr_allfs_cp: coverpoint wb_in_pkt.aluout_wb_in {
			bins diff = {[0:'1]} iff(((wb_in_pkt.W_Control_wb_in == 2'b00 || wb_in_pkt.W_Control_wb_in == 2'b10) &&
				wb_in_pkt.aluout_wb_in == 16'hffff) || (wb_in_pkt.W_Control_wb_in == 2'b01 &&
				wb_in_pkt.memout_wb_in == 16'hffff));
			option.weight = 0;
			type_option.weight = 0;
		}
	
		r_3_4_1_1: coverpoint wb_in_pkt.enable_wb_in {
			bins enable_0 = {0};
			bins enable_1 = {1};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_1_2: cross w_control_cp, diff_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_2_1: cross sr1_cp, VSR1_spec_cp {
			ignore_bins ign = binsof(VSR1_spec_cp.allfs);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_2_2: cross sr2_cp, VSR2_spec_cp {
			ignore_bins ign = binsof(VSR2_spec_cp.allfs);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_2_3: cross sr1_cp, VSR1_spec_cp {
			ignore_bins ign = binsof(VSR1_spec_cp.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_2_4: cross sr2_cp, VSR2_spec_cp {
			ignore_bins ign = binsof(VSR2_spec_cp.zero);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_3_1: cross dr_cp, wr_zero_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_3_2: cross dr_cp, wr_allfs_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_4_4_1: coverpoint wb_out_pkt.psr2cmp {
			bins psr1 = {3'b001};
			bins psr2 = {3'b010};
			bins psr4 = {3'b100};
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	
	covergroup MemAccess_Cov;
	
		memstate_cp: coverpoint ma_in_pkt.mem_state_in {
			bins load = {2'b00, 2'b01};
			bins write = {2'b10};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		load_spec_cp: coverpoint ma_in_pkt.Data_dout_in  {
			bins load0 = {16'h0000};
			bins load1 = {16'hffff};
			option.weight = 1;
			type_option.weight = 1;
		}
	
		wr_spec_cp: coverpoint ma_in_pkt.M_Data_in  {
			bins wr0 = {16'h0000};
			bins wr1 = {16'hffff};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		load_cp: coverpoint ma_in_pkt.Data_dout_in  {
			option.auto_bin_max = 4;
			option.weight = 1;
			type_option.weight = 1;
		}
	
		wr_cp: coverpoint ma_in_pkt.M_Data_in  {
			option.auto_bin_max = 4;
			option.weight = 1;
			type_option.weight = 1;
		}
		
		addr_cp: coverpoint ma_in_pkt.M_Addr_in  {
			option.auto_bin_max = 8;
			option.weight = 1;
			type_option.weight = 1;
		}
	
		r_3_5_1_1: coverpoint ma_in_pkt.mem_state_in {
			bins memstate0 = {2'b00};
			bins memstate1 = {2'b01};
			bins memstate2 = {2'b10};
			bins memstate3 = {2'b11};
			option.weight = 1;
			type_option.weight = 1;
		
		}
		
		r_3_5_1_2: coverpoint ma_in_pkt.M_control_in  {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_5_2_1__r_3_5_2_2: cross memstate_cp, load_spec_cp {
			ignore_bins ign = binsof(memstate_cp.write);
			option.weight = 2;
			type_option.weight = 2;
		}
	
		r_3_5_2_3: cross addr_cp, memstate_cp, load_cp {
			ignore_bins ign = binsof(memstate_cp.write);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_3_5_3_1__r_3_5_3_2: cross wr_spec_cp, memstate_cp {
			ignore_bins ign = binsof(memstate_cp.load);
			option.weight = 2;
			type_option.weight = 2;
		}
		
		r_3_5_3_3: cross addr_cp, memstate_cp, wr_cp {
			ignore_bins ign = binsof(memstate_cp.load);
			option.weight = 1;
			type_option.weight = 1;
		}
		

	
	endgroup
	
	covergroup Ctrl_Cov;
	
		psr_cp: coverpoint ctrl_in_pkt.psr_in {
			bins psr1 = {3'b001};
			bins psr2 = {3'b010};
			bins psr4 = {3'b100};
			option.weight = 0;
			type_option.weight = 0;
		}
	
		NZP_cp: coverpoint ctrl_in_pkt.NZP_in {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		en_fetch_cp: coverpoint ctrl_out_pkt.enable_fetch2cmp {
			bins zero = {1'b0};
			bins one = {1'b1};
			option.weight = 0;
			type_option.weight = 0;
			
		}
		
		en_uPC_cp: coverpoint ctrl_out_pkt.enable_updatePC2cmp {
			bins zero = {1'b0};
			bins one = {1'b1};
			option.weight = 0;
			type_option.weight = 0;
			
		}
		
		en_dec_cp: coverpoint ctrl_out_pkt.enable_decode2cmp {
			bins zero = {1'b0};
			bins one = {1'b1};
			option.weight = 0;
			type_option.weight = 0;
			
		}
		
		en_ex_cp: coverpoint ctrl_out_pkt.enable_execute2cmp {
			bins zero = {1'b0};
			bins one = {1'b1};
			option.weight = 0;
			type_option.weight = 0;
			
		}
		
		en_wb_cp: coverpoint ctrl_out_pkt.enable_writeback2cmp {
			bins zero = {1'b0};
			bins one = {1'b1};
			option.weight = 0;
			type_option.weight = 0;
			
		}
	
		r_3_6_1_1: coverpoint ctrl_in_pkt.complete_data_in {
			bins comp_data0 = {1'b0};
			bins comp_data1 = {1'b1};
			option.weight = 1;
			type_option.weight = 1;
		
		}
		
		r_3_6_1_2: cross psr_cp, NZP_cp {
			option.weight = 1;
			type_option.weight = 1;

		}
	
		r_3_6_1_3: cross en_uPC_cp, en_fetch_cp, en_dec_cp, en_ex_cp, en_wb_cp { 
			bins t1 = binsof(en_uPC_cp.zero) && binsof(en_fetch_cp.zero) && binsof(en_dec_cp.zero) && binsof(en_ex_cp.zero) && binsof(en_wb_cp.zero);
			bins t2 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one) && binsof(en_dec_cp.one) && binsof(en_ex_cp.one) && binsof(en_wb_cp.one);
			bins t3 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one);
			bins t4 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.zero);
			bins t5 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one) && binsof(en_dec_cp.zero) && binsof(en_ex_cp.zero) && binsof(en_wb_cp.zero);
			bins t6 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one) && binsof(en_dec_cp.one) && binsof(en_ex_cp.one) && binsof(en_wb_cp.zero);
			bins t7 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one) && binsof(en_dec_cp.one) && binsof(en_ex_cp.zero) && binsof(en_wb_cp.one);
			bins t8 = binsof(en_uPC_cp.one) && binsof(en_fetch_cp.one) && binsof(en_dec_cp.one) && binsof(en_ex_cp.zero) && binsof(en_wb_cp.zero);
			bins t9 = binsof(en_uPC_cp.zero) && binsof(en_fetch_cp.zero) && binsof(en_dec_cp.zero) && binsof(en_ex_cp.one) && binsof(en_wb_cp.one);
			option.weight = 1;
			type_option.weight = 1;		
		}
	endgroup
/*	
	covergroup Cache_Ctrl_Cov;
	
		r_4_1_1: coverpoint cache_in_pkt.rd {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_1_2: coverpoint cache_in_pkt.count_in {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_1_3: coverpoint cache_in_pkt.state_in {
			bins b0 = {0};
			bins b1 = {1};
			bins b2 = {2};
			bins b3 = {3};
			bins b4 = {4};
			bins b5 = {5};
			bins b6 = {6};
			bins b7 = {7};
			bins b8 = {8};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		state_out_cp: coverpoint cache_out_pkt.state_out {
			bins b0 = {0};
			bins b1 = {1};
			bins b2 = {2};
			bins b3 = {3};
			bins b4 = {4};
			bins b5 = {5};
			bins b6 = {6};
			bins b7 = {7};
			bins b8 = {8};
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_1_4: cross r_4_1_3, state_out_cp {
			bins t1 = binsof(r_4_1_3.b0) && binsof(state_out_cp.b1);
			bins t2 = binsof(r_4_1_3.b0) && binsof(state_out_cp.b4);
			bins t3 = binsof(r_4_1_3.b3) && binsof(state_out_cp.b2);
			bins t4 = binsof(r_4_1_3.b3) && binsof(state_out_cp.b8);
			bins t5 = binsof(r_4_1_3.b7) && binsof(state_out_cp.b2);
			bins t6 = binsof(r_4_1_3.b7) && binsof(state_out_cp.b8);
			bins t7 = binsof(r_4_1_3.b1) && binsof(state_out_cp.b2);
			bins t8 = binsof(r_4_1_3.b2) && binsof(state_out_cp.b3);
			bins t9 = binsof(r_4_1_3.b4) && binsof(state_out_cp.b5);
			bins t10 = binsof(r_4_1_3.b5) && binsof(state_out_cp.b6);
			bins t11 = binsof(r_4_1_3.b6) && binsof(state_out_cp.b7);
			
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Proc_Intf_Cov;
	
		r_4_2_1: coverpoint cache_out_pkt.complete {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_2_2: coverpoint cache_out_pkt.dout {
			bins b0_0 = {[0:'1]} iff (cache_out_pkt.dout[0] == 0);
			bins b0_1 = {[0:'1]} iff (cache_out_pkt.dout[0] == 1);
			bins b1_0 = {[0:'1]} iff (cache_out_pkt.dout[1] == 0);
			bins b1_1 = {[0:'1]} iff (cache_out_pkt.dout[1] == 1);
			bins b2_0 = {[0:'1]} iff (cache_out_pkt.dout[2] == 0);
			bins b2_1 = {[0:'1]} iff (cache_out_pkt.dout[2] == 1);
			bins b3_0 = {[0:'1]} iff (cache_out_pkt.dout[3] == 0);
			bins b3_1 = {[0:'1]} iff (cache_out_pkt.dout[3] == 1);
			bins b4_0 = {[0:'1]} iff (cache_out_pkt.dout[4] == 0);
			bins b4_1 = {[0:'1]} iff (cache_out_pkt.dout[4] == 1);
			bins b5_0 = {[0:'1]} iff (cache_out_pkt.dout[5] == 0);
			bins b5_1 = {[0:'1]} iff (cache_out_pkt.dout[5] == 1);
			bins b6_0 = {[0:'1]} iff (cache_out_pkt.dout[6] == 0);
			bins b6_1 = {[0:'1]} iff (cache_out_pkt.dout[6] == 1);
			bins b7_0 = {[0:'1]} iff (cache_out_pkt.dout[7] == 0);
			bins b7_1 = {[0:'1]} iff (cache_out_pkt.dout[7] == 1);
			bins b8_0 = {[0:'1]} iff (cache_out_pkt.dout[8] == 0);
			bins b8_1 = {[0:'1]} iff (cache_out_pkt.dout[8] == 1);
			bins b9_0 = {[0:'1]} iff (cache_out_pkt.dout[9] == 0);
			bins b9_1 = {[0:'1]} iff (cache_out_pkt.dout[9] == 1);
			bins b10_0 = {[0:'1]} iff (cache_out_pkt.dout[10] == 0);
			bins b10_1 = {[0:'1]} iff (cache_out_pkt.dout[10] == 1);
			bins b11_0 = {[0:'1]} iff (cache_out_pkt.dout[11] == 0);
			bins b11_1 = {[0:'1]} iff (cache_out_pkt.dout[11] == 1);
			bins b12_0 = {[0:'1]} iff (cache_out_pkt.dout[12] == 0);
			bins b12_1 = {[0:'1]} iff (cache_out_pkt.dout[12] == 1);
			bins b13_0 = {[0:'1]} iff (cache_out_pkt.dout[13] == 0);
			bins b13_1 = {[0:'1]} iff (cache_out_pkt.dout[13] == 1);
			bins b14_0 = {[0:'1]} iff (cache_out_pkt.dout[14] == 0);
			bins b14_1 = {[0:'1]} iff (cache_out_pkt.dout[14] == 1);
			bins b15_0 = {[0:'1]} iff (cache_out_pkt.dout[15] == 0);
			bins b15_1 = {[0:'1]} iff (cache_out_pkt.dout[15] == 1);
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Valid_Arr_Cov;
	
		r_4_3_1: coverpoint cache_in_pkt.addr[5:2] {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_3_2: coverpoint cache_in_pkt.valid_in {
			bins zero = {[0:'1]} iff (cache_in_pkt.valid_in == 0 && cache_in_pkt.state_in != 4'h8);
			bins one = {[0:'1]} iff (cache_in_pkt.valid_in == 1 && cache_in_pkt.state_in != 4'h8);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_3_3: coverpoint cache_in_pkt.validarr_in {
			bins b0_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[0] == 0);
			bins b0_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[0] == 1);
			bins b1_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[1] == 0);
			bins b1_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[1] == 1);
			bins b2_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[2] == 0);
			bins b2_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[2] == 1);
			bins b3_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[3] == 0);
			bins b3_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[3] == 1);
			bins b4_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[4] == 0);
			bins b4_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[4] == 1);
			bins b5_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[5] == 0);
			bins b5_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[5] == 1);
			bins b6_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[6] == 0);
			bins b6_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[6] == 1);
			bins b7_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[7] == 0);
			bins b7_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[7] == 1);
			bins b8_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[8] == 0);
			bins b8_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[8] == 1);
			bins b9_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[9] == 0);
			bins b9_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[9] == 1);
			bins b10_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[10] == 0);
			bins b10_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[10] == 1);
			bins b11_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[11] == 0);
			bins b11_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[11] == 1);
			bins b12_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[12] == 0);
			bins b12_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[12] == 1);
			bins b13_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[13] == 0);
			bins b13_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[13] == 1);
			bins b14_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[14] == 0);
			bins b14_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[14] == 1);
			bins b15_0 = {[0:'1]} iff (cache_in_pkt.validarr_in[15] == 0);
			bins b15_1 = {[0:'1]} iff (cache_in_pkt.validarr_in[15] == 1);
			option.weight = 1;
			type_option.weight = 1;
		} 
	
	endgroup
	
	covergroup Cache_Data_Cov;
	
		state_cp: coverpoint cache_in_pkt.state_in {
			bins two = {2};
			bins four = {4};
			option.weight = 0;
			type_option.weight = 0;
		}
		
		addr_bo_cp: coverpoint cache_in_pkt.addr[1:0] {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		count_cp: coverpoint cache_in_pkt.count_in {
			option.weight = 0;
			type_option.weight = 0;
		}
	
		r_4_4_1: coverpoint cache_out_pkt.rrqst {
			bins rd_hit = {[0:'1]} iff (cache_in_pkt.state_in == 0 && cache_in_pkt.rd == 1 && cache_in_pkt.miss_in == 0);
			bins rd_miss = {[0:'1]} iff (cache_out_pkt.rrqst == 1 && cache_out_pkt.wrqst == 0 && cache_out_pkt.miss_out == 1);
			bins wr_hit = {[0:'1]} iff (cache_out_pkt.wrqst == 1 && cache_out_pkt.miss_out == 0);
			bins wr_miss = {[0:'1]} iff (cache_out_pkt.wrqst == 1 && cache_out_pkt.miss_out == 1);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_2: cross state_cp, addr_bo_cp {
			ignore_bins ign = binsof(state_cp.two);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_3: cross state_cp, count_cp {
			ignore_bins ign = binsof(state_cp.four);
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_4_1: coverpoint cache_in_pkt.blkreg_in[63:48] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_4_2: coverpoint cache_in_pkt.blkreg_in[47:32] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_4_3: coverpoint cache_in_pkt.blkreg_in[31:16] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_4_4: coverpoint cache_in_pkt.blkreg_in[15:0] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_5_1: coverpoint cache_in_pkt.blockdata_in[63:48] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_5_2: coverpoint cache_in_pkt.blockdata_in[47:32] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_5_3: coverpoint cache_in_pkt.blockdata_in[31:16] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		r_4_4_5_4: coverpoint cache_in_pkt.blockdata_in[15:0] {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_6: coverpoint cache_in_pkt.ramrd_in {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_7: coverpoint cache_in_pkt.din {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_8: coverpoint cache_in_pkt.addr[5:2] {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_4_9: coverpoint cache_in_pkt.valid_in {
			bins wr_hit = {[0:'1]} iff (cache_in_pkt.valid_in == 1 && cache_in_pkt.addr[15:6] != cache_in_pkt.memdata_in[73:64]);
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Mem_Intf_Cov;
	
		r_4_5_1: coverpoint cache_in_pkt.offdata_in {
			option.auto_bin_max = 16;
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
	
	covergroup Cache_Cov;
	
		rdrdy_cp: coverpoint cache_in_pkt.rdrdy {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		rdacpt_cp: coverpoint cache_out_pkt.rdacpt {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		rrdy_cp: coverpoint cache_in_pkt.rrdy {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		rrqst_cp: coverpoint cache_out_pkt.rrqst {
			option.weight = 0;
			type_option.weight = 0;
		}
	
		wacpt_cp: coverpoint cache_in_pkt.wacpt {
			option.weight = 0;
			type_option.weight = 0;
		}
		
		wrqst_cp: coverpoint cache_out_pkt.wrqst {
			option.weight = 0;
			type_option.weight = 0;
		}
	
		r_4_6_1: cross rdrdy_cp, rdacpt_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_6_2: cross rrdy_cp, rrqst_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
		
		r_4_6_3: cross wacpt_cp, wrqst_cp {
			option.weight = 1;
			type_option.weight = 1;
		}
	
	endgroup
*/
endclass


function Cover_SB::new(	string name = "Cover_SB", virtual TA_Probe_io  ports );
	this.ports = ports;
	this.name = name;
	this.driver_mbox = driver_mbox;
	this.fetch_in_mbox = fetch_in_mbox;
	this.dec_in_mbox = dec_in_mbox;
	this.ex_in_mbox = ex_in_mbox;
	this.wb_in_mbox = wb_in_mbox;
	this.ctrl_in_mbox = ctrl_in_mbox;
	this.ma_in_mbox = ma_in_mbox;
	//this.cache_in_mbox = cache_in_mbox;
	this.fetch_out_mbox = fetch_out_mbox;
	this.dec_out_mbox = dec_out_mbox;
	this.ex_out_mbox = ex_out_mbox;
	this.wb_out_mbox = wb_out_mbox;
	this.ctrl_out_mbox = ctrl_out_mbox;
	this.ma_out_mbox = ma_out_mbox;
	//this.cache_out_mbox = cache_out_mbox;
	
	ALU_Cov = new();
	Control_Cov = new();
	Memory_Cov = new();
	Combination_Cov = new();
	Fetch_Cov = new();
	Decode_Cov = new();
	Execute_Cov = new();
	Writeback_Cov = new();
	MemAccess_Cov = new();
	Ctrl_Cov = new();
	//Cache_Ctrl_Cov = new();
	//Proc_Intf_Cov = new();
	//Valid_Arr_Cov = new();
	//Cache_Data_Cov = new();
	//Mem_Intf_Cov = new();
	//Cache_Cov = new();
	if (driver_mbox == null) 
		driver_mbox = new();
	if (fetch_in_mbox == null)
		fetch_in_mbox = new();
	if (dec_in_mbox == null)
		dec_in_mbox = new();
	if (ex_in_mbox == null)
		ex_in_mbox = new();
	if (wb_in_mbox == null)
		wb_in_mbox = new();
	if (ctrl_in_mbox == null)
		ctrl_in_mbox = new();
	if (ma_in_mbox == null)
		ma_in_mbox = new();
	//if (cache_in_mbox == null)
	//	cache_in_mbox = new();
	if (fetch_out_mbox == null)
		fetch_out_mbox = new();
	if (dec_out_mbox == null)
		dec_out_mbox = new();
	if (ex_out_mbox == null)
		ex_out_mbox = new();
	if (wb_out_mbox == null)
		wb_out_mbox = new();
	if (ctrl_out_mbox == null)
		ctrl_out_mbox = new();
	if (ma_out_mbox == null)
		ma_out_mbox = new();
	//if (cache_out_mbox == null)
	//	cache_out_mbox = new();
		
endfunction

task Cover_SB::check_stage_cvg();
	Fetch_Cov.sample();
	Decode_Cov.sample();
	Execute_Cov.sample();
	Writeback_Cov.sample();
	MemAccess_Cov.sample();
	Ctrl_Cov.sample();
	//Cache_Ctrl_Cov.sample();
	//Proc_Intf_Cov.sample();
	//Valid_Arr_Cov.sample();
	//Cache_Data_Cov.sample();
	//Mem_Intf_Cov.sample();
	//Cache_Cov.sample();
	
	fetch_cvg_val = Fetch_Cov.get_coverage();
	decode_cvg_val = Decode_Cov.get_coverage();
	execute_cvg_val = Execute_Cov.get_coverage();
	writeback_cvg_val = Writeback_Cov.get_coverage();
	memaccess_cvg_val = MemAccess_Cov.get_coverage();
	ctrl_cvg_val = Ctrl_Cov.get_coverage();
	//cache_ctl_cvg_val = Cache_Ctrl_Cov.get_coverage();
	//proc_if_cvg_val = Proc_Intf_Cov.get_coverage();
	//val_arr_cvg_val = Valid_Arr_Cov.get_coverage();
	//cache_data_cvg_val = Cache_Data_Cov.get_coverage();
	//mem_if_cvg_val = Mem_Intf_Cov.get_coverage();
	//cache_cvg_val = Cache_Cov.get_coverage();
	
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.1 Fetch stage coverage At present = %f", fetch_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.2 Decode stage coverage At present = %f", decode_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.3 Execute stage coverage At present = %f", execute_cvg_val);	
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.4 Writeback stage coverage At present = %f", writeback_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.5 MemAccess stage coverage At present = %f", memaccess_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 3.6 Control stage coverage At present = %f", ctrl_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.1 Cache Controller stage coverage At present = %f", cache_ctl_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.2 ProcInterface stage coverage At present = %f", proc_if_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.3 Valid Array stage coverage At present = %f", val_arr_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.4 Cache Data stage coverage At present = %f", cache_data_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.5 MemInterface stage coverage At present = %f", mem_if_cvg_val);
	//$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 4.5 Generic Cache coverage At present = %f", cache_cvg_val);
endtask;

task Cover_SB::check_pkt_cvg();
	// COVERAGE ADDITION 
	ALU_Cov.sample();	
	Control_Cov.sample();
	Memory_Cov.sample();
	Combination_Cov.sample();
	
	
	alu_cvg_val = 	ALU_Cov.get_coverage();
	control_cvg_val = Control_Cov.get_coverage();
	memory_cvg_val = Memory_Cov.get_coverage();
	combination_cvg_val = Combination_Cov.get_coverage();
	
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 2.1 ALU Operations At present = %f", alu_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 2.2 Control Operations At present = %f", control_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 2.3 Memory Operations At present = %f", memory_cvg_val);
	$display ($time, "  [TA SCOREBOARD -> COVERAGE] Coverage Result for 2.4 Combination Operations At present = %f", combination_cvg_val);
endtask

task Cover_SB::start();
	$display ($time, "[TA COVERAGE METHOD ] TA COVERAGE STARTED");

	
//	$display ($time, "[SCOREBOARD] Receiver Mailbox contents = %d", receiver_mbox.num());
	fork
		forever 
		begin
			if(fetch_out_mbox.try_get(fetch_out_pkt)) begin
				//receiver_mbox.get(pkt2cmp);
				driver_mbox.get(pkt_sent);
				dec_out_mbox.get(dec_out_pkt);
				ex_out_mbox.get(ex_out_pkt);
				wb_out_mbox.get(wb_out_pkt);
				ctrl_out_mbox.get(ctrl_out_pkt);
				ma_out_mbox.get(ma_out_pkt);
				//cache_out_mbox.get(cache_out_pkt);
				fetch_in_mbox.get(this.fetch_in_pkt);
				dec_in_mbox.get(this.dec_in_pkt);
				ex_in_mbox.get(this.ex_in_pkt);
				wb_in_mbox.get(this.wb_in_pkt);
				ctrl_in_mbox.get(this.ctrl_in_pkt);
				ma_in_mbox.get(this.ma_in_pkt);
				//cache_in_mbox.get(cache_in_pkt);
				if (ports.IMem_rd2cmp && ports.complete_instr_in) begin
					check_pkt_cvg();
				end
				check_stage_cvg();
/*
				if (error_count > 0 && `AUTO_STOP) begin
					#20;
					$finish;
				end
*/				
			end
			else begin
				#1;
			end

		end
	join_none
	$display ($time, "[SCOREBOARD] Forking of Process Finished");
endtask
