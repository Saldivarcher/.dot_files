let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
      \ 'left': [
                 \ ['mode', 'paste'], ['git_status', 'coc_status'],
                 \ ['readonly', 'relativepath', 'custom_modified']
               \ ],
      \ 'right': [['indent', 'percent', 'lineinfo'], ['filetype', 'fileencode']]
    \ },
  \ 'component_expand': {
      \ 'git_status': 'GitStatusline',
      \ 'indent': 'SleuthIndicator',
      \ 'fileencode': 'FileEncoding',
    \ },
  \ 'component_function': {
      \ 'coc_status': 'coc#status',
    \ },
\}

function! GitStatusline() abort
  let l:head = fugitive#head()
  if !exists('b:gitgutter')
    return (empty(l:head) ? '' : printf(' %s', l:head))
  endif

  let l:summary = GitGutterGetHunkSummary()
  let l:result = filter([l:head] + map(['+','~','-'], {i,v -> v.l:summary[i]}), 'v:val[-1:] !=? "0"')

  return (empty(l:result) ? '' : printf(' %s', join(l:result, ' ')))
endfunction

function! FileEncoding() abort
  if &filetype==?'defx'
    return ""
  endif
 return (&fenc!=#""?&fenc:&enc)
endfunction
