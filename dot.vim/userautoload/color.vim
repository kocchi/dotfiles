"===============================================
" ¥«¥é¡¼ÀßÄê
"===============================================
" ¥·¥ó¥¿¥Ã¥¯¥¹¥Ï¥¤¥é¥¤¥È¤òÍ­¸ú¤Ë¤¹¤ë
syntax enable
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
"ÇØ·Ê¿§¤ò dark ¤Ë¤¹¤ë
set background=dark
"if ($ft=='ruby')
"    colorscheme Tomorrow-Night
"else
"    colorscheme solarized
"endif
" µ±ÅÙ¤È¥³¥ó¥È¥é¥¹¥È¤Ï¡¢ºÇ½é¤Ï¥Ç¥Õ¥©¥ë¥È¤ò»î¤¹¤Î¤¬¥ª¥¹¥¹¥á¤Ç¤¹
" ¼«Ê¬¤Ï¥³¥ó¥È¥é¥¹¥È¤À¤±¹â¤¯¤·¤Æ¤¤¤Þ¤¹
" µ±ÅÙ¤ò¹â¤¯¤¹¤ë
let g:solarized_visibility = "high"
" ¥³¥ó¥È¥é¥¹¥È¤ò¹â¤¯¤¹¤ë
let g:solarized_contrast = "high"
" ¥«¥é¡¼¥¹¥­¡¼¥Þ¤ò Solarized ¤Ë¤¹¤ë
colorscheme solarized
set t_Co=256

" ¥¤¥ó¥Ç¥ó¥È¤Ë¥¬¥¤¥É¥é¥¤¥ó¤ò¤Ä¤±¤ë
NeoBundle 'nathanaelkane/vim-indent-guides'
" vim-indent-guides
" Vim µ¯Æ°»þ vim-indent-guides ¤ò¼«Æ°µ¯Æ°
let g:indent_guides_enable_on_vim_startup=1
" ¥¬¥¤¥É¤ò¥¹¥¿¡¼¥È¤¹¤ë¥¤¥ó¥Ç¥ó¥È¤ÎÎÌ
let g:indent_guides_start_level=2
" ¼«Æ°¥«¥é¡¼Ìµ¸ú
let g:indent_guides_auto_colors=0
" ¥¬¥¤¥É¤ÎÉý
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#444433 ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#444433 ctermbg=black
".t¤È.psgi¤Î¥·¥ó¥¿¥Ã¥¯¥¹¥Ï¥¤¥é¥¤¥È
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

hi clear Cursorcolumn
hi Cursorcolumn gui=underline
highlight CursorColumn ctermbg=black guibg=black

" ¥¿¡¼¥ß¥Ê¥ë¥¿¥¤¥×¤Ë¤è¤ë¥«¥é¡¼ÀßÄê
if &term =~ "xterm-256color" || "screen-256color"
  " 256¿§
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Êä´°¸õÊä¤Î¿§¤Å¤± for vim7
" hi Pmenu ctermbg=255 ctermfg=0 guifg=#000000 guibg=#999999
" hi PmenuSel ctermbg=blue ctermfg=black
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
" hi PmenuSbar ctermbg=0 ctermfg=9
" hi PmenuSbar ctermbg=255 ctermfg=0 guifg=#000000 guibg=#FFFFFF

" md as markdown, instead of modula2
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
au BufRead,BufNewFile *.md set filetype=markdown
"===============================================
