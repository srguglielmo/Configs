"
" srg's vimrc
"

" Behavior
set backspace=indent,eol,start	" Backspace over autoindents, lines, and start of insert mode
set nocompatible
set encoding=utf-8
set history=500
set secure						" Disable autocmd/write in .vimrc and .exrc
set shortmess=					" Don't abbrevate anything
set errorbells					" Beep or flash screen on errors
set ignorecase					" Ignore case in search patterns
set nomodeline					" Don't process modelines
set smartcase					" If search has upper case, ignore ignorecase
set nospell						" Spell-checking
set spelllang=en_us
set visualbell					" Flash screen (no beeping)
set writebackup					" Always make a backup while writing
set hidden						" Allow switching away from changed buffers without writing


" Use a dedicated swap dir
set directory=~/.vim/swapdir//

" And backup dir
set writebackup					" Make a backup before overwriting a file
set backup						" And keep it around
set backupcopy=yes				" Make backups by copying original
set backupdir=~/.vim/backupdir/


" Persistent undo
set undolevels=500
set undodir=~/.vim/undodir/
set undofile

set autoread					" If the file was modified before editing, reload it

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_skip_empty_sections = 1	" Small performance penalty
"let g:airline_extensions = []			" Only enable these extensions
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#branch#vcs_priority = ["git"]
"set ttimeoutlen=20

" Display
set wildmenu					" Wildcard menu
set wildignore=*/.git/*,*/.svn/*,*/.DS_Store
set background=dark				" Terminal background color for syntax colors
set foldcolumn=1
set hlsearch					" Highlight all search results
set cmdheight=1
set laststatus=2				" Always show status line
" set statusline=%t				" Tail of the filename
" set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
" set statusline+=%{&ff}]			" File format
" set statusline+=%h				" Help file flag
" set statusline+=%m				" Modified flag
" set statusline+=%r				" Read only flag
" set statusline+=%y				" Filetype
" set statusline+=%=				" Left/right separator
" set statusline+=%c,				" Cursor column
" set statusline+=%l/%L			" Cursor line/total lines
" set statusline+=\ %P			" Percent through file
set mouse=						" Don't use the mouse
set linebreak					" Break lines at words
set list						" Show invisibles
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
set number						" Show line numbers
set ruler						" Show row and column ruler information
set scrolloff=5					" Number of lines of context above/below cursor
set showcmd						" Show incomplete/pending commands
set formatoptions+=j			" Delete comment character when joining commented lines
set noincsearch					" Never show search results incrementally
set showbreak=++				" Wrap-broken line prefix
set showmatch					" Highlight matching brace
set matchtime=10				" Tenths of a second to show matching brace
set showtabline=2				" Always show the tab bar

" netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0			" Don't show the top banner
let g:netrw_browse_split = 3	" Open files in a new tab
let g:netrw_winsize = 20		" Percent width of window

" Enable syntax highlighting
syntax enable
colorscheme deus
set hlsearch

" Syntastic, automatic syntax checking
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_php_checkers = ['php', 'phplint', 'phpmd']
"let g:syntastic_php_phpcs_args = ""
let g:syntastic_sh_checkers = ['checkbashisms', 'sh', 'shellcheck']

set signcolumn=yes				" Always show sign column

filetype on						" Try to recognize the file type (and set options)
filetype plugin on
filetype indent on

set fileformats=unix,dos,mac

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

autocmd filetype crontab setlocal nowritebackup noswapfile

" .md files are always Markdown, not Modula-2
"autocmd BufNewFile,BufReadPost *.md set filetype=markdown

