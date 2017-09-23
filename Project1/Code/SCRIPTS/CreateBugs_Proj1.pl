#!/usr/local/bin/perl
#
# CreateBugs.pl
# version 0.1
# 11/19/06


use strict;
use warnings;

my $filename;
my $iter1;
my $iter2;

my $random_number;
my $random_number2;
my $bugnumber;
my $arraysize;
my $destdir; 
my $groupname;
my $number_to_remove;
my $level_array;

my @level1_fullbug_array; 
my @choices_level1_array;
my @level1_fixed_array;
my @level1_bugs;

my @level2_fullbug_array; 
my @choices_level2_array;
my @level2_fixed_array;
my @level2_bugs;

my @level3_fullbug_array; 
my @choices_level3_array;
my @level3_fixed_array;
my @level3_bugs;

@level1_fullbug_array = ([1, 2, 3, 4], [5, 6, 7, 8, 9, 10, 11], [29]);
@choices_level1_array = (2, 1, 1);

@level2_fullbug_array = ([12, 13, 16, 18, 19], [14, 15, 20], [17], [21, 22, 23, 24]);
@choices_level2_array = (1, 1, 1, 1);

@level3_fullbug_array = ([25, 26, 27, 28]);
@choices_level3_array = (2);
#print "@{$fullarray[0]}\n";

if ($#ARGV != 1) {
        print "[ERROR]Incorrect input arguments\n";
        print "[ERROR] Run As ./CreateBugs.pl <Groupname> <Folder where data_defs.v has to be written>\n";
        print "[ERROR] Run As ./CreateBugs.pl Grp1 ./Headers/\n";
        print "[ERROR] Please create the above directory first\n";
        exit;
}

$filename = "BugList$ARGV[0]";
$groupname = $ARGV[0];
$destdir = "$ARGV[1]/$ARGV[0]";

open(SIMWRITE, ">${destdir}/${filename}")|| die "can't open write file : $filename";
open(CSVWRITE, ">${destdir}/${filename}.csv")|| die "can't open write file : ${filename}.csv";
open(DATADEFWRITE, ">${destdir}/data_defs.v") ||die "can't open write file : data_defs.v";
#Creating Level 1 Distribution for input Group and Writing the Distribution to File 
# ************************************************************************************************ 
#																								 #	
#						INSERTING LEVEL 1 BUGS												     #
#     																							 #
# ************************************************************************************************ 
print SIMWRITE "LEVEL 1 BUGS\n";
print SIMWRITE "============\n";
print DATADEFWRITE "`protect\n";
print DATADEFWRITE "\n//LEVEL 1 BUGS\n";

# Create grouping of bugs to be used and the number of bugs to be chosen from this grouping
# Note that the bugs chosen will be added to the list send to student and the rest will be 
# fixed.
$iter2 = 0;
foreach $level_array (@level1_fullbug_array) {
	@level1_fixed_array = @{$level_array};
	print "@level1_fixed_array\n";
	$number_to_remove = $choices_level1_array[$iter2];
	for ($iter1 = 0; $iter1 < $number_to_remove; $iter1 = $iter1 + 1) {
		$arraysize = $#level1_fixed_array + 1;
		$random_number = int((rand(100000)*$arraysize/(100000)));
		push(@level1_bugs, $level1_fixed_array[$random_number]);
		splice(@level1_fixed_array, $random_number, 1 ); 
	}
	$iter2++;
	foreach $bugnumber (@level1_fixed_array) {
		print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	}
}
foreach $bugnumber (@level1_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "    BUG_${bugnumber},";
	
}

# ************************************************************************************************ 
#																								 #	
#						INSERTING LEVEL 2 BUGS												     #
#     																							 #
# ************************************************************************************************ 
print SIMWRITE "\nLEVEL 2 BUGS\n";
print SIMWRITE "============\n";
print DATADEFWRITE "\n//LEVEL 2 BUGS\n";
$iter2 = 0;
foreach $level_array (@level2_fullbug_array) {
	@level2_fixed_array = @{$level_array};
	print "@level2_fixed_array\n";
	$number_to_remove = $choices_level2_array[$iter2];
	for ($iter1 = 0; $iter1 < $number_to_remove; $iter1 = $iter1 + 1) {
		$arraysize = $#level2_fixed_array + 1;
		$random_number = int((rand(100000)*$arraysize/(100000)));
		push(@level2_bugs, $level2_fixed_array[$random_number]);
		splice(@level2_fixed_array, $random_number, 1 ); 
	}
	$iter2++;
	foreach $bugnumber (@level2_fixed_array) {
		print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	}
}
foreach $bugnumber (@level2_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "    BUG_${bugnumber},";
	
}


# ************************************************************************************************ 
#																								 #	
#						INSERTING LEVEL 3 BUGS												     #
#     																							 #
# ************************************************************************************************ 

print SIMWRITE "\nLEVEL 3 BUGS\n";
print SIMWRITE "============\n";
print DATADEFWRITE "\n//LEVEL 3 BUGS\n";
$iter2 = 0;
foreach $level_array (@level3_fullbug_array) {
	@level3_fixed_array = @{$level_array};
	print "@level3_fixed_array\n";
	$number_to_remove = $choices_level3_array[$iter2];
	for ($iter1 = 0; $iter1 < $number_to_remove; $iter1 = $iter1 + 1) {
		$arraysize = $#level3_fixed_array + 1;
		$random_number = int((rand(100000)*$arraysize/(100000)));
		push(@level3_bugs, $level3_fixed_array[$random_number]);
		splice(@level3_fixed_array, $random_number, 1 ); 
	}
	$iter2++;
	foreach $bugnumber (@level3_fixed_array) {
		print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	}
}
foreach $bugnumber (@level3_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "    BUG_${bugnumber},";
	
}

print DATADEFWRITE "\n \n`endprotect\n";
close(SIMWRITE);
close(DATADEFWRITE);
close(CSVWRITE);

print "\n [INFO] IF A NEW PROTECTED VP FILE IS NOT CREATED MAKE SURE YOU HAVE ADDED MODELSIM TO YOU PATH\n";
system("vlog +protect ${destdir}/data_defs.v");
system("cp ./mti_lib/data_defs.vp ${destdir}");

