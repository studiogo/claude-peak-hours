#!/bin/bash
set -e

echo "Installing Claude Peak Hours..."

REPO="studiogo/claude-peak-hours"
TMP_DIR=$(mktemp -d)
ZIP_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep "browser_download_url.*zip" | cut -d '"' -f 4)

if [ -z "$ZIP_URL" ]; then
    echo "Error: No release found. Building from source..."
    cd "$TMP_DIR"
    git clone "https://github.com/$REPO.git" repo
    cd repo
    bash build.sh
    cp -r "build/Claude Peak Hours.app" /Applications/
else
    curl -sL "$ZIP_URL" -o "$TMP_DIR/app.zip"
    unzip -q "$TMP_DIR/app.zip" -d "$TMP_DIR"
    cp -r "$TMP_DIR/Claude Peak Hours.app" /Applications/
fi

rm -rf "$TMP_DIR"

echo "Installed to /Applications/Claude Peak Hours.app"
echo "Starting..."
open "/Applications/Claude Peak Hours.app"
