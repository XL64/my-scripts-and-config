#!/bin/bash

echo ">>> 5.2.1 SCOTCH 6.0.0 <<<"
python missing_installs.py -p pastix       -v 5.2.1 -s 6.0.0   -i ~/src/pastix/pastix_release_4492 $*
echo ">>> 5.2.1 SCOTCH 5.1.12b <<<"
python missing_installs.py -p pastix       -v 5.2.1 -s 5.1.12b -i ~/src/pastix/pastix_release_4492 $*
echo ">>> 5.2 SCOTCH 6.0.0 <<<"
python missing_installs.py -p pastix       -v 5.2   -s 6.0.0   -i ~/src/pastix/pastix_release_3725 $*
echo ">>> 5.2 SCOTCH 5.1.12b <<<"
python missing_installs.py -p pastix       -v 5.2   -s 5.1.12b -i ~/src/pastix/pastix_release_3725 $*
echo ">>> 5.2.1 SCOTCH 6.0.0 NOMPI<<<"
python missing_installs.py -p pastix-nompi -v 5.2.1 -s 6.0.0   -i ~/src/pastix/pastix_release_4492 $*
echo ">>> 5.2.1 SCOTCH 5.1.12b NOMPI<<<"
python missing_installs.py -p pastix-nompi -v 5.2.1 -s 5.1.12b -i ~/src/pastix/pastix_release_4492 $*
echo ">>> 5.2 SCOTCH 6.0.0 NOMPI<<<"
python missing_installs.py -p pastix-nompi -v 5.2   -s 6.0.0   -i ~/src/pastix/pastix_release_3725 $*
echo ">>> 5.2 SCOTCH 5.1.12b NOMPI<<<"
python missing_installs.py -p pastix-nompi -v 5.2   -s 5.1.12b -i ~/src/pastix/pastix_release_3725 $*

args=`getopt rdclf $*`
set -- $args
DRYRUN=0
for i
do
    case "$i" in
        -r) shift; DRYRUN=1;;
    esac
    #echo "$i\n"
done

if [ $DRYRUN -eq 0 ]
then
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/pastix
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/pastix-nompi
    chmod -R a+rX        /opt/cluster/plafrim-dev/pastix
    chmod -R a+rX        /opt/cluster/plafrim-dev/pastix-nompi
    chmod -R g+w         /opt/cluster/plafrim-dev/pastix
    chmod -R g+w         /opt/cluster/plafrim-dev/pastix-nompi
    python make_latest.py -r /opt/cluster/plafrim-dev/pastix/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/pastix/int64
    python make_latest.py -r /opt/cluster/plafrim-dev/pastix-nompi/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/pastix-nompi/int64
fi
