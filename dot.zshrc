# srg's ~/.zshrc
# This is run for interactive shells.

#############
# FUNCTIONS #
#############
# Function definitions are first in this file because other
# options below (prompts, aliases, etc) depend on them.

function command_not_found_handler {
	printf "\t\t¯\_(ツ)_/¯\n"
	exit 127
}

# Set the right prompt based on zle vi mode (cmd or insert)
# and git status/branch.
# Called from my-zle-line-init() and my-zle-keymap-select().
function indicate-zle-mode {
	#RPS1='${vcs_info_msg_0_} ' # The zsh built-in vcs_info
	RPS1='$(git_super_status) ' # zsh-git-prompt from GitHub

	# Print the Vi mode zle is in
	if [[ $KEYMAP == "main" ]]; then
		# main is viins mode
		RPS1+='%F{251}[%F{040}INS%F{251}]%f'

	elif [[ $KEYMAP == "vicmd" ]]; then
		RPS1+='%F{251}[%K{088}%F{227}%BCMD%b%k%F{251}]%f'

	elif [[ $KEYMAP == "viopp" ]]; then
		RPS1+='%F{251}[%K{088}%F{227}%BOPP%b%k%F{251}]%f'

	elif [[ $KEYMAP == "visual" ]]; then
		RPS1+='%F{251}[%K{088}%F{227}%BVIS%b%k%F{251}]%f'

	else
		RPS1+="%F{251}[%K{088}%F{227}%BERR/$KEYMAP%b%k%F{251}]%f"
	fi

	# Redraw the prompts
	zle reset-prompt
}

# Sets the zle mode (cmd or insert) in RPS1
function my-zle-keymap-select {
	# Set RPS1
	indicate-zle-mode

	# Anonymous function, executed immediately.
	# Returns the last program's exit code for use in in $PS1.
	function {
		return $__prompt_status
	}
}

# Since we use $? in PS1 below, we need to preserve the exit status
# of the last executed command in a temp variable.
function my-zle-line-init {
	# Set RPS1
	indicate-zle-mode

	# Set $__prompt_status to the last cmd's return code
	typeset -g __prompt_status="$?"
}

###########
# PROMPTS #
###########

# The main prompt
PS1="%F{057}%n%F{251}@%F{172}%M%f "				# user@host
PS1+="%F{251}%~%f"								# directory
PS1+=$'\n'										# newline
PS1+='%(?.'										# If exit code is 0
	#PS1+='(%?%)'								#   just display the exit code, no color
PS1+='.'										# else
	PS1+='%K{088}%F{227}%B'						#   start color and bold
	PS1+='(%?%)'								#   print exit code
	PS1+='%b%f%k '								#   end bold and color
PS1+=')'										# end if
PS1+="%F{040}%(2L.++.%#)%f "					# Display ++ if in a subshell, else %#

# Git info in the right prompt. RPS1 is set via the zle functions above.
#autoload -Uz vcs_info							# Load the vcs_info module
#zstyle ':vcs_info:*' enable git				# Only use git (not svn, etc)
#zstyle ':vcs_info:*' actionformats '%F{251}[%F{227}%K{088}%b/%a%k%F{251}]%f'
#zstyle ':vcs_info:*' formats '%F{251}[%F{040}%c%u%b%F{251}]%f'
#zstyle ':vcs_info:*' branchformat '%b'			# %b
#zstyle ':vcs_info:*' check-for-changes true	# Enable use of %c and %u
#zstyle ':vcs_info:*' stagedstr '%F{057}S '		# %c
#zstyle ':vcs_info:*' unstagedstr '%F{172}U '	# %u
#precmd () { vcs_info }							# Execute `vcs_info` just before each prompt
RPS1=""											# Mmust be set here to display the zle KEYMAP in RPS1 in the very first prompt

###########
# OPTIONS #
###########
# Only non-default options are set below

# Directory
setopt AUTO_CD AUTO_PUSHD
setopt CHASE_DOTS					# Resolve .. to physical dir
setopt PUSHD_IGNORE_DUPS
#setopt PUSHD_MINUS					# Swap the meaning of + and -

# Completion
setopt ALWAYS_TO_END				# Move cursor to end, even if we completed in a word
setopt COMPLETE_ALIASES
setopt BASH_AUTO_LIST				# Show completion menu on 2nd tab
setopt COMPLETE_IN_WORD				# Must be set for the _prefix completer
setopt GLOB_COMPLETE				# Use a completion menu for glob pattern matching
setopt LIST_PACKED					# Pack more info in the completion list
setopt LIST_ROWS_FIRST				# Left to right, not up to down
#setopt REC_EXACT					# Accept exact command match if it exists

# Expansion/Globbing
#unsetopt CASE_GLOB CASE_MATCH		# Make globbing and regexes case-insensitive
#setopt EXTENDED_GLOB				# Use # ~ ^ for globbing
#setopt GLOB_DOTS					# Dangerous
setopt MARK_DIRS					# Append / to dirs resulting from globbing
setopt NUMERIC_GLOB_SORT			# Sort numeric filenames numerically
setopt REMATCH_PCRE					# Use the PCRE library/module
#unsetopt UNSET						# Required for zsh-syntax-highlighting
#setopt WARN_CREATE_GLOBAL			# zsh-git-prompt will complain with this on
#setopt WARN_NESTED_VAR				# Also required for zsh-syntax-highlighting

# History
unsetopt EXTENDED_HISTORY			# I don\'t care about timestamps
setopt HIST_FCNTL_LOCK				# Lock the history file when writing
setopt HIST_IGNORE_ALL_DUPS			# Remove old entries if they\'re dupes
setopt HIST_IGNORE_SPACE			# Ignore commands with spaces prepended
setopt HIST_LEX_WORDS				# Be accurate when reading in a history file
setopt HIST_NO_FUNCTIONS			# Don\'t record functions
setopt HIST_NO_STORE				# Department of Redundancy Department
setopt HIST_REDUCE_BLANKS			# Don\t record blank commands
setopt HIST_SAVE_NO_DUPS			# Don\'t save any dupes when writing file
setopt HIST_VERIFY					# Probably a good idea
setopt INC_APPEND_HISTORY			# Append to history immediately (for multiple terms open at same time)
unsetopt SHARE_HISTORY				# Not even in ksh mode

# Input/Output
unsetopt CLOBBER					# Don\'t let > and >> clobber files (use >! or >>! instead)
unsetopt FLOW_CONTROL				# Disable ctrl+s and ctrl+q
setopt INTERACTIVE_COMMENTS			# Allow comments on interactive sessions
setopt HASH_EXECUTABLES_ONLY		# Only "cache" the path to to exec files
setopt PATH_DIRS					# Search path even for commands with slashes
unsetopt PATH_SCRIPT				# Don\'t search in path for a passed script argument
unsetopt RM_STAR_SILENT				# Not even in ksh/sh emulation mode
setopt RM_STAR_WAIT					# Pause 10 sec after a rm wildcard

# Job control
setopt LONG_LIST_JOBS				# Long listing by default

# Prompt
setopt PROMPT_SUBST					# Required for vcs_info in prompt
#setopt TRANSIENT_RPROMPT

# Scripts/functions
unsetopt MULTI_FUNC_DEF				# Don\'t allow func definitions with multiple names
unsetopt MULTIOS					# Don\'t automatically add extra tees and pipes
setopt PIPE_FAIL
#setopt SOURCE_TRACE					# Display names of files as they\'re sourced

# ZLE
#setopt COMBINING_CHARS				# Enabled in /etc/zshrc on MacOS
unsetopt SINGLE_LINE_ZLE			# Not even in KSH emulation mode

#######
# ZLE #
#######

# Create user defined widgets that use the above loaded widgets
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# zle-line-init is a widget that is executed every time zle is
# started to read a new line of input. Override it with our own function.
zle -N zle-line-init my-zle-line-init

# zle-keymap-select is a widget that is executed every time KEYMAP changes
# while the line editor is active. $KEYMAP within the function is the
# new keymap. The old keymap is passed as the sole argument. 
zle -N zle-keymap-select my-zle-keymap-select

################
# KEY BINDINGS #
################
bindkey -v										# Vi style in zle
#bindkey '^i' complete-word						# Required for _expand

# Load user-contrib widgets that match history based onthe current line prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search		# Up arrow calls the above widgets
bindkey '^[[B' down-line-or-beginning-search	# Down arrow

# ctrl+space to accept the autosuggestion
#bindkey '^ ' autosuggest-accept

#############
# VARIABLES #
#############

# ZSH vars
cdpath=(. ~/Code)					# PATH, but for cd
DIRSTACKSIZE=10						# Directory history size
#fignore=()							# File suffixes to ignore during completion
HISTFILE=~/.zhistory
#HISTORY_IGNORE
HISTSIZE=10000
#KEYTIMEOUT
LANG=en_US.UTF-8
path=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin)
#REPORTMEMORY=200					# Min size in MB. See TIMEFMT.
REPORTTIME=8						# Seconds.
SAVEHIST=10000
#SPROMPT
TIMEFMT='[%*E] [%Us CPUu] [%Ss CPUs] [%MMiB Max]'
TMPPREFIX=/tmp/zsh
watch=(notme)
WATCHFMT='%n has %a %l from %m'
#WORDCHARS

# Environment vars
export EDITOR=vim
export GREP_OPTIONS='--extended-regexp --binary-file=without-match'
export LESS='--ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS'
export LESSHISTFILE=/dev/null
export LESSSECURE=1
export PAGER=less
export VISUAL=vim

###########
# ALIASES #
###########

# Homebrew's thefuck
if [[ -f /usr/local/bin/thefuck ]]; then
	eval $(thefuck --alias)
fi

alias cp='cp -iv'
alias dqr='diff -qr --exclude=".git"'
alias dv='dirs -v'
alias l='ls -aFGhl'
alias lp='ls -aeFGhlO'
alias mv='mv -iv'
alias rm='rm -iv'
alias gp='git pull'
alias gs='git status'
alias vi='vim'
alias vim='vim -p'

# Global
alias -g G='|grep'				# See GREP_OPTIONS
alias -g L='|less'				# and LESS

# Suffix ("text.NAME" -> "VALUE text.NAME")
alias -s css=$EDITOR
alias -s html=$EDITOR
alias -s js=$EDITOR
alias -s log=$PAGER
alias -s md=$PAGER
alias -s php=$EDITOR
alias -s txt=$EDITOR

# If set, unset
unalias run-help 2>/dev/null
unalias which-command 2>/dev/null

##############
# COMPLETION #
##############

# Setup the ZSH function path
$fpath=()
if [[ "$(uname)" == "Darwin" ]]; then
	# Homebrew's zsh-completions
	$fpath=(/usr/local/share/zsh-completions)
	
	# Homebrew's zsh
	$fpath=($fpath /usr/local/share/zsh/site-functions /usr/local/Cellar/zsh/5.4.2_1/share/zsh/functions)
fi

#zstyle ':completion:*' completer _list _expand _complete _match _correct _approximate _prefix
#zstyle ':completion::expand:*' tag-order expansions
#zstyle ':completion:*:approximate:*' max-errors 2 numeric	# Allow up to 2 spelling mistakes
#zstyle ':completion:*:match:*' original true
#zstyle ':completion:*:cd:*' ignore-parents parent pwd		# Completion won't match parent (cd ../<TAB>)
zstyle ':completion:*' menu select=3						# Use arrow keys with menu, min results
zstyle ':completion:*' use-compctl false					# Never use old style completions
zstyle ':completion:*' group-name ''						# Separate completion types in the menu
zstyle ':completion:*:descriptions' format "%F{green}%d%f"	# Show the completion type in menu
#zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
#    'local-directories named-directories'					# Don't complete from cdpath
##zstyle ':completion:*' verbose true
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*:default' list-colors '=(#b)*(XX *)=32=31' '=*=32'
##zstyle ':completion:*' use-cache on
##zstyle ':completion:*' cache-path ~/.zsh/cache
#zstyle ':completion:*' squeeze-slashes true
#zstyle ':completion:*' file-sort modification

# Load completion
autoload -Uz compinit && compinit

# compinstall
#zstyle ':completion:*' completions 1
#zstyle ':completion:*' expand prefix suffix
#zstyle ':completion:*' glob 1
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' list-suffixes true
#zstyle ':completion:*' prompt '%e found.'
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle :compinstall filename '/Users/tuf83079/.zshrc'
# End compinstall

# Custom function to handle command history.
# This defangs "dangerous" commands by recording
# them in history prefixed with a comment (#).
#function zshaddhistory() {
#	if [[ $1 =~ "^ " ]]; then
		# This will respect HIST_IGNORE_SPACE.
#		return 0

#	elif [[ $1 =~ "cp\ *|mv\ *|rm\ *|cat\ *\>|pv\ *|dd\ *" ]]; then
#		1="# $1"
#	fi
	
	# Write to usual history location
#	print -sr -- ${1%%$'\n'}
	
	# Instruct the shell itself not to save the history (we just did).
#	return 1
#}

# Homebrew's zsh-autosuggestions
if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
	ZSH_AUTOSUGGEST_USE_ASYNC=true
else
	echo ""
	echo "Missing zsh-autosuggestions!"
	echo ""
fi

# Homebrew's zsh-git-prompt
if [[ -f /usr/local/opt/zsh-git-prompt/zshrc.sh ]]; then
	source /usr/local/opt/zsh-git-prompt/zshrc.sh
	#GIT_PROMPT_EXECUTABLE="haskell"				# Install instructions broken as of 2017-11-24l
	ZSH_THEME_GIT_PROMPT_PREFIX="%F{251}[%f"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%F{251}]%f"
	#ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
	#ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
	#ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
	#ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
	#ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
	#ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
	#ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
	#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
	#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
else
	echo ""
	echo "Missing zsh-git-prompt!"
	echo ""
fi

# Homebrew's zsh-syntax-highlighting
# Must be at the end of zshrc
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
	echo ""
	echo "Missing zsh-syntax-highlighting!"
	echo ""
fi

# EOF
