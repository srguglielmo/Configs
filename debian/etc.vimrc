" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching

" General
set viminfo="NONE"	" We don't want no .viminfo
set cmdheight=2
set number			" Show line numbers
set linebreak		" Break lines at word (requires Wrap lines)
set showbreak=+++	" Wrap-broken line prefix
set spell			" Enable spell-checking
set spelllang=en	" US English
set errorbells		" Beep or flash screen on errors
set visualbell		" Use visual bell (no beeping)
set hlsearch		" Highlight all search results
set ruler		" Show row and column ruler information
set undolevels=500	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour
set scrolloff=10

" Tabs
set autoindent		" Auto-indent new lines
set smartindent		" Enable smart-indent
set smarttab		" Use shiftwidth for inserting tabs
set tabstop=4		" Number of spaces per tab
set shiftwidth=4	" Something to do with tabs
set noexpandtab		" Don't use spaces!
set softtabstop=0	" Disable this
