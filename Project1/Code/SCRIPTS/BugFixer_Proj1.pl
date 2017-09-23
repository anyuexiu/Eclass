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
my $writefile_datadefs;
my $writefile_buglist;
my $lineread;
my $linefound;
my $beginwrite;
my $destdir;
my $student_dir;

if ($#ARGV != 1) {
        print "[ERROR] Incorrect input arguments\n";
        print "[ERROR] Run this code as > ./BugFixer.pl <BugNumber to be fixed>  <Group Name>\n";
        print "[ERROR] For example, ./BugFixer.pl 23    Grp1\n";
        exit;
}
# Inputs would be group name and the bug number 

$bug_number = $ARGV[0];
$group_number = $ARGV[1];
$source_dir = "../002_students/$ARGV[1]/";

$writefile_buglist = "temp_buglist";
$readfile = "${source_dir}"."/BugList${group_number}";
$linefound = 0;

open(FILEREAD, "<${readfile}")|| die "can't open file : $readfile";
open(FILEWRITE, ">${writefile_buglist}")|| die "can't open write file : $writefile_buglist";
 	while ($lineread = <FILEREAD>) {
	 	if($lineread =~ /^\s*BUG(\d+) (.+)FIXED$/)	{	
			if($1 == $bug_number) {
				print "[ERROR] BUG ALREADY FIXED\n";
				exit;
			}
			else {
				print FILEWRITE "$lineread";
			}
			 
 		}
	 	elsif($lineread =~ /^\s*BUG(\d+)$/)	{	
			if($1 == $bug_number) {
	 			print FILEWRITE "	BUG${bug_number}  ----> FIXED\n";
				$linefound = 1;
			}
			else {
				print FILEWRITE "$lineread";
			}
			
 		}
		else {
			print FILEWRITE "$lineread";
		}
	}
	if ($linefound == 0) {
		print "[ERROR] The bug that is to be fixed could not be found in list of bugs provided to group\n";
		exit;
	}

close(FILEWRITE);
close(FILEREAD);

$writefile_datadefs = "temp_datadefs";
$readfile = "${source_dir}"."/data_defs.v";
open(FILEREAD, "<${readfile}")|| die "can't open read file : $readfile";
open(FILEWRITE, ">${writefile_datadefs}")|| die "can't open write file : $writefile_datadefs";
$beginwrite = 0;

 	while ($lineread = <FILEREAD>) {
	 	if($lineread =~ /endprotect/)	{	
	 		print FILEWRITE "$lineread";
 		}
 		elsif($lineread =~ /protect/){
	 		print FILEWRITE "$lineread";
	 		print FILEWRITE "\n`define BUG${bug_number}DONEANDDUSTEDWITH\n";
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
system("cp ${writefile_datadefs} ${source_dir}/data_defs.v");
#print "$destdir\n";	
print "running: cp ${writefile_datadefs} ${source_dir}\n\n";

system("cp ${writefile_buglist} ${source_dir}/BugList${group_number}");


system("vlog +protect ${source_dir}/data_defs.v");
system("cp ./mti_lib/data_defs.vp ${source_dir}/data_defs.vp");
#$student_dir = "/afs/eos.ncsu.edu/lockers/workspace/ece/ece745/002/${group_number}/FromTA/Prj1/";
#print "Student Directory = $student_dir\n";
#if(-e $student_dir && -d $student_dir) {
#	print "Directory Exists and Can Copy new data_defs file\n";
#}
#else {
#	print "Directory Does not exists. Need to create FromTA directory\n";
#	system("mkdir ${student_dir}");
#}
#system("cp ${source_dir}/data_defs.vp $student_dir");

















