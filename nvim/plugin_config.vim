call plug#begin(expand('~/.config/nvim/plugged'))

" NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Colorscheme
Plug 'altercation/vim-colors-solarized'

" File type icons
Plug 'ryanoasis/vim-devicons'

" Generate pairs
Plug 'jiangmiao/auto-pairs'

" Text search
Plug 'rking/ag.vim'

" File finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'

" Github
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Intellisense
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

call plug#end()

" NerdTree config

let NERDTreeShowHidden=1

" Solarized config
colorscheme solarized

" Fzf config
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

" Coc config

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Set update time to avoid delays
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
