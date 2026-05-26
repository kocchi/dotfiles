# User Memory

## Response Style
- Always respond in Japanese (日本語で回答)
- Be concise and direct
- Use code examples when helpful

## Git
- `Co-Authored-By` トレーラーを付けない

## gcloud CLI
- **参照以外の操作は絶対禁止**（list, describe, get のみ。create, delete, update, deploy 等は実行しない）

## Coding Preferences
- Prefer modern syntax and best practices
- Add comments for complex logic
- Follow existing code style in the project

## This Repository (dotfiles/chezmoi)

### Tool Preferences
- リポジトリ管理: `ghq` (`~/ghq/github.com/...`)
- dotfiles 管理: `chezmoi`
- シェル: `zsh`

### GitHub Accounts
- Personal: `kocchi`
- Work: `yuki-hirako_dena`

### Bootstrap 順序
chezmoi → Homebrew → ghq の順でインストールされる。
ghq 依存の処理は `run_once_after_*` で実行すること。

### 関連リポジトリ
- OSS Plugin: `github.com/kocchi/user-model-framework`

### Authentication
OAuth 認証を使用（`claude login` で設定済み）。`apiKeyHelper` は不要。

### Required Plugins (manual install)
```
/plugin install skill-creator
```
