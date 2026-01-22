# カスタム関数

# ghqとfzfを使ったリポジトリ移動（zleが利用可能な場合のみ）
if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1 && zmodload -e zsh/zle 2>/dev/null; then
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

# Playwright MCP ランチャー
function mcpw() {
    local cmd
    if command -v @playwright/mcp >/dev/null 2>&1; then
        cmd=(@playwright/mcp)
    elif command -v playwright-mcp >/dev/null 2>&1; then
        cmd=(playwright-mcp)
    else
        cmd=(npx -y @playwright/mcp)
    fi

    # 代表的なcapabilitiesをワンショットで有効化できるショートカット
    # 例: mcpw all -> 全capを有効化
    if [[ ${1-} == "all" ]]; then
        shift
        exec "${cmd[@]}" --caps=vision,pdf,tracing,verify "$@"
    fi

    exec "${cmd[@]}" "$@"
}
