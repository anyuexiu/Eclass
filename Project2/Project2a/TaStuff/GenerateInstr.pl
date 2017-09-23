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


sub	dec2hex {
	my $a = shift;
	my $hexval = sprintf("%x", $a);
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


