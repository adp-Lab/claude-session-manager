# cr — Claude Code Session Navigator
# Add this to your ~/.zshrc or ~/.bashrc
# More info: https://github.com/edgarmohn-git/claude-session-manager

function cr() {
  # Derive the Claude project folder key from the current directory
  local project_key
  project_key=$(pwd | sed 's|^/||; s|/|-|g')
  local project_dir="$HOME/.claude/projects/$project_key"
  local sessions_file="$project_dir/memory/sessions.md"
  local jsonl_dir="$project_dir"

  # Show session map
  if [[ -f "$sessions_file" ]]; then
    if command -v glow &>/dev/null; then
      glow -w 125 "$sessions_file"
    else
      cat "$sessions_file"
    fi
  else
    echo ""
    echo "  No sessions.md found."
    echo "  Expected location: $sessions_file"
    echo ""
    echo "  Create one based on the template:"
    echo "  https://github.com/edgarmohn-git/claude-session-manager"
    echo ""
  fi

  echo ""
  echo "  Type a short UUID and press Enter to resume directly."
  echo "  Or just press Enter to open the interactive picker."
  echo ""
  printf "  UUID > "
  read input

  if [[ -n "$input" ]]; then
    local match
    match=$(ls "$jsonl_dir"/${input}*.jsonl 2>/dev/null | head -1)
    if [[ -n "$match" ]]; then
      local full_uuid
      full_uuid=$(basename "$match" .jsonl)
      echo ""
      echo "  Resuming session: $full_uuid"
      echo ""
      claude --resume "$full_uuid"
    else
      echo ""
      echo "  No session found matching: $input"
      echo "  Check your sessions.md for valid UUIDs."
    fi
  else
    claude --resume
  fi
}
