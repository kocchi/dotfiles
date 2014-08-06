"===============================================
" カラー設定
"===============================================
" シンタックスハイライトを有効にする
syntax enable
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
"背景色を dark にする
set background=dark
"if ($ft=='ruby')
"    colorscheme Tomorrow-Night
"else
"    colorscheme solarized
"endif
" 輝度とコントラストは、最初はデフォルトを試すのがオススメです
" 自分はコントラストだけ高くしています
" 輝度を高くする
let g:solarized_visibility = "high"
" コントラストを高くする
let g:solarized_contrast = "high"
" カラースキーマを Solarized にする
colorscheme solarized
set t_Co=256

" インデントにガイドラインをつける
NeoBundle 'nathanaelkane/vim-indent-guides'
" vim-indent-guides
" Vim 起動時 vim-indent-guides を自動起動
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量
let g:indent_guides_start_level=2
" 自動カラー無効
let g:indent_guides_auto_colors=0
" ガイドの幅
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#444433 ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#444433 ctermbg=black
".tと.psgiのシンタックスハイライト
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

hi clear Cursorcolumn
hi Cursorcolumn gui=underline
highlight CursorColumn ctermbg=black guibg=black

" ターミナルタイプによるカラー設定
if &term =~ "xterm-256color" || "screen-256color"
  " 256色
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

" 補完候補の色づけ for vim7
" hi Pmenu ctermbg=255 ctermfg=0 guifg=#000000 guibg=#999999
" hi PmenuSel ctermbg=blue ctermfg=black
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
" hi PmenuSbar ctermbg=0 ctermfg=9
" hi PmenuSbar ctermbg=255 ctermfg=0 guifg=#000000 guibg=#FFFFFF
"===============================================
