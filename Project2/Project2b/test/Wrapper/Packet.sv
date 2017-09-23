`include "defines.v"
class Instruction_Packet;
	string name;
   rand bit [2:0] src1;
   rand bit [2:0] src2;
   rand bit [2:0] dest;
   rand bit [3:0] opcode;
   rand bit [4:0] imm;
   rand bit imm_en;
   rand bit noop_en;
   rand bit [8:0] pcOffset9;
   rand bit [5:0] pcOffset6;
   rand bit [2:0] branchCondition;
   rand bit [2:0] base;
   bit [15:0] instr;

	constraint Full_Custom {
		noop_en inside {[0:0]};
		src1 inside {[0:7]};
		src2 inside {[0:7]};
		dest inside {[0:7]};
		pcOffset9 inside {[0:511]};
		pcOffset6 inside {[0:63]};
		branchCondition inside {[0:7]};
		base inside {[0:7]};
		imm  inside {[0:31]};
		opcode inside {`ADD,`NOT,`AND,`BR,`JMP,`ST,`STR,`STI,`LD,`LDR,`LDI,`LEA};
//		opcode inside {`ST,`STR,`STI};
//		opcode inside {`LD,`LDR,`LDI};


		imm_en inside {0,1};
	}
	
	constraint Execute_1 {
		noop_en inside {[0:0]};
		src1 inside {[0:4]};
		src2 inside {[0:4]};
		dest inside {[5:7]};
		pcOffset9 inside {[0:511]};
		pcOffset6 inside {[0:63]};
		branchCondition inside {[0:7]};
		base inside {[0:7]};
		imm  inside {[0:31]};
		opcode inside {`ADD,`AND};
		imm_en inside {0,1};
	}
	
	constraint Load {
		noop_en inside {[0:0]};
		src1 inside {[0:7]}; //{[0:7]};
		src2 inside {[0:7]}; //{[0:7]};
		dest inside {[0:7]}; //{[0:7]};
		pcOffset9 inside {10};
		pcOffset6 inside {10};
		branchCondition inside {2};
		base inside {[0:7]};
		imm  inside {[0:31]};
//		imm  inside {0};
		opcode inside {`LD};
		imm_en inside {0,1};
	}
	
	constraint OnlyADD_AND {
      noop_en inside {0};
		solve src1 before dest;
		dest inside {7};
      opcode inside {`ADD, `AND}; //allow ADD, AND, NOT instructions only
   }
	
	constraint OnlyALU {
      noop_en inside {0};
		pcOffset9 inside {0};
		branchCondition inside {0};
      opcode inside {`ADD,`NOT,`AND}; //allow ADD, AND, NOT instructions only
   }
	
	constraint r_3_3_1_4 {
      noop_en inside {0};
		src1 inside {1};
		src2 inside {1};
		dest inside {1};
		imm_en inside {0};
      opcode inside {`ADD,`NOT,`AND}; //allow ADD, AND, NOT instructions only
   }
	
	constraint r_3_6_1_3 {
      noop_en inside {0};
		pcOffset9 inside {0};
		branchCondition inside {0};
      opcode inside {`ADD,`NOT,`AND,`BR}; //allow ADD, AND, NOT instructions only
   }
	
/*	
	constraint Full_Custom {
		noop_en inside {[0:0]};
		src1 inside {[0:7]};
		src2 inside {[0:7]};
		dest inside {[0:7]};
		pcOffset9 inside {[0:511]};
		pcOffset6 inside {[0:63]};
		branchCondition inside {[0:7]};
		base inside {[0:7]};
		imm  inside {[0:31]};
		opcode inside {`ADD,`NOT,`AND,`BR,`JMP,`ST,`STR,`STI,`LD,`LDR,`LDI,`LEA};
		imm_en inside {0,1};
	}
	

	constraint Custom {
		noop_en inside {[0:0]};
		src1 inside {[0:2]}; //{[0:7]};
		src2 inside {[0:2]}; //{[0:7]};
		dest inside {[0:2]}; //{[0:7]};
		pcOffset9 inside {0};
		pcOffset6 inside {[0:63]};
		branchCondition inside {0};
		base inside {[0:2]};
		imm  inside {[0:31]};
//		opcode inside {`ADD,`NOT,`AND,`BR,`JMP,`ST,`STR,`STI,`LD,`LDR,`LDI,`LEA};
		opcode inside {`ADD,`NOT,`AND,`BR,`LD,`ST};
//		opcode inside {`ADD,`NOT,`AND,`BR};
		imm_en inside {0,1};
	}

	constraint Store {
		noop_en inside {[0:0]};
		src1 inside {7}; //{[0:7]};
		src2 inside {[0:7]}; //{[0:7]};
		dest inside {[0:6]}; //{[0:7]};
		pcOffset9 inside {1};
		pcOffset6 inside {10};
		branchCondition inside {2};
		base inside {7};
		imm  inside {[0:31]};
//		imm  inside {0};
		opcode inside {`STI};
		imm_en inside {0};
	}	
	
	constraint Branch {
		noop_en inside {[0:0]};
		src1 inside {[0:7]}; //{[0:7]};
		src2 inside {[0:7]}; //{[0:7]};
		dest inside {[0:7]}; //{[0:7]};
		pcOffset9 inside {[0:511]};
		pcOffset6 inside {[0:63]};
		branchCondition inside {[1:7]};
		base inside {[0:7]};
		imm  inside {[0:31]};
		opcode inside {`JMP,`BR};
		imm_en inside {0};
	}

   constraint Full {
      noop_en inside {0};
      opcode inside {[0:3], [5:9], [10:12], 14}; //Allow all legal instructions
   }
       
   constraint OnlyControl {
      noop_en inside {0};
      opcode inside {0, 12}; //allow only control instructions like BRx and JMP
   }
	 
   constraint OnlyMemory {
      noop_en inside {0};
      opcode inside {[2:3], [6:7], [10:11], 14}; //allow loads and stores only
   }
   constraint OnlyLoads {
      noop_en inside {0};
      opcode inside  {2, 6, 10}; //only loads here. LEA is not a load, so it is not here.
   }

   constraint OnlyStores {
      noop_en inside {0};
      opcode inside{3, 7, 11};
   }

   constraint OnlyPCRelative {
      noop_en inside{0};
      opcode inside {[2:3]};
   }
   constraint OnlyRegAddressing {
      noop_en inside{0};
      opcode inside{[6:7]};
   }
   constraint OnlyIndirect {
      noop_en inside{0};
      opcode inside {[10:11]};
   }
   constraint OnlyLEA {
      noop_en inside{0};
      opcode inside {14};
   }
*/
   function bit[15:0] synthInst();
	if (noop_en)
		instr = 16'h0;
	else begin
      case(opcode)
	`BR: instr = {4'b0000, branchCondition, pcOffset9}; //BR
	`ADD: instr = {4'b0001, dest, src1, imm_en, (imm_en?imm:{2'b00, src2})};
 //ADD
	`LD: instr = {4'b0010, dest, pcOffset9}; //LD
	`ST: instr = {4'b0011, src1, pcOffset9}; //ST
	//No 4 case!
	`AND: instr = {4'b0101, dest, src1, imm_en, (imm_en?imm:{2'b00, src2})};
 //AND
	`LDR: instr = {4'b0110, dest, base, pcOffset6}; //LDR
	`STR: instr = {4'b0111, src1, base, pcOffset6}; //STR
	//No 8 case!
	`NOT: instr = {4'b1001, dest, src1, 6'b111111}; //NOT
	`LDI: instr = {4'b1010, dest, pcOffset9}; //LDI
	`STI: instr = {4'b1011, src1, pcOffset9}; //STI
	`JMP: instr = {7'b1100000, base, 6'b000000}; //JMP
	//No 13 case!
	`LEA: instr = {4'b1110, dest, pcOffset9}; //LEA
	default:
	  begin
	     $display($time, "[ERROR IN PACKET GENERATION] Please check the constraints, an invalid instruction was generated with opcode %h.", opcode);
	     instr = 16'hffff; //opcode 15 is invalid, so 16'hffff can be used to return an error.
	  end
      endcase // case (opcode)
	end
      if (instr==16'h0000 && !`ALLOW_NOP) begin
			this.pcOffset9 = 1;
			instr = 16'h0001;
		end
		
      return instr;
   endfunction // bit[15:0] synthInst()


   extern function new(string name = "Packet");
endclass

function Instruction_Packet::new(string name = "Packet");
	this.name = name;
endfunction

