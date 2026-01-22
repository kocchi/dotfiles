# zsh補完設定
autoload -U compinit

# 補完キャッシュの最適化（1日に1回のみチェック）
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit -u
else
    compinit -C -u
fi

# 補完候補をメニュー選択可能に
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select

# 補完マッチング
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 補完表示
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# 色付き補完
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 補完順序
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# ディレクトリ補完
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# プロセス補完
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Git補完強化
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-*:*' group-order heads-local heads-remote branches-local branches-remote

# 補完キャッシュ
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# 補完動作
setopt COMPLETE_IN_WORD    # 単語の途中でも補完
setopt ALWAYS_TO_END       # 補完後にカーソルを末尾に移動
setopt AUTO_MENU           # 連続でTabを押すとメニュー補完
setopt AUTO_LIST           # 補完候補を自動で一覧表示
setopt AUTO_PARAM_SLASH    # ディレクトリ名の補完で末尾にスラッシュを追加
setopt FLOW_CONTROL        # フロー制御を有効
unsetopt MENU_COMPLETE     # 最初のTabで補完候補を表示
