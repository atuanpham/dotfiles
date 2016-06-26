" Powerline configs

set rtp+=/home/atuanpham/anaconda2/lib/python2.7/site-packages/powerline/bindings/vim
set expandtab
set tabstop=4
set softtabstop=4
set autoindent
set shiftwidth=4
set number
set cursorline

" Clear last search highlighting
map <Space> :noh<cr>

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

syntax enable
filetype plugin indent on

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
Plug 'rking/ag.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'


call plug#end()

" -------------------------
" -------- Configs --------
" -------------------------

" --- solarized personal conf ---
set background=dark
colorscheme solarized

set colorcolumn=81
highlight ColorColumn ctermbg=magenta guibg=Magent
call matchadd('ColorColumn', '\%81v', 100)

" --- Unite configs ---
let g:unite_source_history_yank_enable = 1
try
    let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
nnoremap <space>f :split<cr> :<C-u>Unite file<cr>
nnoremap <space>g :split<cr> :<C-u>Unite -start-insert file_rec/git<cr>
" make a grep on all files!
nnoremap <space>/ :split<cr> :<C-u>Unite grep:.<cr>
" see the yank history
nnoremap <space>y :split<cr>:<C-u>Unite history/yank<cr>
" reset not it is <C-l> normally
:nnoremap <space>r <Plug>(unite_restart)

" --- AG configs ---
" type & to search the word in all files in the current dir
nmap & :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Ag 
