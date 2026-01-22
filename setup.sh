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

# Brewfileを使ったCLIツールのインストール
install_cli_tools() {
    log_info "Brewfileを使ってCLIツールをインストールしています..."
    
    local brewfile="$HOME/.local/share/chezmoi/Brewfile"
    
    if [[ ! -f "$brewfile" ]]; then
        log_warning "Brewfileが見つかりません: $brewfile"
        log_info "基本的なツールのみインストールします..."
        
        # Brewfileが無い場合の最小限インストール
        local essential_tools=("git" "neovim" "tmux" "fzf" "ripgrep" "chezmoi")
        for tool in "${essential_tools[@]}"; do
            if ! brew list "$tool" >/dev/null 2>&1; then
                log_info "$tool をインストールしています..."
                brew install "$tool"
            fi
        done
    else
        log_info "Brewfileからパッケージをインストールしています..."
        cd "$(dirname "$brewfile")"
        brew bundle install --file="$brewfile"
    fi
    
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

# Starshipの設定チェック
setup_starship() {
    local config_dir="$HOME/.config"
    local starship_config="$config_dir/starship.toml"
    
    mkdir -p "$config_dir"
    
    if [[ -f "$starship_config" ]]; then
        log_info "Starshipの設定ファイルは既に存在します"
    else
        log_warning "Starshipの設定ファイルが見つかりません"
        log_info "chezmoiでdotfilesを適用すると設定ファイルが作成されます"
    fi
    
    log_success "Starshipの設定確認が完了しました"
}

# Agent Skills のセットアップ (Cursor & Claude Code 共通)
setup_agent_skills() {
    log_info "Agent Skills をセットアップしています..."
    
    local agent_skills_dir="$HOME/.agent/skills"
    local claude_skills_link="$HOME/.claude/skills"
    local cursor_skills_link="$HOME/.cursor/skills"
    local claude_settings="$HOME/.claude/settings.json"
    
    # ~/.agent/skills ディレクトリの確認（自作 Skill 用）
    if [[ -d "$agent_skills_dir" ]]; then
        log_info "Agent Skills ディレクトリは既に存在します: $agent_skills_dir"
    else
        mkdir -p "$agent_skills_dir"
        log_success "Agent Skills ディレクトリを作成しました: $agent_skills_dir"
    fi
    
    # シンボリックリンクの確認
    if [[ -L "$claude_skills_link" ]]; then
        log_info "Claude Code用シンボリックリンクは既に存在します"
    else
        log_info "chezmoiでdotfilesを適用するとシンボリックリンクが作成されます"
    fi
    
    if [[ -L "$cursor_skills_link" ]]; then
        log_info "Cursor用シンボリックリンクは既に存在します"
    else
        log_info "chezmoiでdotfilesを適用するとシンボリックリンクが作成されます"
    fi
    
    # Plugin 設定ファイルの確認
    if [[ -f "$claude_settings" ]]; then
        log_info "Claude Code Plugin 設定が存在します"
        log_info "設定されているプラグイン:"
        grep -o '"[^"]*@[^"]*"' "$claude_settings" 2>/dev/null | tr -d '"' | while read plugin; do
            echo "    - $plugin"
        done
    else
        log_warning "Claude Code Plugin 設定が見つかりません"
        log_info "chezmoiでdotfilesを適用すると作成されます"
    fi
    
    log_success "Agent Skills の確認が完了しました"
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
    setup_agent_skills
    
    log_success "セットアップが完了しました！"
    log_info "以下の追加作業を行ってください："
    echo "  1. ターミナルを再起動してください"
    echo "  2. tmuxを起動して 'prefix + I' でプラグインをインストール"
    echo "  3. Neovimを起動してプラグインの自動インストールを確認"
    echo "  4. 'asdf install <language> latest' で必要な言語をインストール"
    echo ""
    log_info "Claude Code / Cursor のプラグイン設定："
    echo "  - プラグインは settings.json で管理されています"
    echo "  - Claude Code 起動後、/plugin コマンドで確認・追加できます"
    echo "  - 自作 Skill は ~/.agent/skills/ に配置してください"
    echo ""
    log_info "追加のヘルプが必要な場合は README.md を確認してください"
}

# スクリプト実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
