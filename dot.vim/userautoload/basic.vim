set nocompatible               " be iMproved
set fileencodings=euc-jp,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,utf-8,sjis,cp932,
set fileencoding=euc-jp
set encoding=utf-8

set number
set laststatus=2
set statusline=%f\ [%{&fenc==''?&enc:&fenc}][%{&ff}]%=%8l:%c%8P

"���ڥ�����å�
"set spell

"��������Ԥ�ϥ��饤��
set cursorline
set cursorcolumn
" �����ȥ�����ɥ��ˤΤ߷��������
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

"" �����⡼�����'Ctr-*'�ǥ��ޥ�ɥ⡼�ɤǤΰ�ư��������ǽ�ˤ���
inoremap <c-d> <delete>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>

"�ƥ�ץ졼�Ȥ�����================================
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl-script.txt
autocmd BufNewFile *.t  0r $HOME/.vim/template/perl-test.txt
"===================================================

"set title "�Խ���Υե�����̾��ɽ������
set showcmd "������Υ��ޥ�ɤ�ɽ������
set ruler "��ɸ��ɽ������
set showmatch   "�Ĥ���̤����ϻ����б������̤�ɽ������
set matchtime=3 "showmatch��ɽ������
set laststatus=2 "���ơ������饤�����ɽ������

set shiftwidth=4    "��Ƭ�Ǥ�<Tab>����
set tabstop=4   "��Ƭ�ʳ��Ǥ�<Tab>����
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2

set autoindent
set expandtab
set list
set listchars=tab:>-,extends:<,trail:-

"���ѥ��ڡ������в�
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#ffffff
au BufNewFile,BufRead * match ZenkakuSpace /��/

" �ӡ��ײ� �ӥ��奢��٥����Ѥ��ʤ�
set vb t_vb=
