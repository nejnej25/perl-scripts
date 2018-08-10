#!/usr/bin/perl
#Author: Perry
#
use strict;
use warnings;
use String::Random;

my $length=$ARGV[0] or die("Usage: uuid-passwd-gen.pl <length>\n");
$length=~'^[0-9]+$' or die("Invalid charater, number only\n");
my $stringgen=String::Random->new;
print "Generated string: ".$stringgen->randregex("[a-zA-Z0-9]{$length}")."\n";
