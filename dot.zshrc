# srg's ~/.zshrc
# Run for interactive shells

############
# ENV VARS #
############
# Env vars must be first because commands below use them

export EDITOR="vim -e"							# Ex-mode
export GPG_TTY=$(tty)							# For gpg-agent
export LESS='--ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS'
export LESSHISTFILE=/dev/null
export LESSSECURE=1
export PAGER=less
export VISUAL=vim

###########
# ALIASES #
###########
# Note: Aliases stack (see 'vi' and 'vim')

# MacOS aliases
if [[ "$(uname)" == "Darwin" ]]; then
	alias b='brew'
	alias l='ls -aFGhl'
	alias lp='ls -aeFGhlO'
fi

# Homebrew's thefuck
if [[ -f /usr/local/bin/thefuck ]]; then
	eval $(/usr/local/bin/thefuck --alias)
fi

# All-OS aliases
alias cp='cp -iv'
alias dqr='diff -qr --exclude=".git"'
alias dv='dirs -v'
alias gp='git pull'								# Note: Aliasing g to git breaks tab completion
alias gs='git status'
alias le='less'
alias lphp='find . -type f -name "*.php" -exec php -l {} \; | grep -v "No syntax errors detected in"'
alias mv='mv -iv'
alias phpl='lphp'								# I always forget if it's phpl or lphp
alias rm='rm -iv'
alias vi='vim'
alias vim='vim -p'

# wp-cli
if [[ -x /usr/local/bin/wp ]]; then
	alias wps='/usr/local/bin/wp --skip-plugins --skip-themes'
fi

# Global aliases
alias -g G='|grep'
alias -g L='|less'

# Suffix aliases ("text.NAME" -> "VALUE text.NAME")
alias -s css=$EDITOR
alias -s html=$EDITOR
alias -s js=$EDITOR
alias -s log=$PAGER
alias -s php=$EDITOR
alias -s txt=$EDITOR

# If set, unset
unalias run-help 2>/dev/null
unalias which-command 2>/dev/null

#############
# FUNCTIONS #
#############

# Search path for function definitions
$fpath=()										# Don't look anywhere unless told
if [[ "$(uname)" == "Darwin" ]]; then
	# Homebrew's zsh
	$fpath=(/usr/local/opt/zsh/share/zsh/functions)

	# Homebrew's zsh-completions
	$fpath=(/usr/local/share/zsh-completions $fpath)

	# Completions provided by additional homebrew packages
	$fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

# Functions to autoload from $fpath
autoload -Uz compinit							# The new completion system
autoload -Uz down-line-or-beginning-search		# Contrib; Match history down based on prefix
autoload -Uz up-line-or-beginning-search		# Contrib; Match history up based on prefix
autoload -Uz vcs_info							# Contrib; version control info

# Custom handling of unknown commands
function command_not_found_handler {
	printf "\t\t¯\_(ツ)_/¯\n"
	exit 127
}

# Function that sets the right prompt based on the current zle vi mode
# and the git status/branch. This is called from my-zle-line-init()
# and my-zle-keymap-select().
function indicate-my-zle-mode {
	RPS1='${vcs_info_msg_0_} '					# zsh's vcs_info

	RPS1+='%F{251}['

	# Print the vi mode that zle is in
	if [[ $KEYMAP == "main" ]]; then			# "main" is insert mode
		RPS1+='%F{040}INS'
	elif [[ $KEYMAP == "vicmd" ]]; then
		RPS1+='%K{088}%F{227}%BCMD%b%k'
	elif [[ $KEYMAP == "viopp" ]]; then
		RPS1+='%K{088}%F{227}%BOPP%b%k'
	elif [[ $KEYMAP == "visual" ]]; then
		RPS1+='%K{088}%F{227}%BVIS%b%k'
	else
		RPS1+="%K{088}%F{227}%BERR/$KEYMAP%b%k"
	fi

	RPS1+='%F{251}]%f'

	zle reset-prompt							# Redraw the prompts
}

# Function that sets the zle mode and preserves the exit status of
# the previous command.
function my-zle-keymap-select {
	# Set RPS1
	indicate-my-zle-mode

	# Anonymous function, executed immediately; returns the last
	# program's exit code for use in in $PS1
	function {
		return $__prompt_status
	}
}

# Since $? is used in PS1, the exit status of the last executed
# command is preserved in to a global variable
function my-zle-line-init {
	# Set RPS1
	indicate-my-zle-mode

	typeset -g __prompt_status="$?"
}

# Wrapper to commit to https://github.com/srguglielmo/NetHackHistory
function nethack {
	if [[ "$(uname)" == "Darwin" ]]; then
		typeset nh_libexec_path="/usr/local/Cellar/nethack/3.6.0/libexec"
		typeset nh_curgame="$nh_libexec_path/currentgame"
		typeset asciinema="/usr/local/bin/asciinema"
	else
		echo "ERROR: Unknown OS"
		return 1
	fi
	
	git -C $nh_libexec_path pull --quiet
		
	if [[ -x $asciinema ]]; then
		# In order to save a full game to a single asciinema file, even if played over
		# several sessions, a manual game counter is read/written to $nh_curgame.
		# The asciicast will be appended to the same file until $nh_curgame is incremented (when the game ends).
		# This is hacky.

		if [[ -f $nh_curgame && -r $nh_curgame && -w $nh_curgame ]]; then
			typeset currentgame=$(<$nh_curgame)

			# NOTE: asciinema 1.x does not currently support appending the file!
			# Version 2.x, once released, will support --append.
			# Run it anyway for testing (see .gitignore).
			$asciinema rec --command=nethack --title="NetHack Game $currentgame" $nh_libexec_path/asciicasts/Game$currentgame.cast

			# After the session ends, prompt to increment $nh_curgame
			echo "Did your NetHack game just end (death, quit, etc)?"
			typeset newgame REPLY
			select newgame in No Yes; do
				case "$newgame" in
					"Yes")
						echo "Incrementing $nh_curgame"
						currentgame=$((currentgame + 1))
						echo "$currentgame" >! $nh_curgame
						break
						;;
					"No")
						echo "Not incrementing $nh_curgame"
						break
						;;
					*)
						echo "Something went wrong..."
						return 1
				esac
			done
		else
			echo "ERROR: Missing/unreadable/unwritable $nh_curgame"
			return 1
		fi
	else
		echo "Warning: asciinema not found. Game will not be recorded. Press ctrl+c to quit now."
		for ((typeset i=0; i<7; i++)); do
			sleep 1
			echo -n "."
		done

		nethack
	fi

	git -C $nh_libexec_path commit --all --message='Autocommit'
	
	# Don't push to GitHub automatically in case the commit message is --append'ed,
	# but cd into $nh_libexec_path so it can be pushed manually if desired.
	cd $nh_libexec_path
}

# Gather the git info just before each prompt
function precmd {
	vcs_info
}

# Custom function to handle command history.
# This defangs "dangerous" commands by recording
# them in history prefixed with a comment (#).
#function zshaddhistory() {
#	if [[ $1 =~ "^ " ]]; then
#		# This will respect HIST_IGNORE_SPACE
#		return 0
#	elif [[ $1 =~ "cp\ *|mv\ *|rm\ *|cat\ *\>|pv\ *|dd\ *" ]]; then
#		1="# $1"
#	fi
#
#	# Write to usual history location
#	print -sr -- ${1%%$'\n'}
#
#	# Instruct the shell itself not to save the history (again)
#	return 1
#}

################
# KEY BINDINGS #
################

bindkey -v										# Vi style in zle
#bindkey '^i' complete-word						# Required for _expand
#bindkey '^ ' autosuggest-accept				# ctrl+space to accept the autosuggestion

# Bind arrow up/down to the contrib functions to match history based
# on the current line prefix (autoloaded above).
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

###########
# MODULES #
###########

# Search path for zmodload
module_path=()
if [[ "$(uname)" == "Darwin" ]]; then
	module_path=(/usr/local/opt/zsh/lib)
fi

# Provides extensions to completion listings:
# Ability to highlight matches, ability to scoll, and different styles
zmodload zsh/complist

# Provides `strftime` builtin and a few read-only time-related variables
zmodload zsh/datetime

# Useful in recovery/emergency situations
#zmodload zsh/files

# Provide the -pcre-match comparison operator
zmodload zsh/pcre

# Scheduled commands
#zmodload zsh/sched

# Provides `zstat` (but don't override `stat` too)
zmodload -F zsh/stat b:zstat

# Create TCP connections with `ztcp`
# and FTP connections with `zftp`
#zmodload zsh/net/tcp
#zmodload zsh/zftp

# Zsh Line Editor (zle)
zmodload zsh/zle
zmodload zsh/zleparameter

# Provides `zstyle` and few other builtins
zmodload zsh/zutil

###########
# OPTIONS #
###########

# Directory
setopt AUTO_CD									# Change dir even if I forget to type `cd`
setopt AUTO_PUSHD								# Add dirs to the directory stack automatically
setopt PUSHD_IGNORE_DUPS						# Ignore dupes in the directory stack
#setopt PUSHD_MINUS								# Swap the meaning of + and -

# Completion
setopt ALWAYS_TO_END							# Move cursor to end, even when completing in a word
setopt BASH_AUTO_LIST							# Show completion menu on 2nd tab
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD							# Must be set for the _prefix completer
setopt GLOB_COMPLETE							# Use a completion menu for glob pattern matching
#setopt LIST_PACKED								# Pack more info in the completion list
setopt LIST_ROWS_FIRST							# Left to right, not up to down
#setopt REC_EXACT								# Accept exact command match if it exists

# Expansion/Globbing
unsetopt CASE_GLOB								# Make globbing case-insensitive
setopt MARK_DIRS								# Append / to dirs resulting from globbing
setopt NUMERIC_GLOB_SORT						# Sort numeric filenames numerically
#setopt RC_EXPAND_PARAM							# Expand arrays
setopt REMATCH_PCRE								# =~ uses zsh/pcre (else uses the sytem ereg libraries)
#unsetopt UNSET									# zsh-syntax-highlighting complains with this unset
setopt WARN_CREATE_GLOBAL
#setopt WARN_NESTED_VAR							# vcs_info complains with this set

# History
setopt HIST_FCNTL_LOCK							# Lock the history file when writing
setopt HIST_IGNORE_ALL_DUPS						# Remove dupes when writing
setopt HIST_IGNORE_SPACE						# Ignore commands with spaces prepended
setopt HIST_LEX_WORDS							# Be accurate when reading in a history file
setopt HIST_NO_FUNCTIONS						# Don't record functions definitions
setopt HIST_NO_STORE							# Department of Redundancy Department
setopt HIST_REDUCE_BLANKS						# Dont record blank commands
setopt HIST_SAVE_NO_DUPS						# Don't save any dupes when writing file
setopt HIST_VERIFY								# Probably a good idea
setopt INC_APPEND_HISTORY						# Append to history immediately (for multiple terms open at same time)
unsetopt SHARE_HISTORY							# Not even in ksh mode

# Input/Output
unsetopt CLOBBER								# Don't let > and >> clobber files (use >! or >>! instead)
#setopt CORRECT									# Spell correction on commands
#setopt CORRECT_ALL								# Spell correction on args
unsetopt FLOW_CONTROL							# Disable ctrl+s and ctrl+q
setopt INTERACTIVE_COMMENTS						# Allow comments on interactive sessions
setopt HASH_EXECUTABLES_ONLY					# Only "cache" the path to to exec files
#setopt PATH_DIRS								# Search $path even for commands with slashes
unsetopt PATH_SCRIPT							# Don't search in path for a passed script argument
unsetopt RM_STAR_SILENT							# Not even in ksh/sh emulation mode
setopt RM_STAR_WAIT								# Pause 10 sec after a rm wildcard

# Job control
setopt LONG_LIST_JOBS							# Long listing by default

# Prompt
setopt PROMPT_SUBST								# Required for vcs_info in prompt
#setopt TRANSIENT_RPROMPT

# Scripts/functions
setopt C_BASES									# Use 0xFF for hex numbers instead of 16#FF
setopt LOCAL_LOOPS								# Use break/continue strictly
unsetopt MULTI_FUNC_DEF							# Don't allow func definitions with multiple names
#unsetopt MULTIOS								# Don't automatically add extra tees and pipes
setopt PIPE_FAIL								# Return the exit status of the rightmost non-zero
#setopt SOURCE_TRACE							# Display names of files as they're sourced
#setopt XTRACE									# Print commands and args as they are executed

# ZLE
#setopt COMBINING_CHARS							# Enabled in /etc/zshrc on MacOS
unsetopt SINGLE_LINE_ZLE						# Not even in KSH emulation mode

##########
# STYLES #
##########

# Completion
zstyle ':completion:*' file-sort modification	# Sort completions by last modification time
zstyle ':completion:*' group-name ''			# Separate completion types in the menu
zstyle ':completion:*' list-colors ''			# Color listings (req group-name='')
zstyle ':completion:*' menu select=2			# Use arrow keys with menu, min results
zstyle ':completion:*' use-compctl false		# Never use old style completions
zstyle ':completion:*' verbose true

zstyle ':completion:*:descriptions' format "%F{green}%d%f"

#zstyle ':completion:*' completer _list _expand _complete _match _correct _approximate _prefix
#zstyle ':completion::expand:*' tag-order expansions
#zstyle ':completion:*:approximate:*' max-errors 2 numeric
#zstyle ':completion:*:match:*' original true
#zstyle ':completion:*:cd:*' ignore-parents parent pwd
#zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
#    'local-directories named-directories'	# Don't complete from cdpath
#zstyle ':completion:*:default' list-colors '=(#b)*(XX *)=32=31' '=*=32'
##zstyle ':completion:*' use-cache on
##zstyle ':completion:*' cache-path ~/.zsh/cache
#zstyle ':completion:*' squeeze-slashes true

# compinstall setup
#zstyle ':completion:*' completions 1
#zstyle ':completion:*' expand prefix suffix
#zstyle ':completion:*' glob 1
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' list-suffixes true
#zstyle ':completion:*' prompt '%e found.'
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle :compinstall filename '/Users/tuf83079/.zshrc'
# End compinstall

# Git info
zstyle ':vcs_info:*' actionformats '%F{251}[%F{227}%K{088}%b/%a%k%F{251}]%f'
zstyle ':vcs_info:*' branchformat '%b'			# %b
zstyle ':vcs_info:*' check-for-changes true		# Enable use of %c and %u
zstyle ':vcs_info:*' enable git					# Only use git (not svn, etc)
zstyle ':vcs_info:*' formats '%F{251}[%F{040}%c%u%b%F{251}]%f'
zstyle ':vcs_info:*' stagedstr '%F{057}Stg '	# %c
zstyle ':vcs_info:*' unstagedstr '%F{172}Unstg ' # %u

#############
# VARIABLES #
#############
# Lowercase variables are arrays

# ZSH vars
cdpath=(. ~/Code ~/Code/GitHub)					# PATH, but for cd
#CORRECT_IGNORE=								# Ignore pattern for spell correction
#CORRECT_IGNORE_FILE=							# Ignore pattern for spell correction on filenames (See CORRECT_ALL)
DIRSTACKSIZE=10									# Directory history size
#fignore=()										# File suffixes to ignore during completion
HISTFILE=~/.zhistory
#HISTORY_IGNORE									# Ignore pattern for history entries
HISTSIZE=10000
#KEYTIMEOUT=									# In hundredths of a second
LANG=en_US.UTF-8
path=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin)

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

#REPORTMEMORY=200								# Min size in MB to report; Doesn't work right in MacOS
REPORTTIME=8									# Min seconds to report
RPS1=""											# Must be empty to display the zle KEYMAP in RPS1 in the very first prompt
SAVEHIST=10000
#SPROMPT=										# Prompt used for spell correction
TIMEFMT='[%*E] [%U CPUusr] [%S CPUsys] [%MMiB Max]'
TMPPREFIX=/tmp/zsh
watch=(notme)

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

##################
# INITIALIZATION #
##################

# Execute the completion function (which was autoloaded above)
compinit

# Load homebrew's zsh-autosuggestions
if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	#ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
	#ZSH_AUTOSUGGEST_USE_ASYNC=true
else
	echo "WARNING: Missing zsh-autosuggestions!"
fi

# Load homebrew's zsh-syntax-highlighting (must be last)
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	# Array of highlighters to enable
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)
	typeset -A ZSH_HIGHLIGHT_STYLES

	# Comments default to black, which are invisible on a black terminal
	ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'

	# Bracket styles
	ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=white,bold,bg=red'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='bg=blue'

	ZSH_HIGHLIGHT_PATTERNS+=('rm -r' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -f' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -fr' 'fg=white,bold,bg=red')

	ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

	ZSH_HIGHLIGHT_STYLES[root]='bg=red'
else
	echo "WARNING: Missing zsh-syntax-highlighting!"
fi

# EOF
