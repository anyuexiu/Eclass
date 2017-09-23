#!/usr/local/bin/perl
#
# CreateBugs.pl
# version 0.1
# 11/19/06


use strict;
use warnings;

my $source_dir;
my $bug_number;
my $group_number;

my $readfile;
my $writefile;
my $lineread;
my $beginwrite;
my 	$destdir;
my $student_dir;
if ($#ARGV != 2) {
        print "[ERROR] Incorrect input arguments\n";
        print "[ERROR] Run this code as > ./BugFixer.pl <SourceDirectory where data_defs.v is present> <BugNumber to be fixed>  <Group Name>\n";
        print "[ERROR] For example, ./BugFixer.pl ./FixedCode/headers/group1/   23    grp1\n";
        exit;
}
# Inputs would be group name and the bug number 

$source_dir = $ARGV[0];
$bug_number = $ARGV[1];
$group_number = $ARGV[2];

#Add 
$writefile = "tempfile";
$readfile = "${source_dir}"."/data_defs.v";
open(FILEREAD, "<${readfile}")|| die "can't open write file : $readfile";
open(FILEWRITE, ">${writefile}")|| die "can't open write file : $writefile";
$beginwrite = 0;

 	while ($lineread = <FILEREAD>) {
	 	if($lineread =~ /endprotect/)	{	
	 		print FILEWRITE "$lineread";
 		}
 		elsif($lineread =~ /protect/){
	 		print FILEWRITE "$lineread";
	 		print FILEWRITE "\n\n`define BUG${bug_number}DONEANDDUSTEDWITH\n";
	 		$beginwrite = 1;
 		}
 		elsif($beginwrite==1){
	 		print FILEWRITE "$lineread";
 		}
	}
	if($beginwrite == 0) {
		#implies file read is empty
		print FILEWRITE "`protect\n";
		print FILEWRITE "JUNK JUNK\n";
		print FILEWRITE "`endprotect\n";
	}
$destdir = "${source_dir}/data_defs.v";
close(FILEREAD);
close(FILEWRITE);
system("cp ${source_dir}/data_defs.v ${source_dir}/data_defs.v.${bug_number}.bkp");
system("cp ${writefile} ${source_dir}/data_defs.v");
print "$destdir\n";	
print "cp ${writefile} ${source_dir}\n";
system("vlog +protect ${source_dir}/data_defs.v");
system("cp ./mti_lib/data_defs.vp ${source_dir}/data_defs.vp");
$student_dir = "/afs/eos.ncsu.edu/lockers/workspace/ece/ece745/002/${group_number}/Bug_Fix/";
print "Student Directory = $student_dir\n";
if(-e $student_dir && -d $student_dir) {
	print "Directory Exists and Can Copy new data_defs file";
}
else {
	print "Directory Does not exists. Need to create FromTA directory\n";
	#system("mkdir ${student_dir}");
}
#system("cp ${source_dir}/data_defs.vp $student_dir");
unlink("tempfile");

