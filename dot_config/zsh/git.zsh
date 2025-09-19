# Git関連のエイリアスと関数

# Gitヘルプ関数
function git-help() {
    echo "🔧 Git エイリアス & 関数一覧"
    echo "=========================="
    echo ""
    echo "📋 基本エイリアス:"
    echo "  g          - git"
    echo "  ga         - git add"
    echo "  gaa        - git add --all"
    echo "  gb         - git branch"
    echo "  gba        - git branch -a"
    echo "  gbd        - git branch -d"
    echo "  gc         - git commit"
    echo "  gcm        - git commit -m"
    echo "  gca        - git commit -a"
    echo "  gcam       - git commit -a -m"
    echo "  gco        - git checkout"
    echo "  gcb        - git checkout -b"
    echo "  gd         - git diff"
    echo "  gds        - git diff --staged"
    echo "  gf         - git fetch"
    echo "  gl         - git log --oneline --graph"
    echo "  gll        - git log (詳細表示)"
    echo "  gp         - git push"
    echo "  gpl        - git pull"
    echo "  gr         - git remote"
    echo "  grv        - git remote -v"
    echo "  gs         - git status"
    echo "  gss        - git status -s"
    echo "  gst        - git stash"
    echo "  gstp       - git stash pop"
    echo ""
    echo "🚀 便利関数:"
    echo "  ggpush     - 現在のブランチをpush"
    echo "  ggpull     - 現在のブランチをpull"
    echo "  ggpnp      - pull → push"
    echo "  ggsup      - upstream設定"
    echo "  glog       - git log --oneline --decorate --graph"
    echo "  gwip       - WIP commit作成"
    echo "  gunwip     - WIP commit取消"
    echo ""
    echo "🎯 fzf強化関数:"
    echo "  gco-fzf    - ブランチ選択checkout"
    echo "  gbd-fzf    - ブランチ選択削除"
    echo "  gshow-fzf  - コミット選択表示"
    echo ""
    echo "🧹 ブランチ整理:"
    echo "  git-prune-branches         - マージ済みブランチ削除"
    echo "  git-prune-branches-dry-run - 削除対象ブランチ確認"
    echo ""
    echo "💡 使用例:"
    echo "  gcm 'fix bug'              # コミット"
    echo "  ggpush                     # 現在のブランチをpush"
    echo "  gco-fzf                    # fzfでブランチ選択"
    echo "  gwip && gco main           # 作業保存して別ブランチへ"
}

# ヘルプエイリアス
alias ghelp='git-help'

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git log --oneline --graph'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status -s'
alias gst='git stash'
alias gstp='git stash pop'

# Git関数
function ggpush() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        echo "現在のブランチを取得できません"
        return 1
    fi
    
    if [ $# -eq 0 ]; then
        git push origin "$branch"
    else
        git push "$@" origin "$branch"
    fi
}

function ggpull() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        echo "現在のブランチを取得できません"
        return 1
    fi
    
    if [ $# -eq 0 ]; then
        git pull origin "$branch"
    else
        git pull "$@" origin "$branch"
    fi
}

function ggpnp() {
    ggpull && ggpush
}

function ggsup() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        echo "現在のブランチを取得できません"
        return 1
    fi
    
    git branch --set-upstream-to=origin/"$branch" "$branch"
}

function glog() {
    git log --oneline --decorate --graph "${@:-HEAD}"
}

function gwip() {
    git add -A
    git rm $(git ls-files --deleted) 2> /dev/null
    git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}

function gunwip() {
    git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1
}

# fzf強化Git関数
if command -v fzf >/dev/null 2>&1; then
    function gco-fzf() {
        local branch
        branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | sed 's/remotes\/origin\///' | sort -u | fzf --prompt="Checkout branch: " --height=20% --border)
        if [ -n "$branch" ]; then
            git checkout "$branch"
        fi
    }
    
    function gbd-fzf() {
        local branch
        branch=$(git branch | grep -v "^\*" | sed 's/^..//' | fzf --prompt="Delete branch: " --height=20% --border)
        if [ -n "$branch" ]; then
            git branch -d "$branch"
        fi
    }
    
    function gshow-fzf() {
        local commit
        commit=$(git log --oneline | fzf --prompt="Show commit: " --height=20% --border | cut -d' ' -f1)
        if [ -n "$commit" ]; then
            git show "$commit"
        fi
    }
fi

# ブランチ整理関数
function git-prune-branches() {
    git fetch --prune origin
    git branch --merged origin/main | grep -vE ' main$|^\*' | xargs -r git branch -d
    git branch --merged origin/master | grep -vE ' master$|^\*' | xargs -r git branch -d
}

function git-prune-branches-dry-run() {
    echo "=== Dry run: branches to be deleted ==="
    git fetch --dry-run --prune origin
    echo "Merged with main:"
    git branch --merged origin/main | grep -vE ' main$|^\*'
    echo "Merged with master:"
    git branch --merged origin/master | grep -vE ' master$|^\*'
}
