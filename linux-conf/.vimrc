" -------------------------------------
" vim-plug
" -------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'mileszs/ack.vim'
Plug 'dense-analysis/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'preservim/tagbar'
Plug 'leafgarland/typescript-vim'
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()

" -------------------------------------
" general options
" -------------------------------------
set number
set nowrap
set encoding=utf-8
set tabstop=4 shiftwidth=4 expandtab
set autoindent
set wildignore=*.pyc,*/__pycache__*

" colors
colorscheme codedark

" -------------------------------------
" general keybindings
" -------------------------------------
" Easy close buffer
nnoremap <C-c> :b#<bar>bd#<bar>b<CR>

" Close all buffers except for the current one
nnoremap <Leader>c :%bd<bar>e#<CR>

" Easy switch buffers
nnoremap <C-j> :bp<CR>
nnoremap <C-k> :bn<CR>
nnoremap <Leader>p :CtrlPBuffer<CR>

" Remove trailing whitespace
nnoremap <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s<CR>

" Toggle line numbers and colorcolumn
nnoremap <F2> :set invnumber<CR> :call <SID>ToggleColorColumn()<CR>

let s:color_column_old = 0
function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction

" -------------------------------------
" netrw
" ------------------------------------
" toggle in left pane
nnoremap <C-n> :Lexplore<CR>

" absolute width of netrw window
let g:netrw_winsize = -28

" do not display info on the top of window
let g:netrw_banner = 0

" tree-view
let g:netrw_liststyle = 3

" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" ignore files
let g:netrw_list_hide= '.*\.swp$,.*\.pyc$,__pycache__'

" use the previous window to open file
let g:netrw_browse_split = 4

" -------------------------------------
" plugin options
" -------------------------------------
" ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|\.pyc$\|__pycache__'

" Tagbar
nnoremap <C-t> :TagbarToggle<CR>

" airline
let g:airline#extensions#tagbar#flags = 'f'

" Ack
nnoremap <Leader>/ :Ack!<Space>
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" ALE
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)
nnoremap <F3> :call ToggleAleFixOnSave()<cr>

function! ToggleAleFixOnSave()
    if g:ale_fix_on_save
        let g:ale_fix_on_save = 0
    else
        let g:ale_fix_on_save = 1
    endif
endfunction
