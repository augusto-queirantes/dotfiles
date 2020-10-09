" Tabs config
set tabstop=2
set softtabstop=0
set shiftwidth=2

set expandtab
set smarttab

" Linebreak on 1000 characters
set lbr
set tw=1000

" Identation
set autoindent
set smartindent

" Show preview
set inccommand=split

" Enable syntax highlighting
syntax enable

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Vertical line on 120 character
set colorcolumn=120

" Remove trailing white spaces on save
autocmd BufWritePre * :%s/\s\+$//e
