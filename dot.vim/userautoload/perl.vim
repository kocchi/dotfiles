"保存して実行
"":w + !perl command
map <F4>  :w !perl<CR>
"!perl command
map <F5>  :!perl %<CR>
autocmd BufNewFile,BufRead *.psgi   set filetype=perl
autocmd BufNewFile,BufRead *.t      set filetype=perl

NeoBundle 'petdance/vim-perl'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'motemen/xslate-vim'
