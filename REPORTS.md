# QA reports

Write markdown files into the evidence folder `./artifacts/qa/<area>-<YYYYMMDD>/` (see [EVIDENCE.md](EVIDENCE.md)), prefixed with the product area (e.g. `workflows_bugs_report.md`):

- `<area>_bugs_report.md`
- `<area>_suggested_improvements.md`
- `<area>_test_coverage.md`
- `<area>_ui_ux_copy_review.md`, for design- or copy-focused audits

## Bugs report

```md
# <Area> Bug Report

Date:
Scope:
Safety / cleanup:

## Bugs

### BUG-001: <Clear title>

Severity:
Area:
Steps:
Actual:
Expected:
Impact:
Evidence: shots/NN-....png or videos/<flow>.webm @ mm:ss
Suggested fix:
Suggested copy, if relevant:
```

## Suggested improvements

```md
# <Area> Suggested Improvements

## Executive summary
## Priority 0: Reliability fixes
## Priority 1: UX and safety fixes
## Priority 2: Copywriting and clarity
## Priority 3: Visual polish and hierarchy
## Suggested automated tests
```

## Test coverage

```md
# <Area> Test Coverage

## Tested areas
## Tests performed
## UI/UX and copy reviewed
## Not tested intentionally
## Final state
```

## UI/UX and copy review

```md
# <Area> UI/UX and Copy Review

## Overall flow verdict
## What feels clear
## What feels confusing
## Copy issues
## Visual hierarchy issues
## Friction points
## Suggested rewritten copy
## Ideal user flow
```
