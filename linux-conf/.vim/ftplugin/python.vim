" jedi autocompletion
set omnifunc=jedi#completions
let g:jedi#popup_on_dot=0
  
" ALE
let b:ale_fixers = ['black', 'isort']
let g:ale_fix_on_save = 1

" Insert breakpoint
nnoremap <Leader>b obreakpoint()<Esc>

" Line length indicator
set colorcolumn=89
