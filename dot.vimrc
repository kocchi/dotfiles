set nocompatible               " be iMproved
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" originalrepos on github
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'petdance/vim-perl'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

"����åץܡ������Ѥ������ɲ�
NeoBundle 'kana/vim-fakeclip.git'
NeoBundle 'Shougo/neomru.vim'
set clipboard+=unnamed

" ���󥿥å��������å�
NeoBundle 'scrooloose/syntastic'
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

"yank to remote
let g:y2r_config = {
            \   'tmp_file': '/tmp/exchange_file',
            \   'key_file': expand('$HOME') . '/.exchange.key',
            \   'host': 'localhost',
            \   'port': 52224,
            \}
function Yank2Remote()
    call writefile(split(@", '\n'), g:y2r_config.tmp_file, 'b')
    let s:params = ['cat %s %s | nc -w1 %s %s']
    for s:item in ['key_file', 'tmp_file', 'host', 'port']
        let s:params += [shellescape(g:y2r_config[s:item])]
    endfor
    let s:ret = system(call(function('printf'), s:params))
endfunction
nnoremap <silent> <unique> <Leader>y :call Yank2Remote()<CR>

"powerline
NeoBundle 'itchyny/lightline.vim'
" lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \   'readonly': '%{&readonly?"\u2b64":""}',
      \ },
      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
      \ }

" ���顼����
set t_Co=256

NeoBundleCheck



"" unite.vim {{{
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    <Leader>f [unite]

" unite.vim keymap
" https://github.com/alwei/dotfiles/blob/3760650625663f3b08f24bc75762ec843ca7e112/.vimrc
nnoremap [unite]u  :<C-u>Unite -no-split<Space>
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> ,vr :UniteResume<CR>

" vinarise
let g:vinarise_enable_auto_detect = 1

" unite-build map
nnoremap <silent> ,vb :Unite build<CR>
nnoremap <silent> ,vcb :Unite build:!<CR>
nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>
" ������ɥ���ʬ�䤷�Ƴ���
autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ������ɥ���Ĥ�ʬ�䤷�Ƴ���
autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
"" }}}

"" unite-grep {{{
" insert mode�ǳ���
let g:unite_enable_start_insert = 1

" ��ʸ����ʸ������̤��ʤ�
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" unite-grep�Υ����ޥå�
" grep����
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" ����������֤�ñ���grep����
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" grep������̤κƸƽ�
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" ���򤷤�ʸ�����unite-grep
" https://github.com/shingokatsushima/dotfiles/blob/master/.vimrc
vnoremap /g y:Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
" }}}

""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

"===============================================
" ���顼����
"===============================================
" ���󥿥å����ϥ��饤�Ȥ�ͭ���ˤ���
"NeoBundle 'altercation/vim-colors-solarized'
"syntax enable
"�طʿ��� dark �ˤ���
set background=light
" ���٤ȥ���ȥ饹�Ȥϡ��ǽ�ϥǥե���Ȥ��Τ���������Ǥ�
" ��ʬ�ϥ���ȥ饹�Ȥ����⤯���Ƥ��ޤ�
" ���٤�⤯����
let g:solarized_visibility = "high"
" ����ȥ饹�Ȥ�⤯����
let g:solarized_contrast = "high"
" ���顼�������ޤ� Solarized �ˤ���
" colorscheme solarized
"
"source ~/.dotfiles/.vimrc.colors
"===============================================

filetype plugin indent on     " required!
filetype indent on
syntax on
nmap <Leader>r <plug>(quickrun)

"���ڥ�����å�
"set spell


"set termencoding=utf-8
"set fileencodings=euc-jp,iso-2022-jp,shift-jis
set fileencodings=euc-jp,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,
set fileencoding=euc-jp
set encoding=utf-8
set fenc=utf-8

set number
set laststatus=2
set statusline=%f\ [%{&fenc==''?&enc:&fenc}][%{&ff}]%=%8l:%c%8P

""��ư��appach�Ƶ�ư
autocmd BufWritePre * :! sudo apachectl restart
autocmd BufWritePre * :! perltidy
"autocmd BufWritePre * :! sudo -E /home/training/script/tool/compile_smart


" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Select with <TAB>
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" for snippets
let g:neocomplcache_snippets_dir = "~/.vim/snippets"
imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-n>"
smap <C-k> <Plug>(neocomplcache_snippets_expand)

"-----------------------------------------------------------------------------
command! Gcc call s:Gcc()
nmap <F6> :Gcc<CR>

function! s:Gcc()
    :w
    :!gcc % -o %.out
    :!%.out
endfunction
"-----------------------------------------------------------------------------

" ESC������2�󲡤��Ƚ�λ����
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

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

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

hi clear Cursorcolumn
hi Cursorcolumn gui=underline
highlight CursorColumn ctermbg=black guibg=black

".t��.psgi�Υ��󥿥å����ϥ��饤��
autocmd BufNewFile,BufRead *.psgi   set filetype=perl
autocmd BufNewFile,BufRead *.t      set filetype=perl

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
"

"��¸���Ƽ¹�
"":w + !perl command
map <F4>  :w !perl<CR>
"!perl command
map <F5>  :!perl %<CR>

set title "�Խ���Υե�����̾��ɽ������
set showcmd "������Υ��ޥ�ɤ�ɽ������
set ruler "��ɸ��ɽ������
set showmatch   "�Ĥ���̤����ϻ����б������̤�ɽ������
set matchtime=3 "showmatch��ɽ������
set laststatus=2 "���ơ������饤�����ɽ������

set shiftwidth=4    "��Ƭ�Ǥ�<Tab>����
set tabstop=4   "��Ƭ�ʳ��Ǥ�<Tab>����
set autoindent
set expandtab
set list
set listchars=tab:>-,extends:<,trail:-


"���ѥ��ڡ������в�
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#ffffff
au BufNewFile,BufRead * match ZenkakuSpace /��/
