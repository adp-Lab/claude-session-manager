# cr + cr-r — Claude Code Session Navigator
# Add this to your ~/.zshrc or ~/.bashrc
# More info: https://github.com/adp-Lab/claude-session-manager

function cr() {
  local project_key
  project_key=$(pwd | sed 's|/|-|g')
  local project_dir="$HOME/.claude/projects/$project_key"
  local sessions_file="$project_dir/memory/sessions.md"
  local jsonl_dir="$project_dir"

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
    echo "  https://github.com/adp-Lab/claude-session-manager"
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

# cr-r: scan for new sessions not yet in sessions.md, add stubs, then call cr
function cr-r() {
  local project_key
  project_key=$(pwd | sed 's|/|-|g')
  local project_dir="$HOME/.claude/projects/$project_key"
  local sessions_file="$project_dir/memory/sessions.md"

  if [[ ! -f "$sessions_file" ]]; then
    echo "  No sessions.md found at: $sessions_file"
    return 1
  fi

  echo ""
  echo "  Scanning for new sessions..."
  local new_count=0

  for f in "$project_dir"/*.jsonl; do
    [[ -f "$f" ]] || continue
    local uuid
    uuid=$(basename "$f" .jsonl | cut -c1-8)
    if ! grep -q "\`$uuid\`" "$sessions_file"; then
      local date_str
      date_str=$(date -r "$f" "+%Y-%m-%d")
      local stub="| \`${uuid}\` | — | — | Stub — added by cr-r ${date_str} | New |"
      SF="$sessions_file" STUB="$stub" python3 -c "
import os
sf = os.environ['SF']
stub = os.environ['STUB']
content = open(sf).read()
marker = '## Active project cards'
if marker in content:
    content = content.replace(marker, stub + '\n' + marker, 1)
else:
    content = content.rstrip() + '\n' + stub + '\n'
open(sf, 'w').write(content)
"
      echo "  + New: $uuid  ($date_str)"
      new_count=$((new_count + 1))
    fi
  done

  if [[ $new_count -eq 0 ]]; then
    echo "  ✓ Sessions map is up to date — no new sessions found."
  else
    echo ""
    echo "  + $new_count new session(s) added as stubs. Annotate them in sessions.md."
  fi
  echo ""

  cr
}
