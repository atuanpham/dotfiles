" ==============================================================================
" PLUGINS
" ==============================================================================

call plug#begin('~/.vim/bundle')

" Aligning text
Plug 'godlygeek/tabular'

" Run git command when using vim
Plug 'tpope/vim-fugitive'

" Use AG for searching
Plug 'rking/ag.vim'

" Search for selected text in file
Plug 'nelstrom/vim-visual-star-search'

" Extend repeating feature of VIM
Plug 'tpope/vim-repeat'

" Color schemes
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Automatically insert brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

call plug#end()


" ==============================================================================
" GENERAL CONFIGS
" ==============================================================================

set nocompatible

set encoding=utf-8

set t_Co=256

" Customize invisible characters and show invisible chars
set list listchars=tab:»·,trail:·,nbsp:·

" Set avoid splitting word across two line
set linebreak

" Display line number
set number

" Width of a line
set textwidth=80
set colorcolumn=+1

" Set width of tab and expand tabs into space
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

if has("autocmd")
    " Enable filetype detection
    filetype on

    " Makefiles require indentation with tabs
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab

    " Another customizations
    autocmd BufNewFile,BufRead *.html, *.css, *.js setlocal ts=2 sts=2 sw=2 expandtab

    " Source vimrc file after saving it
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Enable highlighting
set hls

" Do case-insensitive matching
set ignorecase

" Access system clipboard
set clipboard=unnamed
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" Backspace deletes like most programs in insert mode
set backspace=2

" Not create backup file
set nobackup
set nowritebackup
set noswapfile

set history=50

" show cursor position
set ruler

" Display status line

" Display status line
set laststatus=2

" Highlight current line
set cursorline

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" ==============================================================================
" SHORTCUTS
" ==============================================================================

" Change mapleader
let mapleader = ","

" Shortcut to toggle `set list!`
nmap <leader>l :set list!<CR>

" Toggle paste mode
set pastetoggle=<F2>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Moving between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Keys for working with tabs
map <C-1> 1gt
map <C-2> 2gt
map <C-3> 3gt
map <C-4> 4gt
map <C-5> 5gt
map <C-6> 6gt
map <C-7> 7gt
map <C-8> 8gt
map <C-9> 9gt
map <C-0> :tablast<CR>

" Make it as easy as possible to open vimrc file
nmap <leader>v :tabedit $MYVIMRC<CR>

" Bubble single line
nmap <C-Up> ddkP
nmap <C-Down> ddp

" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Aligning
if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" Clear highlighting
nnoremap <CR> :noh<CR>


" ==============================================================================
" PLUGIN CONFIGS
" ==============================================================================

" Color scheme settings
set background=dark
colorscheme PaperColor

" Airline configs
" Install Powerline fonts at:
"       https://github.com/powerline/fonts
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='PaperColor'
let g:airline_powerline_fonts = 1

" Construct mapping for repeating
nnoremap <silent> <Plug>TransposeCharacters xp
	\:call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters

