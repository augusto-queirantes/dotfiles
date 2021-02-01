" Set leader key
let mapleader = " "

" Copy
vnoremap <C-c> y: call system("xclip -i", getreg("\""))<CR>

" Cut
vmap <C-x> "+c

" Paste
imap <C-v> <C-r><C-o>+
vmap <C-v> p
nnoremap <C-v> p"

" Fast saving
nmap <C-s> :w!<cr>

" Disable highlight when <leader><cr> is pressed
map <silent> <Esc><Esc> :noh<cr>

" NEREDTree tree view shortcut
map <C-\> :NERDTreeFocus<cr>

" NERDTreeFind shortcut
map <leader>ff :NERDTreeFind<cr>

" Tabs in normal and visual mode
nnoremap <tab> >>
nnoremap <S-tab> <<

" Tabs in visual mode
xnoremap <tab> >gv
xnoremap <s-tab> <gv

" Split shortcuts
nnoremap <leader>vs :vsplit<cr>
nnoremap <leader>s :split<cr>

" File serach shortcut
nnoremap <C-f> /

" Indent all file
nnoremap === mxgg=G`x

" Ctrl-a
nnoremap <C-a> ggvG$

" Remap vim 0 to first non-blank character
map 0 ^

" Remap vim $ to last non-balnk character
map $ g_

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Remove directional key mappings
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Fzf shortcut
nnoremap <c-p> :Files<cr>

" When a typo happens
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Git
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>

" Buffer nav
noremap <leader>j :bp<CR>
noremap <leader>l :bn<CR>
noremap <leader>c :bd<CR>

" Vim commentary
map <C-space> gcc
