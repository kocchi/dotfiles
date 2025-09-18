#!/bin/bash

# macOS開発環境セットアップスクリプト (2025年版)
set -euo pipefail

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# エラーハンドリング
error_exit() {
    log_error "$1"
    exit 1
}

# コマンド存在チェック
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# macOSチェック
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error_exit "このスクリプトはmacOS専用です"
    fi
    log_success "macOS環境を確認しました"
}

# Homebrewのインストール
install_homebrew() {
    if command_exists brew; then
        log_info "Homebrewは既にインストールされています"
        brew update
    else
        log_info "Homebrewをインストールしています..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # パスを設定
        if [[ -d "/opt/homebrew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    log_success "Homebrewの準備が完了しました"
}

# 基本的なCLIツールのインストール
install_cli_tools() {
    log_info "CLIツールをインストールしています..."
    
    # システム版で十分なツール（既存の場合はスキップ）
    local system_tools=(
        "curl"
        "wget"
    )
    
    # 開発に重要なツール（Homebrew版を推奨）
    local dev_tools=(
        "git"          # システム版は古い場合が多い
        "tree"         # システム版は機能限定
    )
    
    # Homebrew専用ツール（システムにはない）
    local homebrew_tools=(
        # 新しいUNIXツールの代替
        "ripgrep"      # grep代替
        "fd"           # find代替
        "bat"          # cat代替
        "eza"          # ls代替（ezaはexaの後継）
        "procs"        # ps代替
        "dust"         # du代替
        "bottom"       # top代替
        "zoxide"       # cd代替
        
        # ファジーファインダー
        "fzf"
        
        # 開発ツール
        "gh"           # GitHub CLI
        "neovim"
        "tmux"
        "ghq"          # リポジトリ管理
        "chezmoi"      # dotfiles管理
        "delta"        # git diff改善
        "htop"
        "jq"           # JSON処理
        "yq"           # YAML処理
        
        # zsh拡張
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "zsh-completions"
        
        # プロンプト
        "starship"
        
        # その他便利ツール
        "httpie"       # curl代替
        "tldr"         # man代替
        "trash"        # rm代替
    )
    
    # システム版で十分なツールのチェック
    for tool in "${system_tools[@]}"; do
        if command_exists "$tool"; then
            log_info "$tool はシステム版を使用します（スキップ）"
        elif brew list "$tool" >/dev/null 2>&1; then
            log_info "$tool は既にHomebrew版がインストールされています"
        else
            log_info "$tool をインストールしています..."
            brew install "$tool"
        fi
    done
    
    # 開発ツール（Homebrew版推奨）
    for tool in "${dev_tools[@]}"; do
        if brew list "$tool" >/dev/null 2>&1; then
            log_info "$tool は既にHomebrew版がインストールされています"
        elif command_exists "$tool"; then
            log_warning "$tool はシステム版が見つかりました。Homebrew版に更新します"
            brew install "$tool"
        else
            log_info "$tool をインストールしています..."
            brew install "$tool"
        fi
    done
    
    # Homebrew専用ツール
    for tool in "${homebrew_tools[@]}"; do
        if brew list "$tool" >/dev/null 2>&1; then
            log_info "$tool は既にインストールされています"
        else
            log_info "$tool をインストールしています..."
            brew install "$tool"
        fi
    done
    
    log_success "CLIツールのインストールが完了しました"
}

# asdfのインストールと設定
install_asdf() {
    if command_exists asdf; then
        log_info "asdfは既にインストールされています"
    else
        log_info "asdf（言語バージョン管理）をインストールしています..."
        brew install asdf
        
        # zshrcに設定を追加
        echo -e "\n# asdf" >> ~/.zshrc
        echo "source $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
        source $(brew --prefix asdf)/libexec/asdf.sh
    fi
    
    # よく使われる言語のプラグインをインストール
    local plugins=("nodejs" "python" "ruby" "rust" "golang")
    
    for plugin in "${plugins[@]}"; do
        if asdf plugin list | grep -q "$plugin"; then
            log_info "$plugin プラグインは既にインストールされています"
        else
            log_info "$plugin プラグインをインストールしています..."
            asdf plugin add "$plugin"
        fi
    done
    
    log_success "asdfの設定が完了しました"
}

# tmuxプラグインマネージャーのセットアップ
setup_tmux_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    if [[ -d "$tpm_dir" ]]; then
        log_info "tmux plugin manager (tpm) は既にインストールされています"
    else
        log_info "tmux plugin manager (tpm) をインストールしています..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
    
    log_success "tmux plugin managerの設定が完了しました"
    log_info "tmux起動後に 'prefix + I' でプラグインをインストールしてください"
}

# Starshipの設定
setup_starship() {
    local config_dir="$HOME/.config"
    local starship_config="$config_dir/starship.toml"
    
    mkdir -p "$config_dir"
    
    if [[ -f "$starship_config" ]]; then
        log_info "Starshipの設定ファイルは既に存在します"
    else
        log_info "Starshipの設定ファイルを作成しています..."
        cat > "$starship_config" << 'EOF'
# Starshipプロンプト設定

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$golang\
$ruby\
$cmd_duration\
$line_break\
$character"""

[directory]
style = "blue bold"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[❯](purple)"
error_symbol = "[❯](red)"
vimcmd_symbol = "[❮](green)"

[git_branch]
symbol = "🌱 "
format = "[$symbol$branch]($style) "
style = "bright-green"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "cyan"

[nodejs]
symbol = " "
style = "bright-green"

[python]
symbol = " "
style = "bright-blue"

[rust]
symbol = " "
style = "bright-red"

[golang]
symbol = " "
style = "bright-cyan"

[ruby]
symbol = " "
style = "bright-red"

[cmd_duration]
min_time = 2_000
format = "took [$duration](bold yellow)"
EOF
    fi
    
    log_success "Starshipの設定が完了しました"
}

# chezmoiのインストールと設定適用
setup_chezmoi() {
    if command_exists chezmoi; then
        log_info "chezmoiは既にインストールされています"
    else
        log_info "chezmoiをインストールしています..."
        brew install chezmoi
    fi
    
    local dotfiles_dir="$HOME/.local/share/chezmoi"
    
    if [[ ! -d "$dotfiles_dir" ]]; then
        error_exit "chezmoiディレクトリが見つかりません: $dotfiles_dir"
    fi
    
    log_info "chezmoiでdotfilesを適用しています..."
    chezmoi apply
    log_success "dotfilesの適用が完了しました"
}

# メイン実行部分
main() {
    log_info "macOS開発環境のセットアップを開始します"
    
    check_macos
    install_homebrew
    install_cli_tools
    install_asdf
    setup_tmux_tpm
    setup_starship
    setup_chezmoi
    
    log_success "セットアップが完了しました！"
    log_info "以下の追加作業を行ってください："
    echo "  1. ターミナルを再起動してください"
    echo "  2. tmuxを起動して 'prefix + I' でプラグインをインストール"
    echo "  3. Neovimを起動してプラグインの自動インストールを確認"
    echo "  4. 'asdf install <language> latest' で必要な言語をインストール"
    echo ""
    log_info "追加のヘルプが必要な場合は README.md を確認してください"
}

# スクリプト実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
