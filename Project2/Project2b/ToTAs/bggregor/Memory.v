
`define handshake2 20
`define mem_latency 50
module Memory(reset, rrqst, rrdy, rdrdy, rdacpt, data, wrqst, wacpt);
  	input rrqst, rdacpt, wrqst;
  	output rrdy, rdrdy, wacpt;
  	inout [15:0] data;
  	input reset;
  	reg rrdy, rdrdy, wacpt;

  	reg [15:0] ram[65535:0];
  	reg [3:0] state;
  	reg flag;
  	reg [15:0] readaddr, storedata;
  	reg [1:0] count;
  	integer debug;
	reg [4:0] mycount;
	wire myflag;

  	// controller
  	always @(reset or rrqst or rdacpt or wrqst or state)
    if(reset)
   	begin 
		count<=0;
		state<=0;
		mycount <= 0;
   	end
    else
    begin
      	case(state) 
        	0: 	begin
	        	case({rrqst,wrqst})
		    		3: // write miss
		      		begin
	 					#`handshake2   
	 					readaddr<=data;
	 					flag<=1;
	 					state<=4;
		      		end
		    		2: // read miss
		      		begin	
	 					#`handshake2	
	 					readaddr<=data;
	 					flag<=0;
	 					state<=1;
		      		end
		   			1: // write hit
		      		begin
	 					#`handshake2	
	 					readaddr=data;
	 					flag=0;
		 				state<=4;
		      		end
		   			0: 
		   			begin
						readaddr<=readaddr;
						flag=0;
						state<=0;
	              	end
         		endcase
         	end 
			1: begin
				if(rrqst==0) begin
 					#`handshake2   
 					state<=2;
 				end
	   			else begin
	    			state<=1;
	    		end
	    	end
			2: begin
 				#(`mem_latency-`handshake2) 
 				state<=3;
 			end
			3: begin
				if(rdacpt)
	  			begin
	     			if(count!=3)begin
 						#`handshake2	
 						state<=7;
           			end
	     			else begin
 						#`handshake2	
 						state<=0;
						debug=5;
           			end
         			count <= count+1;
	 			end
	   			else begin
	      			state<=3;
            	end
            end
			4: begin
				if(wrqst==0) begin
					#`handshake2    
					state<=5;
				end
	  			else begin 
	  				state<=4;
	  			end
	  		end
			5: begin 
				if(wrqst) begin
 					#`handshake2	
 					storedata<=data;
    				state<=6;
	    		end
	   			else begin
	     			state<=5;
	     		end
	     	end
			6: begin 
				if(wrqst==0) begin
 	     			if(flag) begin
 						#(`mem_latency-`handshake2) 	
 						state	<=3;
 					end
	     			else begin
 						#`handshake2 	
 						state	<=0;
 					end
 				end
           		else begin
						state	<=6;
				end
			end
			7: begin
             	if(rdacpt==0)begin 
 					#`handshake2 	
 					state<=3;
 				end
          		else begin
					state<=7;
				end
	   		end	
     	endcase
	end

 	// behavior
 	always @(state or storedata)
   	case(state)
     	0: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=0;
      	end
     	1: begin
		  	rrdy<=1;
		  	rdrdy<=0;
		  	wacpt<=0;
      	end
     	3: begin
	  		rrdy<=0;
	  		rdrdy<=1;
			wacpt<=0;
			
		end
     	4: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=1;
       	end
     	6: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=1;
	  		ram[readaddr]<=storedata;
		end
     	default: begin
	  		rrdy<=0;
	  		rdrdy<=0;
	  		wacpt<=0;
		end
   	endcase
	
	always @(state)
		if (~myflag && state==0) mycount = mycount + 1;
	
	assign myflag = (mycount == 20);
		
	
	
	always @(readaddr or count)
	begin
		ram[{readaddr[15:2],count}] = mycount<4? 16'h5555:mycount<6?16'haaaa:mycount<10? 16'hffff:mycount<14?16'h1111:mycount<17?16'h0000:$random ;
	//$display($time,"random number = %h   ,   addr = %h ", ram[{readaddr[15:2],count}],{readaddr[15:2],count} );
	end
/*
	always @(readaddr or count)
		begin
	
	 //(3000201);
		ram[{readaddr[15:2],count}] = $random ;
	//$display($time,"random number = %h   ,   addr = %h ", ram[{readaddr[15:2],count}],{readaddr[15:2],count} );
		end

	*/
  	assign data=(state==3)? ram[{readaddr[15:2],count}] : 16'hz;

endmodule
