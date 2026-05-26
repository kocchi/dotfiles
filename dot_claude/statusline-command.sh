#!/bin/sh
# Claude Code statusLine command
# Display: current branch + PR inline on line 1, submodule PRs as tree below
#
# Example:
#   user@host dir feat/foo │ model ctx:15% #12
#     ├─ kencom feat/bar #34
#     └─ kp-amber feat/baz #56
#
# PR of current worktree is shown inline at the end of line 1 (no separate ● row).
# Submodule PRs are shown only when they exist.
#
# Color palette (256-color):
#   muted gray  = 38;5;102    bright blue = 38;5;75
#   golden      = 38;5;221    sky cyan    = 38;5;81
#   warm white  = 38;5;252    dark gray   = 38;5;240
#   soft pink   = 38;5;217    lavender    = 38;5;146
#   orange      = 38;5;214

input=$(cat)

cwd=$(echo "$input"   | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input"  | jq -r '.context_window.used_percentage // empty')
sid=$(echo "$input"   | jq -r '.session_id // empty')

# ctx% をファイルに書き出し（hooks からの参照用）
if [ -n "$used" ]; then
  ctx_file="/tmp/claude-ctx-${SESSION_ID:-unknown}.json"
  # session_id が入力にあれば使う、なければ PID ベース
  _sid=$(echo "$input" | jq -r '.session_id // empty')
  [ -n "$_sid" ] && ctx_file="/tmp/claude-ctx-${_sid}.json"
  printf '{"used_percentage":%.1f,"timestamp":"%s"}\n' "$used" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$ctx_file"
fi

user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")

# --- Line 1: user@host dir branch | model ctx:N% ---
branch=""
git_common=""
git_dir=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    git_common=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)
    git_dir=$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)
fi

line=$(printf "\033[38;5;102m%s@%s\033[0m \033[1;38;5;75m%s\033[0m" "$user" "$host" "$dir")
[ -n "$branch" ] && line="$line $(printf "\033[38;5;221m%s\033[0m" "$branch")"
[ -n "$model" ]  && line="$line $(printf "\033[38;5;240m│ %s\033[0m" "$model")"
[ -n "$used" ]   && line="$line $(printf "\033[38;5;240mctx:%.0f%%\033[0m" "$used")"
[ -n "$sid" ]    && line="$line $(printf "\033[38;5;240m-r \033[38;5;102m%s\033[0m" "$sid")"

# --- Worktree list + submodule tree ---

# Resolve main worktree root (where .git dir lives) and current worktree root
main_wt=""
cur_wt=""
if [ -n "$branch" ]; then
    cur_wt=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$git_common" ] && [ "$git_common" != "$git_dir" ]; then
        main_wt=$(cd "$git_common" && cd .. && pwd)
    else
        main_wt="$cur_wt"
    fi
fi

if [ -n "$main_wt" ]; then
    hash=$(echo "$main_wt" | md5 -q 2>/dev/null || echo "$main_wt" | md5sum 2>/dev/null | cut -d' ' -f1)
    cache_dir="/tmp/claude-sl-${hash}"
    # prs_file: PR-resolved data — type TAB wt_path TAB branch TAB pr_num TAB pr_url TAB parent_wt
    # pr_num/pr_url are empty when no open PR exists; rows are always written so display works immediately
    prs_file="$cache_dir/prs"
    snapshot="$cache_dir/branches"
    mkdir -p "$cache_dir"

    # Snapshot: all worktrees + submodule branches, used to detect when PRs need re-resolving
    # Format: type TAB path TAB branch TAB parent_wt
    {
        git -C "$main_wt" worktree list --porcelain 2>/dev/null | awk '
            /^worktree / { path = substr($0, 10) }
            /^branch /   { b = substr($0, 8); sub("refs/heads/", "", b); printf "wt\t%s\t%s\t\n", path, b }
        '
        git -C "$main_wt" worktree list --porcelain 2>/dev/null | awk '/^worktree /{ print substr($0, 10) }' | while read -r wt; do
            git -C "$wt" submodule --quiet foreach --recursive \
                "echo \"sm\t${wt}/\$sm_path\t\$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)\t${wt}\"" 2>/dev/null
        done
    } | sort > "${snapshot}.new"

    needs_refresh=0
    if [ ! -f "$snapshot" ]; then
        needs_refresh=1
    elif ! diff -q "$snapshot" "${snapshot}.new" >/dev/null 2>&1; then
        needs_refresh=1
    fi
    mv "${snapshot}.new" "$snapshot"

    # Background PR resolution: triggered only when branch state changes
    # Stores full-path rows so display-time awk can match wt_path == cur_wt exactly
    if [ "$needs_refresh" -eq 1 ]; then
        rm -f "$prs_file"
        (
            TAB="$(printf '\t')"
            while IFS="$TAB" read -r type path br parent_wt; do
                [ -z "$type" ] && continue
                num=""; url=""
                remote=$(git -C "$path" remote get-url origin 2>/dev/null)
                if [ -n "$remote" ]; then
                    slug=$(echo "$remote" | sed -E 's#^(https://github\.com/|git@github\.com:)##; s/\.git$//')
                    if [ -n "$slug" ]; then
                        json=$(gh pr view "$br" --repo "$slug" --json number,url 2>/dev/null)
                        if [ -n "$json" ]; then
                            num=$(echo "$json" | jq -r '.number // empty')
                            url=$(echo "$json" | jq -r '.url // empty')
                        fi
                    fi
                fi
                # wt rows: parent_wt = path itself (used as group key for submodule matching)
                stored_parent="$parent_wt"
                [ "$type" = "wt" ] && stored_parent="$path"
                printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$type" "$path" "$br" "$num" "$url" "$stored_parent"
            done < "$snapshot" > "${prs_file}.tmp"
            mv "${prs_file}.tmp" "$prs_file"
        ) &
    fi

    # Display: render at call time with cur_wt injected
    # Current worktree's PR → append to line 1 (no duplicate ● row)
    # Submodules of current worktree → tree below
    if [ -f "$prs_file" ] && [ -s "$prs_file" ]; then
        pr_and_tree=$(awk -F'\t' -v cur_wt="$cur_wt" '
            function osc8(url, text) {
                return "\033]8;;" url "\033\\" text "\033]8;;\033\\"
            }
            function pr_link(num, url) {
                if (num == "") return ""
                return "\033[38;5;81m" osc8(url, "#" num) "\033[0m"
            }
            BEGIN { sm_count = 0 }
            {
                type = $1; path = $2; br = $3; num = $4; url = $5; parent = $6
                if (type == "wt" && path == cur_wt) {
                    wt_num = num; wt_url = url
                } else if (type == "sm" && parent == cur_wt && num != "") {
                    label = path; sub("^.*/", "", label)
                    key = label "|" br
                    if (!(key in seen)) {
                        seen[key] = 1
                        sm_count++
                        sm_labels[sm_count]   = label
                        sm_branches[sm_count] = br
                        sm_nums[sm_count]     = num
                        sm_urls[sm_count]     = url
                    }
                }
            }
            END {
                # line 1 suffix: PR link for current worktree (or empty)
                printf "%s", pr_link(wt_num, wt_url)
                # line 2+: submodule tree (only if submodules have PRs)
                for (i = 1; i <= sm_count; i++) {
                    connector = (i == sm_count) ? "└─" : "├─"
                    printf "\n  \033[38;5;240m%s\033[0m \033[38;5;217m%s\033[0m \033[38;5;146m%s\033[0m %s", \
                        connector, sm_labels[i], sm_branches[i], pr_link(sm_nums[i], sm_urls[i])
                }
            }
        ' "$prs_file")
        [ -n "$pr_and_tree" ] && line="$line $pr_and_tree"
    fi
fi

printf "%s" "$line"
