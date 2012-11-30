#!/bin/bash
LOCK_FILE=/tmp/lock_mpi
myname=`whoami`
if [ -f $LOCK_FILE ]; then
    name=`cat $LOCK_FILE`;
    if [ $name != $myname ]; then
	machine=`uname -n`;	
	echo "MPI running on $machine by \"$name\" (!= \"$myname\")";
	exit;
    else
	$*;
	sleep 0.3;
	if [ -f $LOCK_FILE ]; then
	    rm $LOCK_FILE
	fi
    fi
else
echo $myname > $LOCK_FILE
chmod +w $LOCK_FILE
$*;
sleep 0.3;
if [ -f $LOCK_FILE ]; then
    rm $LOCK_FILE
fi
fi
    

