zmodload zsh/regex
OS=`uname`
if [[ $OS == "Darwin" ]];
then
    machine=`scutil --get ComputerName | awk '{print $1}'`
else
       machine=$HOST
fi
#echo $machine
if [[ $machine == "Cronos" ]];
then
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
    export PATH=/usr/local/share/python:$PATH
    export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
# Finished adapting your PATH environment variable for use with MacPorts.

    alias mygalefs='mkdir /Volumes/mygale;sshfs lacoste@mygale: -ovolname=mygale -oping_diskarb -oreconnect /Volumes/mygale'
    alias mygaleaccesfs='mkdir /Volumes/mygale;sshfs lacoste@mygale_acces: -ovolname=mygale -oping_diskarb -oreconnect /Volumes/mygale'
    alias vulcainfs='mkdir /Volumes/vulcain;sshfs lacoste@vulcain: -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/vulcain'
    alias vulcainalgianefs='mkdir /Volumes/vulcain;sshfs froehly@vulcain_acces: -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/vulcain'
    alias mediavulcainfs='mkdir /Volumes/media-vulcain;sshfs lacoste@vulcain:/media/vulcain/lacoste -ovolname=media-vulcain -oping_diskarb -oreconnect /Volumes/media-vulcain'
    alias romulusfs='mkdir /Volumes/romulus;sshfs mfaverge@romulus:lacoste -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/romulus'
    alias vargaswd='mkdir /Volumes/vargas-workdir;sshfs rhyb079@vargas:/workgpfs/rech/hyb/rhyb079 -ovolname=vargas-workdir -oping_diskarb -oreconnect /Volumes/vargas-workdir'
    alias vargasfs='vargaswd'

    alias newemacs="/Users/lacoste/Applications/Emacs.app/Contents/MacOS/Emacs"

    export HOMEBREW_EDITOR="emacs"
fi

if [[ $machine == "vulcain" ||
            $machine == "loki" ||
            $machine == "agni" ||
            $machine == "hephaistos" ]];
then
#alias ls="/sw/bin/ls --color"
    alias NaturalDocs="perl ~/bin/NaturalDocs/NaturalDocs"
    alias ls="ls --color"
    alias la="ls -a"
    alias ll="ls -l"
    alias cvss="cvs status | grep Status"
    alias tanit="ssh -CY lacoste@tanit.enseirb.fr"
    alias clean="rm *~ *.log *.toc *.aux "
    alias proj="cd ~/.proj/"
    alias junit="cd; source .bash_profile; cd -"
    alias i2="cd /Users/xl/Documents/cours/i2/"
    alias i1="cd /Users/xl/Documents/cours/i1/"
    alias sgbd="i2; cd SGBD"
    alias album="mogrify -resize 800x600 -format jpg * ; album"
    alias javag="java -Dapple.laf.useScreenMenuBar=true -Dapple.awt.brushMetalLook=true"
    alias unecran="xrandr -r 53.0 -s 1440x900"
    alias bigecran="xrandr -r 52.0 -s 1280x1024"
    alias scecran="xrandr -r 51.0 -s 800x600"
    alias deuxecrans="xrandr -r 50.0 -s 2720x1024"
    alias env64="source /opt/env/env_64_mpich2.sh"
    alias env32="source /opt/env/env_32_mpich2.sh"
    alias iccsource="export LANG=C && 
      source /opt/env/env_64_mpich2.sh && 
      source /opt/intel/Compiler/11.0/083/bin/iccvars.sh intel64 && 
      source /opt/intel/Compiler/11.0/083/bin/ifortvars.sh intel64 &&
      source /opt/intel/Compiler/11.0/083//mkl/tools/environment/mklvarsem64t.sh &&
      source /opt/scotch/int64/env.sh && source /opt/gotoblas/env.sh"
    alias make="colormake"
    alias comp=' make debug install && cd matrix_drivers/src && make debug install && cd - && cd test_c/src && make debug && cd -'
    alias comp=' make expor install && cd matrix_drivers/src && make expor install && cd - && cd test_c/src && make expor && cd -'
    alias simpleprompt='export PROMPT=%n@%m:%~: && export RPROMPT='
    alias screen='~/bin/grabssh.sh; LANG=EN_US screen'
    alias fixssh='source ~/bin/fixssh; ssh'
fi

export VISUAL=emacs
export EDITOR=emacs


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct #_approximate
zstyle :compinstall filename '/Users/lacoste/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

if [[ "$TERM" == "dumb" ]]
then
    unsetopt appendhistory autocd extendedglob nomatch notify
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

alias make='nocorrect make'


export PATH=$HOME/bin:$PATH

# need the host name set sometimes
[ -z "$HOSTNAME" ] && export HOSTNAME=$(hostname)

# preserve the X environment variables
store_display() {
    export | grep '\(DISPLAY\|XAUTHORITY\)=' > ~/.display.${HOSTNAME}
}

# read out the X environment variables
update_display() {
    [ -r ~/.display.${HOSTNAME} ] && source ~/.display.${HOSTNAME}
}

# WINDOW is set when we are in a screen session
if [ -n "$WINDOW" ] ; then 
    # update the display variables right away
    update_display
    
    # setup the preexec function to update the variables before each command
    preexec () {
        update_display
    }
fi

# this will reset the ssh-auth-sock link and screen display file before we run screen
_screen_prep() {
    if [ "$SSH_AUTH_SOCK" != "$HOME/.screen/ssh-auth-sock.$HOSTNAME" ] ; then
        ln -fs "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME"
    fi
    store_display
}
alias screen='_screen_prep ; screen'

function choute() {
    echo "(l($1)/l(10.)-l($2)/l(10.))/(l($3)/l(10.)-l($4)/l(10.))" | bc -l
}

function cs(){
    cd $*;ls
}

function get_pid () {
    ps aux | grep $1 |grep -v grep| tail -n $(($LC_RANK+1)) | head -n 1| awk '{print $2}'
}


function compare_columns()
{
    local file1=$1
    local col1=$2
    local file2=$3
    local col2=$4
    
    LC_ALL=en awk -v col1=$col1 -v col2=$col2 'FNR==NR{a[NR]=$col1; }FNR!=NR{sum1=sum1+$col2*$col2 ;sum2+=($col2-a[FNR])*($col2-a[FNR])}END{print "sum(b_i**2)", sum1, "sum((b_i-a_i)**2)", sum2, "sqrt(sum(b_i-a_i)**2)/sum(b_i**2))", sqrt(sum2/sum1)}' $file1 $file2
}

function duf()
{
    du -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ $machine == "Cronos" ]];
then
    ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="jonathan"
else
    if [[ $machine == "vulcain" ||
                $machine == "loki" ||
                $machine == "agni" ||
                $machine == "hephaistos" ]];
    then
        ZSH_THEME="blinks"
        ZSH=/opt/oh-my-zsh
    fi
fi

plugins=(git)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all
unsetopt inc_append_history
unsetopt share_history # share command history data

# Used to get ssh-agent in screen
# required a setenv SSH_AUTH_SOCK "/tmp/ssh-agent-$USER-screen" in screenrc
alias screen="test $SSH_AUTH_SOCK && ln -sf \"$SSH_AUTH_SOCK\" \"/tmp/ssh-agent-$USER-screen\"; screen"
