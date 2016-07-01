"===============================================
" ���顼����
"===============================================
" ���󥿥å����ϥ��饤�Ȥ�ͭ���ˤ���
syntax enable
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
"if ($ft=='ruby')
"    colorscheme Tomorrow-Night
"else
"    colorscheme solarized
"endif
" ���٤ȥ���ȥ饹�Ȥϡ��ǽ�ϥǥե���Ȥ��Τ���������Ǥ�
" ��ʬ�ϥ���ȥ饹�Ȥ����⤯���Ƥ��ޤ�
" ���٤�⤯����
let g:solarized_visibility = "high"
" ����ȥ饹�Ȥ�⤯����
let g:solarized_contrast = "high"
set t_Co=256
" ���顼�������ޤ� Solarized �ˤ���
colorscheme solarized
"�طʿ��� dark �ˤ���
set background=dark
let g:solarized_termtrans=1

"===================================================================
" vim-indent-guides
"===================================================================
" ����ǥ�Ȥ˥����ɥ饤���Ĥ���
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup=1
" 1����ǥ���ܤ��饬���ɤ���
let g:indent_guides_start_level = 1
" ��ư���顼��̵���ˤ��Ƽ�ư�����ꤹ��
let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=green
" �ϥ��饤�ȿ����Ѳ����� (Terminal �Ǥ�̤���ݡ���)
"let g:indent_guides_color_change_percent = 20
" �����ɤ���
let g:indent_guides_guide_size = 1
" ���������򥤥�ǥ�����˹�碌��
"let g:indent_guides_guide_size = &tabstop
"===================================================================

"��������Ԥ�ϥ��饤��
set cursorline
"set cursorcolumn
"autocmd InsertEnter,InsertLeave * set cursorline!
"autocmd InsertEnter,InsertLeave * set cursorcolumn!
"highlight CursorLine   cterm=NONE ctermfg=NONE ctermbg=NONE
hi clear CursorLine
"highlight CursorColumn cterm=italic ctermfg=NONE ctermbg=NONE

" �����ߥʥ륿���פˤ�륫�顼����
" if &term =~ "xterm-256color" || "screen-256color"
"   " 256��
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

" �䴰����ο��Ť� for vim7
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
