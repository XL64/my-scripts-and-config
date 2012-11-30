#!/usr/bin/perl

use POSIX;
use strict;

my $software  = "mpich2";
my $srcroot   = "/media/vulcain/src";
my $extension = ".tar.gz";
my $numver;
my @liste_version = `ls $srcroot/$software/*$extension` ;
my @liste_config = ( 
    { 'prefix'   => "/opt/mpich2-NUM",
      'options'  => "--enable-f77 --enable-fc --enable-cxx --enable-threads=multiple FC=gfortran" },
    { 'prefix'   => "/opt/mpich2-NUM-vg",
      'options'  => "--enable-f77 --enable-fc --enable-cxx --enable-threads=multiple  --enable-g=meminit FC=gfortran" },
    { 'prefix'   => "/opt/intel/mpich2-NUM",
      'options'  => "--enable-f77 --enable-fc --enable-cxx --enable-threads=multiple CC=icc CXX=icpc FC=ifort" },
    # { 'prefix'   => "/opt/mpich2-NUM-vg",
    #   'options'  => "--enable-mpi-threads --enable-mem-debug --enable-mem-profile" },
    );



my $env = "#!/bin/bash\n";
$env .= "LIB=mpi\n";
$env .= "\n";
$env .= "export MPI_HOME=_PREFIX_\n";
$env .= "\n";
$env .= "for i in PATH LD_LIBRARY_PATH LD_RUN_PATH INCLUDE_PATH\n";
$env .= "do\n";
$env .= "\n";
$env .= "  for j in /mpich2 /openmpi\n";
$env .= "  do\n";
$env .= '    cmd1="echo \$$i | sed -r \'s+(\(.*:\)|)[^:]*${j}[^:]*(|\(:.*\))+\1\2+\'"'."\n";
$env .= '    cmd2="echo \$temp | sed \'s/::/:/\' | sed \'s/^://\' | sed \'s/:$//\' "'."\n";
$env .= "\n";
$env .= '    temp=`eval $cmd1`;'."\n";
$env .= '    temp=`eval $cmd2`;'."\n";
$env .= '    eval "$i=$temp";'."\n";
$env .= "  done\n";
$env .= "done\n";
$env .= "\n";
$env .= 'export PATH=$MPI_HOME/bin:$PATH'."\n";
$env .= 'export LD_RUN_PATH=$MPI_HOME/lib:$LD_RUN_PATH'."\n";
$env .= 'export LD_LIBRARY_PATH=$MPI_HOME/lib:$LD_LIBRARY_PATH'."\n";
$env .= 'export INCLUDE_PATH=$MPI_HOME/include:$INCLUDE_PATH'."\n";

print "############################################################\n";
print "              Choix de la version a installer               \n";
print "                                                               \n";
print " WARNING : Don't forget to source icc and ifort vars           \n";
print "  source /opt/intel/Compiler/11.0/083/bin/iccvars.sh intel64   \n";
print "  source /opt/intel/Compiler/11.0/083/bin/ifortvars.sh intel64 \n";
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
system("tar xvzf $liste_version[$numver]");

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
    my @argslist = (
	["./configure --prefix=$prefix $liste_config[$i]{'options'}"],
	["LANG=C make"],
	["make install"],
	["make distclean"]);

    for my $argsref (@argslist) {
	my @args = @$argsref;
	system(@args)  == 0
	    or die "system  failed: $? (installing in $prefix)";
    }
    my $tutu = $env;
    $tutu =~ s/_PREFIX_/$prefix/;
    
    open(M, ">$prefix/env.sh");
    print M $tutu;
    close M;
}

print " Il ne reste plus qu'a créer le lien sur la version par défaut si elle marche\n";
print " Recompiler PT-Scocth avec cette derniere version de mpich2 :)\n";
print " Et synchroniser les autres machines : sudo /opt/scripts/syncoptall.sh\n";
