" ==============================================================================
" PLUGINS
" ==============================================================================

call plug#begin('~/.vim/bundle')

" Tree explorer
Plug 'scrooloose/nerdtree'

" Commenting
Plug 'tpope/vim-commentary'

" Displaying indent levels
Plug 'nathanaelkane/vim-indent-guides'

" Aligning text
Plug 'godlygeek/tabular'

" Run git command when using vim
Plug 'tpope/vim-fugitive'

" Use AG for searching
" NOTE: Have to install AG first: https://github.com/ggreer/the_silver_searcher
Plug 'rking/ag.vim'

" Search for selected text in file using * or #
Plug 'nelstrom/vim-visual-star-search'

" Extend repeating feature of VIM
Plug 'tpope/vim-repeat'

" Color schemes
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'notpratheek/vim-luna'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'chriskempson/base16-vim'

" Statusline
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

" Automatically insert brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" File navigation
Plug 'ctrlpvim/ctrlp.vim'

" Using <Tab> in VIM
" Plug 'ervandew/supertab'

" Closing html tags automatically
Plug 'alvan/vim-closetag'

" Code folding
Plug 'tmhedberg/SimpylFold'

" Code completion
" Plug 'davidhalter/jedi-vim'
Plug 'Valloric/YouCompleteMe'

" Structure overview
Plug 'majutsushi/tagbar'

" === Python section ===

" Python indentation
Plug 'Vimjas/vim-python-pep8-indent'

" === End Python section ===

" === Jinja section ===
Plug 'lepture/vim-jinja'
" === End Jinja secion ===

call plug#end()


" ==============================================================================
" GENERAL CONFIGS
" ==============================================================================

set nocompatible

set encoding=utf-8

set t_Co=256

" Customize invisible characters and show invisible chars
set listchars=tab:»·,trail:·,nbsp:·,space:·

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

filetype plugin indent on
syntax on

if has("autocmd")
    " Makefiles require indentation with tabs
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab

    " Another customizations
    " autocmd BufNewFile,BufRead *.html, *.css, *.js setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

    " Use with Jinja
    au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja ts=2 sts=2 sw=2 expandtab

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
set laststatus=2

" Highlight current line
set cursorline

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Allow to remove non-empty directory
let g:netrw_localrmdir='rm -r'

" Always loaded with opened folds
set foldmethod=indent
set foldlevel=20

" Gui font
set guifont=Menlo\ for\ Powerline:h11
set linespace=3


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
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt
map <leader>0 :tablast<CR>
map <leader>q :tabclose<CR>

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

" Toggle folding with <Space>
nnoremap <space> za

" Format JSON
map =j :%!python -m json.tool<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>

" YouCompleteMe
nmap <leader>g :YcmCompleter GoTo<CR>


" ==============================================================================
" PLUGIN CONFIGS
" ==============================================================================

" Color scheme settings
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_bold = 0
let g:gruvbox_italic = 1

" Airline configs
" NOTE: Install Powerline fonts at: https://github.com/powerline/fonts
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_tabs = 1
" let g:airline_theme='badwolf'
" let g:airline_powerline_fonts = 1

" Lightline configs
" Please copy gruvbox.vim to colorscheme of lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" Construct mapping for repeating
nnoremap <silent> <Plug>TransposeCharacters xp
    \:call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters

" Use AG for searching
if executable("ag")
    " Use Ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " CtrlP + Ag
    let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

    let g:ctrlp_use_caching = 0

    if !exists(":Ag")
        command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
        nnoremap \ :Ag<SPACE>
    endif
endif

" SympylFold configs
let g:SimpylFold_docstring_preview = 1

" Jedi configs
" Use tabs when going to definitions
" let g:jedi#use_tabs_not_buffers = 1

" YouCompleteMe configs
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 0
let g:ycm_python_binary_path = 'python' " Autocomplete regardless of virtualenv
let g:ycm_goto_buffer_command = 'new-or-existing-tab'

" Vim-Closetag plugin
" filenames like *.xml, *.html, *.xhtml, ...
" Then after you press <kbd>&gt;</kbd> in these files, this plugin will try to close the current tag.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non closing tags self closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" integer value [0|1]
" This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is '<leader>>'
"
let g:closetag_close_shortcut = '<leader>>'

" NERDTree configs
" - Open automatically when Vim starts up
autocmd vimenter * NERDTree
" - Open automatically when Vim starts up if no file were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" - Open automatically when Vim starts up on opening a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0]
            \ | wincmd p| ene | endif
" - Shortcut to open NERDTree (Ctrl + n)
map <C-n> :NERDTreeToggle<CR>
" - Closing Vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" VIM indent guides
"
let g:indent_guides_guide_size = 1
