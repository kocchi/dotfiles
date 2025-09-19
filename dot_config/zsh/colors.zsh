# 色設定とテーマ

# LS_COLORSの設定（現代的な色合い）
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34"

# zsh-syntax-highlightingの色設定を上書き
if [[ -n ${ZSH_HIGHLIGHT_STYLES+x} ]]; then
    # コマンド
    ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
    
    # パス
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'
    
    # 文字列
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    
    # オプション
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue'
    
    # エラー
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
    
    # 危険なコマンドパターン
    ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
    ZSH_HIGHLIGHT_PATTERNS+=('sudo rm *' 'fg=white,bold,bg=red')
    ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=yellow,bold')
fi

# zsh-autosuggestionsの色設定
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,italic"

# 補完メニューの色設定
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- No matches found --%f'

# fzfの色設定（Catppuccinテーマ風）
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6ac,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6ac,hl+:#f38ba8
--height 40% --layout=reverse --border --margin=1 --padding=1
--prompt='❯ ' --pointer='❯' --marker='❯'"

# batの色設定
export BAT_THEME="Catppuccin-mocha"

# lessの色設定
export LESS_TERMCAP_mb=$'\e[1;32m'     # begin blinking
export LESS_TERMCAP_md=$'\e[1;32m'     # begin bold
export LESS_TERMCAP_me=$'\e[0m'        # end mode
export LESS_TERMCAP_se=$'\e[0m'        # end standout-mode
export LESS_TERMCAP_so=$'\e[01;33m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'        # end underline
export LESS_TERMCAP_us=$'\e[1;4;31m'   # begin underline

# grepの色設定
export GREP_COLOR='1;32'
export GREP_OPTIONS='--color=auto'
