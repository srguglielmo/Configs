#
# srg"s ~/.bashrc
#

# If not running interactively, don"t do anything
if [[ $- != *i* ]]; then
	return
fi

# Prompts
if [[ "$EUID" -eq 0 ]]; then
	PS1="\[$(tput setaf 1)$(tput bold)\][\u@\h] \w\n\$\[$(tput sgr0)\] "
else
	PS1="\[$(tput setaf 2)\][\u@\h] \w\n\$\[$(tput sgr0)\] "
fi
PS2="> "
PS3="> "
PS4="+ "

# Save history
HISTCONTROL="ignorespace:erasedups"
HISTSIZE=250
HISTFILESIZE=250
HISTFILE="~/.bash_history"

# Shell options
shopt -s autocd checkjobs
shopt -s checkwinsize histappend

# Env Vars
export VISUAL="vim"
export EDITOR="vim"
export LANG="en_US.UTF-8"
export LESSHISTFILE="/dev/null"
export LESSSECURE=1

# Aliases
alias cp="cp -iv"
alias l="ls -aFhl --color=auto"
alias mkdir="mkdir -v"
alias mv="mv -iv"
alias rm="rm -iv --one-file-system"
alias vi="vim"
