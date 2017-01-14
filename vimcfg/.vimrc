"
" PLUGINS
"

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

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
    set guifont=Fira_Mono:h10:cANSI:qDRAFT
"    set guifont=Anonymous_Pro:h12:cANSI:qDRAFT
"    set guifont=Consolas:h10:cANSI:qDRAFT
"    set guifont=Droid_Sans_Mono_Dotted:h10:cANSI:qDRAFT
"    set guifont=Hack:h10:cANSI:qDRAFT
"    set guifont=Inconsolata:h10:cANSI:qDRAFT
"    set guifont=Liberation_Mono:h10:cANSI:qDRAFT
"    set guifont=Source_Code_Pro:h10:cANSI:qDRAFT
"    set guifont=Roboto\ Mono:h10:cANSI:qDRAFT "Not working!
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

" Split navigation (these probably don't work in a terminal?)
nnoremap è <C-W><C-H>
nnoremap ê <C-W><C-J>
nnoremap ë <C-W><C-K>
nnoremap ì <C-W><C-L>

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

" Get rid of one keystroke for something soo common
nnoremap . :
nnoremap : .

" Quickly join next line at cursor position
nnoremap <leader>j d$J

" Move lines up/down
nnoremap K ddkP
nnoremap J ddp

" Insert blank line (or break current one) without going to insert mode
nnoremap <CR> i<CR><Esc>


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

