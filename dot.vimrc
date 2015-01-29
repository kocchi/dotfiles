"filetype plugin indent off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
endif

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
call neobundle#end()

set runtimepath+=~/.vim/
runtime! userautoload/*.vim

filetype plugin indent on     " required!
filetype indent on

"-----------------------------------------------------------------------------
command! Gcc call s:Gcc()
nmap <F6> :Gcc<CR>

function! s:Gcc()
    :w
    :!gcc % -o %.out
    :!%.out
endfunction
"-----------------------------------------------------------------------------
