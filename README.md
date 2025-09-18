# macOS開発環境設定 (2025年版)

このリポジトリには、最新のツールとベストプラクティスを反映したmacOS開発環境の設定ファイルが含まれています。

**[chezmoi](https://chezmoi.io/)で管理されることを前提としています。**

## 🚀 主要な特徴

### 📦 含まれているツール

- **Neovim**: lazy.nvimを使用したエディタ設定
- **zsh**: fzf、zsh-autosuggestions、zsh-syntax-highlightingを使用
- **tmux**: 最新の構文とプラグインを使用
- **Starship**: 美しく高速なプロンプト
- **asdf**: 統一的な言語バージョン管理
- **chezmoi**: dotfiles管理ツール
- **新しいCLIツール**: ripgrep, fd, bat, eza, procs, dust, bottom など

### 🛠 改善された機能

- **Vim → Neovim**: LSP、Treesitter、新しいプラグイン
- **peco → fzf**: より高速なファジーファインダー
- **個別言語管理 → asdf**: rbenv, nodebrew, pyenv を asdf に統一
- **古いエイリアス → 新しいツール**: cat→bat, ls→eza, grep→ripgrep など

## 📥 インストール方法

### chezmoiを使用したインストール（推奨）

```bash
# chezmoiをインストール
brew install chezmoi

# リポジトリを初期化
chezmoi init https://github.com/yourusername/dotfiles

# 設定を確認（ドライラン）
chezmoi diff

# 設定を適用
chezmoi apply

# セットアップスクリプトを実行
cd ~/.local/share/chezmoi
./setup.sh
```

### Homebrew自動同期

新しいツールをインストールしたときに自動でdotfilesに反映されます：

```bash
# 通常のbrew installの代わりに
brewi lazygit          # install + Brewfile更新 + コミット確認
brewu unnecessary-tool # uninstall + Brewfile更新
brewup                 # upgrade + Brewfile更新
brewsync               # 手動でBrewfile同期
brewbundle             # Brewfileから復元
```

### 手動インストール

#### 1. 必要なツールのインストール

```bash
# Homebrewのインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 基本ツールのインストール
brew install neovim tmux fzf ripgrep fd bat eza starship asdf
brew install zsh-autosuggestions zsh-syntax-highlighting
```

#### 2. dotfilesの適用

```bash
# リポジトリをクローン
git clone https://github.com/yourusername/dotfiles ~/.local/share/chezmoi

# chezmoiで設定を適用
cd ~/.local/share/chezmoi
chezmoi apply
```

#### 3. プラグインのセットアップ

```bash
# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# asdfプラグインの追加
asdf plugin add nodejs
asdf plugin add python
asdf plugin add ruby
```

## 🔧 設定詳細

### Neovim設定

- **プラグインマネージャー**: lazy.nvim
- **LSP**: mason.nvim + nvim-lspconfig
- **ファイラー**: neo-tree.nvim
- **ファジーファインダー**: telescope.nvim
- **テーマ**: catppuccin
- **自動補完**: nvim-cmp

### zsh設定

- **プロンプト**: Starship
- **補完**: zsh-autosuggestions + zsh-syntax-highlighting
- **ファジーファインダー**: fzf
- **ディレクトリジャンプ**: zoxide
- **言語管理**: asdf

### tmux設定

- **プラグインマネージャー**: tpm
- **キーバインド**: Vimライク
- **テーマ**: Catppuccinカラー
- **機能**: セッション復元、バッテリー表示、クリップボード連携

## 📋 セットアップ後の作業

### 1. ターミナルの再起動

設定を有効にするためにターミナルを再起動してください。

### 2. tmuxプラグインのインストール

```bash
# tmuxを起動
tmux

# プラグインをインストール (prefix + I)
# デフォルトプレフィックス: Ctrl-b
```

### 3. Neovimプラグインの確認

```bash
# Neovimを起動
nvim

# プラグインが自動的にインストールされることを確認
# LSPサーバーも自動でインストールされます
```

### 4. 言語環境のセットアップ

```bash
# Node.js
asdf install nodejs latest
asdf global nodejs latest

# Python
asdf install python latest
asdf global python latest

# Ruby
asdf install ruby latest
asdf global ruby latest
```

## 🔧 chezmoi の使用方法

### 設定ファイルの編集

```bash
# 設定ファイルを編集
chezmoi edit ~/.zshrc

# 変更内容を確認
chezmoi diff

# 変更を適用
chezmoi apply
```

### よく使うchezmoiコマンド

```bash
# 現在の状態を確認
chezmoi status

# 設定ファイルを再適用
chezmoi apply

# 最新のリポジトリから更新
chezmoi update

# 変更をリポジトリにプッシュ
chezmoi git add .
chezmoi git commit -m "Update dotfiles"
chezmoi git push
```

## 🔍 よく使用するキーバインド

### Neovim

- `<Space>` : リーダーキー
- `<Space>e` : ファイルツリー表示
- `<Space>ff` : ファイル検索
- `<Space>fg` : 文字列検索
- `<F6>` : C言語コンパイル&実行

### tmux

- `Ctrl-b |` : 垂直分割
- `Ctrl-b -` : 水平分割
- `Ctrl-b h/j/k/l` : ペイン移動
- `Ctrl-b r` : 設定リロード

### zsh

- `Ctrl-r` : 履歴検索 (fzf)
- `Ctrl-]` : ghqリポジトリ検索
- `..` / `...` / `....` : ディレクトリ移動

## 🆘 トラブルシューティング

### よくある問題

1. **プラグインが読み込まれない**
   - ターミナルを再起動してください
   - パスの設定を確認してください

2. **asdfコマンドが見つからない**
   ```bash
   echo 'source $(brew --prefix asdf)/libexec/asdf.sh' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **fzfが動作しない**
   ```bash
   $(brew --prefix)/opt/fzf/install
   ```

4. **Neovimでエラーが発生する**
   - `:checkhealth` でプラグインの状態を確認
   - `:Lazy sync` でプラグインを更新

## 📚 参考リンク

- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Starship](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [asdf](https://asdf-vm.com/)
- [chezmoi](https://chezmoi.io/)
- [tmux](https://github.com/tmux/tmux)

## 📁 ファイル構成

```
.
├── .chezmoi.toml.tmpl        # chezmoi設定（テンプレート）
├── .chezmoiignore           # chezmoiで管理しないファイル
├── dot_config/              # ~/.config/
│   ├── nvim/
│   │   └── init.lua         # Neovim設定
│   └── starship.toml        # Starshipプロンプト設定
├── dot_tmux.conf            # ~/.tmux.conf
├── dot_zshrc.tmpl           # ~/.zshrc（テンプレート）
├── README.md                # このファイル
└── setup.sh                 # セットアップスクリプト
```

### chezmoiのファイル命名規則

- `dot_` → `.` （例: `dot_zshrc` → `~/.zshrc`）
- `.tmpl` → テンプレート処理される
- `.chezmoiignore` → chezmoiで管理されない

## 🔄 更新履歴

- **2025年版**: 全面的な更新
  - Vim → Neovim (lazy.nvim)
  - peco → fzf
  - 個別言語管理 → asdf
  - 新しいCLIツールの導入
  - Starshipプロンプトの採用