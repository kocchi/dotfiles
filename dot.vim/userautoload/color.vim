"===============================================
" ���顼����
"===============================================
" ���󥿥å����ϥ��饤�Ȥ�ͭ���ˤ���
syntax enable
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
"�طʿ��� dark �ˤ���
set background=dark
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
" ���顼�������ޤ� Solarized �ˤ���
colorscheme solarized
set t_Co=256

" ����ǥ�Ȥ˥����ɥ饤���Ĥ���
NeoBundle 'nathanaelkane/vim-indent-guides'
" vim-indent-guides
" Vim ��ư�� vim-indent-guides ��ư��ư
let g:indent_guides_enable_on_vim_startup=1
" �����ɤ򥹥����Ȥ��륤��ǥ�Ȥ���
let g:indent_guides_start_level=2
" ��ư���顼̵��
let g:indent_guides_auto_colors=0
" �����ɤ���
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#444433 ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#444433 ctermbg=black
".t��.psgi�Υ��󥿥å����ϥ��饤��
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

hi clear Cursorcolumn
hi Cursorcolumn gui=underline
highlight CursorColumn ctermbg=black guibg=black

" �����ߥʥ륿���פˤ�륫�顼����
if &term =~ "xterm-256color" || "screen-256color"
  " 256��
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
