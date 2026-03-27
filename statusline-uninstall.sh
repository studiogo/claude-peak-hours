#!/bin/bash
set -e

TARGET="$HOME/.claude/statusline.sh"
BACKUP="${TARGET}.backup"
SETTINGS="$HOME/.claude/settings.json"

echo "Uninstalling Claude Peak Hours status line..."

# Remove script
if [ -f "$TARGET" ]; then
    rm "$TARGET"
    echo "Removed $TARGET"
fi

# Restore backup if exists
if [ -f "$BACKUP" ]; then
    mv "$BACKUP" "$TARGET"
    echo "Restored previous statusline from backup"
fi

# Remove statusLine from settings.json
if [ -f "$SETTINGS" ] && grep -q "statusLine" "$SETTINGS"; then
    tmp=$(mktemp)
    jq 'del(.statusLine)' "$SETTINGS" > "$tmp"
    mv "$tmp" "$SETTINGS"
    echo "Removed statusLine from $SETTINGS"
fi

echo ""
echo "Done! Restart Claude Code to apply changes."
