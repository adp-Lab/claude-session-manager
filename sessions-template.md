# Project sheet — your Claude sessions

<!-- CO2 estimates are rough guesses based on session size. Entirely optional. -->
<!-- Status: Act = active / Sto = stopped / Don = done / Edu = learning session -->

CO2: 🌱 tiny · 🌿 low · 🌍 med · 🔥 high · 💀 very high

---

| UUID     | Topic                                      | Status |
|----------|--------------------------------------------|--------|
| `xxxxxxx` | Replace this with your first session topic | Act    |
| `xxxxxxx` | Another session                            | Act    |

---

## How to find your UUIDs

Session files are stored here:

```
~/.claude/projects/<your-project-key>/*.jsonl
```

The first 8 characters of each filename are your short UUID.
Example: `6051a796-3882-4aa6-8712-d493047cdc4f.jsonl` → UUID is `6051a796`

To list all your session files:

```bash
ls ~/.claude/projects/$(pwd | sed 's|^/||; s|/|-|g')/*.jsonl
```

## Tips

- Keep the "first words" column in quotes — it's what the Claude interactive picker shows
- Update Status as sessions progress
- You can add columns for Repo, CO2, or anything else that helps you navigate
