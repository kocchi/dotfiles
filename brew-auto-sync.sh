#!/bin/bash
# brew-auto-sync.sh - Homebrewインストールの自動同期

set -euo pipefail

DOTFILES_DIR="$HOME/.local/share/chezmoi"
BREWFILE="$DOTFILES_DIR/Brewfile"

# ログ関数
log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# Brewfileを更新する関数
update_brewfile() {
    log_info "Brewfileを更新しています..."
    
    cd "$DOTFILES_DIR"
    
    # 現在インストールされているパッケージからBrewfileを生成
    brew bundle dump --force --file="$BREWFILE"
    
    # gitで変更があるかチェック
    if git diff --quiet "$BREWFILE"; then
        log_info "Brewfileに変更はありません"
        return 0
    fi
    
    log_success "Brewfileを更新しました"
    
    # 自動コミットするかユーザーに確認
    echo "Brewfileの変更内容:"
    git diff "$BREWFILE"
    echo
    
    read -p "この変更をコミットしますか？ (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add "$BREWFILE"
        git commit -m "chore: update Brewfile with newly installed packages"
        
        read -p "リモートにプッシュしますか？ (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push
            log_success "変更をリモートにプッシュしました"
        fi
    fi
}

# メイン関数
main() {
    case "${1:-}" in
        "install")
            shift
            log_info "brew install $*"
            brew install "$@"
            update_brewfile
            ;;
        "uninstall")
            shift
            log_info "brew uninstall $*"
            brew uninstall "$@"
            update_brewfile
            ;;
        "upgrade")
            log_info "brew upgrade"
            brew upgrade
            update_brewfile
            ;;
        "sync")
            update_brewfile
            ;;
        "bundle")
            log_info "Brewfileからパッケージを復元しています..."
            cd "$DOTFILES_DIR"
            brew bundle install --file="$BREWFILE"
            log_success "パッケージの復元が完了しました"
            ;;
        *)
            echo "使用法: $0 {install|uninstall|upgrade|sync|bundle} [packages...]"
            echo
            echo "  install   - パッケージをインストールしてBrewfileを更新"
            echo "  uninstall - パッケージをアンインストールしてBrewfileを更新"
            echo "  upgrade   - 全パッケージを更新してBrewfileを更新"
            echo "  sync      - 現在の状態でBrewfileを更新"
            echo "  bundle    - Brewfileからパッケージをインストール"
            exit 1
            ;;
    esac
}

main "$@"
