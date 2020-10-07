" Remove buffers menun
let no_buffers_menu=1

" Set colorscheme
silent! colorscheme molokai

" Colorscheme config
let g:CSApprox_loaded = 1

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '|'
let g:indentLine_faster = 1

" Status bar
set laststatus=2

" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
