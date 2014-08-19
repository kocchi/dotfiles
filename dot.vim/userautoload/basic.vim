set nocompatible               " be iMproved
set fileencodings=euc-jp,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,utf-8,sjis,cp932,
set fileencoding=euc-jp
set encoding=utf-8

set number
set laststatus=2
set statusline=%f\ [%{&fenc==''?&enc:&fenc}][%{&ff}]%=%8l:%c%8P

"スペルチェック
"set spell

"カーソル行をハイライト
set cursorline
set cursorcolumn
" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorcolumn
    autocmd WinEnter,BufRead * set cursorcolumn
augroup END

"" 挿入モード中に'Ctr-*'でコマンドモードでの移動・削除を可能にする
inoremap <c-d> <delete>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>

"テンプレートの設定================================
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl-script.txt
autocmd BufNewFile *.t  0r $HOME/.vim/template/perl-test.txt
"===================================================

"set title "編集中のファイル名を表示する
set showcmd "入力中のコマンドを表示する
set ruler "座標を表示する
set showmatch   "閉じ括弧の入力時に対応する括弧を表示する
set matchtime=3 "showmatchの表示時間
set laststatus=2 "ステータスラインを常に表示する

set shiftwidth=4    "行頭での<Tab>の幅
set tabstop=4   "行頭以外での<Tab>の幅
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2

set autoindent
set expandtab
set list
set listchars=tab:>-,extends:<,trail:-

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#ffffff
au BufNewFile,BufRead * match ZenkakuSpace /　/

" ビープ音 ビジュアルベルを使用しない
set vb t_vb=
