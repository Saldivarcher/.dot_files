call plug#begin('~/.vim/plugged')
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'justinmk/vim-syntax-extra'
Plug 'justinmk/vim-sneak'
if has('unix')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
endif
if has('macunix')
  Plug '/usr/local/opt/fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-sleuth'
Plug 'gruvbox-community/gruvbox'
Plug 'neutaaaaan/iosvkem'
Plug 'HendrikPetertje/vimify'
"<Leader>ig is the command to get indent coloring
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Shougo/vinarise'
Plug 'Shougo/echodoc.vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'vhdirk/vim-cmake'
call plug#end()

set background=dark
set t_Co=256
set nocompatible

set encoding=UTF-8

colorscheme gruvbox
let g:gruvbox_contrast_dark="hard"

syntax on
set number
set ruler

if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
        \ setlocal expandtab tabstop=2 shiftwidth=2
  let g:_has_set_default_indent_settings = 1
endif

"set wrap
"set textwidth=79

set mouse=a
set ffs=unix,dos,mac
set updatetime=300

filetype plugin on
filetype indent on

set autoread
set nobackup
set nowb
set noswapfile

set whichwrap+=<,>,h,l
" Highlight matching bracket
set showmatch
set mat=2
set hidden
" Make vim command bar a bit bigger
set cmdheight=2

" Blinking cursor, although doesn't have an effect on alacritty
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Lowers brightness on matching brackets
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" Vim-sneak
let g:sneak#label = 1

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" Removes whitespace and newlines from strings
function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

function! ChangeToGnu()
  "GNU Coding Standards
  set cindent
  set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  set expandtab
  set shiftwidth=2
  set tabstop=8
  set softtabstop=2
  set textwidth=80
  set fo-=ro fo+=cql
endfunction

if filereadable('/proc/cpuinfo')
    " Remove newline from the end of the string
    let n = Chomp(system('grep -c ^processor /proc/cpuinfo'))
    let cpu_count = (n > 1 ? ('-j'.(n)): '')
else
    let cpu_count = ''
endif

autocmd FileType rust let b:dispatch = "cargo build " . cpu_count

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! ReloadSleuth()
  Sleuth
  call LightlineReload()
endfunction

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
command! ReloadSleuth call ReloadSleuth()
command! ChangeToGnu call ChangeToGnu()
" space is my leader key
let mapleader=' '

nnoremap <leader>nt :tabnew<CR>
nnoremap <leader>bt :-tabnew<CR>
nnoremap <leader>hh :tabprevious<CR>
nnoremap <leader>ll :tabnext<CR>
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>cp :pc<CR>
nnoremap <leader>rr :FZF<CR>
nnoremap <leader>bs :set scrollback=1<CR>
nnoremap <leader>bd :set scrollback=100000<CR>
nnoremap <leader>ob :Vinarise<CR>
nnoremap <leader>po :VinarisePluginDump<CR>
nnoremap <leader>rs :ReloadSleuth<CR>
nnoremap <leader>cg :ChangeToGnu<CR>
nnoremap <leader>fs :Vista finder<CR>
" Go back to previous open file
nnoremap <leader>gb :e#<CR>

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
nnoremap <F8> :Vista!!<CR>
nnoremap <F9> :CargoBuildRelease<CR>

" Use Esc to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

" Sets spellcheck for git commit messages and markdown files
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown  setlocal spell

let g:vista#executives = ['coc', 'ctags']

let g:vista_executive_for = {
\  "cpp" : "coc"
\  }

" Size of code box within fzf search window
let g:vista_fzf_preview = ['right:50%']
" Add items coc doesn't work for here
let g:vista_close_on_jump = 1
let g:vista_sidebar_width = 70

let g:vista#renderer#enable_icon = 1

let g:vinarise_objdump_intel_assembly = 0

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function":      "\u2a10",
\   "variable":      "\u0056",
\   "enum":          "\u00e8",
\   "method":        "\u006d",
\   "module":        "\u2133",
\   "type":          "\u0054",
\   "typeParameter": "\u0054",
\   "typedef":       "\u0054",
\   "types":         "\u0054",
\  }

let g:spotify_token='MzUwYTQ3OGM1OGYwNGVlNmE0MDI2ODZiYTE3NDBjZTg6ZTMzYjAyODA2MjBhNGZlNWJlOTRiNmFhYThhNzlmOTM'
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_color_change_percent=0

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

" If in insert mode, help cannot be called
inoremap <F1> <Esc>
noremap <F1> :call MapF1()<CR>

" Close help with f1 if open
function! MapF1()
  if &buftype == "help"
    exec 'quit'
  else
    exec 'help'
  endif
endfunction

function! Formatonsave()
  " Only format the diff.
  let l:formatdiff = 1
  py3f /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

" Jump to tab: <Leader>t
function TabName(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

function! s:jumpToTab(line)
    let pair = split(a:line, ' ')
    let cmd = pair[0].'gt'
    execute 'normal' cmd
endfunction

nnoremap <silent> <Leader>sb :call fzf#run({
\   'source':  reverse(map(range(1, tabpagenr('$')), 'v:val." "." ".TabName(v:val)')),
\   'sink':    function('<sid>jumpToTab'),
\   'up':    tabpagenr('$') + 2
\ })<CR>

source  ~/.dot_files/nvim/fzf.vim
source  ~/.dot_files/nvim/defx.vim
source  ~/.dot_files/nvim/autocomplete.vim
source  ~/.dot_files/nvim/lightline.vim
