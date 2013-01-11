
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# Finished adapting your PATH environment variable for use with MacPorts.

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

alias make='nocorrect make'
alias mygalefs='mkdir /Volumes/mygale;sshfs lacoste@mygale: -ovolname=mygale -oping_diskarb -oreconnect /Volumes/mygale'
alias mygaleaccesfs='mkdir /Volumes/mygale;sshfs lacoste@mygale_acces: -ovolname=mygale -oping_diskarb -oreconnect /Volumes/mygale'
alias vulcainfs='mkdir /Volumes/vulcain;sshfs lacoste@vulcain: -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/vulcain'
alias vulcainalgianefs='mkdir /Volumes/vulcain;sshfs froehly@vulcain_acces: -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/vulcain'
alias mediavulcainfs='mkdir /Volumes/media-vulcain;sshfs lacoste@vulcain:/media/vulcain/lacoste -ovolname=media-vulcain -oping_diskarb -oreconnect /Volumes/media-vulcain'
alias romulusfs='mkdir /Volumes/romulus;sshfs mfaverge@romulus:lacoste -ovolname=vulcain -oping_diskarb -oreconnect /Volumes/romulus'

alias vargaswd='mkdir /Volumes/vargas-workdir;sshfs rhyb079@vargas:/workgpfs/rech/hyb/rhyb079 -ovolname=vargas-workdir -oping_diskarb -oreconnect /Volumes/vargas-workdir'
alias vargasfs='vargaswd'

alias newemacs="/Users/lacoste/Applications/Emacs.app/Contents/MacOS/Emacs"

export PATH=$HOME/bin:$PATH

#source $HOME/.zsh_prompt

export HOMEBREW_EDITOR="emacs"
ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jonathan"
plugins=(git)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all
unsetopt inc_append_history
unsetopt share_history # share command history data

function compare_columns()
{
    local file1=$1
    local col1=$2
    local file2=$3
    local col2=$4
    
    LC_ALL=en awk -v col1=$col1 -v col2=$col2 'FNR==NR{a[NR]=$col1; print $col1, NR, a[NR]}FNR!=NR{sum1=sum1+$col2*$col2 ;sum2+=($col2-a[FNR])*($col2-a[FNR])}END{print "sum(b_i**2)", sum1, "sum((b_i-a_i)**2)", sum2, "sqrt(sum(b_i-a_i)**2)/sum(b_i**2))", sqrt(sum2/sum1)}' $file1 $file2
}
