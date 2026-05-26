# カスタム関数

# GitHub アカウント自動切り替え (ディレクトリベース)
function _auto_switch_gh_account() {
    local current_dir="$PWD"
    local target_account=""
    
    # kocchi のリポジトリ
    if [[ "$current_dir" == *"/ghq/github.com/kocchi/"* ]] || \
       [[ "$current_dir" == "$HOME/.local/share/chezmoi"* ]]; then
        target_account="kocchi"
    # 仕事用 (デフォルト)
    elif [[ "$current_dir" == *"/ghq/github.com/"* ]]; then
        target_account="yuki-hirako_dena"
    fi
    
    # 切り替えが必要な場合のみ実行
    if [[ -n "$target_account" ]]; then
        local current_account=$(gh auth status 2>&1 | grep "Active account: true" -B2 | head -1 | awk '{print $NF}' 2>/dev/null)
        if [[ "$current_account" != "$target_account" ]]; then
            gh auth switch -u "$target_account" 2>/dev/null && \
                echo "🔄 gh: switched to $target_account"
        fi
    fi
}

# ディレクトリ変更時に自動実行
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_switch_gh_account

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

# Claude Code / Codex: ghq+fzf でプロジェクトへ移動し前回セッションを再開
# （Ghostty が分割レイアウトと cwd を復元 → ここで会話を再開、で作業復旧率を最大化）
if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
    # ccr    : ディレクトリ選択 → 最新の Claude 会話を継続 (claude --continue)
    # ccr r  : ディレクトリ選択 → 会話ピッカー (claude --resume)
    function ccr() {
        local dir
        dir=$(ghq list -p | fzf --prompt="claude resume> ") || return
        cd "$dir" || return
        if [[ "${1-}" == "r" ]]; then claude --resume; else claude --continue; fi
    }
    # cxr    : ディレクトリ選択 → 最新の Codex セッションを継続 (codex resume --last)
    # cxr r  : ディレクトリ選択 → セッションピッカー (codex resume)
    function cxr() {
        local dir
        dir=$(ghq list -p | fzf --prompt="codex resume> ") || return
        cd "$dir" || return
        if [[ "${1-}" == "r" ]]; then codex resume; else codex resume --last; fi
    }
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

# Claude Code プラグインを Cursor と同期（シェル起動時に自動実行）
if [[ -x "$HOME/.local/bin/sync-claude-plugins.sh" ]]; then
    "$HOME/.local/bin/sync-claude-plugins.sh" &>/dev/null &
fi
