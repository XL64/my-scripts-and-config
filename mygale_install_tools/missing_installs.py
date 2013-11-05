import subprocess
import os, sys
import shutil
g_root = u"/opt/cluster/plafrim-dev/"
g_modules =  u"module purge; module load compiler/%s/%s mpi/%s/%s lib/mkl/10.3.9.293 lib/hwloc/latest;"
g_modules_nompi =  u"module purge; module load compiler/%s/%s lib/mkl/10.3.9.293 lib/hwloc/latest;"
g_scotch_makefile = u"""
prefix  = __PREFIX__
EXE     =
LIB     = .a
OBJ     = .o

AR      = ar
MAKE    = make
ARFLAGS = -ruv
CAT     = cat
CFLAGS  = -g -O3 -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DSCOTCH_DETERMINISTIC -DSCOTCH_PTHREAD -DSCOTCH_RENAME -DSCOTCH_RENAME_PARSER __TYPE__ -Drestrict= -fPIC
LDFLAGS = -lz -lm -lrt
LEX     = flex  -Pscotchyy -olex.yy.c
YACC    = bison -pscotchyy -y -b y
CAT     = cat
CP      = cp
LN      = ln
MKDIR   = mkdir
MV      = mv
RANLIB  = ranlib
CCS     = __CC__
CCP     = __MPCC__
CCD     = __MPCC__
"""

g_pastix_makefile = u"""
HOSTARCH    = i686_pc_linux
VERSIONBIT  = _64bit
EXEEXT      =
OBJEXT      = .o
LIBEXT      = .a
CCPROG      = __CC__ #-Wall
CFPROG      = __FC__
CF90PROG    = __FC__
MCFPROG     = __MPFC__
CF90CCPOPT  = __FC_PREPROC__
# Compilation options for optimization (make expor)
CCFOPT      = -g -O3
# Compilation options for debug (make | make debug)
CCFDEB      = -g3

LKFOPT      =
MKPROG      = make
MPCCPROG    = __MPCC__ #-Wall
MPCXXPROG   = __MPCXX__
CPP         = cpp
ARFLAGS     = ruv
ARPROG      = ar
# Uncomment the correct line
EXTRALIB    = __LIB_FORTRAN__ -lm -lrt


VERSIONMPI  = _mpi
VERSIONSMP  = _smp
VERSIONSCH  = _static
VERSIONINT  = _int
VERSIONPRC  = _simple
VERSIONFLT  = _real
VERSIONORD  = _scotch

###################################################################
#                  SETTING INSTALL DIRECTORIES                    #
###################################################################
ROOT       = __PREFIX__
INCLUDEDIR = ${ROOT}/include
LIBDIR     = ${ROOT}/lib
BINDIR     = ${ROOT}/bin

###################################################################
#                  SHARED LIBRARY GENERATION                      #
###################################################################
SHARED=1
SHARED_FLAGS =  -shared -Wl,-soname,__SO_NAME__
CCFDEB       := ${CCFDEB} -fPIC
CCFOPT       := ${CCFOPT} -fPIC
CFPROG       := ${CFPROG} -fPIC

###################################################################
#                          INTEGER TYPE                           #
###################################################################
# Uncomment the following lines for integer type support (Only 1)
 CCTYPES     = __TYPE__
#VERSIONINT  = _long
#CCTYPES     = -DFORCE_LONG -DLONG
#---------------------------
#VERSIONINT  = _int32
#CCTYPES     = -DFORCE_INT32 -DINTSIZE32
#---------------------------
#VERSIONINT  = _int64
#CCTYPES     = -DFORCE_INT64 -DINTSIZE64

###################################################################
#                           FLOAT TYPE                            #
###################################################################
CCTYPESFLT  =
# Uncomment the following lines for double precision support
VERSIONPRC  = _double
CCTYPESFLT := $(CCTYPESFLT) -DFORCE_DOUBLE -DPREC_DOUBLE

# Uncomment the following lines for float=complex support
#VERSIONFLT  = _complex
#CCTYPESFLT := $(CCTYPESFLT) -DFORCE_COMPLEX -DTYPE_COMPLEX


###################################################################
#                          MPI/THREADS                            #
###################################################################

# Uncomment the following lines for sequential (NOMPI) version
#VERSIONMPI  = _nompi
#CCTYPES    := $(CCTYPES) -DFORCE_NOMPI
#MPCCPROG    = $(CCPROG)
#MCFPROG     = $(CFPROG)
__NOMPI__

# Uncomment the following lines for non-threaded (NOSMP) version
#VERSIONSMP  = _nosmp
#CCTYPES    := $(CCTYPES) -DFORCE_NOSMP

# Uncomment the following line to enable a progression thread
#CCPASTIX   := $(CCPASTIX) -DTHREAD_COMM

# Uncomment the following line if your MPI doesn't support MPI_THREAD_MULTIPLE level
#CCPASTIX   := $(CCPASTIX) -DPASTIX_FUNNELED

# Uncomment the following line if your MPI doesn't support MPI_Datatype correctly
#CCPASTIX   := $(CCPASTIX) -DNO_MPI_TYPE

# Uncomment the following line if you want to use semaphore barrier
# instead of MPI barrier (with IPARM_AUTOSPLIT_COMM)
#CCPASTIX    := $(CCPASTIX) -DWITH_SEM_BARRIER

# Uncomment the following lines to enable StarPU.
#CCPASTIX   := ${CCPASTIX} `pkg-config libstarpu --cflags` -DWITH_STARPU
#EXTRALIB   := $(EXTRALIB) `pkg-config libstarpu --libs`

# Uncomment the following line to enable StarPU profiling
# ( IPARM_VERBOSE > API_VERBOSE_NO ).
#CCPASTIX   := ${CCPASTIX} -DSTARPU_PROFILING

# Uncomment the following line to disable CUDA (StarPU)
#CCPASTIX   := ${CCPASTIX} -DFORCE_NO_CUDA

###################################################################
#                          Options                                #
###################################################################

# Show memory usage statistics
#CCPASTIX   := $(CCPASTIX) -DMEMORY_USAGE

# Show memory usage statistics in solver
#CCPASTIX   := $(CCPASTIX) -DSTATS_SOPALIN

# Uncomment following line for dynamic thread scheduling support
#CCPASTIX   := $(CCPASTIX) -DPASTIX_DYNSCHED

# Uncomment the following lines for Out-of-core
#CCPASTIX   := $(CCPASTIX) -DOOC -DOOC_NOCOEFINIT -DOOC_DETECT_DEADLOCKS

###################################################################
#                      GRAPH PARTITIONING                         #
###################################################################

# Uncomment the following lines for using metis ordering
#VERSIONORD  = _metis
#METIS_HOME  = ${HOME}/metis-4.0
#CCPASTIX   := $(CCPASTIX) -DMETIS -I$(METIS_HOME)/Lib
#EXTRALIB   := $(EXTRALIB) -L$(METIS_HOME) -lmetis

# Scotch always needed to compile
SCOTCH_HOME = __SCOTCH_HOME__
SCOTCH_INC ?= $(SCOTCH_HOME)/include
SCOTCH_LIB ?= $(SCOTCH_HOME)/lib
# Uncomment on of this blocks
#scotch
CCPASTIX   := $(CCPASTIX) -I$(SCOTCH_INC) -DWITH_SCOTCH
EXTRALIB   := $(EXTRALIB) -L$(SCOTCH_LIB) -lscotch -lscotcherrexit
#ptscotch
#CCPASTIX   := $(CCPASTIX) -I$(SCOTCH_INC) -DDISTRIBUTED -DWITH_SCOTCH
#EXTRALIB   := $(EXTRALIB) -L$(SCOTCH_LIB) -lptscotch -lptscotcherrexit

###################################################################
#                Portable Hardware Locality                       #
###################################################################
# If HwLoc library is available, Uncomment the following lines to bind correctly threads on cpus
HWLOC_HOME ?= __HWLOC_HOME__
HWLOC_INC  ?= $(HWLOC_HOME)/include
HWLOC_LIB  ?= $(HWLOC_HOME)/lib
CCPASTIX   := $(CCPASTIX) -I$(HWLOC_INC) -DWITH_HWLOC
EXTRALIB   := $(EXTRALIB) -L$(HWLOC_LIB) -lhwloc

###################################################################
#                             MARCEL                              #
###################################################################

# Uncomment following lines for marcel thread support
#VERSIONSMP := $(VERSIONSMP)_marcel
#CCPASTIX   := $(CCPASTIX) `pm2-config --cflags` -I${PM2_ROOT}/marcel/include/pthread
#EXTRALIB   := $(EXTRALIB) `pm2-config --libs`
# ---- Thread Posix ------
EXTRALIB   := $(EXTRALIB) -lpthread

# Uncomment following line for bubblesched framework support (need marcel support)
#VERSIONSCH  = _dyn
#CCPASTIX   := $(CCPASTIX) -DPASTIX_BUBBLESCHED

###################################################################
#                              BLAS                               #
###################################################################

# Choose Blas library (Only 1)
# Do not forget to set BLAS_HOME if it is not in your environnement
# BLAS_HOME=/path/to/blas
#----  Blas    ----
#BLASLIB =  -lblas
#---- Gotoblas ----
#BLASLIB =  -L$(BLAS_HOME) -lgoto
#----  MKL     ----
# Uncomment the correct line
BLASLIB =  -L$(MKL_LIB) -lmkl_intel_lp64 -lmkl_sequential -lmkl_core
#BLASLIB =  -L$(BLAS_HOME) -lmkl_intel -lmkl_sequential -lmkl_core
#----  Acml    ----
#BLASLIB =  -L$(BLAS_HOME) -lacml

###################################################################
#                         PYTHON WRAPPER                          #
###################################################################
#MPI4PY_DIR    = /path/to/mpi4py
#MPI4PY_INC    = $(MPI4PY_DIR)/src/include/
#MPI4PY_LIBDIR = $(MPI4PY_DIR)/build/lib.linux-x86_64-2.7/
#PYTHON_INC    = /usr/include/python2.7/
#CCTYPES      := $(CCTYPES) -fPIC

###################################################################
#                          DO NOT TOUCH                           #
###################################################################

FOPT      := $(CCFOPT)
FDEB      := $(CCFDEB)
CCHEAD    := $(CCPROG) $(CCTYPES) $(CCFOPT)
CCFOPT    := $(CCFOPT) $(CCTYPES) $(CCPASTIX)
CCFDEB    := $(CCFDEB) $(CCTYPES) $(CCPASTIX)


###################################################################
#                        MURGE COMPATIBILITY                      #
###################################################################
# Uncomment if you need MURGE interface to be thread safe
# CCPASTIX   := $(CCPASTIX) -DMURGE_THREADSAFE

MAKE     = $(MKPROG)
CC       = $(MPCCPROG)
CFLAGS   = $(CCFOPT) $(CCTYPESFLT)
FC       = $(MCFPROG)
FFLAGS   = $(CCFOPT)
LDFLAGS  = $(EXTRALIB) $(BLASLIB)
"""
g_module_file = u"""#%Module
#########################
#        __MODULENAME__         #
#     Version __VERSION__     #
######################################################################
#CONFIGURATION:
######################################################################

# Verification de la presence des prerequis et des conflits
# ---------------------------------------------------------
conflict __modulename__
prereq compiler
prereq mpi

catch {set COMPILER $env(COMPILER)}
catch {set COMPILER_VER $env(COMPILER_VER)}
if {![info exists COMPILER] || ![info exists COMPILER_VER]} {
   if {[module-info mode display]} {
      set   COMPILER       compiler
      set   COMPILER_VER   version
   } else {
      puts stderr "\t[module-info name] Load Error: COMPILER env vars were not properly defined"
      break
      exit 1
   }
}

catch {set MPI $env(MPI)}
catch {set MPI_VER $env(MPI_VER)}
if {![info exists MPI] || ![info exists MPI_VER]} {
   if {[module-info mode display]} {
      set   MPI            mpi
      set   MPI_VER        version
   } else {
      puts stderr "\t[module-info name] Load Error: COMPILER env vars were not properly defined"
      break
      exit 1
   }
}

# Reponse a la commande : > module help __modulename__/__VERSION__
# ----------------------------------------------------------------------------------------
proc ModulesHelp { } {
   global name version prefix man_path
   puts stderr "\t[module-info name] - loads the $name environment"
   puts stderr "\tThe following env variables are modified:"
   puts stderr "\t$prefix to \$PETSC_DIR"
   puts stderr "\n\tVersion $version\n""
}


# Reponse a la commande : > module whatis petsc/__VERSION__
#-------------------------------------------------------------------------------------------
module-whatis   "loads the [module-info name] environment"


# Definition de variables internes au modulefile
# ----------------------------------------------
set     name            __modulename__
set     version         __VERSION__
set     prefix          /opt/cluster/plafrim-dev/${name}/${version}/${COMPILER}/${COMPILER_VER}/${MPI}/${MPI_VER}
set     arch            linux-gnu-intel

# Protection permettant de verifier si la presence du PATH precedent
# ------------------------------------------------------------------
if {![module-info mode display]} {
   if {![file exists $prefix]} {
      puts stderr "\t[module-info name] Load Error: $prefix does not exist"
      break
      exit 1
   }
}


# Definition des variables d\'environnement
# ----------------------------------------
setenv         __MODULENAME__             $name
setenv         __MODULENAME___VER         $version
setenv         __MODULENAME___DIR         $prefix
setenv         __MODULENAME___HOME         $prefix
setenv         __MODULENAME___ARCH        $arch
setenv         __MODULENAME___LIB_DIR     $prefix/lib
setenv         __MODULENAME___INC_DIR     $prefix/include
setenv         __MODULENAME___BIN_DIR     $prefix/bin
prepend-path   LD_LIBRARY_PATH    $prefix/lib
"""

def get_available(name, excludes):
    cmd = u"module av 2>&1 | sed -e 's/ [ ]*/\\n/g' |"
    cmd = cmd + u" grep '%s/' | grep -v latest |" %(name)
    for exclude in excludes:
        cmd += u" grep -v %s |" % exclude
    cmd += u"sed -e 's/(.*)//g'"

    compiler_list=subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).communicate()[0].split()
    out = []
    for compiler in compiler_list:
        split = compiler.split(u"/")
        split.pop(0)
        out.append(split)
    return out


def get_var(key, compiler, mpi):
    global g_modules, g_modules_nompi
    if (mpi == None):
        cmd = g_modules_nompi % (compiler[0], compiler[1])
    else:
        cmd = g_modules % (compiler[0], compiler[1], mpi[0], mpi[1])
    cmd = cmd + u'echo $%s' %key
    #print cmd
    return subprocess.Popen(cmd, shell=True,
                            stdout=subprocess.PIPE).communicate()[0].rstrip()

def get_path(key, compiler, mpi):
    global g_modules, g_modules_nompi
    if (mpi == None):
        cmd = g_modules_nompi % (compiler[0], compiler[1])
    else:
        cmd = g_modules % (compiler[0], compiler[1], mpi[0], mpi[1])
    cmd = cmd + u'which %s' %key

    return subprocess.Popen(cmd, shell=True,
                            stdout=subprocess.PIPE).communicate()[0].rstrip()

def install(programme, version, source_dir, scotch_version, libs):
    global g_pastix_makefile
    global g_scotch_makefile
    global g_module_file
    global g_root

    compiler = libs[0]
    if libs[1] == None:
        mpi_lib = None
        mpi     = None
    else:
        mpi = libs[1]
        mpi_lib = u"/opt/cluster/mpi/%s/%s/%s/%s" % (mpi[0], mpi[1],
                                                     compiler[0],
                                                     compiler[1])
        if (not os.path.exists(mpi_lib)):
            print "%s does not exists" % (mpi_lib)
            return

    versions = [[u"int32", u"-DINTSIZE32"],
                [u"int64", u"-DINTSIZE64"]]
    for version_int in versions:
        prefix = g_root
        scotch_home = g_root
        prefix = os.path.join(prefix, programme, version,
                              compiler[0], compiler[1])
        if mpi:
            prefix = os.path.join(prefix, mpi[0], mpi[1])
        if "pastix" in programme:
            prefix = os.path.join(prefix, "scotch", scotch_version)
        prefix = os.path.join(prefix, version_int[0])
        if mpi:
            scotch_home = os.path.join(scotch_home,
                                       u"scotch", scotch_version,
                                       compiler[0], compiler[1],
                                       mpi[0], mpi[1])
        else:
            scotch_home = os.path.join(scotch_home,
                                       u"scotch-nompi", scotch_version,
                                       compiler[0], compiler[1])

        scotch_home = os.path.join(scotch_home,
                                   version_int[0])
        modulefile = g_module_file
        if ("scotch" in programme):
            makefile = g_scotch_makefile
            modulefile = modulefile.replace(u"__modulename__", u"scotch")
            modulefile = modulefile.replace(u"__MODULENAME__", u"SCOTCH")
            makefile_filename = u"%s/src/Makefile.inc" % source_dir
            if (u"nompi" in programme):
                if (u"esmumps" in programme and not u"5.1.12" in version):
                    makecmds = [[u"make", u"realclean"],
                                [u"make", u"esmumps"],
                                [u"mkdir", u"-p", prefix],
                                [u"make", u"install"]]
                else:
                    makecmds = [[u"make", u"realclean"],
                                [u"make", u"scotch"],
                                [u"mkdir", u"-p", prefix],
                                [u"make", u"install"]]
            else:
                if (u"esmumps" in programme  and not u"5.1.12" in version):
                    makecmds = [[u"make", u"realclean"],
                                [u"make", u"esmumps", u"ptesmumps"],
                                [u"mkdir", u"-p", prefix],
                                [u"make", u"install"]]
                else:
                    makecmds = [[u"make", u"realclean"],
                                [u"make", u"scotch", u"ptscotch"],
                                [u"mkdir", u"-p", prefix],
                                [u"make", u"install"]]
        if (u"pastix" in programme):
            makefile = g_pastix_makefile
            modulefile = modulefile.replace(u"__modulename__", u"pastix")
            modulefile = modulefile.replace(u"__MODULENAME__", u"PASTIX")

            makefile_filename = u"%s/src/config.in" % source_dir
            makecmds = [[u"make", u"clean"],
                        [u"make", u"-j", u"examples"]]
        CC = get_var(u"CC", compiler, mpi)
        FC = get_var(u"FC", compiler, mpi)
        HWLOC_DIR = get_var(u"HWLOC_DIR", compiler, mpi)
        if FC == u'ifort':
            LIB_FORTRAN = u"-lifcore"
            FC_PREPROC = u"-fpp"
        else:
            if FC == u'gfortran':
                LIB_FORTRAN = u'-lgfortran'
                FC_PREPROC = u"-ffree-form -x f95-cpp-input"
            else:
                LIB_FORTRAN = u'-lpgf90 -lpghpf2'
                FC_PREPROC = u""

        my_env = os.environ
        my_env[u"LD_LIBRARY_PATH"] = get_var(u"LD_LIBRARY_PATH", compiler, mpi)
        my_env[u"PATH"] = get_var(u"PATH", compiler, mpi)
        my_env[u"MKL_LIB"] = get_var(u"MKL_LIB", compiler, mpi)
        CC = get_path(CC, compiler, mpi)
        FC = get_path(FC, compiler, mpi)
        if u"nompi" in programme:
            MPCC = CC
            MPFC = FC
            CXX = get_var(u"CXX", compiler, mpi)
            MPCXX = get_path(CXX, compiler, mpi)
        else:
            MPCC  = get_path(u"mpicc", compiler, mpi)
            MPCXX = get_path(u"mpicxx", compiler, mpi)
            MPFC  = get_path(u"mpif90", compiler, mpi)
        makefile = makefile.replace(u"__PREFIX__", prefix)
        makefile = makefile.replace(u"__LIB_FORTRAN__", LIB_FORTRAN)
        makefile = makefile.replace(u"__FC_PREPROC__", FC_PREPROC)
        makefile = makefile.replace(u"__SCOTCH_HOME__", scotch_home)
        makefile = makefile.replace(u"__HWLOC_HOME__", HWLOC_DIR)
        makefile = makefile.replace(u"__CC__", CC)
        makefile = makefile.replace(u"__MPCC__", MPCC)
        makefile = makefile.replace(u"__MPCXX__", MPCXX)
        makefile = makefile.replace(u"__FC__", FC)
        makefile = makefile.replace(u"__MPFC__", MPFC)
        makefile = makefile.replace(u"__TYPE__", version_int[1])
        if (u"pastix" == programme):
            makefile = makefile.replace(u"__NOMPI__", u"")
        if (u"pastix-nompi" == programme):
            makefile = makefile.replace(u"__NOMPI__",
                                        u"VERSIONMPI  = _nompi\n"+
                                        u"CCTYPES    := $(CCTYPES) -DFORCE_NOMPI\n")
        FILE = open(makefile_filename,"w")
        FILE.write(makefile)
        out =""
        err =""
        FILE.close()
        for makecmd in makecmds:
            (out, err) = subprocess.Popen(makecmd,
                                          stdout=subprocess.PIPE,
                                          stderr=subprocess.PIPE,
                                          cwd=u"%s/src" % source_dir,
                                          env=my_env).communicate()
            #print MPCC
            #print out
            try:
                print u"%s out :\n %s" %(u" ".join(makecmd), out)
                print u"%s err :\n %s" %(u" ".join(makecmd), err)
            except:
                print makecmd
                print out
                print err

def missing_installs(package_name, version, test, depends, scotch_version):
    global g_root

    base = g_root
    missing = []
    compiler = depends.pop(0)
    if (u"nompi" in package_name):
        mpi = None
    else:
        mpi      = depends.pop(0)
    for compiler in compilers:
        test_file = os.path.join(base, package_name, version,
                                 compiler[0], compiler[1])
        if u"nompi" in package_name:
            if "pastix" in package_name:
                test_file = os.path.join(test_file, "scotch", scotch_version)
            test_file = os.path.join(test_file, test)
            if not os.path.exists(test_file):
                missing.append([compiler, None])
        else:
            for mpi in mpis:
                test_file2 = os.path.join(test_file, mpi[0], mpi[1])
                if "pastix" in package_name:
                    test_file2 = os.path.join(test_file2, "scotch", scotch_version)
                test_file2 = os.path.join(test_file2, test)

                if not os.path.exists(test_file2):
                    mpi_lib = os.path.join(u"/opt/cluster/mpi/",
                                           mpi[0], mpi[1],
                                           compiler[0], compiler[1])

                    if (os.path.exists(mpi_lib)):
                        missing.append([compiler, mpi])
    return missing

if __name__ == "__main__":
    from optparse import OptionParser
    # Defining the options of the program
    usage="""usage: %prog -p programme -v version [options]

Check what need to be installed.
"""
    username    = os.getenv('USER')

    parser = OptionParser(usage=usage)

    parser.add_option("-p", "--programme", dest="programme",
                      help="Programme name",
                      metavar='string', type=str, default=[])

    parser.add_option("-s", "--scotch-version", dest=u"scotch_version",
                      help="Scotch version number",
                      metavar='string', type=str, default=u"")

    parser.add_option("-v", "--version", dest="version",
                      help="Version number",
                      metavar='string', type=str, default=[])

    parser.add_option('-c', '--count', dest='count',
                      help='Count the number of build missing',
                      action='store_true', default=False)

    parser.add_option('-l', '--list', dest='list',
                      help='List the missing build',
                      action='store_true', default=False)

    parser.add_option('-i', '--install', dest='source_dir',
                      help='Install the missing build with srcdir',
                      metavar='source_dir', type=str, default=[])

    parser.add_option('-f', '--force-rebuild', dest='force',
                      help='Force rebuild of all install',
                      action='store_true', default=False)

    parser.add_option('-d', '--clean', dest='clean',
                      help='Clean old installs',
                      action='store_true', default=False)

    parser.add_option('-r', '--dryrun', dest='dryrun',
                      help='dry run',
                      action='store_true', default=False)

    # Parse the command line
    (options, args) = parser.parse_args()

    compilers = get_available(u"compiler", [])
    mpis = get_available(u"mpi", [u"mpiexec"])

    test = u"toto"
    if  u"scotch" in options.programme :
        test = u"int32/lib/libscotch.a"
    if u"pastix" in options.programme:
        test = u"int32/lib/libpastix.a"
    if options.force:
        test = u"no_test"

    if options.version == [] or options.programme == []:
        print "version and programme required"
        print usage
        sys.exit(1)

    if options.clean:
        base = os.path.join(g_root, options.programme, options.version)
        if os.path.isdir(base):
            for compiler in os.listdir(base):
                for version in os.listdir(os.path.join(base, compiler)):
                    if not version == "latest":
                        if not [compiler, version] in compilers:
                            print "remove %s %s: %s" %(compiler, version, os.path.join(base, compiler, version))
                            if not options.dryrun:
                                shutil.rmtree(os.path.join(base, compiler, version))

        if not u"nompi" in options.programme:
            for compiler in compilers:
                base=os.path.join(g_root, options.programme, options.version, compiler[0], compiler[1])
                if os.path.isdir(base):
                    for mpi in os.listdir(base):
                        for version in os.listdir(os.path.join(base, mpi)):
                            if not version == "latest":
                                if not [mpi, version] in mpis:
                                    print "remove %s %s: %s" %(mpi, version, os.path.join(base, mpi, version))
                                    if not options.dryrun:
                                        shutil.rmtree(os.path.join(base, mpi, version))

    if options.count or options.list or options.source_dir:
        missings = missing_installs(options.programme, options.version, test, [compilers, mpis], options.scotch_version)

    if options.count:
        print "%d installations required" %( len(missings))
    if options.list:
        for missing in missings:
            print missing

    if options.source_dir:
        if u"pastix" in options.programme  and options.scotch_version == "":
            print "Scotch version required"
            print get_path("mpic++", ["intel","12.1.12.361"], ["intel", "latest"])
            print usage
            sys.exit(1)
        for missing in missings:
            if not options.dryrun:
                install(options.programme, options.version, options.source_dir, options.scotch_version, missing)
