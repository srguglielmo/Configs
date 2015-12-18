#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

umask 077

# Color root's prompt
if [ $EUID -eq 0 ]; then
	PS1='\[\e[1;31m\][\u@\H] \w\n\$\[\e[0m\] '
else
	PS1='\[\e[1;32m\][\u@\H] \w\n\$\[\e[0m\] '
fi
PS2='> '
PS3='> '
PS4='+ '
shopt -s checkwinsize

# Aliases
alias ls='ls --color=auto'
alias vi=vim
alias l='ls --color=auto -alh'
alias grep='grep --color=auto'
alias mv='mv -iv'
alias rm='rm -iv --one-file-system'

# Don't crowd ~ with history dotfiles
unset HISTFILE
export LESSHISTFILE=-

export LESS=-R
export LESSSECURE=1
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
