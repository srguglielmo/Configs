# ~/.bashrc: sourced by ~/.profile for login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# No history recording
unset HISTFILE
export LESSHISTFILE=/dev/null
export LESSSECURE=1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Color prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Aliases
alias l='ls -AhlF --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias top=htop
alias gpg=gpg2
alias g=grep
