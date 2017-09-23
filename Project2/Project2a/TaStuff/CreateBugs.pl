#!/usr/local/bin/perl
#
# CreateBugs.pl
# version 0.1
# 11/19/06


use strict;
use warnings;



my $filename;

my 	$level1bug2;
my 	$level1bug3;
my 	$level1_32_33;
my 	$chose_32_33;

my @level1_options;
my @level1_bugs;

my @level2_options;
my @level2_bugs;


my 	$level2bug1;
my 	$level2bug2;
my 	$level2bug3;
my 	$level2bug4;
my 	$level2bug5;


my 	$level2_15_21;
my	$level2_26_27;
my	$level2_28_29;
my	$level2_30_31;
my	$level2_35_40;
my	$level2_13_25; 
my  @level2_temp_array;
my 	$level2_exec;
my 	$level2_control;
my 	$level2_wb;


my 	@level3_options;
my 	@level3_bugs;

my 	$level3bug1;
my 	$level3bug2;
my 	$level3bug3;
my 	$level3bug4;

my	$level3_6_7;
my	$level3_14_19;
my	$level3_22_24;
my	$level3_37_39;
my  @level3_temp_array;

my $random_number;
my $bugnumber;
my $arraysize;
my $destdir; 

if ($#ARGV != 1) {
        print "[ERROR]Incorrect input arguments\n";
        print "[ERROR] Run As ./CreateBugs.pl <Groupname> <Folder where data_defs.v has to be written>\n";
        print "[ERROR] Run As ./CreateBugs.pl Grp1 ./Headers/Grp1/\n";
        #print "[ERROR] Please create the above directory first\n";
        exit;
}
$filename = "BugList$ARGV[0]";
$destdir = $ARGV[1];
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
print DATADEFWRITE "\n//LEVEL 2 BUGS\n";

$level1_bugs[0] = 1;
#selection between Bug 32/33 if needed
$random_number = rand(100000);
if	($random_number > 50000) {
	$level1_32_33 = 32;	
	print DATADEFWRITE "`define BUG33DONEANDDUSTEDWITH\n";
}
else {
	$level1_32_33 = 33;	
	print DATADEFWRITE "`define BUG32DONEANDDUSTEDWITH\n";
}
@level1_options = (8,9, 34, $level1_32_33);
print "Level1 Options @level1_options\n";

#Create 1 index out of 4
$arraysize = $#level1_options + 1;
$random_number = int((rand(10000)*$arraysize)/(10000));
if($random_number == 3) {
	$chose_32_33 = 1;	
}
else {
	$chose_32_33 = 0;	
}
push(@level1_bugs, $level1_options[$random_number]);
splice(@level1_options, $random_number, 1 ); 

#Create 1 index out of 3
$arraysize = $#level1_options + 1;
$random_number = int((rand(10000)*$arraysize)/(10000));
push(@level1_bugs, $level1_options[$random_number]);
splice(@level1_options, $random_number, 1 ); 

if($random_number == 3) {
	$chose_32_33 = 1;	
}
else {
	$chose_32_33 = 0;	
}

print "Level1 Bugs = @level1_bugs\n";

foreach $bugnumber (@level1_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "  BUG_${bugnumber},";
	
}

foreach $bugnumber (@level1_options) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}


# ************************************************************************************************ 
#																								 #	
#						INSERTING LEVEL 2 BUGS												     #
#     																							 #
# ************************************************************************************************ 
print SIMWRITE "\nLEVEL 2 BUGS\n";
print SIMWRITE "============\n";
print DATADEFWRITE "\n//LEVEL 2 BUGS\n";

if((rand(100000) > 50000)){ $level2_13_25 = 13; print DATADEFWRITE "`define BUG25DONEANDDUSTEDWITH\n";}
else { $level2_13_25 = 25; print DATADEFWRITE "`define BUG13DONEANDDUSTEDWITH\n";}
	
if((rand(100000) > 50000)){ $level2_26_27 = 26; print DATADEFWRITE "`define BUG27DONEANDDUSTEDWITH\n";}
else { $level2_26_27 = 27; print DATADEFWRITE "`define BUG26DONEANDDUSTEDWITH\n";}
	

if((rand(100000) > 50000)){ $level2_28_29 = 28; print DATADEFWRITE "`define BUG29DONEANDDUSTEDWITH\n";}
else { $level2_28_29 = 29; print DATADEFWRITE "`define BUG28DONEANDDUSTEDWITH\n";}
	
if((rand(100000) > 50000)){ $level2_30_31 = 30;print DATADEFWRITE "`define BUG31DONEANDDUSTEDWITH\n";}
else { $level2_30_31 = 31; print DATADEFWRITE "`define BUG30DONEANDDUSTEDWITH\n";}
	
if((rand(100000) > 50000)){ $level2_35_40 = 35; print DATADEFWRITE "`define BUG40DONEANDDUSTEDWITH\n";}
else { $level2_35_40 = 40; print DATADEFWRITE "`define BUG35DONEANDDUSTEDWITH\n";}
	



@level2_temp_array = (15,16,17,18,20,21);
$random_number = int((rand(100000)*6/(100000)));
$level2_15_21 = $level2_temp_array[$random_number];
splice(@level2_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level2_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}

$level2_bugs[0] = $level2_13_25;
$level2_bugs[1] = 41; # the connection error
$level2_bugs[2] = $level2_35_40; # the connection error

@level2_temp_array = (3,4,5);
$random_number = int((rand(100000)*3/(100000)));
$level2_exec = $level2_temp_array[$random_number];
splice(@level2_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level2_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}


@level2_temp_array = ($level2_28_29, $level2_30_31);
$random_number 	= int((rand(100000)*2/(100000)));
$level2_wb 		= $level2_temp_array[$random_number];
splice(@level2_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level2_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}


@level2_temp_array = (10,$level2_15_21, $level2_26_27);
$random_number = int((rand(100000)*3/(100000)));
$level2_control = $level2_temp_array[$random_number];
splice(@level2_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level2_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}


@level2_options = ($level2_exec,$level2_wb,$level2_control, 43, 45);
print "Level2 Options @level2_options\n";
$arraysize = $#level2_options + 1;
$random_number = int((rand(10000)*$arraysize/(10000)));
push(@level2_bugs, $level2_options[$random_number]);
splice(@level2_options, $random_number, 1 ); 

$arraysize = $#level2_options + 1;
$random_number = int((rand(10000)*$arraysize/(10000)));
push(@level2_bugs, $level2_options[$random_number]);
splice(@level2_options, $random_number, 1 ); 

foreach $bugnumber (@level2_options) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
}

print "Level2 Bugs @level2_bugs\n";
foreach $bugnumber (@level2_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "  BUG_${bugnumber},";
	
}

# ************************************************************************************************ 
#																								 #	
#						INSERTING LEVEL 3 BUGS												     #
#     																							 #
# ************************************************************************************************ 

print SIMWRITE "\nLEVEL 3 BUGS\n";
print SIMWRITE "============\n";
print DATADEFWRITE "\n//LEVEL 3 BUGS\n";
if(int(rand(100000) > 50000)) {$level3_6_7 = 6; print DATADEFWRITE "`define BUG7DONEANDDUSTEDWITH\n";} 
else {$level3_6_7 = 7; print DATADEFWRITE "`define BUG6DONEANDDUSTEDWITH\n";}

if(int(rand(100000) > 50000)) {$level3_14_19 = 14; print DATADEFWRITE "`define BUG19DONEANDDUSTEDWITH\n";} 
else {$level3_14_19 = 19; print DATADEFWRITE "`define BUG14DONEANDDUSTEDWITH\n";}

@level3_temp_array = (22, 23, 24);
$random_number = int((rand(100000)*3/(100000)));
$level3_22_24 = $level3_temp_array[$random_number];
splice(@level3_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level3_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	
}

@level3_temp_array = (37, 38, 39);
$random_number = int((rand(100000)*3/(100000)));
$level3_37_39 = $level3_temp_array[$random_number];
splice(@level3_temp_array, $random_number, 1 ); 
foreach $bugnumber (@level3_temp_array) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	
}


$level3_bugs[0] = 36;

if(chose_32_33) {
	@level3_options = (2, 11, 12, $level3_14_19, $level3_22_24, $level3_37_39, 42, 44);
	print DATADEFWRITE "`define BUG${level3_6_7}DONEANDDUSTEDWITH\n";
}
else{
	@level3_options = (2, $level3_6_7, 11, 12, $level3_14_19, $level3_22_24, $level3_37_39, 42, 44);
}
print "Level3 Options @level3_options\n";

$arraysize = $#level3_options + 1;
$random_number = int((rand(10000)*$arraysize)/(10000));
push(@level3_bugs, $level3_options[$random_number]);
splice(@level3_options, $random_number, 1 ); 

$arraysize = $#level3_options + 1;
$random_number = int((rand(10000)*$arraysize)/(10000));
push(@level3_bugs, $level3_options[$random_number]);
splice(@level3_options, $random_number, 1 ); 

$arraysize = $#level3_options + 1;
$random_number = int((rand(10000)*$arraysize)/(10000));
push(@level3_bugs, $level3_options[$random_number]);
splice(@level3_options, $random_number, 1 ); 

print "Level3 Bugs = @level3_bugs\n";
foreach $bugnumber (@level3_bugs) {
	print SIMWRITE "	BUG$bugnumber\n";
	print CSVWRITE "  BUG_${bugnumber},";
	
}

foreach $bugnumber (@level3_options) {
	print DATADEFWRITE "`define BUG${bugnumber}DONEANDDUSTEDWITH\n";
	
}


print DATADEFWRITE "`endprotect\n";
close(SIMWRITE);
close(DATADEFWRITE);
close(CSVWRITE);
