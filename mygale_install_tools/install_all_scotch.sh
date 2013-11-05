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
