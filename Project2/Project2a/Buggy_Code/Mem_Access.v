`include "data_defs.v"
module MemAccess(	mem_state, M_Control, M_Data, M_Addr, memout, Data_addr, Data_din, Data_dout, Data_rd);
   input 	[1:0] 	mem_state;
   input 		M_Control;
   input [15:0] 	M_Data;
   input [15:0] 	M_Addr;
   input [15:0] 	Data_dout;

   output [15:0] 	Data_addr;
   output [15:0] 	Data_din;
   output 		Data_rd;
   output [15:0] 	memout;

   reg [15:0] 		addr;           // addresses for memory address
   reg [15:0] 		din;            // data read from/written to memory
   reg 			rd;                    // read/write signal

   reg [15:0] 		Data_addr;
   reg [15:0] 		Data_din;
   reg 			Data_rd;

`protect
   
   always @(mem_state or M_Addr or M_Data or Data_dout or M_Control)
     begin
    	if(mem_state==0)  				// Read Memory 	        
      	  begin
`ifdef BUG35DONEANDDUSTEDWITH             	
       	     if(M_Control==0)
`else 
       	       if(M_Control==1) //BUG35 DIFFICULTY 2
`endif
	  	 Data_addr	<=	M_Addr;  		// M_Control==0 means LD or LDR, addr <= desired address
       	       else 
	  	 Data_addr	<=	Data_dout;    		// M_Control==1 means LDI, addr <= data from last cycle
	     Data_din	<=	16'h0;      		// because it's a read, din doesn't matter
`ifdef BUG40DONEANDDUSTEDWITH
             Data_rd		<=	1'b1;         		// rd should be high for a read
`else
             Data_rd		<=	1'b0;
`endif
      	  end 
    	else if(mem_state==1) 		// Read Indirect Address
      	  begin
	     Data_addr	<=	M_Addr;    		// addr <= desired address
	     Data_din	<=	16'h0;      		// because it's a read, din doesn't matter
             Data_rd		<=	1'b1;         		// rd should be high for a read
      	  end
    	     else if(mem_state==2)     		// Write Memory
      	       begin
`ifdef BUG35DONEANDDUSTEDWITH             	
       		  if(M_Control==0)
`else 
       		    if(M_Control==1) //BUG35 DIFFICULTY 2
`endif
	  	      Data_addr	<=	M_Addr;  		// M_Control==0 means ST or STR, addr <= desired address
       		    else 
	  	      Data_addr	<=	Data_dout;    		// M_Control==1 means STI, addr <= data from last cycle
		  Data_din	<=	M_Data;
        	  Data_rd		<=	1'b0;         		// rd should be low for a write
      	       end
    		  else                  		// Other State
      		    begin
`ifdef BUG36DONEANDDUSTEDWITH             	
		       Data_addr	<=	16'hz;     		// All memory signals should be high impedence
		       Data_din	<=	16'hz;
		       Data_rd		<=	1'bz; 
`else
		       Data_addr	<=	M_Addr;    		// All memory signals should be high impedence 
		       Data_din	<=	16'hx;				// BUG36 DIFFICULTY 2
		       Data_rd		<=	1'b0; 
`endif      		             	
      		    end
     end
   assign memout = Data_dout;
`endprotect
   
endmodule // MemAccess
