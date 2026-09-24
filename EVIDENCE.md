# QA evidence: browser, screenshots, video

Reference for [SKILL.md](SKILL.md). Evidence is what turns a finding from a claim into something the user can open.

## Pick the driver

Use the first one this machine actually has. Probe, don't assume: `which <cli>`, the tool list in your context, `ls ~/.cache/ms-playwright`.

1. **A browser tool already in your context**: a harness browser tool (e.g. BB `browser_script`), Chrome DevTools MCP, Playwright MCP. Use it as is.
2. **A browser CLI on PATH**: `chrome-devtools-axi` (`open`, `snapshot`, `click @uid`, `screenshot <path>`), `agent-browser`, `bb browser` (`capture <tabId>` for screenshots).
3. **Playwright** as the fallback, and the default whenever you need video:
   `mkdir -p /tmp/qa-rec && cd /tmp/qa-rec && npm init -y >/dev/null && npm i playwright`, then `npx playwright install chromium` only if `~/.cache/ms-playwright` has no chromium.
4. **Native mobile app**: iOS simulator `xcrun simctl io booted screenshot|recordVideo <file>`; Android `adb exec-out screencap -p > f.png`, `adb shell screenrecord /sdcard/qa.mp4` then `adb pull`.

Nothing works → say which drivers you probed and ask the user for a browser, rather than reviewing from source code.

State the driver you chose in the coverage report.

## Where evidence lives

Save everything under `./artifacts/qa/<area>-<YYYYMMDD>/`:

- `shots/NN-<page>-<state>.png`, numbered in test order, e.g. `07-workflows-empty-search.png`
- `videos/<flow>.webm` plus `videos/<flow>_frames/` from the frame script
- Report files from [REPORTS.md](REPORTS.md) link each finding to its shot or `video @ mm:ss`.

## Screenshots

Capture a baseline shot per page in step 1, then a shot for every finding at the moment it is visible (the broken state, not the page after you moved on). Also capture: every empty, loading, error, and success state reached; each modal and confirm dialog; the final state after cleanup. Full page when the issue is below the fold; include a narrow viewport (390x844) shot when layout is in scope.

Open every shot you cite and check it shows the claim. A shot of the wrong state is worse than none.

## Video

Record when a still cannot show the bug:

- Transitions and timing: flicker, layout shift, a spinner that never ends, a flash of wrong content, double renders.
- Multi-step flows where state drifts between steps: stale modal, wrong item opened, count that updates late.
- Anything intermittent: record several runs of the flow and compare.
- The user asked for a video.

Record with Playwright (drive it through the whole flow in one script, pausing about 800 ms after each action so states are visible on the frame grid):

```js
// /tmp/qa-rec/<flow>.mjs, run with: cd /tmp/qa-rec && node <flow>.mjs
import { chromium } from 'playwright';
const browser = await chromium.launch();
const size = { width: 1280, height: 800 };
const context = await browser.newContext({ viewport: size, recordVideo: { dir: 'videos', size } });
const page = await context.newPage();
await page.goto(URL);
// ...steps, each followed by: await page.waitForTimeout(800);
const video = page.video();
await context.close(); // flushes the video
await browser.close();
console.log(await video.path());
```

Reuse auth when the app needs sign-in: `browser.newContext({ storageState: 'auth.json', ... })`, saved once from a signed-in context with `context.storageState({ path: 'auth.json' })`. Keep `auth.json` out of `./artifacts/` and out of git.

## Analyze the video

A recording you never looked at is not evidence. Convert it to images, then read them:

```sh
<skill-dir>/scripts/frames.sh <video> [out_dir] [fps=2]
```

`<skill-dir>` is the folder holding this file (e.g. `~/.agents/skills/qa-testing`). It writes timestamp-stamped `frame_NNNN.png` at the given fps, `changes_NNNN.png` at each scene change, and `sheet_NN.png` contact sheets (12 frames each).

1. Read every contact sheet in order: it is the whole flow at a glance.
2. Read the `changes_*` frames: each is a moment the screen moved.
3. For anything suspect, open the full frames around it; raise fps (`5` or `10`) on a short clip for fast glitches.
4. Hunt specifically for: blank or half-rendered frames between states, content jumping position, a state that appears for one frame then vanishes, the wrong item or stale data after navigation, a spinner or skeleton that outlasts the data, text truncated or overlapping mid-transition, and a button still enabled after submit (double-submit risk).

Done when: every sheet is read and each suspect moment is either a finding with a timestamp or cleared.

## Share it

Save first, then show the user the worst findings' shots inline using whatever the harness offers (image attachment, inline file view, artifact link), and link the evidence folder in the final reply. Post shots to a PR, issue, or chat channel only when the user asked for it there.
