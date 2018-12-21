call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jremmen/vim-ripgrep'
Plug 'raimondi/delimitmate'
Plug 'justinmk/vim-syntax-extra'
Plug 'justinmk/vim-sneak'
if has('unix')
    Plug '~/.fzf'
endif
if has('macunix')
    Plug '/usr/local/opt/fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'morhetz/gruvbox'
Plug 'neutaaaaan/iosvkem'
call plug#end()

set background=dark
set t_Co=256
set nocompatible

set encoding=UTF-8

colorscheme gruvbox
let g:gruvbox_contrast_dark="hard"
let g:airline_theme='gruvbox'

syntax on
set number
set ruler

filetype plugin indent on

set tabstop=4
set expandtab
set shiftwidth=4

set autoindent
set cindent
set smarttab

set wrap
set textwidth=79

set mouse=a
set ffs=unix,dos,mac

filetype plugin on
filetype indent on

set autoread
set nobackup
set nowb
set noswapfile

set whichwrap+=<,>,h,l
set showmatch
set mat=2

" Lowers brightness on matching brackets
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" YouCompleteMe options
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_goto_buffer_command = 'new-tab'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0

" Vim-sneak
let g:sneak#label = 1

" Removes whitespace and newlines from strings
function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

if filereadable('/proc/cpuinfo')
    " Remove newline from the end of the string
    let n = Chomp(system('grep -c ^processor /proc/cpuinfo'))
    let cpu_count = (n > 1 ? ('-j'.(n)): '')
else
    let cpu_count = ''
endif

autocmd FileType rust let b:dispatch = "cargo build " . cpu_count

" Removes whitespace from a file
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

fun! CargoBuild()
    execute "Cargo build " . g:cpu_count
endfun

fun! CargoBuildRelease()
    execute "Cargo build --release " . g:cpu_count
endfun

command! CargoBuild call CargoBuild()
command! CargoBuildRelease call CargoBuildRelease()
command! TrimWhitespace call TrimWhitespace()
" space is my leader key
let mapleader=' '
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>nt :tabnew<CR>
nnoremap <leader>bt :-tabnew<CR>
nnoremap <leader>hh :tabprevious<CR>
nnoremap <leader>ll :tabnext<CR>
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>rr :FZF<CR>
nnoremap <leader>bs :set scrollback=1<CR>
nnoremap <leader>bd :set scrollback=100000<CR>

" Opens a new terminal in a newtab
nnoremap <leader>tt :tabnew<CR>:terminal<CR>
nnoremap <leader>ot :terminal<CR>

" close a quickfix window
nnoremap <leader>cw :ccl<CR>

" Unhighlights search results
nnoremap <leader><space> :noh<cr>
nnoremap <leader>dw :TrimWhitespace<cr>

nnoremap <F6> :CargoBuild<CR>
nnoremap <F7> :Dispatch!<CR>
nnoremap <F8> :TagbarToggle<CR>
nnoremap <F9> :CargoBuildRelease<CR>

" Use Esc to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

" Maps 'ctrl-n' to open nerdtree
map  <C-n> :NERDTreeToggle<CR>
map  <C-o> :NERDTreeFind<CR>

" NERD Tree options
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore =['\.pyc$', '\.o$', '\.a$', '\.cbor$']
let NERDTreeMinimalUI = 1

" Sets spellcheck for git commit messages and markdown files
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown  setlocal spell

set switchbuf+=newtab

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
