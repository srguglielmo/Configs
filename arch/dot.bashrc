#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompts
if [ $EUID -eq 0 ]; then
	PS1='\[\e[1;31m\][\u@\H] \w\n\$\[\e[0m\] '
else
	PS1='\[\e[1;32m\][\u@\H] \w\n\$\[\e[0m\] '
fi
PS2='> '
PS3='> '
PS4='+ '

# Don't save history, but keep it for the session
HISTSIZE=500
unset HISTFILE

# Env Vars
export VISUAL=vim
export EDITOR=vim
export LESSHISTFILE=/dev/null
export LESSSECURE

# Aliases
alias l='ls -aFhl --color=auto'
alias rm='rm -iv --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -v'
alias vi='vim'
alias top='htop'
alias se='sudoedit'
alias sudo="sudo " # Use calling user's env

# Check window size after each command
shopt -s checkwinsize
