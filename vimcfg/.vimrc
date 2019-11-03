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
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'ervandew/supertab'
Plugin 'a.vim'
Plugin 'tpope/vim-surround'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tikhomirov/vim-glsl'
Plugin 'junegunn/vim-easy-align'
Plugin 'moll/vim-bbye'
Plugin 'junegunn/goyo.vim'
Plugin 'chaoren/vim-wordmotion'

call vundle#end()

filetype on
filetype plugin on
filetype indent on

" Add ~/.vim/ in windows too for cross-platform-ness
if has('win32')
    let &runtimepath='~/.vim/,' . &runtimepath
    set shellslash  " Required for 'rg_derive_root' to work (without patch)
endif

" Somewhat hacky way to get '.vim' folder path
let $VIMHOME=expand('<sfile>:p:h') . '/.vim/'

set rtp-=~/.vim/after
set rtp+=~/.vim/after

" Ctrl-P
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.git', '.svn', '.p4ignore', 'p4config.txt', 'project.plik']
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
                                \ --type-add "sl:*.{glsl,pssl}" -tsl
                                \ --type-add "pyx:*.pyx" -tpyx
                                \ --type-add "config:{*settings*,*.cfg,*.ini}" -tconfig'

    " Use ripgrep over grep
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m ",%f:%l:%m

    " vim-ripgrep
    let g:rg_binary = 'rg'
    " Search for literal string
    let g:rg_command = g:rg_binary . ' --vimgrep -F ' . g:rg_filetype_flags
    let g:rg_highlight = 1
    let g:rg_derive_root = 1
    let g:rg_root_types = ['.git', '.svn', '.p4ignore', 'p4config.txt', 'project.plik']

    " Use ripgrep for indexing files in CtrlP
    let g:ctrlp_user_command = 'rg -F %s --files --color=never ' . g:rg_filetype_flags
    let g:ctrlp_use_caching = 1    " We'll see..
endif

if executable('global') || executable('global.exe')
    let g:ctrlp_buftag_ctags_bin = 'global -c'
endif

" Supertab
let g:SuperTabNoCompleteAfter = ['^', ',', '\s', '{', '}', '(', ')', '=', ';', '"']

" vim-surround
let g:surround_48 = "#if 0\n\r\n#endif"

" Goyo
let g:goyo_width = 120

" wordmotion
" TODO Do we want to completely replace w, b, e, etc.?
let g:wordmotion_prefix = ','



"
" EDITOR SETTINGS
"
syntax enable
set background=dark

if has('gui_running')
    set guifont=Consolas_NF:h12:cDEFAULT:qCLEARTYPE
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
    "colorscheme simple-dark
    "colorscheme corporation
    colorscheme retro-minimal
    "colorscheme mustang_sensei_edit
    "colorscheme handmade-hero
    "colorscheme distinguished
    "colorscheme solarized
endif

" Airline switches
"let g:airline_theme='solarized'
"let g:airline_solarized_bg='dark'
let g:airline_theme='molokai'
"let g:airline_theme='papercolor'
"let g:airline_theme='ubaryd'
"let g:airline_theme='powerlineish'
"let g:airline_theme='cobalt2'
"let g:airline_theme='minimalist'

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0

" Lightline switches
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
    \ },
    \ 'component': {
    \   'readonly': '%{&readonly?"":""}',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
\ }
    "\ 'colorscheme': 'wombat',
	"\ 'colorscheme': 'OldHope',
    "\ 'colorscheme': 'nord',
		"\ 'colorscheme': 'solarized',
		"\ 'colorscheme': 'jellybeans',
		"\ 'colorscheme': 'Tomorrow',
		"\ 'colorscheme': 'Tomorrow_Night',
		"\ 'colorscheme': 'Tomorrow_Night_Eighties',
		"\ 'colorscheme': 'PaperColor',
		"\ 'colorscheme': 'seoul256',
		"\ 'colorscheme': 'one',
		"\ 'colorscheme': 'materia',
		"\ 'colorscheme': 'material',
		"\ 'colorscheme': 'deus',

" No bell please!
set visualbell
set t_vb=
" Incremental searches with ocurrences
set hlsearch
set showmatch
set incsearch
" Keep context around cursor
set scrolloff=3
" Show mode & command
set noshowmode
set showcmd
" Line numbers
set nocursorline
set ruler
set relativenumber
" Fast scrolling
set ttyfast
" Display status line
set laststatus=2
" Customize it
set statusline+=%F
" Other
set colorcolumn= "110
set splitbelow
set splitright
"set linespace=0     "continuous line
set fillchars+=vert:│
" Show < or > when characters are not displayed on the left or right.
set list listchars=precedes:<,extends:>

" Timeout for commands, leader key, etc.
set timeoutlen=750



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
" C-specific indentation rules
set cinoptions=(0=0



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
set smartcase

set cpoptions+={

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
"set makeprg=build.py\ -d
"set makeprg=build.py
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
" FUNCTIONS, COMMANDS, AUTOS
"

" Formatting options (as autocmd so it overrides filetypes)
augroup filetypeformat
    autocmd!
    " Filetypes for weird files
    au BufRead,BufNewFile wscript set filetype=python
    au BufRead,BufNewFile *.state set filetype=json

    au FileType * set fo+=q fo+=r fo+=n
    au FileType c,cpp setlocal comments-=:// comments+=f://
    au FileType python setlocal cindent tabstop=4 shiftwidth=4 softtabstop=4 expandtab cinwords=if,elif,else,for,while,try,except,finally,def,class
    let g:xml_syntax_folding=1
    au FileType xml setlocal foldmethod=syntax foldlevel=999
    au FileType qf setlocal wrap    " Wrap lines in quickfix window
    au FileType json setlocal foldmethod=syntax foldlevel=999
augroup END

function! DisablePluginMappings()
    " Remove crappy mappings in A.vim that mess with the leader in insert mode
    silent! iunmap <leader>ih
    silent! iunmap <leader>is
    silent! iunmap <leader>ihn
endfunction

augroup disabledmappings
    autocmd! VimEnter * :call DisablePluginMappings()
augroup END

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
" FIXME For some obscure reason this mapping never works after restarting!
nnoremap <leader>syn :call SynGroup()<CR>

" Toggle fullscreen using external DLL
" TODO Keep track of status with a global variable so we can always enable it (for Goyo)
command! ToggleFullscreen call libcallnr(expand("$VIMHOME") . "gvimfullscreen_64.dll", "ToggleFullScreen", 0)
" 'Refresh' fullscreen state (only works with 'noremap' for some reason!)
noremap <F11> <Esc>:ToggleFullscreen<CR><Esc>:ToggleFullscreen<CR><ESC>:windo e<CR>
noremap <S-F11> <Esc>:ToggleFullscreen<CR>

" Enter fullscreen by default
"augroup fullscreen
    "" NOTE When using CheckAndMaybeLoadLastSession() below this should be turned off or they'll conflict!
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
        if has('gui_running')
            ToggleFullscreen
        endif
    else
        simalt ~x
    endif
endfun

function! CheckAndMaybeSaveLastSession()
    if exists("g:current_session_file")
        echom "Saving session to " . g:current_session_file
        "set sessionoptions=blank,buffers,curdir,tabpages,winsize,options
        exe 'mksession! ' . fnameescape(g:current_session_file)
    endif
endfun

augroup sessions
    autocmd!
    " Auto save current session in current dir when closing
    autocmd VimEnter * nested call CheckAndMaybeLoadLastSession()
    "autocmd FocusGained * windo e | echom 'Reloaded all windows'
    autocmd VimLeave * call CheckAndMaybeSaveLastSession()
augroup END

set sessionoptions-=options

" Highlight ocurrences of word under cursor
command! HLcword let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>' | set hls
" Highlight ocurrences of visual selection (yanked in the 'v' register)
command! HLcsel let @/ = '\V\<'.escape(@v, '/\').'\>' | set hls

" Hide ^M line endings in mixed-mode files
command! HideCR match Ignore /\r$/
" Convert to sane line endings
command! FixFormat :update<CR>:e ++ff=dos<CR>:setlocal ff=unix<CR>:w<CR>
 
" Auto-save on loss of focus
au! FocusLost * :wa

" Auto-reload vimrc upon saving
augroup vimrc
  autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | call LightlineReload() | redraw
  autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | call LightlineReload() | redraw
augroup END

" Simple filetype templates
augroup templates
    autocmd!
    autocmd BufNewFile *.{h,hpp} call <SID>InsertInclusionGuards()
augroup END

" Custom task-comments highlighting
augroup vimrc_todo
    au!
    au Syntax * syn match MyTodo "\v<(FIXME|NOTE|TODO|HACK)"
          \ containedin=.*Comment.*
    au Syntax * syn match Bookmark "\v\@\w+"
          \ containedin=.*Comment.*
augroup END
hi def link MyTodo Todo
hi def link Bookmark Todo

" Insert MIT license at the top
command! Mit :0r ~/.vim/mit.txt

" Helper functions to perform substitutions with a prompt
function! Replace(source, target, ...) range
    let l:mmod = a:0 >= 1 ? a:1 : ''
    let l:vmod = a:0 >= 2 ? a:2 : ''

    try
        let l:searchstring = '.,$s' . l:mmod . '/' . l:vmod . a:source . '/' . a:target . '/gcI|echo ''Continue at beginning of file? (y/q)''|if getchar()==121|1,''''-&&|else|redraw|echo|en'
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

function! PromptReplaceCurrent(sourceMode, ...) range
    let l:targetMode = a:0 >= 1 ? a:1 : ''

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
        normal! mS

        if l:targetMode == ""
            call Replace(l:source, l:target, 'no')
        elseif l:targetMode == "quickfix"
            HLcword
            Rg
            let l:searchstring = 's//' . l:target . '/gcI'
            "echom "Search string: " . l:searchstring
            " HACK Somebody is sending spurious input which makes the first 3
            " entries in the cdo list to be auto-accepted. This seems to work
            " for now (my current suspect is RgHighlight() calling 'feedkeys')
            let l:dummy = input("")
            "redraw
            "echo
            execute 'cdo s//' . l:target . '/gcI'
        endif

        normal! `S
    endif
    call inputrestore()
endfunction

" Custom make function with status message
function! MakeAndShowQF()
    echom "Building..."
    redraw
    " Set a mark so we can return to it after examining errors etc
    normal! mM
    silent make
    echo
    let l:isLeftSide = (win_screenpos(0)[1] < (&columns / 2))
    if l:isLeftSide
        vert botright cw 90
    else
        vert topleft cw 90
    endif
    if len(getqflist()) > 0
        cfirst   " Jump to first error
    endif
endfunction

" Close QF making sure we return to the previous split
function! CloseQF()
    let l:inQF = getwininfo(win_getid())[0]['quickfix']
    if l:inQF
        " Only do this if we are _in_ the QF window
        wincmd p
    endif
    ccl
endfunction

" Reload lightline without exiting
function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" Customize Goyo
function! s:goyo_toggle()
    "if version >= 800
        "hi EndOfBuffer guifg=BG guibg=NONE ctermfg=BG ctermbg=NONE
    "endif
    ToggleFullscreen
    ToggleFullscreen
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_toggle()
autocmd! User GoyoExit nested call <SID>goyo_toggle()

" In-the-zone mode!
noremap <F10> :Goyo<CR>

" Move to split or create anew
function! WinMoveOrSplit(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction



"
" KEY MAPPINGS
"

" Map <leader>
let mapleader = "\<Space>"
noremap <Space> <Nop>
 
" Unmap arrow keys
no <down> <Nop>
no <left> <Nop>
no <right> <Nop>
no <up> <Nop>
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>

" Get rid of one keystroke for something soo common
nnoremap . :
vnoremap . :
nnoremap : .
vnoremap : .

" Alias change word (still can use S to change whole line)
nnoremap cc ciw
nnoremap cC ciW

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

" Move lines up/down
nnoremap ë :m-2<cr>==
nnoremap ê :m+<cr>==
xnoremap ë :m-2<cr>gv=gv
xnoremap ê :m'>+<cr>gv=gv

" Split navigation
" (move to the split in the direction shown, or create a new split)
nnoremap <silent> <C-h> :call WinMoveOrSplit('h')<cr>
nnoremap <silent> <C-j> :call WinMoveOrSplit('j')<cr>
nnoremap <silent> <C-k> :call WinMoveOrSplit('k')<cr>
nnoremap <silent> <C-l> :call WinMoveOrSplit('l')<cr>
vnoremap <silent> <C-h> :call WinMoveOrSplit('h')<cr>
vnoremap <silent> <C-j> :call WinMoveOrSplit('j')<cr>
vnoremap <silent> <C-k> :call WinMoveOrSplit('k')<cr>
vnoremap <silent> <C-l> :call WinMoveOrSplit('l')<cr>
"nnoremap <C-h> <C-W><C-H>
"nnoremap <C-j> <C-W><C-J>
"nnoremap <C-k> <C-W><C-K>
"nnoremap <C-l> <C-W><C-L>

" Resize current split
" ### NOTE Ctrl and Ctrl-Shift send the same keystroke! ###
nnoremap <C-S-Left>     <C-W><
nnoremap <C-S-Down>     <C-W>-
nnoremap <C-S-Up>       <C-W>+
nnoremap <C-S-Right>    <C-W>>

" Perl/Python compatible regex formatting
nnoremap / /\v
vnoremap / /\v

" Replace-paste without yanking in visual mode
" (also, make it behave more intuitively)
vnoremap p "_c<C-R>"<ESC>

" Naive auto-completion / snippets
inoremap {<CR> {<CR>}<Esc>O
inoremap {{<CR> {<CR>};<Esc>O
" These need to be 'imap'
imap <S-Space>d (<C-R>=strftime('%d/%m/%Y')<CR>)<Space>
imap <S-Space>c <plug>NERDCommenterInsert (<C-R>=strftime('%d/%m/%Y')<CR>)<Space>
imap <S-Space>n <plug>NERDCommenterInsert NOTE<Space>
imap <S-Space>t <plug>NERDCommenterInsert TODO<Space>
imap <S-Space>f <plug>NERDCommenterInsert FIXME<Space>
imap <S-Space>b <plug>NERDCommenterInsert @

" Delete in insert mode without using extended keys or chords
inoremap <C-BS> <C-W>
inoremap <S-BS> <Del>
inoremap <C-S-BS> <Esc>ldwi

" Change font size
nnoremap <C-kPlus> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nnoremap <C-kMinus> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>
 


" Search more quickly!
nnoremap <leader><Space> /
nnoremap <leader><S-Space> ?

" Split line at cursor
nnoremap <leader><CR> i<CR><Esc>
nnoremap <leader><S-CR> a<CR><Esc>

" Toggle folds
nnoremap <leader>- za

" Indent inside current block
nnoremap <leader>= =i{
" Manually indent visual selection
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv
xnoremap > >gv
xnoremap < <gv

" EasyAlign interactive
xmap <leader>aa <Plug>(EasyAlign)
nmap <leader>aa <Plug>(EasyAlign)
" EasyAlign commonly used
vnoremap <leader>a<space> :'<,'>EasyAlign-\ <CR>
vnoremap <leader>a= :'<,'>EasyAlign=<CR>

" Buffers
" Create new buffer
nnoremap <leader>B :enew<CR>
" Switch to previous buffer
nnoremap <leader>bb :b#<CR>
" Close buffer using Bbye (preserve windows)
nnoremap <leader>bc :Bd<CR>
" List buffers using CtrlP
nnoremap <leader>bl :CtrlPBuffer<CR>

" Delete after cursor
nnoremap <leader>D lD

" Built-in explorer
nnoremap <leader>ee :Ex<CR>
nnoremap <leader>es :Vex<CR>

" Find in files using ripgrep
nnoremap <leader>f :Rg<space>
nnoremap <leader>ff :HLcword<CR>:Rg<CR>
vnoremap <leader>ff y:HLcword<CR>:Rg <C-R>"<CR>
" Find current word, then replace across all locations
nnoremap <leader>fr :call PromptReplaceCurrent("word", "quickfix")<CR>

" Switch to .h/cpp
nnoremap <leader>hh :A<CR>
nnoremap <leader>hs :AV<CR>

" Join next line (at the end of current one)
nnoremap <leader>J J

" Highlight occurences of the word under the cursor without moving
nnoremap <leader>k :HLcword<CR>
" Highlight occurences of the current visual selection without moving
vnoremap <leader>k "vy:HLcsel<CR>
" Easily clear highlights after search
nnoremap <leader><S-k> :noh<cr>

" Silent make (with result on an opposite split)
" FIXME The opposite split business depends on where the cursor is on invocation,
" and not (as it should) on which of the splits the first error will be highlighted
nnoremap <silent> <leader>m :wa<CR>:call MakeAndShowQF()<CR>

" Comments with NERDCommenter (not working?)
nmap <leader>ncl <plug>NERDCommenterAlignLeft
nmap <leader>ncc <plug>NERDCommenterComment
nmap <leader>ncb <plug>NERDCommenterAlignBoth

" Insert blank lines without going to insert mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

" CtrlP in mixed mode
nnoremap <leader>pm :CtrlPMixed<CR>
" CtrlP in quickfix mode (close quickfix window if open!)
nnoremap <leader>pq :CPqf<CR>
" CtrlP in buffer mode
nnoremap <leader>pb :CtrlPBuffer<CR>
" CtrlP in tags mode (this would need a ctags compatible command from GNU Global!)
nnoremap <leader>pt :CtrlPTag<CR>

" Navigate quickfix and location results
nnoremap <leader>qn :cn<CR>
nnoremap <leader>qp :cp<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-b> :cp<CR>
nnoremap <leader>ln :lne<CR>
nnoremap <leader>lp :lp<CR>

" Replace
nnoremap <leader>r :call PromptReplace()<CR>
" Interactively replace current word
nnoremap <leader>rr :call PromptReplaceCurrent("word")<CR>
" Interactively replace last searched term
nnoremap <leader>rs :call PromptReplaceCurrent("search")<CR>
" Interactively replace currently selected text (in visual mode)
vnoremap <leader>rv y:call PromptReplaceCurrent("visual")<CR>
" Replace _inside_ a visual selection
vnoremap <leader>ri :call PromptReplace("visual")<CR>
" Quickly substitute pointer dereferences
nnoremap <leader>r- yiw:.,$s/<C-R>0\./<C-R>0->/gc<CR>
nnoremap <leader>r. yiw:.,$s/<C-R>0->/<C-R>0./gc<CR>
" Replace-paste over words or visual selections
nnoremap <leader>rw "_ciw<C-R>"<ESC>
nnoremap <leader>rW "_ciW<C-R>"<ESC>
nnoremap <leader>rl "_ddP
vnoremap <leader>rp "_c<C-R>"<ESC>

" Toggle NERDTree (current path not working it seems)
nnoremap <leader>t :NERDTreeToggle %<CR>

" Tags using Gtags
nnoremap <leader>ts :Gtags<space>
nnoremap <leader>tf :Gtags -f %<CR>:CPqf<CR>
nnoremap <F12>      :Gtags<CR><CR>:CPqf<CR>
nnoremap <S-F12>    :Gtags -r<CR><CR>:CPqf<CR>

" Quickly open .vimrc
nnoremap <leader>vim :e $MYVIMRC<CR>
nnoremap <leader>gvim :e $MYGVIMRC<CR>

" Windows
" Quickly close windows
nnoremap <leader>wc <C-w>c
nnoremap <leader>cc <C-w>c
nnoremap <leader>cl :call CloseQF()<CR>
" Split current window (show same buffer)
nnoremap <leader>ws <C-w>o:vert sb %<CR>
" Swap splits
nnoremap <leader>wx <C-w>x
" Make them equal
nnoremap <leader>w= <C-w>=
" Maximize
nnoremap <leader>ww <C-w>o

" Insert result of expressions
inoremap <C-Space>x <C-R>=
nnoremap <leader>x i<C-R>=

" Copy and paste using system's clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P

" Save all
nnoremap <leader>ss :wa<CR>

