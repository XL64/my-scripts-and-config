# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

if [[ $- == *i* ]]
then
    test -s ~/.alias && . ~/.alias || true
    LIQUIDPROMPT=$HOME/src/liquid-prompt/liquidprompt/liquidprompt
    test -s $LIQUIDPROMPT && source $LIQUIDPROMPT || true
    module load git/1.8.1.2 emacs
    export LESS="-F -X -R"
    export LP_ENABLE_SVN=0
fi


# preserve the X environment variables
store_display() {
    export | grep '\(DISPLAY\|XAUTHORITY\)=' > ~/.display.${HOSTNAME}
}

# read out the X environment variables
update_display() {
    echo eval "[ -r ~/.display.${HOSTNAME} ] && source ~/.display.${HOSTNAME}";
}

# WINDOW is set when we are in a screen session
if [ -n "$WINDOW" ] ; then 
    # update the display variables right away
    [ -r ~/.display.${HOSTNAME} ] && source ~/.display.${HOSTNAME}
    
    
    # setup the preexec function to update the variables before each command
    preexec () {
        #`update_display`
	:;
    }
fi

# this will reset the ssh-auth-sock link and screen display file before we run screen
_screen_prep() {
    if [ -n "$SSH_AUTH_SOCK" ] ; then
	if [ "$SSH_AUTH_SOCK" != "$HOME/.screen/ssh-auth-sock.$HOSTNAME" ] ; then
            ln -fs "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME"
	fi
    fi
    store_display
}

function compare_columns()
{
    local file1=$1
    local col1=$2
    local file2=$3
    local col2=$4
    
    LC_ALL=en awk -v col1=$col1 -v col2=$col2 'FNR==NR{a[NR]=$col1; }FNR!=NR{sum1=sum1+$col2*$col2 ;sum2+=($col2-a[FNR])*($col2-a[FNR])}END{print "sum(b_i**2)", sum1, "sum((b_i-a_i)**2)", sum2, "sqrt(sum(b_i-a_i)**2)/sum(b_i**2))", sqrt(sum2/sum1)}' $file1 $file2
}

# WINDOW is not set when we are not in a screen session
if [ -z "$WINDOW" ] ; then 
    alias screen='_screen_prep ; screen'
else
    alias screen='[ -r ~/.display.${HOSTNAME} ] && source ~/.display.${HOSTNAME} ; screen'	
fi

