//`include "data_defs.v"
//module TA_Mon_SB (LC3_io.TB LC3, TA_Probe_io probe_if);
class TA_Mon_SB (LC3_io.TB LC3, TA_Probe_io probe_if);
	
	Cover_SB 		Cov_Inst;			// scoreboard object
	Monitor			Mon_Inst;
	
//	reg [7:0] rand_reg;
//	reg enable_fetch_d1;
//	reg success;
//
//	int run_n_times;
//	int error_count;
//	
	
        Mon_Inst = new("Monitor", LC3, probe_if, 
        				Cov_Inst.driver_mbox, Cov_Inst.fetch_in_mbox, 
		                Cov_Inst.dec_in_mbox, Cov_Inst.ex_in_mbox, Cov_Inst.wb_in_mbox, 
		                Cov_Inst.ctrl_in_mbox, Cov_Inst.ma_in_mbox, //Cov_Inst.cache_in_mbox, 
		                
		                Cov_Inst.fetch_out_mbox, Cov_Inst.dec_out_mbox, Cov_Inst.ex_out_mbox, 
		                Cov_Inst.wb_out_mbox, Cov_Inst.ctrl_out_mbox, Cov_Inst.ma_out_mbox//, 
		                //Cov_Inst.cache_out_mbox
		          );
		
		Cov_Inst = new("Cover_SB", probe_if); 
		fork 
			Mon_Inst.start();
			Cov_Inst.start();
		join_none	
		
		#300000;	
  	end
endclass
//endmodule
