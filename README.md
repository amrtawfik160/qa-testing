# qa-testing

An agent skill for hands-on product QA. The agent tests your product like a real user in a real browser, then reports bugs, UX friction, and copy issues, each backed by a screenshot or a video timestamp.

Works with any agent that reads `SKILL.md` skills: Claude Code, Codex, Cursor, Gemini CLI, Pi, and others.

## What it does

- Maps each page, records a baseline, and checks UI hierarchy, flow, and copy on every screen
- Runs a full create → edit → delete lifecycle on disposable, tagged test data, then cleans up
- Tries bad inputs (empty fields, invalid times and cron, duplicates, unsaved edits)
- Covers AI agents (with prompt-injection checks), integrations, templates and workflows, and skill libraries
- Uses whatever browser the machine has (a browser tool, a browser CLI, or Playwright), or an iOS or Android simulator
- Saves screenshots for every finding, records video of flows, and reviews the video frame by frame to catch flicker, layout shifts, and stale states
- Writes bug, improvement, coverage, and UI/copy reports on request

It stays safe by default: no sending, publishing, purchasing, or touching real data unless you ask.

## Install

```sh
git clone https://github.com/amrtawfik160/qa-testing ~/.agents/skills/qa-testing
```

Then link it where your agent looks for skills, for example:

```sh
ln -s ~/.agents/skills/qa-testing ~/.claude/skills/qa-testing   # Claude Code
ln -s ~/.agents/skills/qa-testing ~/.codex/skills/qa-testing    # Codex
ln -s ~/.agents/skills/qa-testing ~/.cursor/skills/qa-testing   # Cursor
```

Video analysis needs `ffmpeg`. Video recording uses Playwright, which the agent installs on demand.

## Use

Ask your agent something like "QA the onboarding flow", "dogfood the workflows page and record a video", or "do a copy audit of settings".

## Files

- `SKILL.md`: the test steps, lenses, and severity guide
- `EVIDENCE.md`: picking a browser, screenshots, recording and analyzing video
- `BRANCHES.md`: checklists for agents, integrations, templates, and skill libraries
- `REPORTS.md`: report templates
- `scripts/frames.sh`: turns a recording into timestamped frames and contact sheets

## License

MIT
