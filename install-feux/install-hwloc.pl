#!/usr/bin/perl

use POSIX;
use strict;

my $software  = "hwloc";
my $srcroot   = "/media/vulcain/src";
my $extension = ".tar.bz2";
my $numver;
my @liste_version = `ls $srcroot/$software/*$extension` ;
my @liste_config = ( 
    { 'prefix'   => "/opt/hwloc-NUM",
      'options'  => "" },
    );

my $env = "#!/bin/bash\n";
$env .= "LIB=hwloc\n";
$env .= "\n";
$env .= "export HWLOC_HOME=_PREFIX_\n";
$env .= "\n";
$env .= "for i in PATH LD_LIBRARY_PATH LD_RUN_PATH INCLUDE_PATH\n";
$env .= "do\n";
$env .= "\n";
$env .= "  for j in /hwloc /libtopology\n";
$env .= "  do\n";
$env .= '    cmd1="echo \$$i | sed -r \'s+(\(.*:\)|)[^:]*${LIB}[^:]*(|\(:.*\))+\1\2+\'"'."\n";
$env .= '    cmd2="echo \$temp | sed \'s/::/:/\' | sed \'s/^://\' | sed \'s/:$//\' "'."\n";
$env .= "\n";
$env .= '    temp=`eval $cmd1`;'."\n";
$env .= '    temp=`eval $cmd2`;'."\n";
$env .= '    eval "$i=$temp";'."\n";
$env .= "  done\n";
$env .= "done\n";
$env .= "\n";
$env .= 'export PATH=$HWLOC_HOME/bin:$PATH'."\n";
$env .= 'export LD_RUN_PATH=$HWLOC_HOME/lib:$LD_RUN_PATH'."\n";
$env .= 'export LD_LIBRARY_PATH=$HWLOC_HOME/lib:$LD_LIBRARY_PATH'."\n";
$env .= 'export INCLUDE_PATH=$HWLOC_HOME/include:$INCLUDE_PATH'."\n";
$env .= 'export PKG_CONFIG_PATH=$HWLOC_HOME/lib/pkgconfig:$PKG_CONFIG_PATH'."\n";

print "############################################################\n";
print "              Choix de la version a installer               \n";
print "\n";


sub PrintList {
    my $i = 0;
    foreach my $archive (@liste_version)
    {
	print "   ".$i." - ".$archive;
	$i++;
    }
    print "Choix de la version (q : quitter) : ";
}

my $stop = 1;
while ( $stop )
{
    PrintList();
    my $answer = <STDIN>;
    chop $answer;
    print $answer."\n";
    if (( $answer eq "q" ) || ( $answer eq "Q" ))
    {
	exit;
    } 
    elsif (!($answer =~ /^-?[\.|\d]*\Z/ ))
    {
	print "\n Choix impossible \n\n"
    }
    elsif (( $answer > $#liste_version ) || ( $answer < 0 ))
    {
	print "\n Choix impossible \n\n"
    }
    else
    {
	$stop = 0;
	$numver=$answer; 
	print "Version choisie : ".$liste_version[$numver];
    }
}

chop $liste_version[$numver];
chdir $srcroot."/".$software;
system("tar xvjf $liste_version[$numver]");

my $version = `basename $liste_version[$numver]`;
chop $version;
$version =~ s/$software-//;
$version =~ s/$extension//;
my $srcdir = $liste_version[$numver];
$srcdir =~ s/$extension//;

chdir $srcdir;

for(my $i=0; $i <= $#liste_config; $i++)
{
    my $prefix = $liste_config[$i]{'prefix'};
    $prefix =~ s/NUM/$version/;

    system("./configure --prefix=$prefix $liste_config[$i]{'options'}");
    system("make");
    system("make install");
    system("make distclean");

    my $tutu = $env;
    $tutu =~ s/_PREFIX_/$prefix/;
    
    open(M, ">$prefix/env.sh");
    print M $tutu;
    close M;

    system("ln -sf $prefix /opt/hwloc");
}

print " Il ne reste plus qu'a créer le lien sur la version par défaut si elle marche :)\n";
print " Et à synchroniser les autres machines : sudo /opt/scripts/syncoptall.sh\n";
