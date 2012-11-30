#!/bin/bash

machinename=`uname -n`

if [ $machinename = "vulcain" ]; then
    for i in hephaistos loki agni
    do 
#	rsync -pog -avuz --delete --exclude "*~" /opt/ $i:/opt
	rsync -pog -avuz --delete --exclude "*~" /opt/ $i:/opt
    done
else
    echo "Ce script ne peut s'executer que depuis vulcain"
fi
