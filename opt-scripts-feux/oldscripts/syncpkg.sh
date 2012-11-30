#!/bin/bash

machinename=`uname -n`
date=`date +20%y%m%d_%H%M`
listname="pkglist_${machinename}_${date}"

dpkg --get-selections > /opt/pkglist/$listname;

if [ $machinename = "laurel" ]; then
    cat /opt/pkglist/$listname | ssh hardy "dpkg --set-selections -; apt-get -y update; apt-get -y dselect-upgrade";
fi
if [ $machinename = "hardy" ]; then
    echo "Copie de l'historique sur laurel pour ne pas quelle soit perdue au prochain rsync"
    scp $listname laurel:/opt/pkglist/$listname;
    echo "Attention : la convention veut qu'on installe sur laurel pour mettre a jour hardy !!!"
    echo "1) Continuer"
    echo "2) Annuler"
    read choice
    if [ $choice -eq 1 ]; then
	cat /opt/pkglist/$listname | ssh laurel "dpkg --set-selections -; apt-get -y update; apt-get -y dselect-upgrade";
    fi
fi