# User Memory

## Response Style
- Always respond in Japanese (日本語で回答)
- Be concise and direct
- Use code examples when helpful

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

### API Key Setup (manual)
新しい環境では `~/.zshrc.local` に追加:

**個人 PC (Anthropic API):**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

**職場 PC (Bedrock):**
```bash
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=ap-northeast-1
export AWS_BEARER_TOKEN_BEDROCK="your-key"
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096
export MAX_THINKING_TOKENS=1024
export ANTHROPIC_DEFAULT_HAIKU_MODEL=global.anthropic.claude-haiku-4-5-20251001-v1:0
export ANTHROPIC_DEFAULT_SONNET_MODEL=global.anthropic.claude-sonnet-4-5-20250929-v1:0
export ANTHROPIC_DEFAULT_OPUS_MODEL=global.anthropic.claude-opus-4-5-20251101-v1:0
```

### Required Plugins (manual install)
```
/plugin install skill-creator
```

### Claude Plugins → Cursor 自動同期
シェル起動時に自動で `sync-claude-plugins.sh` が実行される。
手動実行も可: `sync-claude-plugins.sh`
