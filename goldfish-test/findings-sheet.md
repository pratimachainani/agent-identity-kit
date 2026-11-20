# Goldfish findings sheet

Grade every finding before you tell anyone the total. Use one of three grades:

- **real**: you changed a line in the plan because of it. The diff is the proof. No diff, not real.
- **noise**: wrong, or it does not matter for this plan. Write one line why.
- **known**: you already had it written down somewhere else. Say where.

## Review
| Field | Value |
|---|---|
| Plan file | |
| Host and version (`claude --version`) | |
| Start / end (clock) | |
| Usage before / after | |
| Stopped on a limit? Where? | |
| Report files | |

| # | Stage | Severity | Finding (short, in its words) | Grade | Why (one line) | Plan line changed |
|---|---|---|---|---|---|---|
| 1 | | | | | | |

**Totals:** real __ · noise __ · known __ · total __

## Marker test
| Who | PAPAYA-17 (CLAUDE.md) | MANGO-42 (AGENTS.md) | KIWI-88 (GEMINI.md) | BANANA-03 (plan, control) |
|---|---|---|---|---|
| Main session (the elephant) | | | | |
| Plain subagent | | | | |
| Goldfish reviewers (reports) | | | | |

Write: **seen** (in its starting context), **read** (found only with a tool), or **no**.
If BANANA-03 is "no" for a row, that row is inconclusive.

## Drift report
| # | Doc says | Code does | Grade | Which one is right | Fix goes in |
|---|---|---|---|---|---|
| 1 | | | | | doc / code |

**Totals:** real __ · noise __ · total __
