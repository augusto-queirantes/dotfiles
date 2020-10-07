" Set line numbers
set number

" Fix backspace indent
set backspace=indent,eol,start

" Tabs config
set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab

" Enable hidden buffers
set hidden

" Show highlights on search
set hlsearch

" Show search matches while typing
set incsearch

" Sets how many lines of history VIM has to remember
set history=1000

" Set to auto read when a file is changed from the outside
set autoread

" Set persistent undo
set undodir=~/.vim_runtime/temp_dirs/undodir
set undofile

" Set cursor position in the middle of the screen
set so=999

"Always show current cursor position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Enable filetype plugins
filetype plugin on
filetype indent on

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable mouse
set mouse=a

" Highlight current line
set cursorline
