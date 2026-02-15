#!/bin/bash
# Sync Claude Code plugins to ~/.agent/skills/ for Cursor compatibility
# Run this after installing new Claude Code plugins

set -e

CLAUDE_PLUGINS_DIR="$HOME/.claude/plugins/marketplaces"
AGENT_SKILLS_DIR="$HOME/.agent/skills"

if [ ! -d "$CLAUDE_PLUGINS_DIR" ]; then
    echo "ℹ️  No Claude Code plugins directory found"
    exit 0
fi

mkdir -p "$AGENT_SKILLS_DIR"

synced=0
for marketplace in "$CLAUDE_PLUGINS_DIR"/*/; do
    skills_dir="${marketplace}skills"
    [ -d "$skills_dir" ] || continue
    
    for skill in "$skills_dir"/*/; do
        [ -d "$skill" ] || continue
        skill_name=$(basename "$skill")
        target="$AGENT_SKILLS_DIR/$skill_name"
        
        # Skip if already exists (either as symlink or directory)
        if [ -e "$target" ]; then
            # If it's our symlink pointing to same place, skip silently
            if [ -L "$target" ]; then
                continue
            fi
            echo "⚠️  Skipping $skill_name (already exists as non-symlink)"
            continue
        fi
        
        ln -s "$skill" "$target"
        echo "✅ Linked: $skill_name"
        ((synced++)) || true
    done
done

if [ $synced -eq 0 ]; then
    echo "✅ All Claude Code plugins already synced"
else
    echo "✅ Synced $synced plugin(s) to ~/.agent/skills/"
fi
