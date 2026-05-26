#!/bin/bash

# Claude Code PreToolUse hook: web-allow-check
# 許可ドメインリストに基づいて Web アクセスを制御する
# 永続リスト: ~/.claude/scripts/web-allow-domains.txt
# セッション許可: ~/.claude/scripts/web-allow-session-{PPID}.txt（PPID ごとに分離）

session_dir="$HOME/.claude/scripts"
session_file="$session_dir/web-allow-session-${PPID}.txt"

# 終了済みセッションのファイルをクリーンアップ
for f in "$session_dir"/web-allow-session-*.txt; do
  [ ! -f "$f" ] && continue
  old_pid=$(echo "$f" | sed 's/.*web-allow-session-\([0-9]*\)\.txt/\1/')
  if ! kill -0 "$old_pid" 2>/dev/null; then
    rm -f "$f"
  fi
done

input=$(cat)
url=$(echo "$input" | jq -r '.tool_input.url' 2>/dev/null || echo "")

# URL がないツール呼び出しは許可
if [ -z "$url" ] || [ "$url" = "null" ]; then
  exit 0
fi

# URL からドメインを抽出
domain=$(echo "$url" | sed -E 's|https?://([^/:]+).*|\1|')

if [ -z "$domain" ]; then
  echo "Error: URL からドメインを抽出できません: $url" >&2
  exit 2
fi

# ドメインチェック関数
check_domain_in_file() {
  local file="$1"
  [ ! -f "$file" ] && return 1

  while IFS= read -r allowed; do
    [ -z "$allowed" ] && continue
    [[ "$allowed" == \#* ]] && continue
    if [ "$domain" = "$allowed" ] || [[ "$domain" == *."$allowed" ]]; then
      return 0
    fi
  done < "$file"
  return 1
}

# 永続許可リストをチェック
if check_domain_in_file "$session_dir/web-allow-domains.txt"; then
  exit 0
fi

# セッション許可リストをチェック
if check_domain_in_file "$session_file"; then
  exit 0
fi

# どちらにもない → ブロック（Claude が選択肢を提示する）
echo "DOMAIN_BLOCKED:$domain:$url" >&2
exit 2
