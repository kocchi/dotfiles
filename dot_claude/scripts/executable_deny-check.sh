#!/bin/bash

# Claude Code PreToolUse hook: deny-check
# permissions.deny        → 絶対ブロック（COMMAND_DENIED）
# permissions.hook_confirm → 確認付きブロック（COMMAND_BLOCKED）、セッション許可対応

session_dir="$HOME/.claude/scripts"
session_file="$session_dir/bash-allow-session-${PPID}.txt"
settings_file="$HOME/.claude/settings.json"

# 終了済みセッションのファイルをクリーンアップ
for f in "$session_dir"/bash-allow-session-*.txt; do
  [ ! -f "$f" ] && continue
  old_pid=$(echo "$f" | sed 's/.*bash-allow-session-\([0-9]*\)\.txt/\1/')
  if ! kill -0 "$old_pid" 2>/dev/null; then
    rm -f "$f"
  fi
done

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null || echo "")
tool_name=$(echo "$input" | jq -r '.tool_name' 2>/dev/null || echo "")

# Bash コマンドのみをチェック
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# パターン抽出関数
extract_patterns() {
  local key="$1"
  jq -r ".permissions.${key}[]? | select(startswith(\"Bash(\")) | gsub(\"^Bash\\\\(\"; \"\") | gsub(\"\\\\)$\"; \"\")" "$settings_file" 2>/dev/null
}

# パターンマッチ関数
matches_pattern() {
  local cmd="$1"
  local pattern="$2"
  cmd="${cmd#"${cmd%%[![:space:]]*}"}"
  cmd="${cmd%"${cmd##*[![:space:]]}"}"
  [[ "$cmd" == $pattern ]]
}

# セッション許可チェック関数
is_session_allowed() {
  local cmd="$1"
  [ ! -f "$session_file" ] && return 1
  while IFS= read -r allowed_pattern; do
    [ -z "$allowed_pattern" ] && continue
    if matches_pattern "$cmd" "$allowed_pattern"; then
      return 0
    fi
  done < "$session_file"
  return 1
}

# コマンドチェック関数（全体 + 分割パーツ）
check_command() {
  local cmd="$1"
  local patterns="$2"
  local level="$3"  # deny or ask

  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    if matches_pattern "$cmd" "$pattern"; then
      if [ "$level" = "deny" ]; then
        echo "COMMAND_DENIED:${pattern}:${cmd}" >&2
        exit 2
      elif [ "$level" = "ask" ]; then
        # セッション許可があればスキップ
        if is_session_allowed "$cmd"; then
          return 0
        fi
        echo "COMMAND_BLOCKED:${pattern}:${cmd}" >&2
        exit 2
      fi
    fi
  done <<<"$patterns"
}

deny_patterns=$(extract_patterns "deny")
ask_patterns=$(extract_patterns "hook_confirm")

# コマンド全体をチェック（deny → ask の順）
check_command "$command" "$deny_patterns" "deny"
check_command "$command" "$ask_patterns" "ask"

# 論理演算子で分割し各部分もチェック
temp_command="${command//;/$'\n'}"
temp_command="${temp_command//&&/$'\n'}"
temp_command="${temp_command//\|\|/$'\n'}"

IFS=$'\n'
for cmd_part in $temp_command; do
  [ -z "$(echo "$cmd_part" | tr -d '[:space:]')" ] && continue
  check_command "$cmd_part" "$deny_patterns" "deny"
  check_command "$cmd_part" "$ask_patterns" "ask"
done

exit 0
