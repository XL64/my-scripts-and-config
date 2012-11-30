#!/bin/bash

MATRIXDIR=/media/local/matrices
machinename=`uname -n`

if [ $machinename != "vulcain" ]; then
    rsync -pog -avuz --exclude "*~" vulcain:$MATRIXDIR/ $MATRIXDIR
    $MATRIXDIR/link.sh
else
    echo "Il faut installer les matrices sur vulcain et les synchroniser ensuite ";
    echo "sur les autres machines depuis vulcain grâce à la commande suivante :";
    echo "     sudo /opt/scripts/syncmtxall.sh"
fi


