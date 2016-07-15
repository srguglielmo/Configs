" Behavior
set backspace=indent,eol,start	" Backspace over autoindents, lines, and start of insert mode
set errorbells					" Beep or flash screen on errors
set ignorecase					" Ignore case in search patterns
set smartcase					" If search has upper case, ignore ignorecase
set spell						" Enable spell-checking
set spelllang=en_us				" Spell checking language
set undolevels=500				" Number of undo levels
set visualbell					" Use visual bell (no beeping)

" Display
set background=dark				" I'm using a dark terminal background, affects syntax
set hlsearch					" Highlight all search results
set linebreak					" Break lines at words
set list						" Show whitespace
set listchars=tab:»-,trail:·	" Use these marks for whitespace.
set number						" Show line numbers
set ruler						" Show row and column ruler information
set scrolloff=10				" Number of lines of context above/below cursor
set showbreak=++				" Wrap-broken line prefix
set showmatch					" Highlight matching brace
set wrap						" Word wrap
syntax on						" Syntax highlighting

" Tabs
set autoindent					" Auto-indent new lines
set noexpandtab					" Don't expand tabs into spaces
set shiftwidth=4				" Width of an indent in characters
set smartindent					" Enable smart-indent
set smarttab					" Enable smart-tabs
set softtabstop=4				" Number of spaces per tab; Same as tabstop
set tabstop=4					" Width of an actual tab character
