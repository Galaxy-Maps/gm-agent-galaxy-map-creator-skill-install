# Galaxy Maps — Skill Bundle Installer

One-step installers for the [Galaxy Maps](https://github.com/Galaxy-Maps) curriculum-creation skill stack.

Galaxy Maps ships in **two flavours**, each is a coordinated bundle of 7 Claude Code skills:

| Bundle | What it does | Best for |
|---|---|---|
| **Non-team** | Sequential, single-agent workflow. One orchestrator drives each phase end-to-end. | Quick maps. Predictable cost. Older Claude Code versions. |
| **Agent Teams** | Multi-agent workflow using Claude Code's Agent Teams. 7 selectable design teams (Dewey, Vygotsky, …) collaborate; 4 adversarial reviewers debate; 1 builder per star. | Higher-quality maps. Comparative design. Heavier token usage. |

Pick one — or install both side-by-side and decide per project.

---

## Install — Non-team bundle

**macOS / Linux / WSL**

```bash
curl -fsSL https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-non-team.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-non-team.ps1 | iex
```

Clones these 7 repos into `~/.claude/skills/`:

- [`gm-agent-01-orchestrator`](https://github.com/Galaxy-Maps/gm-agent-01-orchestrator)
- [`gm-agent-02-intent`](https://github.com/Galaxy-Maps/gm-agent-02-intent)
- [`gm-agent-03-curriculum`](https://github.com/Galaxy-Maps/gm-agent-03-curriculum)
- [`gm-agent-04-curriculum-critiquer`](https://github.com/Galaxy-Maps/gm-agent-04-curriculum-critiquer)
- [`gm-agent-05-branching`](https://github.com/Galaxy-Maps/gm-agent-05-branching)
- [`gm-agent-06-mission-builder`](https://github.com/Galaxy-Maps/gm-agent-06-mission-builder)
- [`gm-agent-07-mission-critiquer`](https://github.com/Galaxy-Maps/gm-agent-07-mission-critiquer)

Then in Claude Code: `/gm-agent-01-orchestrator` to start a Galaxy Map.

---

## Install — Agent Teams bundle

**macOS / Linux / WSL**

```bash
curl -fsSL https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-with-agent-teams.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-with-agent-teams.ps1 | iex
```

Clones these 7 repos into `~/.claude/skills/`:

- [`gm-agent-01a-orchestrator-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-01a-orchestrator-with-agent-teams)
- [`gm-agent-02-intent`](https://github.com/Galaxy-Maps/gm-agent-02-intent)
- [`gm-agent-03a-curriculum-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-03a-curriculum-with-agent-teams)
- [`gm-agent-04a-curriculum-critiquer-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-04a-curriculum-critiquer-with-agent-teams)
- [`gm-agent-05a-branching-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-05a-branching-with-agent-teams)
- [`gm-agent-06a-mission-builder-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-06a-mission-builder-with-agent-teams)
- [`gm-agent-07a-mission-critiquer-with-agent-teams`](https://github.com/Galaxy-Maps/gm-agent-07a-mission-critiquer-with-agent-teams)

Then in Claude Code: `/gm-agent-01a-orchestrator-with-agent-teams` to start a Galaxy Map.

> The Agent Teams bundle and the non-team bundle share `gm-agent-02-intent` — that's intentional. The Intent phase is identical in both flavours, so it's a single shared skill.

---

## Options

Both scripts accept the same flags:

| Flag | Effect |
|---|---|
| *(default)* | Personal install — clones into `~/.claude/skills/`, available across all projects. |
| `--project` | Project install — clones into `./.claude/skills/` of the current directory, scoped to one project. |
| `--dest <dir>` | Custom install directory. |

PowerShell equivalents: `-Project`, `-Dest <dir>`.

The scripts are **idempotent** — re-running them runs `git pull --ff-only` on each already-installed skill, so you always have the latest. To check for updates, just re-run the install command.

---

## Uninstall

Removes all Galaxy Maps skills (both bundles) from your install directory.

**macOS / Linux / WSL**

```bash
curl -fsSL https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/uninstall.sh | bash
```

Or with the same `--project` / `--dest <dir>` flags as the install scripts.

---

## How Claude Code discovers these skills

Claude Code watches `~/.claude/skills/` for any directory containing a `SKILL.md` file and loads it as an invokable skill. The directory name becomes the `/skill-name` command. No restart needed — skills are picked up live within the current session.

For per-project installs (`--project`), the `.claude/skills/` directory must be at or above your current working directory when Claude Code starts. Commit it to git to share with collaborators; add it to `.gitignore` to keep it personal.

For the canonical Claude Code skills documentation, see [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills).

---

## Other LLMs / agents

The repos work in any environment that reads `SKILL.md` files in a discoverable directory. If your tool uses a different skills directory:

```bash
bash install-non-team.sh --dest ~/.cursor/skills        # Cursor
bash install-non-team.sh --dest ~/.codex/skills         # Codex CLI
bash install-non-team.sh --dest ~/.config/agent/skills  # generic Agent SDK harness
```

---

## Provenance

Forked and modularized from the original [tairea/galaxy-maps-ai-skill](https://github.com/tairea/galaxy-maps-ai-skill) and [tairea/galaxy-maps-ai-skill-with-agent-teams](https://github.com/tairea/galaxy-maps-ai-skill-with-agent-teams) monorepos. Each role now lives in its own repo so it can be iterated on independently.
