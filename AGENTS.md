# Agent Context

This file contains agent-specific guidance only.

Read [`README.md`](README.md) first for the project overview, how it works, and developer workflow.

---

## Scratchpad

You can use a `SCRATCHPAD.md` file (gitignored) for persistent working memory across chat sessions. At the start of a session, read it for additional context on recent work, lessons learned, and known quirks. As you work, feel free to update the scratchpad with any learnings that a future session would benefit from knowing.

## General Guidelines

### Constructive Pushback
- **Don't just implement what's asked** — briefly flag if you see a concern. The user values a 1-2 sentence heads-up over silent compliance.
- This includes: unnecessary abstractions, deprecated patterns, simpler alternatives, or potential footguns.
- When the user proposes a solution, briefly evaluate whether a more elegant solution exists.

### Secrets hygiene
- Before making any edit or commit, ask: **could this write a secret in plaintext somewhere it shouldn't be?**
- Never put tokens, keys, or passwords in plaintext in any unencryped file.

### Comments
- **Never remove comments** when modifying files unless:
  - The comment applies to code being removed
  - The meaning of the code has changed
  - Specifically asked to remove them
- Comments contain valuable domain knowledge - preserve them

## Key gotchas

- **npm alias syntax**: `"rapid2": "npm:@rapideditor/rapid@^2.5.6"` — the `@` before the version is required and easy to miss for scoped packages (the package name already contains `@`)
- **`cp -R src dst` behavior**: if `dst` already exists, files land inside it (`dst/src/`); if it doesn't exist, it's created as a copy of `src`. `build.sh` relies on this — don't pre-create the subdirectories
- **Lockfiles**: gitignored but intentionally NOT deleted by `clean.sh`, since any package manager should work
- **`rapid3: file:../rapid`**: this path won't resolve inside Docker. Not a problem now (we build locally and commit `dist/` when releasing), but relevant if we ever move the build back into Docker
- **Symlinks in `dist/rapid3`**: rapid3's dist folder contains symlinks (e.g. `index.html@ -> /Users/bryan/Projects/rapid/dist/index.html`). Docker copies broken symlinks rather than the files they point to, causing nginx 403 errors. `build.sh` uses `cp -RL` to dereference symlinks into real files at copy time
