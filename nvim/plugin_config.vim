call plug#begin('~/.config/nvim/plugged')

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

" Languages sintax highlight
Plug 'sheerun/vim-polyglot'

" Improve comments
Plug 'tpope/vim-commentary'

" Linting
Plug 'dense-analysis/ale'

" Code completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Dockerfile support
Plug 'ekalinin/Dockerfile.vim'

" Rails support
Plug 'tpope/vim-rails'

" Vue support
Plug 'posva/vim-vue'

call plug#end()

" NerdTree configuration
let NERDTreeShowHidden=1

" Solarized configuration
colorscheme solarized

" Fzf configuration
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

" Polyglot configuration
set nocompatible

" Ale configuration
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

" Deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
