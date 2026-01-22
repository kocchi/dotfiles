# Personal Agent Data

このディレクトリは **個人データと設定** を管理します。  
フレームワーク（skills, rules, templates）は別リポジトリで管理。

## 構成

```
~/.agent/
├── agents/                  # 個人用 SubAgents
│   ├── code-reviewer.md
│   ├── debugger.md
│   ├── explorer.md
│   └── test-runner.md
├── data/
│   ├── user_model.yaml      # あなたの User Model
│   └── CHANGELOG.md         # 変更履歴
└── README.md
```

## フレームワークのインストール

```bash
# Claude Code
/plugin install user-model-framework@kocchi

# または手動 (ghq)
ghq get github.com/kocchi/user-model-framework
# symlink で接続
```

## 関連リポジトリ

- [user-model-framework](https://github.com/kocchi/user-model-framework) - OSS Plugin
