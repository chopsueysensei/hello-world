"
" PLUGINS
"

set encoding=utf-8

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-dispatch'
Plugin 'ervandew/supertab'
Plugin 'a.vim'
Plugin 'tpope/vim-surround'
"Plugin 'jsfaint/gen_tags.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'OmniSharp/omnisharp-vim'

call vundle#end()

filetype on
filetype plugin on
filetype indent on

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
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix']
let g:ctrlp_max_files = 0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

if executable('rg')
    " Use ripgrep over grep
    set grepprg=rg\ --vimgrep\ --no-heading " --color=never
    set grepformat=%f:%l:%c:%m,%f:%l:%m

    " Use ripgrep for indexing files in CtrlP
"    let extglob = '{cs,cpp,h}'
"    let g:ctrlp_user_command = 'ripgrep %s --files --color=never -g "\**\*.'.extglob.'"'
    let g:ctrlp_user_command = 'rg -F %s --files --color=never -tcpp -tcs -tjava -tjson -tlua -tpy -txml
                                \ --type-add "xaml:*.{xaml,axml}" -txaml --type-add "bat:*.bat" -tbat'
    let g:ctrlp_use_caching = 0    " We'll see..
endif

if executable('global') || executable('global.exe')
    let g:ctrlp_buftag_ctags_bin = 'global -c'
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
let g:ycm_show_diagnostics_ui = 0

" gen_tags
let g:gen_tags#verbose = 1
let g:gen_tags#project_root = 'C:\dev\repo\nova_phd_trunk'

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

" Quickly open .vimrc
nnoremap <leader>rc :e $MYVIMRC<cr>

" Quickly close window
nnoremap <leader>c <C-W>c

" Quickly save
inoremap <leader>w <Esc>:update<Cr>
nnoremap <leader>w :update<Cr>

" Split windows easily
nnoremap <leader>sh  :topleft  vnew<CR>
nnoremap <leader>sj  :botright new<CR>
nnoremap <leader>sk  :topleft  new<CR>
nnoremap <leader>sl  :botright vnew<CR>

" Resize current split (Ctrl and Ctrl-Shift seem to send the same keystroke!)
nnoremap <C-S-Left>     <C-W><
nnoremap <C-S-Down>     <C-W>-
nnoremap <C-S-Up>       <C-W>+
nnoremap <C-S-Right>    <C-W>>

" Split navigation
nnoremap <leader>h <C-W><C-H>
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>

" Move lines up/down
nnoremap ë ddkP
nnoremap ê ddp

" Move around quickly by whitespace
nnoremap H Bh
nnoremap J }
nnoremap K {
nnoremap L El

vnoremap H Bh
vnoremap J }
vnoremap K {
vnoremap L El

" Move by half a page 
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>

vnoremap <C-j> <C-d>
vnoremap <C-k> <C-u>

" Get rid of one keystroke for something soo common
nnoremap . :
nnoremap : .

" Join next line (at the end of current one)
nnoremap <leader>J J

" Insert blank line (or break current one) without going to insert mode
"nnoremap <CR> i<CR><Esc>
" Delete in insert mode without using extended keys or chords
inoremap <C-BS> <C-W>
inoremap <S-BS> <Del>
inoremap <C-S-BS> <Esc>ldwi

" Search more quickly!
nnoremap <Space> /
" Highlight occurences without moving the cursor
nnoremap <leader>* :let @/='\<'.expand("<cword>").'\>'<bar>set hls<cr>

" Toggle NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>

" CtrlP in mixed mode
nnoremap <leader>p :CtrlPMixed<CR>
" CtrlP in quickfix mode (close quickfix window if open!)
nnoremap <leader>qf :QfCP<CR>
" CtrlP in buffer mode
nnoremap <leader>b :CtrlPBuffer<CR>

" Switch to previous buffer
nnoremap <leader>bb :b#<CR>

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

" Generate GTAGS (via gen_tags)
nnoremap <leader>gen :GenGTAGS<CR>

" Gtags
nnoremap <leader>ts :Gtags<space>
nnoremap <leader>tf :Gtags -f %<CR>:QfCP<CR>
nnoremap <F12>      :Gtags<CR><CR>:QfCP<CR>
nnoremap <S-F12>    :Gtags -r<CR><CR>:QfCP<CR>

" CtrlP in tags mode (this would need a ctags compatible command from GNU Global!)
nnoremap <leader>tt :CtrlPTag<CR>

" cscope (gtags-cscope via gen_tags) (not working in windows!)
" nmap <leader>tu :scs find c <C-R>=expand('<cword>')<CR><CR>
" nmap <leader>te :scs find e <C-R>=expand('<cword>')<CR><CR>
" nmap <leader>tf :scs find f <C-R>=expand("<cfile>")<CR><CR>
" nmap <leader>td :scs find g <C-R>=expand('<cword>')<CR><CR>
" nmap <leader>ti :scs find i <C-R>=expand('<cfile>')<CR><CR>
" nmap <leader>ts :scs find s <C-R>=expand('<cword>')<CR><CR>
" nmap <leader>tx :scs find t <C-R>=expand('<cword>')<CR><CR>

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

" Perl/Python compatible regex formatting
nnoremap / /\v
vnoremap / /\v

" Silent make
nnoremap <leader>m :wa<CR>:silent make<CR>:vert botright cw 90<CR>:cc<CR>

" Easily replace current word
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Easily replace last searched term (from current line on)
nnoremap <leader>rs :.,$s///gc<Left><Left><Left>
" Other quick common replacements (from current line on)
nnoremap <leader>r- :.,$s/->/\./gc<CR>
nnoremap <leader>r. :.,$s/\./->/gc<CR>

" Naive auto-completion / snippets
inoremap {<CR> {<CR>}<Esc>O
inoremap ,t<CR> // TODO 

" Swap splits
nnoremap <leader>wx <C-w>x


"
" LOOK & FEEL
"
syntax enable
set background=dark

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

    " Colorschemes
    colorscheme retro-minimal
    "colorscheme mustang_sensei_edit
    "colorscheme solarized
    "colorscheme distinguished
    "colorscheme simple-dark
endif

" Airline switches
"let g:airline_theme='powerlineish'
let g:airline_theme='molokai'
"let g:airline_theme='cobalt2'
"let g:airline_powerline_fonts = 1
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
set nocursorline
set ruler
set relativenumber
" Fast scrolling
set ttyfast
" Display status line
set laststatus=2
" Other
set colorcolumn=90
set splitbelow
set splitright
set fillchars=vert:\│
" Timeout for commands, leader key, etc.
set timeoutlen=750



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
" C-specific indentation rules
set cinoptions=(0=0


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
" Smart case sensitivity in searches
set ignorecase
"set smartcase

" Folding method needed for OmniSharp
"set foldmethod=syntax
" Ignore case when autocompleting
set wildignorecase

" Sane default tags location
set tags=./tags;
" Use cscope db when searching for a tag, and other things
set cscopetag
set cscopeverbose
set cscopequickfix=s-,c-,d-,i-,t-,e-
set csto=0

" TODO Customize this per-project
set makeprg=build.bat

" Remember last flags used in :substitute
set nogdefault

" Group together all backup & undo files
set backupdir=~/.backup
set undodir=~/.backup

" CtrlP in quickfix mode (close quickfix window if open!)
function! SubstQuickfixWithCtrlP()
    ccl
    CtrlPQuickfix
endfunction
command! QfCP call SubstQuickfixWithCtrlP()

" C header files inclusion guards
function! s:InsertInclusionGuards()
  let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! ko
endfunction

" Auto-save on loss of focus
au FocusLost * :wa

" Auto-reload vimrc upon saving
augroup vimrc     " Source vim configuration upon save
  autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
  autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
augroup END

" Wrap lines in QF
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END

" Simple filetype templates
augroup templates
    autocmd!
    autocmd BufNewFile *.{h,hpp} call <SID>InsertInclusionGuards()
augroup END

" Custom task-comments highlighting (not working!)
augroup vimrc_todo
    au!
    au Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|HACK):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyTodo Todo

