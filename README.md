# Claude Session Manager — `cr`

> Navigate your Claude Code sessions clearly and quickly.

---

## The problem

Claude Code stores every conversation as a session. When you want to resume one, the built-in picker shows only the **first few words** you typed — no labels, no context, no way to know which session is which.

If you run multiple projects or topics in parallel, finding the right session becomes a guessing game.

## The solution

`cr` is a small shell function that:

1. Renders a **human-readable session map** (a markdown table you maintain) before opening the picker
2. Lets you **jump directly** to any session by typing its short UUID — no scrolling through a list

---

## What it looks like

```
$ cr

  Project sheet — your Claude sessions

  | UUID     | Topic                          | Status |
  |----------|--------------------------------|--------|
  | 6051a796 | Brunsviga scheduling tool      | Act    |
  | bfcfe8ff | Personal website               | Act    |
  | 13138e33 | How Claude Code works          | Done   |

  Type a short UUID and press Enter to resume directly.
  Or just press Enter to open the interactive picker.

  UUID > 6051a796
  Resuming session: 6051a796-3882-4aa6-8712-d493047cdc4f
```

---

## Requirements

- macOS or Linux
- [Claude Code](https://claude.ai/code) installed (`claude` CLI in PATH)
- zsh or bash
- [`glow`](https://github.com/charmbracelet/glow) — optional, for formatted rendering (`brew install glow`)

---

## Install

### Option A — Automatic (recommended)

```bash
git clone https://github.com/edgarmohn-git/claude-session-manager.git
cd claude-session-manager
bash install.sh
source ~/.zshrc
```

The installer will:
- Add the `cr` function to your `~/.zshrc` (or `~/.bashrc`)
- Create a `sessions.md` template in the right location for your current project
- Check whether `glow` is installed

### Option B — Manual

1. Copy the contents of `cr.sh` into your `~/.zshrc`
2. Reload: `source ~/.zshrc`
3. Copy `sessions-template.md` to your Claude project's memory folder:

```bash
MEMORY_DIR=~/.claude/projects/$(pwd | sed 's|^/||; s|/|-|g')/memory
mkdir -p "$MEMORY_DIR"
cp sessions-template.md "$MEMORY_DIR/sessions.md"
```

---

## Usage

```bash
cr                 # show session map, then prompt for UUID or Enter
```

- **Type a short UUID** (e.g. `6051a796`) → resumes that session directly
- **Press Enter** → opens Claude's interactive resume picker

---

## The sessions.md file

This is a markdown table you maintain yourself — stored inside your Claude project's memory folder. Add a row each time you start a new session worth tracking.

```
~/.claude/projects/<project-key>/memory/sessions.md
```

Where `<project-key>` is your project directory path with slashes replaced by dashes.
Example: `/Users/you/myproject` → `-Users-you-myproject`

### Finding your UUIDs

Session files are JSONL files named after their full UUID:

```bash
ls ~/.claude/projects/$(pwd | sed 's|^/||; s|/|-|g')/*.jsonl
```

The first 8 characters of the filename are your short UUID.
Example: `6051a796-3882-4aa6-8712-d493047cdc4f.jsonl` → `6051a796`

---

## Tip: Milestone formatting

When working on multi-step tasks in Claude, add this to your `CLAUDE.md` to get consistent progress markers:

```
When marking a significant milestone, always use this format:

# 🚀🚀🚀🚀      STEP N DONE — MOVING TO STEP N+1      🚀🚀🚀🚀

🆘❕🆘   LONG CHAT? SAVE TO MEMORY NOW   🆘❕🆘
---
```

---

## License

MIT — use it, adapt it, share it.

---

Built during a vibe coding session with [Claude Code](https://claude.ai/code).
