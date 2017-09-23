#!/usr/local/bin/perl
#
# GenerateInstr.pl
# version 0.1
# 11/19/06


use strict;
use warnings;



my $opcode;
my $src1;
my $src2;
my $dr; 
my $imm5; 
my $offset9; 
my $offset6; 

my $operation;
my $instruction;
my $instr_hex;
my $arg2;
my $arg3;
my $arg4;
my $nzp;
my $nzp_bin;
my $sr;
#print "@ARGV\n";

if ($#ARGV > 3) {
	print "[ERROR] Too many input arguments\n";
	exit;
}

$operation = $ARGV[0];

#print "Operation Sent in = $operation\n";	

if (($operation =~ /AND|and|ADD|add|NOT|not/)) {
	print "ALU Operation\n";
	if ($operation =~ /AND|and|ADD|add/) {
		if ($#ARGV != 3) {
			print "[ERROR] Incorrect Number of arguments\n";
			print "Example (case insensitive) : AND R7, R3, R2 \n ";
			exit;
		} # end if ($#ARGV != 3		
		else {
			if ($operation =~ /AND|and/) {
				$opcode = sprintf("%04b", 5);
				print "OPCODE BINARY $opcode\n";	
			}
			elsif ($operation =~ /ADD|add/) {
				$opcode = sprintf("%04b", 1);
				print "OPCODE BINARY $opcode\n";			
			}
				
			$instruction = ${opcode};		
			
			if ($ARGV[1] =~ /(r|R)([0-7])/) {
				$dr = sprintf("%03b", $2);
				print "Dest = $dr\n";
				$instruction = ${instruction}.${dr};
			}
			
			if ($ARGV[2] =~ /(r|R)([0-7])/) {
				$src1 = sprintf("%03b", $2);
				print "src1 = $src1\n";
				$instruction = ${instruction}.${src1};
			}
			
			if ($ARGV[3] =~ /(r|R)([0-7])/) {
				$src2 = sprintf("%03b", $2);
				print "src2 = $src2\n";
				$instruction = ${instruction}."000".${src2};
			}
			elsif ($ARGV[3] =~ /(#)([A-Fa-f0-9]+)/) {
				$imm5 = sprintf("%05b", $2);
				print "imm5 = $imm5\n";
				$instruction = ${instruction}."1".${imm5};
			}					
		}		
	} # end if ($opeation =~ /AND|and/
	else { #not operation
		if ($#ARGV != 2) {
			print "[ERROR] Incorrect Number of arguments\n";
			print "Example (case insensitive) : NOT R3, R4 \n ";
			exit;
		} # end if ($#ARGV != 2
		$opcode = sprintf("%04b", 9);
		print "OPCODE BINARY $opcode\n";
		$instruction = 	${opcode};	
		if ($ARGV[1] =~ /(r|R)([0-7])/) {
			$dr = sprintf("%03b", $2);
			print "Dest = $dr\n";
			$instruction = ${instruction}.${dr};
		}
			
		if ($ARGV[2] =~ /(r|R)([0-7])/) {
			$src1 = sprintf("%03b", $2);
			print "src1 = $src1\n";
			$instruction = ${instruction}.${src1}."111111";
		}
	}
	print "Instruction = $instruction\n";
	
	$instr_hex = &bin2hex($instruction);	
	print "Instruction in Hex = $instr_hex\n";

} # end if (($operation =~ /AND|and|ADD|add|
elsif (($operation =~ /JMP|jmp|BR|br/)) {
	print "CONTROL INSTRUCTION\n";
	if ($operation =~ /jmp|JMP/) {
		if ($#ARGV != 1) {
			print "[ERROR] Incorrect Number of arguments\n";
			print "Example (case insensitive) : JMP R7\n ";
			exit;
		} # end if ($#ARGV != 3		
		else { # JMP instruction
			$opcode = sprintf("%04b",12);
			print "OPCODE BINARY $opcode\n";
			$instruction = ${opcode};
			$instruction = ${instruction}."000";
			if ($ARGV[1] =~ /(r|R)([0-7])/) {
				$sr = sprintf("%03b", $2);
				print "BaseR = $sr\n";
				$instruction = ${instruction}.${sr};
			}
			$instruction = ${instruction}."000000";			
		}
	}
	if ($operation =~ /BR|br/) {
		if ($#ARGV != 2) {
			print "[ERROR] Incorrect Number of arguments\n";
			print "Example (case insensitive) : BR NZ #142\n ";
			exit;
		} # end if ($#ARGV != 3		
		else { # BR instruction
			$opcode = sprintf("%04b",0);
			print "OPCODE BINARY $opcode\n";
			$instruction = ${opcode};
			$nzp = 0;
			print "NZP Input = $ARGV[1]\n";
			if ($ARGV[1] =~ /N/) {
				$nzp = 4;
			}
			if($ARGV[1] =~ /Z/) {
				$nzp = $nzp + 2;
			}
			if($ARGV[1] =~ /P/) {
				$nzp = $nzp + 1;	
			}
			$nzp_bin = sprintf("%03b", $nzp);			
			print "NZP Value Bin = $nzp_bin\n";			
			$instruction = ${instruction}.${nzp_bin};
			if ($ARGV[2] =~ /(#)([A-Fa-f0-9]+)/) {
				$offset9 = sprintf("%09b", $2);
				print "Offset9 = $offset9\n";
			}
			$instruction = ${instruction}.${offset9};
			print "Final Instruction Value In Binary = $instruction\n";			
		}
	}
	$instr_hex = &bin2hex($instruction);
	print "Instruction in Hex = $instr_hex\n";
}

elsif (($operation =~ /LD|LDR|LEA|LDI|STI|STR|ST/)) {
	print "MEMORY INSTRUCTION\n";
	if($operation =~ /LDR|STR/) {
		if ($#ARGV != 3) {
			print "[ERROR] Incorrect Number of arguments for LDR|STR\n";
			print "Example (case insensitive) : LDR R7 R2 #12\n ";
			exit;
		} # end if ($#ARGV != 3		
		else {
			if($operation =~ /LDR/) {
				$opcode = sprintf("%04b",6);
			}
			elsif($operation =~ /STR/) {
				$opcode = sprintf("%04b",7);
			}
			print "OPCODE BINARY $opcode\n";
			$instruction = ${opcode};
			
			if ($ARGV[1] =~ /(r|R)([0-7])/) {
				$sr = sprintf("%03b", $2);
				print "DR = $sr\n";
				$instruction = ${instruction}.${sr};
			}

			if ($ARGV[2] =~ /(r|R)([0-7])/) {
				$sr = sprintf("%03b", $2);
				print "BaseR = $sr\n";
				$instruction = ${instruction}.${sr};
			}

			if ($ARGV[3] =~ /(#)([A-Fa-f0-9]+)/) {
				$offset6 = sprintf("%06b", $2);
				print "Offset6 = $offset6\n";
			}
			$instruction = ${instruction}.${offset6};
			
		}		
	}
	elsif ($operation =~ /LD|LEA|LDI|STI|ST/) {
		if ($#ARGV != 2) {
			print "[ERROR] Incorrect Number of arguments for LD|LEA|LDI|STI|ST\n";
			print "Example (case insensitive) : LD R7 #142\n ";
			exit;
		} # end if ($#ARGV != 3		
		else { 
			#if($operation =~ /LD|LEA|LDI|STI|ST/) 
			if($operation =~ /LDI/) {
				$opcode = sprintf("%04b",10);
			}
			elsif($operation =~ /LD/) {
				$opcode = sprintf("%04b",2);
			}
			elsif($operation =~ /LEA/) {
				$opcode = sprintf("%04b",14);
			}
			elsif($operation =~ /STI/) {
				$opcode = sprintf("%04b",11);
			}
			elsif($operation =~ /ST/) {
				$opcode = sprintf("%04b",3);
			}
			print "OPCODE BINARY $opcode\n";
			$instruction = ${opcode};
			
			if ($ARGV[1] =~ /(r|R)([0-7])/) {
				$sr = sprintf("%03b", $2);
				print "DR = $sr\n";
				$instruction = ${instruction}.${sr};
			}

			if ($ARGV[2] =~ /(#)([A-Fa-f0-9]+)/) {
				$offset9 = sprintf("%09b", $2);
				print "Offset9 = $offset9\n";
			}
			$instruction = ${instruction}.${offset9};
			
			
		}
	}
	$instr_hex = &bin2hex($instruction);
	print "Instruction in Hex = $instr_hex\n";
}

sub	dec2hex {
	my $a = shift;
	my $hexval = sprintf("%.4x", $a);
	return $hexval;
}

sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub bin2hex {
	my $binary = shift;
	my $decimal = &bin2dec($binary);
	my $hex = &dec2hex($decimal);
	return $hex;
}

