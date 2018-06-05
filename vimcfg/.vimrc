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
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-dispatch'
Plugin 'ervandew/supertab'
Plugin 'a.vim'
Plugin 'tpope/vim-surround'
Plugin 'jremmen/vim-ripgrep'
Plugin 'Valloric/ListToggle'
Plugin 'tikhomirov/vim-glsl'
Plugin 'junegunn/vim-easy-align'
"Plugin 'SirVer/ultisnips'
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

" Somewhat hacky way to get '.vim' folder path
let $VIMHOME=expand('<sfile>:p:h') . '/.vim/'

set rtp-=~/.vim/after
set rtp+=~/.vim/after

" Ctrl-P
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_match_window = 'order:ttb'
let g:ctrlp_show_hidden = 1
let g:ctrlp_by_filename = 1
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix']
let g:ctrlp_max_files = 0
if has('python') || has('python3')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

if executable('rg')
    " ripgrep file type flags for use in all variants
    let g:rg_filetype_flags = '-tcpp -tcs -tjava -tjson -tlua -tpy -txml
                                \ --type-add "xaml:*.{xaml,axml}" -txaml
                                \ --type-add "bat:*.bat" -tbat
                                \ --type-add "sl:*.glsl" -tsl
                                \ --type-add "config:{*settings*,*.cfg,*.ini}" -tconfig'

    " Use ripgrep over grep
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m ",%f:%l:%m

    " vim-ripgrep
    let g:rg_binary = 'rg'
    " Search for literal string
    let g:rg_command = g:rg_binary . ' --vimgrep -F -w ' . g:rg_filetype_flags
    let g:rg_highlight = 1
    let g:rg_derive_root = 1
    let g:rg_root_types = ['.git', '.svn', '.p4ignore']

    " Use ripgrep for indexing files in CtrlP
    let g:ctrlp_user_command = 'rg -F %s --files --color=never ' . g:rg_filetype_flags
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

" Supertab
let g:SuperTabNoCompleteAfter = ['^', ',', '\s', '{', '(', '=', ';', '"']

" List toggle (since we already use <leader>l)
let g:lt_location_list_toggle_map = '<leader>wl'

" NERDCommenter
map <leader>ncl <plug>NERDCommenterAlignLeft
map <leader>ncc <plug>NERDCommenterComment
map <leader>ncb <plug>NERDCommenterAlignBoth



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

" Quickly close windows
nnoremap <leader>cb :bd<CR>
nnoremap <leader>cw <C-w>c
nnoremap <leader>wc <C-w>c
nnoremap <leader>ww <C-w>o
nnoremap <leader>cl :ccl<CR>

" Quickly save if needed
inoremap <leader>u <Esc>:update<Cr>
nnoremap <leader>u :update<Cr>

" Split windows easily
nnoremap <leader>sh  :topleft  vnew<CR>
nnoremap <leader>sj  :botright new<CR>
nnoremap <leader>sk  :topleft  new<CR>
nnoremap <leader>sl  :botright vnew<CR>

nnoremap <leader>ws :vert sb %<CR>

" Swap splits
nnoremap <leader>wx <C-w>x

" Resize current split
" ### NOTE Ctrl and Ctrl-Shift send the same keystroke! ###
nnoremap <C-S-Left>     <C-W><
nnoremap <C-S-Down>     <C-W>-
nnoremap <C-S-Up>       <C-W>+
nnoremap <C-S-Right>    <C-W>>

" Split navigation
nnoremap <C-h> <C-W><C-H>
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>

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
"nnoremap <C-S-j> <C-d>
"nnoremap <C-S-k> <C-u>
"vnoremap <C-S-j> <C-d>
"vnoremap <C-S-k> <C-u>

" Get rid of one keystroke for something soo common
nnoremap . :
nnoremap : .

" Change word (this should be the standard mapping!)
nnoremap <leader>cc cw
nnoremap <leader>cC cW

" Join next line (at the end of current one)
nnoremap <leader>J J

" Insert blank lines without going to insert mode
nnoremap <leader><CR> o<Esc>
nnoremap <leader><S-CR> O<Esc>
nnoremap <leader><C-CR> O<Esc>

" Delete in insert mode without using extended keys or chords
inoremap <C-BS> <C-W>
inoremap <S-BS> <Del>
inoremap <C-S-BS> <Esc>ldwi

" Search more quickly!
nnoremap <Space> /
nnoremap <S-Space> ?
" Highlight occurences without moving the cursor
nnoremap <leader>* :HLcw<CR>

" Toggle NERDTree (current path not working it seems)
nnoremap <leader>t :NERDTreeToggle %<CR>

" CtrlP in mixed mode
nnoremap <leader>pm :CtrlPMixed<CR>
" CtrlP in quickfix mode (close quickfix window if open!)
nnoremap <leader>pq :CPqf<CR>
" CtrlP in buffer mode
nnoremap <leader>bb :CtrlPBuffer<CR>

" Switch to previous buffer
nnoremap <leader>bl :b#<CR>

" Hide ^M line endings in mixed-mode files
nnoremap <leader><space>cr :match Ignore /\r$/<CR>
" Convert to DOS line endings
nnoremap <leader><space>dos :e ++ff=dos<CR>:w<CR>

" Format current paragraph or visual selection
vmap <leader>= gq
nmap <leader>= gqap
" EasyAlign
vnoremap <leader>a<space> :'<,'>EasyAlign-\ <CR>

" Switch to .h/cpp
nnoremap <leader>oo :A<CR>
nnoremap <leader>os :AV<CR>

" Generate GTAGS (via gen_tags)
nnoremap <leader>gen :GenGTAGS<CR>

" Gtags
nnoremap <leader>ts :Gtags<space>
nnoremap <leader>tf :Gtags -f %<CR>:CPqf<CR>
nnoremap <F12>      :Gtags<CR><CR>:CPqf<CR>
nnoremap <S-F12>    :Gtags -r<CR><CR>:CPqf<CR>

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
"nnoremap <leader>gi     :YcmCompleter GoToInclude<CR>
"nnoremap <leader>gd     :YcmCompleter GoToDefinition<CR>
"nnoremap <leader>gdl    :YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>g      :YcmCompleter GoTo<CR>
"nnoremap <leader>gu     :YcmCompleter GoToReferences<CR>
"nnoremap <leader>gim    :YcmCompleter GoToImplementation<CR>
"nnoremap <leader>doc    :YcmCompleter GetDoc<CR>
"nnoremap <leader>fx     :YcmCompleter FixIt<CR>
"nnoremap <leader>re     :YcmCompleter RefactorRename 

" Perl/Python compatible regex formatting
nnoremap / /\v
vnoremap / /\v

" Silent make (with result on a right hand split)
" TODO Improve to detect if we're in the right split and show on the left instead
nnoremap <leader>m :wa<CR>:silent make<CR>:vert botright cw 90<CR>:cc<CR>

" Replace
nnoremap <leader>r :call PromptReplace()<CR>
" Easily replace current word
nnoremap <leader>rr :call PromptReplaceCurrent("word")<CR>
" Easily replace last searched term
nnoremap <leader>rs :call PromptReplaceCurrent("search")<CR>
" Replace currently selected text (in visual mode)
vnoremap <leader>rv y:call PromptReplaceCurrent("visual")<CR>
" Replace _inside_ a visual selection
vnoremap <leader>r :call PromptReplace("visual")<CR>

" Other quick common replacements (from current line on)
nnoremap <leader>r- :.,$s/->/\./gc<CR>
nnoremap <leader>r. :.,$s/\./->/gc<CR>

" Find in files using ripgrep
nnoremap <leader>f :Rg<space>
nnoremap <leader>ff :HLcw<CR>:Rg<CR>
vnoremap <leader>ff y:HLcw<CR>:Rg <C-R>"<CR>
" Find current word, then replace across all locations
" FIXME This loops very weirdly through the same places several times
nnoremap <leader>fr :HLcw<CR>:Rg<CR>:cdo %s///gc<Left><Left><Left>
nnoremap <leader>rf :HLcw<CR>:Rg<CR>:cdo %s///gc<Left><Left><Left>

" Naive auto-completion / snippets
inoremap {<CR> {<CR>}<Esc>O
inoremap ,t<CR> // TODO 

" Replace-paste without yanking in visual mode
vnoremap p "_dp
vnoremap P "_dP

" Built-in explorer
nnoremap <leader>e :Vex<CR>

" Copy and paste using system's clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P

" Navigate quickfix and location results
nnoremap <leader>qn :cn<CR>
nnoremap <leader>qp :cp<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-b> :cp<CR>
nnoremap <leader>ln :lne<CR>
nnoremap <leader>lp :lp<CR>


"
" LOOK & FEEL
"
syntax enable
set background=dark

if has('gui_running')
    set guifont=Consolas_NF:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Consolas:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Input:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Fira_Mono:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Source_Code_Pro:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Droid_Sans_Mono_Dotted:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Anonymous_Pro:h12:cDEFAULT:qCLEARTYPE
"    set guifont=Hack:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Inconsolata:h12:cDEFAULT:qCLEARTYPE
"    set guifont=Liberation_Mono:h11:cDEFAULT:qCLEARTYPE
"    set guifont=Roboto_Mono:h10:cDEFAULT:qCLEARTYPE "Not working!

    " Colorschemes
    colorscheme retro-minimal
    "colorscheme mustang_sensei_edit
    "colorscheme handmade-hero
    "colorscheme solarized
    "colorscheme distinguished
    "colorscheme simple-dark
endif

" Airline switches
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
"let g:airline_theme='molokai'
"let g:airline_theme='papercolor'
"let g:airline_theme='ubaryd'
"let g:airline_theme='powerlineish'
"let g:airline_theme='cobalt2'

let g:airline_powerline_fonts = 1
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
set colorcolumn= "90
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
" MISC SETTINGS
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
" For clang-cl:
set efm+=%I%f(%l\\,%c):\ \ note:\ %m
set efm+=%W%f(%l\\,%c):\ \ warning:\ %m
set efm+=%E%f(%l\\,%c):\ \ error:\ %m,%-C%.%#,%Z

" Remember last flags used in :substitute
set nogdefault

" Group together all backup & undo files
set backupdir=~/.backup
set undodir=~/.backup

"
" MISC FUNCTIONS, COMMANDS, AUTOS..
"

" Open CtrlP in quickfix mode (close quickfix window if open!)
function! SubstQuickfixWithCtrlP()
    ccl
    CtrlPQuickfix
endfunction
command! CPqf call SubstQuickfixWithCtrlP()

" C header files inclusion guards
function! s:InsertInclusionGuards()
  let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! ko
endfunction

" Identify syntax highlighting group under cursor
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <leader>shl :call SynGroup()<CR>

" Toggle fullscreen using external DLL
command! ToggleFullscreen call libcallnr(expand("$VIMHOME") . "gvimfullscreen_64.dll", "ToggleFullScreen", 0)
" 'Refresh' fullscreen state (only works with 'noremap' for some reason!)
noremap <F11> <Esc>:ToggleFullscreen<CR><Esc>:ToggleFullscreen<CR>


" Enter fullscreen by default
"augroup fullscreen
    "" When using CheckAndMaybeLoadLastSession() below this should be turned off or they'll conflict!
    "if has('gui_running')
        "autocmd! VimEnter * :ToggleFullscreen
    "endif
"augroup END

" Sessions!
function! CheckAndMaybeLoadLastSession()
    let l:filename = "last_session.vim"
    if argc() == 0
        if filereadable(l:filename)
            exe 'source ' . fnameescape(l:filename)
            echom "Loaded session from " . l:filename
        endif
        let g:current_session_file = l:filename
    endif
    if has('gui_running')
        ToggleFullscreen
    endif
endfun

function! CheckAndMaybeSaveLastSession()
    if exists("g:current_session_file")
        echom "Saving session to " . g:current_session_file
        set sessionoptions=options,curdir,buffers,blank,winsize,tabpages
        exe 'mksession! ' . fnameescape(g:current_session_file)
    endif
endfun

augroup sessions
    autocmd!
    " Auto save current session in current dir when closing
    autocmd VimEnter * :call CheckAndMaybeLoadLastSession()
    autocmd VimLeave * :call CheckAndMaybeSaveLastSession()
augroup END

" Highlight ocurrences of word under cursor
command! HLcw let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>' | set hls

" Auto-save on loss of focus
au FocusLost * :wa

" Auto-reload vimrc upon saving
augroup vimrc
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

" Custom task-comments highlighting
augroup vimrc_todo
    au!
    au Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|HACK)/
          \ containedin=.*Comment.*
augroup END
hi def link MyTodo Todo

" Insert MIT license at the top
command! Mit :0r ~/.vim/mit.txt

" Filetypes for weird files
augroup filetypedetect
    au BufRead,BufNewFile wscript set filetype=python
augroup END

" Helper functions to perform substitutions with a prompt
function! Replace(source, target, ...) range
    let l:mmod = a:0 >= 1 ? a:1 : ''
    let l:vmod = a:0 >= 2 ? a:2 : ''

    try
        " FIXME This way of redoing 'wrapping' a subst by redoing it from the start is a bit annoying..
        let l:searchstring = '.,$s' . l:mmod . '/' . l:vmod . a:source . '/' . a:target . '/gcI|1,''''-&&'
        echom "Search string: " . l:searchstring
        exe l:searchstring
    catch
        redraw
        echohl ErrorMsg | echomsg "'" . a:source . "' not found." | echohl None
    endtry
endfunction

function! PromptReplace(...) range
    let l:mode = a:0 >= 1 ? a:1 : ''
    
    let l:vmod = ''
    if l:mode == "visual"
        let l:vmod = '\%V'
    endif

    call inputsave()
    let l:source = input("Replace: ")
    if !empty(l:source)
        let l:target = input("with: ")
        if !empty(l:target)
            call Replace(l:source, l:target, 'm', l:vmod)
        endif
    endif
    call inputrestore()
endfunction

function! PromptReplaceCurrent(sourceMode) range
    if a:sourceMode == "word"
        let l:source = expand("<cword>")
    elseif a:sourceMode == "search"
        let l:source = @/
    elseif a:sourceMode == "visual"
        let l:source = @"
    endif
    
    if empty(l:source)
        return
    endif

    call inputsave()
    let l:target = input("Replace '" . l:source . "' with: ")
    if !empty(l:target)
        call Replace(l:source, l:target, 'no')
    endif
    call inputrestore()
endfunction

