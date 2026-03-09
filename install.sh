#!/usr/bin/env bash
# install.sh — Claude Session Manager setup
# https://github.com/adp-Lab/claude-session-manager

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect shell config file
if [[ "$SHELL" == *"zsh"* ]]; then
  SHELL_RC="$HOME/.zshrc"
else
  SHELL_RC="$HOME/.bashrc"
fi

echo ""
echo "Claude Session Manager — installer"
echo "-----------------------------------"
echo ""

# Step 1: Add cr function to shell config
if grep -q "function cr()" "$SHELL_RC" 2>/dev/null; then
  echo "[!] cr function already found in $SHELL_RC — skipping."
else
  echo ">> Adding cr function to $SHELL_RC"
  echo "" >> "$SHELL_RC"
  echo "# Claude Session Manager" >> "$SHELL_RC"
  cat "$SCRIPT_DIR/cr.sh" >> "$SHELL_RC"
  echo "[OK] cr function added."
fi

# Step 2: Derive project key and create sessions.md
PROJECT_KEY=$(pwd | sed 's|^/||; s|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_KEY/memory"
SESSIONS_FILE="$MEMORY_DIR/sessions.md"

if [[ -f "$SESSIONS_FILE" ]]; then
  echo "[!] sessions.md already exists at $SESSIONS_FILE — skipping."
else
  echo ">> Creating memory folder and sessions.md at:"
  echo "   $SESSIONS_FILE"
  mkdir -p "$MEMORY_DIR"
  cp "$SCRIPT_DIR/sessions-template.md" "$SESSIONS_FILE"
  echo "[OK] sessions.md created from template."
fi

# Step 3: Check for glow
echo ""
if command -v glow &>/dev/null; then
  echo "[OK] glow is installed — session maps will render with formatting."
else
  echo "[!] glow not found. Install it for formatted session maps:"
  echo "    brew install glow"
fi

echo ""
echo "-----------------------------------"
echo "Done. Reload your shell to activate:"
echo ""
echo "    source $SHELL_RC"
echo ""
echo "Then run:  cr"
echo ""
