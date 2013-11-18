#!/bin/bash

echo ">>> 6.0.0 NOMPI <<<"
python missing_installs.py -p scotch-nompi         -v 6.0.0    -i ~/src/scotch/scotch_6.0.0          $*
echo ">>> 5.1.12b NOMPI <<<"
python missing_installs.py -p scotch-nompi         -v 5.1.12b  -i ~/src/scotch/scotch_5.1.12b	     $*
echo ">>> 6.0.0 NOMPI ESMUMPS <<<"
python missing_installs.py -p scotch-nompi-esmumps -v 6.0.0    -i ~/src/scotch/scotch_6.0.0_esmumps  $*
echo ">>> 5.1.12b NOMPI ESMUMPS <<<"
python missing_installs.py -p scotch-nompi-esmumps -v 5.1.12b  -i ~/src/scotch/scotch_5.1.12_esmumps $*
echo ">>> 6.0.0 <<<"
python missing_installs.py -p scotch               -v 6.0.0    -i ~/src/scotch/scotch_6.0.0	     $*
echo ">>> 5.1.12b <<<"
python missing_installs.py -p scotch               -v 5.1.12b  -i ~/src/scotch/scotch_5.1.12b	     $*
echo ">>> 6.0.0 ESMUMPS <<<"
python missing_installs.py -p scotch-esmumps       -v 6.0.0    -i ~/src/scotch/scotch_6.0.0_esmumps  $*
echo ">>> 5.1.12b ESMUMPS <<<"
python missing_installs.py -p scotch-esmumps       -v 5.1.12b  -i ~/src/scotch/scotch_5.1.12_esmumps $*

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
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/scotch
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/scotch-nompi
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/scotch-esmumps
    chgrp -R plafrim-dev /opt/cluster/plafrim-dev/scotch-nompi-esmumps
    chmod -R a+rX        /opt/cluster/plafrim-dev/scotch
    chmod -R a+rX        /opt/cluster/plafrim-dev/scotch-nompi
    chmod -R a+rX        /opt/cluster/plafrim-dev/scotch-esmumps
    chmod -R a+rX        /opt/cluster/plafrim-dev/scotch-nompi-esmumps
    chmod -R g+w         /opt/cluster/plafrim-dev/scotch
    chmod -R g+w         /opt/cluster/plafrim-dev/scotch-nompi
    chmod -R g+w         /opt/cluster/plafrim-dev/scotch-esmumps
    chmod -R g+w         /opt/cluster/plafrim-dev/scotch-nompi-esmumps
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch/int64
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-nompi/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-nompi/int64
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-esmumps/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-esmumps/int64
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-nompi-esmumps/int32
    python make_latest.py -r /opt/cluster/plafrim-dev/scotch-nompi-esmumps/int64
fi
