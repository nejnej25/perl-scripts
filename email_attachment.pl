#!/usr/bin/perl
#Author: Perry

use strict;
use warnings;

#Module for email with attachments
use MIME::Lite;

#Create the email
my $mesg=MIME::Lite->new(
		From=>'root@sniper1a.localdomain',
		To=>$ARGV[0],
		Type=>'multipart/mixed',
		Subject=>$ARGV[1]
	);

#Create the body of the email
$mesg->attach(
	Type=>'TEXT',
	Data=>"Hello this is mime lite"
	);

#Attachment of the email, in this sample
#its image
$mesg->attach(
	Type=>'AUTO',
	Path=>$ARGV[2],
	Filename=>'image.jpg',
	Disposition=>'attachment'
	);

#Send the email
$mesg->send;
