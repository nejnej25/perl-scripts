#!/usr/bin/perl
#Author: Perry

use strict;
use warnings;
use Net::Ping;
use Archive::Tar;
use File::Rsync;
use Data::Dumper;

#check the backup dest
sub check_host{
	my $host=$ARGV[0];
	my $ping=Net::Ping->new('icmp');
	if ( $ping->ping($host) ){
		print "$host is alive!\n##################\n\n";
	}
	else{
		die "$host is down! Exiting..\n";
	}
}

#backup files
sub backup{
	my $location=$ARGV[1];
	my $fname=$ARGV[2];
	my $tar=Archive::Tar->new();
	chdir($location);
	opendir(DIR,$location) or die "Directory not found..\n";
	my @files=readdir(DIR);
	foreach my $file(@files){
		print "$file adding to tarball..\n";
		$tar->add_files($file);
	}
	$tar->write("/tmp/$fname-backup.tar.gz",COMPRESS_GZIP);
	print "/tmp/$fname-backup.tar.gz has been created.\n##################\n\n";

}

#Send to the backup host
sub sync{
	my $fname=$ARGV[2];
	my $host=$ARGV[0];
	my $path=$ARGV[3];
	my $rsync=File::Rsync->new(
		archive => 1,
		compress => 1,
		rsh => '/usr/bin/ssh',
		'rsync-path' => '/usr/bin/rsync'
	);
	print "Sending to backupserver..\n";
	$rsync->exec(src=>"/tmp/$fname-backup.tar.gz",dest=>"$host:$path");

	my $status=$rsync->status;
	if ( $status == 0 ){
		print "Successfully synced to the backup server..\n";
	}
	else{
		print "Failed to sync to the backup server..\n";
	}
}

#Check user
my $user=getpwuid($<);
if ( $user eq "root" ){

	#Check arguments
	my $args=@ARGV;
	if ( $args != 4 ){
		print "This script is intended for backup puropose. Archiving the files into tarball and sync it to backup server\nAlso run this script with root privileges";
		print "USAGE: backup.pl <Destination IPAddress> <Source Location> <Tar Name> <Destination Location>\n";
		exit 10;
	}
	else{
		check_host();
		backup();
		sync();
	}
}
else{
	die "Please run this script with root privileges\n";
}
