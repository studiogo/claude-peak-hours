#!/bin/bash
set -e

SCRIPT_URL="https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/claude-code-statusline.sh"
TARGET="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "Installing Claude Peak Hours status line..."

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install it first:"
    echo "  macOS:  brew install jq"
    echo "  Linux:  sudo apt install jq"
    echo "  Windows: choco install jq"
    exit 1
fi

# Create .claude dir if needed
mkdir -p "$HOME/.claude"

# Backup existing statusline
if [ -f "$TARGET" ]; then
    cp "$TARGET" "${TARGET}.backup"
    echo "Backed up existing statusline to ${TARGET}.backup"
fi

# Download script
curl -sL "$SCRIPT_URL" -o "$TARGET"
chmod +x "$TARGET"
echo "Downloaded statusline script to $TARGET"

# Configure settings.json
if [ -f "$SETTINGS" ]; then
    if grep -q "statusLine" "$SETTINGS"; then
        echo "statusLine already configured in $SETTINGS"
    else
        # Add statusLine to existing settings
        tmp=$(mktemp)
        jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}}' "$SETTINGS" > "$tmp"
        mv "$tmp" "$SETTINGS"
        echo "Added statusLine to $SETTINGS"
    fi
else
    echo '{"statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}}' > "$SETTINGS"
    echo "Created $SETTINGS with statusLine config"
fi

echo ""
echo "Done! Restart Claude Code to see the status line."
echo "To uninstall: curl -sL https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/statusline-uninstall.sh | bash"
