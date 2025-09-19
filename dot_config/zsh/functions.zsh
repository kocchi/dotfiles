# カスタム関数

# ghqとfzfを使ったリポジトリ移動
if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
    function ghq-fzf() {
        local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N ghq-fzf
    bindkey '^]' ghq-fzf
fi

# プロセス終了用の関数
function fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}
