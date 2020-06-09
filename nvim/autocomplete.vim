" Disable preview documentation
set completeopt-=preview

" Limit autocomplete menu
set pumheight=15

autocmd CursorHold * silent call CocActionAsync('highlight')

augroup autocomplete
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Install coc extensions for: rust, json, python, viml
let g:coc_global_extensions = [
  \ 'coc-rust-analyzer',
  \ 'coc-json',
  \ 'coc-pyls',
  \ 'coc-vimlsp',
  \ 'coc-pairs',
  \ ]

function! SetLSPShortcuts()
  nmap <leader>gd <Plug>(coc-definition)
  nmap <leader>gc <Plug>(coc-declaration)
  nmap <leader>gi <Plug>(coc-implementation)
  nmap <leader>gr <Plug>(coc-references)
  nmap <leader>gt <Plug>(coc-type-definition)
  nmap <leader>lr <Plug>(coc-rename)
  nmap <leader>gh :call CocAction('doHover')<CR>
  " Workspace symbol search
  nnoremap <silent><leader>ws :<C-u>CocList --top -I symbols<CR>
  " Document only symbol search
  " TODO: Figure out how to use fzf for outlining and move it to the top
  nnoremap <silent><leader>gs :<C-u>CocList --top outline<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c,rust,python,vim call SetLSPShortcuts()
augroup END

" Better tab completetion for coc
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
