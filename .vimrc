execute pathogen#infect()
set background=dark
set t_Co=256
set nocompatible

set encoding=UTF-8

colorscheme Iosvkem

syntax on
set number
set ruler

filetype plugin indent on

set tabstop=4
set expandtab
set shiftwidth=4

set autoindent
set smartindent
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

" Removes whitespace from a file
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

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
" Unhighlights search results
nnoremap <leader><space> :noh<cr>
nnoremap <leader>dw :TrimWhitespace<cr>

" Opens a new terminal in a newtab
nnoremap <leader>tt :tabnew<CR>:terminal<CR>
nnoremap <leader>ot :terminal<CR>
" Use Esc to exit terminal-mode
tnoremap <Esc> <C-\><C-n>


" Maps 'ctrl-n' to open nerdtree
map <C-n> :NERDTreeToggle<CR>
map <C-o> :NERDTreeFind<CR>

" NERD Tree options
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore =['\.pyc$', '\.o$', '\.a$', '\.cbor$']
let NERDTreeMinimalUI = 1

"NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('rs', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('c', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('cpp', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('bp', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('go', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('h', 'Magenta', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('toml', 'Magenta', 'none', '#ff00ff', '#151515')

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
