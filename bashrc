#!/usr/bin/env bash
######
# vim: ts=4 sw=4 ht=4 et nu nowrap
#shellcheck disable=SC1090,SC2121,SC1001,SC1091


set -o vi
set keymap vi

stty erase ^\?
stty werase ^\u

## check the window size after each program (vim etc.) terminates
## so the line-wrapping is correct if the window was resized
## while bash wasn't the active program
shopt -s checkwinsize

## don't offer to complete an empty line when I hit tab
shopt -s no_empty_cmd_completion

## add extended filename globbing
shopt -s extglob

## cd to a bare directory name
shopt -s autocd

HISTCONTROL=ignoredups:ignorespace

if [ -d ~/bin ]; then
  PATH=$PATH:~/bin
fi

EDITOR=$(command -v vim)
LSCOLORS='Dxfxcxdxbxegedabagacad' 
PAGER='less -FRXSWIm'
reset=$(tput sgr0)
bold=$(tput bold)
PS1='\[${bold}\t \u@\h \w${reset}\] \n$ '
mkdir -p ~/.env
chmod 700 ~/.env
TZ='America/Los_Angeles'

export EDITOR LSCOLORS HISTCONTROL PAGER PATH PS1 TZ

if [[ $(uname) == "Linux" ]]; then
    alias ls='/bin/ls -lhF --color=auto'
    alias ll="/bin/ls -lAhF --color=auto"
    alias mode='stat -c "%a %n"'
    alias mounts='df -P -t nfs -h | sed "s/Mounted on/Mounted_on/" | column -t'
    alias vols='lsblk -i -o kname,mountpoint,fstype,size,maj:min,name,state,rm,rota,ro,type,label,model,serial'
elif [[ $(uname) == "Darwin" ]]; then
    alias cpu-temp='osx-cpu-temp -F'   # brew install osx-cpu-temp
    alias ls='/bin/ls -lhFG'
    alias ll='/bin/ls -lAhFG'
    PATH=$PATH:${HOME}/oracle/instantclient_19_8
    export SQLPATH="${HOME}/oracle"
fi

# read the ssh-agent eval file, if it exists
[[ -f /tmp/ssh-agent ]] && . /tmp/ssh-agent > /dev/null

########  MISCELLANEOUS ####################
alias back='cd $OLDPWD'
alias beep='echo '
alias cls='clear'
alias cu='cd ..'
alias diff='diff -du'
alias env="env | sort"
alias grep='grep -E'
alias j="jobs"
[[ -x $(command -v ack) ]] && alias pack='ack --passthru'
alias proctree='/bin/ps -ew --forest -Oc'
alias rebash='source ~/.bash_login'
alias quit='exit'


# print the header (the first line of input)
# and then run the specified command on the body (the rest of the input)
# use it in a pipeline, e.g. ps | body grep somepattern
# from http://unix.stackexchange.com/questions/11856/sort-but-keep-header-line-at-the-top/11859#11859
function body {
    IFS= read -r header
    printf '%s\n' "$header"
    "$@"
}

ff() {
    find ./* -type f -name "*${1}*"
}

username="$USER"
if [[ "$LOGNAME" -ne "$USER" ]]; then
    username="$LOGNAME"
fi 
if [[ "$SUDO_USER" -ne "$USER" ]]; then
    username="$SUDO_USER"
fi 
export username

if [[ -d /opt/homebrew/bin ]] ; then
    PATH=$PATH:/opt/homebrew/bin
fi
if [ "$(command -v brew > /dev/null 2>&1; echo $?)" -eq 0 ] ; then
    if [ -f "$(brew --prefix)/etc/bash_completion" ] ; then
        . "$(brew --prefix)/etc/bash_completion"
    fi
fi

# ~/.localconfig/ is always last in case I want to override anything
for dwierenga_completion_dir in /etc/bash_completion.d /usr/local/etc/bash_completion.d  "$HOME/.bash_completion.d"  "$HOME/.localconfig"; do
    if [ -d "${dwierenga_completion_dir}" ]; then
        find "$dwierenga_completion_dir"/* -maxdepth 1 -type f -not -name '*.md'  -not -name 'inputrc' 2> /dev/null 
        for f in $( find $dwierenga_completion_dir/* -maxdepth 1 -type f -not -name '*.md'  -not -name 'inputrc' 2> /dev/null ) ; do
            . "$f"
        done
    fi
done



#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"


[[ -f ~/.prompt ]] && . ~/.prompt

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/danwiere/.sdkman"
[[ -s "/Users/danwiere/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/danwiere/.sdkman/bin/sdkman-init.sh"

