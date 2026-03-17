# rapid-container — Agent Context

This repository packages multiple versions of [Rapid](https://rapideditor.org) (a front-end OSM editor) into a single nginx Docker container, serving them as static files. It is not an application — it's a deployment artifact.

## How it works

- `rapid2` is installed from npm (`@rapideditor/rapid@^2.x`)
- `rapid3` is currently a local `file:../rapid` dependency (not yet published to npm); once published it will become a normal npm alias too
- `scripts/build.sh` installs nothing — it just copies `node_modules/rapid2/dist` and `node_modules/rapid3/dist` into `./dist/rapid2/` and `./dist/rapid3/`
- `./dist/` is **committed to git** so downstream projects can `git clone` without needing any build tooling
- The Dockerfile is intentionally minimal: it just copies `./dist/` into an nginx image

## Deployment context

This repo is consumed by [`workspaces-stack`](https://github.com/TaskarCenterAtUW/workspaces-stack) (a separate repo), which `git clone`s this project into a `rapid/` subfolder and builds the Docker image via `docker-compose.build.yml`. No build happens inside Docker — the pre-built `dist/` is all that's needed.

## Developer workflow

```sh
npm install        # or bun/yarn/pnpm — any package manager works
sh ./scripts/build.sh   # populates ./dist/
docker build -t rapid-container .
docker run -p 8080:80 rapid-container  # test at localhost:8080/rapid2/ and /rapid3/
```

## Key gotchas

- **npm alias syntax**: `"rapid2": "npm:@rapideditor/rapid@^2.5.6"` — the `@` before the version is required and easy to miss for scoped packages (the package name already contains `@`)
- **`cp -R src dst` behavior**: if `dst` already exists, files land inside it (`dst/src/`); if it doesn't exist, it's created as a copy of `src`. `build.sh` relies on this — don't pre-create the subdirectories
- **Lockfiles**: gitignored but intentionally NOT deleted by `clean.sh`, since any package manager should work
- **`rapid3: file:../rapid`**: this path won't resolve inside Docker. Not a problem now (we build locally and commit `dist/`), but relevant if we ever move the build back into Docker


## Scratchpad

Use a `SCRATCHPAD.md` file (git-ignored) for persistent working memory across chat sessions. At the start of a session, read it for context on recent work, lessons learned, and known quirks. As you work, feel free to update the scratchpad with any learnings that a future session would benefit from knowing.


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

