"===============================================
" カラー設定
"===============================================
" シンタックスハイライトを有効にする
syntax enable
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
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
set t_Co=256
" カラースキーマを Solarized にする
colorscheme solarized
"背景色を dark にする
set background=dark
let g:solarized_termtrans=1

"===================================================================
" vim-indent-guides
"===================================================================
" インデントにガイドラインをつける
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup=1
" 1インデント目からガイドする
let g:indent_guides_start_level = 1
" 自動カラーを無効にして手動で設定する
let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=green
" ハイライト色の変化の幅 (Terminal では未サポート)
"let g:indent_guides_color_change_percent = 20
" ガイドの幅
let g:indent_guides_guide_size = 1
" ガイド幅をインデント幅に合わせる
"let g:indent_guides_guide_size = &tabstop
"===================================================================

"カーソル行をハイライト
set cursorline
"set cursorcolumn
"autocmd InsertEnter,InsertLeave * set cursorline!
"autocmd InsertEnter,InsertLeave * set cursorcolumn!
"highlight CursorLine   cterm=NONE ctermfg=NONE ctermbg=NONE
hi clear CursorLine
"highlight CursorColumn cterm=italic ctermfg=NONE ctermbg=NONE

" ターミナルタイプによるカラー設定
" if &term =~ "xterm-256color" || "screen-256color"
"   " 256色
"   set t_Co=256
"   set t_Sf=[3%dm
"   set t_Sb=[4%dm
" elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
"   set t_Co=16
"   set t_Sf=[3%dm
"   set t_Sb=[4%dm
" elseif &term =~ "xterm-color"
"   set t_Co=8
"   set t_Sf=[3%dm
"   set t_Sb=[4%dm
" endif

" 補完候補の色づけ for vim7
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
