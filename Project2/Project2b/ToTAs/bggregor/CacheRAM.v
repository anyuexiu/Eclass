module CacheRAM(data, addr, rd);
  	input [3:0] addr;
  	inout [73:0] data;
  	input rd;

  	reg [73:0] memarray[15:0];

  	assign data=(rd==1)?memarray[addr]:74'hz;

  	always @(data or addr or rd)
    	if(rd==0) begin
      		memarray[addr]=data;
      	end
    
endmodule




