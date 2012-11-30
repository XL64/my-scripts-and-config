#!/bin/bash

MATRIXDIR=/media/local/matrices
machinename=`uname -n`
if [ $machinename = "vulcain" ]
then
    chown -R root:users /media/local/matrices
#     find $MATRIXDIR -type f -exec chmod 644 {} \;
#     find $MATRIXDIR -type d -exec chmod 755 {} \;
#     find $MATRIXDIR -type d -exec chmod g+s {} \;
    for i in hephaistos loki agni
    do
	rsync -pog -avuz --exclude "*~" $MATRIXDIR/ $i:$MATRIXDIR
        ssh $i $MATRIXDIR/link.sh
    done
    $MATRIXDIR/link.sh
else
    echo "Ce script ne peut pas etre exécuter depuis autre machine que vulcain"
fi

