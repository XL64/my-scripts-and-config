#!/bin/bash

machinename=`uname -n`

if [ $machinename != "vulcain" ]; then
    rsync -pog -avuz --delete --exclude "*~" vulcain:/opt/ /opt
else
    echo "Il faut compiler sur vulcain et ensuite synchroniser sur les autres avec cssh"
fi
