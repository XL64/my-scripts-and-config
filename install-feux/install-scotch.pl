#!/usr/bin/perl

use POSIX;
use strict;

sub doSystemCommand
{
    my $systemCommand = $_[0];

    print LOG "$0: Executing [$systemCommand] \n";
    my $returnCode = system( $systemCommand );

    if ( $returnCode != 0 ) 
    { 
        die "Failed executing [$systemCommand]\n"; 
    }
}

my $software  = "scotch";
my $srcroot   = "/media/vulcain/src";
my $extension = ".tar.gz";
my $numver;
my @liste_version = `ls $srcroot/$software/*$extension` ;
my @liste_config = ( 
    { 'prefix'   => "/opt/scotch-NUM-mpich2",
      'version'  => "scotch", 
      'ccs'      => "gcc",
      'ccd'      => "/opt/mpich2/bin/mpicc",
      'ccp'      => "/opt/mpich2/bin/mpicc",
	},
    { 'prefix'   => "/opt/scotch-NUM-mpich2-vg",
      'version'  => "scotch",
      'ccs'      => "gcc",
      'ccd'      => "/opt/mpich2-vg/bin/mpicc",
      'ccp'      => "/opt/mpich2-vg/bin/mpicc",
    },
    { 'prefix'   => "/opt/scotch-NUM-openmpi",
      'version'  => "scotch",
      'ccs'      => "gcc",
      'ccd'      => "/opt/openmpi/bin/mpicc",
      'ccp'      => "/opt/openmpi/bin/mpicc",
    },
    { 'prefix'   => "/opt/intel/scotch-NUM-mpich2",
      'version'  => "scotch",
      'ccs'      => "icc",
      'ccd'      => "/opt/intel/mpich2/bin/mpicc",
      'ccp'      => "/opt/intel/mpich2/bin/mpicc",
    },
    { 'prefix'   => "/opt/ptscotch-NUM-mpich2",
      'version'  => "ptscotch", 
      'ccs'      => "gcc",
      'ccd'      => "/opt/mpich2/bin/mpicc",
      'ccp'      => "/opt/mpich2/bin/mpicc",
   },
    { 'prefix'   => "/opt/ptscotch-NUM-mpich2-vg",
      'version'  => "ptscotch",
      'ccs'      => "gcc",
      'ccd'      => "/opt/mpich2-vg/bin/mpicc",
      'ccp'      => "/opt/mpich2-vg/bin/mpicc",
    },
    { 'prefix'   => "/opt/ptscotch-NUM-openmpi",
      'version'  => "ptscotch",
      'ccs'      => "gcc",
      'ccd'      => "/opt/openmpi/bin/mpicc",
      'ccp'      => "/opt/openmpi/bin/mpicc",
    },
    { 'prefix'   => "/opt/intel/ptscotch-NUM-mpich2",
      'version'  => "ptscotch",
      'ccs'      => "icc",
      'ccd'      => "/opt/intel/mpich2/bin/mpicc",
      'ccp'      => "/opt/intel/mpich2/bin/mpicc",
    },
    );

my %liste = (
    "int"   => "",
    "int32" => "-DINTSIZE32",
    "int64" => "-DINTSIZE64",
    "long"  => "-DLONG"
    );


my $env = "#!/bin/bash\n";
$env .= "LIB=scotch\n";
$env .= "\n";
$env .= "export SCOTCH_HOME=_PREFIX_\n";
$env .= "\n";
$env .= "for i in PATH LD_LIBRARY_PATH LD_RUN_PATH INCLUDE_PATH\n";
$env .= "do\n";
$env .= "\n";
$env .= '  cmd1="echo \$$i | sed -r \'s/(\(.*:\)|)[^:]*${LIB}[^:]*(|\(:.*\))/\1\2/\'"'."\n";
$env .= '  cmd2="echo \$temp | sed \'s/::/:/\' | sed \'s/^://\' | sed \'s/:$//\' "'."\n";
$env .= "\n";
$env .= '  temp=`eval $cmd1`;'."\n";
$env .= '  temp=`eval $cmd2`;'."\n";
$env .= '  eval "$i=$temp";'."\n";
$env .= "done\n";
$env .= "\n";
$env .= 'export PATH=$SCOTCH_HOME/bin:$PATH'."\n";
$env .= 'export LD_RUN_PATH=$SCOTCH_HOME/lib:$LD_RUN_PATH'."\n";
$env .= 'export LD_LIBRARY_PATH=$SCOTCH_HOME/lib:$LD_LIBRARY_PATH'."\n";
$env .= 'export INCLUDE_PATH=$SCOTCH_HOME/include:$INCLUDE_PATH'."\n";

my $makefile = "";
$makefile .= "prefix  = _PREFIX_\n";
$makefile .= "EXE     =               \n";
$makefile .= "LIB     = .a		  \n";
$makefile .= "OBJ     = .o		  \n";
$makefile .= "\n";
$makefile .= "AR      = ar		  \n";
$makefile .= "MAKE    = make 	  \n";
$makefile .= "ARFLAGS = -ruv	  \n";
$makefile .= "CFLAGS  = -O3 -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_PTHREAD -DSCOTCH_RENAME _TYPE_ -Drestrict= -DSCOTCH_COLLECTIVE \n";
$makefile .= "LDFLAGS = -lz -lm -lrt  \n";
$makefile .= "LEX     = flex	  \n";
$makefile .= "YACC    = bison -y      \n";
$makefile .= "CAT     = cat		  \n";
$makefile .= "CP      = cp		  \n";
$makefile .= "LN      = ln	          \n";
$makefile .= "MKDIR   = mkdir	  \n";
$makefile .= "MV      = mv		  \n";
$makefile .= "RANLIB  = ranlib	  \n";

print "###############################################################\n";
print "              Choix de la version a installer                  \n";
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
doSystemCommand("tar xvzf $liste_version[$numver]");

my $version = `basename $liste_version[$numver]`;
chop $version;
$version =~ s/$software[-_]//;
$version =~ s/$extension//;
my $srcdir = $liste_version[$numver];
$srcdir =~ s/$extension//;

chdir $srcdir."/src";

for(my $i=0; $i <= $#liste_config; $i++)
{
    my $prefix    = $liste_config[$i]{'prefix'};
    $prefix =~ s/NUM/$version/;

    foreach $version (keys %liste)
    {
	my $lmakefile = $makefile;
	my $lenv      = $env;
	my $rep = $prefix."/".$version;
	
	$lmakefile =~ s/_PREFIX_/$rep/;
	$lmakefile =~ s/_TYPE_/$liste{$version}/;

	$lmakefile .= "CCS     = $liste_config[$i]{'ccs'}  \n";
	$lmakefile .= "CCP     = $liste_config[$i]{'ccp'}  \n";
	$lmakefile .= "CCD     = $liste_config[$i]{'ccd'}  \n";
	$lenv      =~ s/_PREFIX_/$rep/;

	open(M, ">Makefile.inc");
	print M $lmakefile;
	close M;

	print "###############################################################\n";
	print $lmakefile."\n";
	print "###############################################################\n";
	print(">>> make realclean <<<\n") ;
	doSystemCommand("make realclean");
	print(">>> LANG=C make $liste_config[$i]{'version'} <<<\n") ;
	doSystemCommand("LANG=C make $liste_config[$i]{'version'}");
	doSystemCommand("mkdir -p $rep");
	print(">>> make install <<<\n");
	doSystemCommand("make install");
	print(">>> make realclean <<<\n");
	doSystemCommand("make realclean");
	
	open(M, ">$rep/env.sh");
	print M $lenv;
	close M;
    }
}

print " Il ne reste plus qu'à synchroniser les autres machines : sudo /opt/scripts/syncoptall.sh\n";
print "\n\n        Enjoy !!!        \n\n";
