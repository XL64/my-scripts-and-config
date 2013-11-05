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
