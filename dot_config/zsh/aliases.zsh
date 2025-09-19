# エイリアス定義
if command -v exa >/dev/null 2>&1; then
    alias ls='exa'
    alias ll='exa -l'
    alias la='exa -la'
    alias tree='exa --tree'
elif command -v eza >/dev/null 2>&1; then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias tree='eza --tree'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi

if command -v procs >/dev/null 2>&1; then
    alias ps='procs'
fi

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
fi

if command -v bottom >/dev/null 2>&1; then
    alias top='btm'
fi

# 一般的なエイリアス
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias vim='nvim'
alias vi='nvim'
alias zshconfig='nvim ~/.zshrc'

# Homebrew自動同期エイリアス
if [[ -x "$HOME/.local/share/chezmoi/brew-auto-sync.sh" ]]; then
    alias brewi='$HOME/.local/share/chezmoi/brew-auto-sync.sh install'    # brew install + 自動同期
    alias brewu='$HOME/.local/share/chezmoi/brew-auto-sync.sh uninstall'  # brew uninstall + 自動同期
    alias brewup='$HOME/.local/share/chezmoi/brew-auto-sync.sh upgrade'   # brew upgrade + 自動同期
    alias brewsync='$HOME/.local/share/chezmoi/brew-auto-sync.sh sync'    # Brewfile手動同期
    alias brewbundle='$HOME/.local/share/chezmoi/brew-auto-sync.sh bundle' # Brewfileから復元
fi
