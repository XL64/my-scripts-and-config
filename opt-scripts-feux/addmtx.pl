#!/usr/bin/perl

use POSIX;
use strict;
use warnings;
use Getopt::Std;

my %opts;
my $matrixdir = "/media/local/matrices";
my $installdir = ".";
my $dir = $matrixdir;

sub Usage{
    print "./addmtx.pl [ -d installdir ] mtxfile1 mtxfile2 ...\n";
    print "      -h               Print this help\n";
    print "      -d installdir    Install matrices in $matrixdir/installdir\n";
    print "   This script can be used only on vulcain\n";
}


my $machinename=`uname -n`;
chop $machinename;
getopts("hd:", \%opts);

if ( defined($opts{h}) || (!($machinename =~ /vulcain/)))
{
    Usage();
    exit;
}

if ( defined($opts{d}) ){
    $installdir = "$opts{d}";
    $dir .= "/".$installdir;
}

if (! ( -d "$dir" ))
{
    `mkdir -p $dir`;
}

`chown -R root:users $matrixdir`;
`find $matrixdir -type d -exec chmod go+rx {} \\;`;

for( my $i = 0; $i <= $#ARGV; $i++)
{
    print $ARGV[$i]." \n";
    my $name=`basename $ARGV[$i]`;
    chop $name;

    `cp -r $ARGV[$i] $dir`;
    `chown -R root:users $dir/$name`;
    if ( -d "$dir/$name" )
    {
	`chmod 755 $dir/$name`;
	`chmod 644 $dir/$name/*`;
    }
    else
    {
	`chmod 644 $dir/$name`;
    }
    `echo $installdir/$name >> $matrixdir/liste`;
}

`/opt/scripts/syncmtxall.sh`;
