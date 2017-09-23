`include "data_defs.v"
module Instr_Memory(clock, addr, din, rd, wr, Instr_dout, complete_instr);
  	input 			clock, rd, wr;
  	input 	[15:0] 	addr, din;
  	output 	[15:0] 	Instr_dout;
  	output 			complete_instr;

  	reg 	[15:0] 	ram[65535:0];
  	reg 	[15:0] 	Instr_dout;
   
  	assign complete_instr	=1;

  	always @(posedge clock)
   	if(rd) 
    begin
		Instr_dout	<=	ram[addr];
   	end
   	else if (wr)
   	begin
		ram[addr]	<=	din;
    end
endmodule


module Data_Memory(clock, addr, din, rd, Data_dout, complete_data);
  	input 			clock, rd;
  	input 	[15:0] 	addr, din;
  	output 	[15:0] 	Data_dout;
  	output 			complete_data;

  	reg 	[15:0] 	ram[65535:0];
  	reg 	[15:0] 	Data_dout;
   
  	assign complete_data =1;

  	always @(posedge clock)
   	if(rd) 
    begin
		Data_dout	<=	ram[addr];
    end
   	else
    begin
		ram[addr]	<=	din;
   	end
endmodule


module Test_LC3();

 	reg clock; 
 	reg reset;

 	wire 	[15:0] 	Data_addr, Data_din, Data_dout;
	wire 	[15:0] 	pc, Instr_dout;
 	wire 			instrmem_rd, complete_instr;
	wire 			Data_rd, complete_data;

 always 
   #5 clock=~clock;

 initial
   begin
    $readmemh("IMem_5.dat",IMem.ram);
    //$readmemh("IMem_5.dat",IMem.ram);
    $readmemh("DMem_5.dat",DMem.ram);
    //$dumpfile("waves.vcd");
    //$dumpvars;
    //$shm_open("waves.db");
    //$shm_probe("AS");
    clock=0;
    reset=1;
    #23 reset=0;
    #1607
//    $display("MEM[300a]=%d (2 expected)",mem.ram[16'h300a]);
//    $display("MEM[300b]=%d (4 expected)",mem.ram[16'h300b]);
//    $display("MEM[300c]=%d (8 expected)",mem.ram[16'h300c]);
//    $display("MEM[300d]=%d (16 expected)",mem.ram[16'h300d]);
//    $display("MEM[300e]=%d (32 expected)",mem.ram[16'h300e]);
    $finish;
  end

  //SimpleLC3 dut(clock, reset, addr, din, dout, rd, complete);
  LC3 DUT 	(	.clock(clock), .reset(reset), .complete_instr(complete_instr), .complete_data(complete_data),
  				.pc(pc), .instrmem_rd(instrmem_rd), .Instr_dout(Instr_dout), 
  				.Data_addr(Data_addr), .Data_din(Data_din), .Data_dout(Data_dout), .Data_rd(Data_rd)			
			);
  //Memory mem(clock, addr, din, rd, dout, complete);
  Instr_Memory 	IMem 	(	.clock(clock), .addr(pc), .din(16'h0), .rd(instrmem_rd), .wr(1'b0),
  							.Instr_dout(Instr_dout), .complete_instr(complete_instr)
  						);
  Data_Memory	DMem	(	
  							.clock(clock), .addr(Data_addr), .din(Data_din), .rd(Data_rd),
  							.Data_dout(Data_dout), .complete_data(complete_data)
  						);

endmodule












