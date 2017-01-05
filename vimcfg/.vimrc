"
" VUNDLE
"

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
" ...
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()
filetype plugin indent on

" Add ~/.vim/ in windows too for cross-platform-ness
if has('win32')
    let &runtimepath='~/.vim/,' . &runtimepath
endif


"
" LOOK & FEEL
"

if has('gui_running')
    set guioptions-=T  " no toolbar
    set guioptions-=m  " no menu
    set guioptions-=r  " no scrollbars
    set guioptions-=L
    if has('gui_win32')
        set guifont=Hack:h10:cANSI:qDRAFT
"    else
"        set guifont=
    endif
endif

" Syntax and colors
syntax enable
set background=dark
"colorscheme solarized
"colorscheme mustang_by_hcalves
"colorscheme distinguished
colorscheme simple-dark
" Airline switches
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0

" No bell please!
set visualbell
" Incremental searches with ocurrences
set hlsearch
set showmatch
set incsearch
" Keep context around cursor
set scrolloff=3
" Show mode & command
set showmode
set showcmd
" Line numbers
set cursorline
set ruler
set relativenumber
" Fast scrolling
set ttyfast
" Display status line
set laststatus=2
" Other
set colorcolumn=90
set splitbelow


"
" KEY MAPPINGS
"

" Map <leader> to comma
let mapleader = ","

" Unmap arrow keys
no <down> <Nop>
no <left> <Nop>
no <right> <Nop>
no <up> <Nop>
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>

" Easily clear highlights after search
nnoremap <leader><space> :noh<cr>

" Use tab to move to matching brackets
nnoremap <tab> %
vnoremap <tab> %

" Quickly open .vimrc
nnoremap <leader>rc <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Split navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Quickly save
inoremap <leader>s <Esc>:update<Cr>
nnoremap <leader>s :update<Cr>

" Split windows easily
nnoremap <leader>sh  :topleft  vnew<CR>
nnoremap <leader>sj  :botright new<CR>
nnoremap <leader>sk  :topleft  new<CR>
nnoremap <leader>sl  :botright vnew<CR>

" Resize current split
nnoremap <C-S-Left> <C-W><
nnoremap <C-S-Down> <C-W>-
nnoremap <C-S-Up> <C-W>+
nnoremap <C-S-Right> <C-W>>


"
" EDITING
"

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
" Better backspace
set backspace=indent,eol,start
" Wrapping
set wrap
set textwidth=0
set wrapmargin=0
" Formatting options (as autocmd so it overrides filetypes)
au FileType * set fo+=q fo+=r fo+=n


"
" MISC
"

set encoding=utf-8
" Hide buffers instead of closing them
set hidden
" Command completions
set wildmenu
set wildmode=list:longest,full
" Undo file
set undofile
" Perl/Python compatible regex formatting
nnoremap / /\v
vnoremap / /\v
" Smart case sensitivity in searches
set ignorecase
set smartcase
" Apply substitutions globally on lines
set gdefault
" Auto-save on loss of focus
au FocusLost * :wa

" Auto-reload vimrc upon saving
augroup vimrc     " Source vim configuration upon save
  autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
  autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
augroup END

