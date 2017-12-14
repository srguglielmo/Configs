" Behavior
set backspace=indent,eol,start	" Backspace over autoindents, lines, and start of insert mode
set encoding=utf-8
set errorbells					" Beep or flash screen on errors
set ignorecase					" Ignore case in search patterns
set nomodeline					" Don't process modelines
set smartcase					" If search has upper case, ignore ignorecase
set nospell						" Spell-checking
set spelllang=en_us
set undolevels=500
set visualbell					" Flash screen (no beeping)

" Display
set background=dark				" Terminal background color for syntax colors
set hlsearch					" Highlight all search results
set linebreak					" Break lines at words
set list						" Show invisibles
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
set number						" Show line numbers
set ruler						" Show row and column ruler information
set scrolloff=10				" Number of lines of context above/below cursor
set showbreak=++				" Wrap-broken line prefix
set showmatch					" Highlight matching brace
set showtabline=2				" Always show the tab bar
set wrap						" Word wrap
syntax on						" Syntax highlighting

" Tab Chars
set autoindent					" Auto-indent new lines
set noexpandtab					" Don't expand tabs into spaces
set shiftwidth=4				" Width of an indent in characters
set smartindent					" Auto-indent
set smarttab					" Auto-tab
set softtabstop=4				" Number of spaces per tab; Same as tabstop
set tabstop=4					" Width of an actual tab character

" Always start at the beginning of the file for commit messages
"autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd filetype crontab setlocal nobackup nowritebackup
