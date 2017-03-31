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
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-dispatch'
Plugin 'Valloric/YouCompleteMe'
Plugin 'a.vim'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'OmniSharp/omnisharp-vim'

call vundle#end()
filetype plugin indent on

" Add ~/.vim/ in windows too for cross-platform-ness
if has('win32')
    let &runtimepath='~/.vim/,' . &runtimepath
"    set shellslash  " Not too sure about this..
endif

" Ctrl-P
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_match_window = 'order:ttb'
let g:ctrlp_show_hidden = 1
let g:ctrlp_by_filename = 1
let g:ctrlp_extensions = ['tag', 'buffertag']

if executable('rg')
    " Use ripgrep over grep
    set grepprg=rg\ --vimgrep\ --color=never

    " Use ripgrep for indexing files in CtrlP
"    let extglob = '{cs,cpp,h}'
"    let g:ctrlp_user_command = 'ripgrep %s --files --color=never -g "\**\*.'.extglob.'"'
    let g:ctrlp_user_command = 'rg -F %s --files --color=never -tcpp -tcs -tjava -tjson -tlua -tpy -txml
                                \ --type-add "xaml:*.{xaml,axml}" -txaml'
    let g:ctrlp_use_caching = 1    " We'll see..
endif

" UltiSnips
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" YouCompleteMe
" ctags needs to be run with '--fields=+l' for this to work
let g:ycm_collect_identifiers_from_tags_files = 1

" Recommended Syntastic settings for n00bs
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" OmniSharp
"let g:OmniSharp_timeout = 1
"set completeopt=longest,menuone,preview
"set splitbelow
"let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
""let g:OmniSharp_server_type = 'roslyn'
"
"augroup omnisharp_commands
"    autocmd!
"    " Set autocomplete function to OmniSharp (if not using YouCompleteMe plugin)
"    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
"    " Build asynchronously with vim-dispatch
"    autocmd FileType cs nnoremap <leader>b :wa!<CR>:OmniSharpBuildAsync<CR>
"    " Automatic syntax check
"    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
"    " Show type info when idle
"    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"    " Key bindings for some contextual commands
"    autocmd FileType cs nnoremap <leader>g  :OmniSharpGotoDefinition<CR>
"    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<CR>
"    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<CR>
"    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<CR>
"    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<CR>
"    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<CR>
"    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<CR>
"    autocmd FileType cs nnoremap <leader>xu :OmniSharpFixUsings<CR>
"    autocmd FileType cs nnoremap <leader>tl :OmniSharpTypeLookup<CR>
"    autocmd FileType cs nnoremap <leader>doc :OmniSharpDocumentation<CR>
"    " Navigate by method/property/field
"    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<CR>
"    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<CR>
"augroup END
"


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
colorscheme Mustang_by_hcalves
highlight ColorColumn guibg=Black   " Get rid of that red horror!
"colorscheme distinguished
"colorscheme simple-dark
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
nnoremap <C-S-H> <C-W><C-H>
nnoremap <C-S-J> <C-W><C-J>
nnoremap <C-S-K> <C-W><C-K>
nnoremap <C-S-L> <C-W><C-L>

" Quickly close window
nnoremap <leader>q <C-W>q

" Quickly save
inoremap <leader>s <Esc>:update<Cr>
nnoremap <leader>s :update<Cr>

" Split windows easily
nnoremap <leader>sh  :topleft  vnew<CR>
nnoremap <leader>sj  :botright new<CR>
nnoremap <leader>sk  :topleft  new<CR>
nnoremap <leader>sl  :botright vnew<CR>

" Resize current split
nnoremap <C-S-Left>     <C-W><
nnoremap <C-S-Down>     <C-W>-
nnoremap <C-S-Up>       <C-W>+
nnoremap <C-S-Right>    <C-W>>

" Move lines up/down
nnoremap ë ddkP
nnoremap ê ddp

" Move around quickly by whitespace
nnoremap H Bh
nnoremap J }
nnoremap K {
nnoremap L El

" Get rid of one keystroke for something soo common
nnoremap . :
nnoremap : .

" Quickly (destructively) join next line at cursor position
nnoremap <leader>j d$J

" Insert blank line (or break current one) without going to insert mode
nnoremap <CR> i<CR><Esc>

" Toggle NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>

" CtrlP in buffer mode
nnoremap <leader>b :CtrlPBuffer<CR>
inoremap <leader>b <Esc>:CtrlPBuffer<CR>

" CtrlP in tags mode
nnoremap <leader>t :CtrlPBufTag<CR>
inoremap <leader>t <Esc>:CtrlPBufTag<CR>

nnoremap <leader>tt :CtrlPTag<CR>
inoremap <leader>tt <Esc>:CtrlPTag<CR>

" Hide ^M line endings in mixed-mode files
nnoremap <leader>cr :match Ignore /\r$/<CR>
" Convert to DOS line endings
nnoremap <leader>dos :e ++ff=dos<CR>:w<CR>

" Format current paragraph or visual selection
vmap <leader>f gq
nmap <leader>f gqap

" Switch to .h/cpp
nnoremap <leader>o :A<CR>
nnoremap <leader>os :AV<CR>

" Jumping to tags
nnoremap <leader>gt <C-]>
nnoremap <leader>lt g]

" Terse YcmCompleter commands
nnoremap <leader>gi     :YcmCompleter GoToInclude<CR>
nnoremap <leader>gd     :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gdl    :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>g      :YcmCompleter GoTo<CR>
nnoremap <leader>gu     :YcmCompleter GoToReferences<CR>
nnoremap <leader>gim    :YcmCompleter GoToImplementation<CR>
nnoremap <leader>doc    :YcmCompleter GetDoc<CR>
nnoremap <leader>fx     :YcmCompleter FixIt<CR>
nnoremap <leader>re     :YcmCompleter RefactorRename 


"
" EDITING
"

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set copyindent
set shiftround
" Better backspace
set backspace=indent,eol,start
" Wrapping
set nowrap
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

" Folding method needed for OminSharp
"set foldmethod=syntax
" Ignore case when autocompleting
set wildignorecase

" Sane default tags location
set tags=./tags;

