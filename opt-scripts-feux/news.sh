#!/bin/bash 
machine=`uname -n`

if test $machine == "vulcain";then

    if test -f ${HOME}/.lastcheck; then
    
	if test `find /media/laurel/films  -type f -newer ${HOME}/.lastcheck | wc -l` -eq 0; then
            echo "Aucun nouveau film!"
	else
	    find /media/laurel/films  -type f -newer ${HOME}/.lastcheck | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}'
	fi
	
	if test `find /media/laurel/series -type f -newer ${HOME}/.lastcheck | wc -l` -eq 0; then
            echo "Aucune nouvelle serie!"
	else	
	    find /media/laurel/series -type f -newer ${HOME}/.lastcheck | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}'
	fi

	if test `find /media/laurel/musique -type f -newer ${HOME}/.lastcheck | wc -l` -eq 0; then
            echo "Aucune nouvelle musique!"
	else	
	    find /media/laurel/musique -type f -newer ${HOME}/.lastcheck | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}'
	fi
    else
	find /media/laurel/series -type f | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}' 
	find /media/laurel/films  -type f | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}'
	find /media/laurel/musique  -type f | grep -Iv srt | sed -e 's/ /\\ /g' | sed -e 's/\[/\\\[/g' | sed -e 's/\]/\\\]/g' | sed -e 's/'\''/\\'\''/g'| xargs ls -aGghtr | cut -c 13- | awk -F" /" '{print $1" \033[1;31m/"$2" \033[0m"}'
    fi

    touch ${HOME}/.lastcheck
else
    ssh vulcain /opt/scripts/news.sh
fi