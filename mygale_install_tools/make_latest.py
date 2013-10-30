import subprocess
import re, sys, os,errno

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST:
            pass
        else: raise

def version_compare(x,y):
    y_s = y.split(u'.')
    for v in x.split(u'.'):
        v2 = y_s.pop(0)
        if (v > v2):
            return 1
        if (v < v2):
            return -1

    return 0

def get_modules(string):
    module_re = re.compile(u"%s/" % string)
    modules = {}
    for string in err.split():
        if (module_re.match(string)):
            module = re.sub(u"\(.*\)",u"",string)
            module = module.split(u'/')
            if not modules.has_key(module[1]) :
                modules[module[1]] = []
            if not module[2] == u'latest':
                modules[module[1]].append(module[2])
    return modules

if __name__ == "__main__":
    from optparse import OptionParser
    # Defining the options of the program
    usage="""usage: %prog -r [root directory] [options] 

Create latest file in root directory
"""
    username    = os.getenv('USER')

    parser = OptionParser(usage=usage)

    parser.add_option("-r", "--root", dest="root",
                      help="Root directory",
                      metavar='path', type=str, default=[])

    parser.add_option('-d', '--dryrun', dest='dryrun',
                      help='dry run',
                      action='store_true', default=False)

    # Parse the command line
    (options, args) = parser.parse_args()

    root = options.root

    p = subprocess.Popen(u"module av", 
                         stderr=subprocess.PIPE, 
                         stdout=subprocess.PIPE, shell=True)
    (out, err) = p.communicate()

    compilers = get_modules(u'compiler')
    mpis      = get_modules(u'mpi')
    mpis.pop(u"mpiexec")
    for key in compilers.keys():
        compiler = sorted(compilers[key], 
                          reverse = True,
                          cmp=version_compare)
        dir = u"%s/%s" %(root,key)
        if not os.path.isdir(dir):
            mkdir_p(dir)
        filename = u'%s/%s' % (dir, u'latest')
        if os.path.isdir(filename):
            print "Removing %s" % filename
            if not options.dryrun:
                os.remove(filename)

        print "Symlink %s %s" %(compiler[0], filename)
        if not options.dryrun:
            os.symlink(compiler[0], filename)

        #subprocess.Popen([u"ln", u"-sT", compiler[0], u'latest'],
        #                 cwd = dir).wait()
        
        if not u'nompi' in root:
            for version in compiler:
                for key2 in mpis.keys():
                    mpi = sorted(mpis[key2],
                                 reverse = True,
                                 cmp = version_compare)
                    dir =  u"%s/%s/%s/%s" %(root,key,version,key2)
                    print "mkdir -p %s" % dir
                    if not options.dryrun:
                        mkdir_p(dir)

                    filename = u'%s/%s' % (dir, u'latest')
                    if os.path.isdir(filename):
                        print "Try remooving %s" % filename
                        if not options.dryrun:
                            os.remove(filename)

                    print "Symlink %s %s" %(mpi[0], filename)
                    if not options.dryrun:
                        os.symlink(mpi[0], filename)
                           
                #subprocess.Popen([u"ln", u"-sT", mpi[0], u'latest'],
                #                 cwd = dir).wait()
            


