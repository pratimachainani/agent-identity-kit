# My findings: Elephant-Goldfish, tested (19 Nov 2026)

Two real plans, one marker test and one drift report, graded by hand with one question: do I change my plan because of this? One person, a few plans: not a benchmark. Blank template: `findings-sheet.md`.

## Review A
| Field | Value |
|---|---|
| Plan file | `agent-identity-kit/vault/README.md` (21 lines) |
| Host and version (`claude --version`) | Claude Code v2.1.328 · Opus 5.5 · Claude Ultra plan (from the recording) |
| Start / end (clock) | 15:31:35 / 15:38:55 = 7 min 20 s of review (session log spans 8 min 14 s, including idle time before Enter; start: Enter at 0:15 in the recording that began 15:31:20; end: `consolidated_review_report.md` written 15:38:55) |
| Usage (API-equivalent) | Session c0548cfd only, from local Claude Code logs (`review-cost.py`, 8 log files: main thread + 7 reviewers): 41 requests · input 102 · output 59,142 · cache write 273,886 · cache read 2,309,700 = **$3.01** at Opus 5.5 list prices ($4 in, $20 out, $5 cache write, $0.20 cache read per million). Split: cache write $1.37, output $1.18, cache read $0.46. On a subscription, so this is not a bill. |
| Stopped on a limit? Where? | No. Stage 9 skipped: no implementation-plan section (FeatureRange 1-21) |
| Report files | zoom_out, comprehension, critic, intermediate_zoom_out, consolidated (not in this kit), plus the 2 vendor pages the review saved |
| Notes from the report | Mode: consolidated. Goldfish context: 2 saved vendor pages (Infisical quickstart, sessions CLI). The consolidator withdrew 1 Stage 7 citation as wrong (sessions-cli 498). Stage 8 rejected most Stage 7 structure proposals as over-building for a runbook. |

Count unit: the 12 action items in `consolidated_review_report.md` (A1-A12). Each one merges the stage findings in its traceability row.

| # | Stage | Severity | Finding (short, in its words) | Grade | Why (one line) | Plan line changed |
|---|---|---|---|---|---|---|
| A1 | 5, 7, 8 | Blocker | Keep the client secret out of the agent's process, and fix the switch-off step (lines 3, 15-19). Sessions default to TTL `never`; removing the grant does not stop existing sessions. | real | Did not know agent can create its own sessions from the client secret. | Line 3 claims; steps 8-10 rewritten: session made in a separate shell, agent gets only the session token, 3-way switch-off |
| A2 | 5, 6, 7, 8 | Major | Collect and set the project ID, and name the variables (lines 11, 15). The CLI fails without `INFISICAL_AGENT_VAULT_PROJECT_ID`. | known | projectId is only missing from the README but present in another file (in my own run notes). | Copied in anyway: step 1 and step 8 (export) |
| A3 | 5, 6, 7, 8 | Major | Do one real end-to-end run and record it (lines 7, 9, 15, 17). Can `claude` reach Anthropic with only `slack.com` in the bundle? | real | Real run was done, but a reader without the author can't tell if or when it was tested. | Setup heading: tested 13 Nov 2026 (earlier flow); new flow marked not re-tested |
| A4 | 5, 6, 7, 8 | Major | Give a first-time reader enough context (lines 1, 7, 9-12, 15). Bundle and identity are both named `site-tester`. | real | Context is scattered across artifacts; a reader can't tell what layer 2 and the video are. | New context line under the title; 'bundle site-tester' / 'identity site-tester' named in steps 2, 4, 5 |
| A5 | 5, 7, 8 | Major (Stage 8 said Nit) | Keep the proxy token out of shell history (line 14). Use `read -s` or a 0600 file. | real | Shell history did not cross my mind. | Steps 7-9: read -s for proxy token, client secret and session token |
| A6 | 5, 6, 7, 8 | Nit | Delete the unused CA fingerprint from step 3 (line 10). | known | Gap in README, but the real run used the CA fingerprint (in my own run notes). | Copied in anyway: --ca-fingerprint in step 9 |
| A7 | 6, 7, 8 | Nit | Line 3: "every request is logged against the agent's machine identity" is not what the logs show. | real | Logs are at session level, not per identity. | Line 3: 'Each session's requests are logged (Sessions → View session logs)' |
| A8 | 5, 6, 7, 8 | Nit | Line 21: labelled links under "References"; remove `.md` from the second URL. | noise | Valid, but not one of my P0 fixes. |  |
| A9 | 7 | Nit | Line 14 placeholder, line 15 sub-steps, lines 16-18 `bash` fence. | noise | Cosmetic, not functional. |  |
| A10 | 5, 6, 7 (8 rejected) | Nit | Source or soften "open source", "no longer maintained", `0.44.7+`, `--telemetry=false`. | real | Missed this citation. | Dropped 'open source, self-hostable'; dated sources for 'no longer maintained', 0.44.7 and --telemetry=false |
| A11 | 7 (8 rejected) | Nit | "Switch it off": one term each for identity, bundle and token. | noise | Over-analysed; 'it' is clear from the step. |  |
| A12 | 7 (8 rejected) | Nit, optional, contested | Short "Why this, not X" and "Limits" notes; Stage 7 rated these Blockers, Stage 8 rejected them. | noise | Not a research paper; this is a sample runbook. |  |

**Totals:** real 6 · known 2 · noise 4 · total 12 (graded by me; each finding checked against the vendor docs first) (Blocker 1 · Major 4 · Nit 7)

**Hero finding:** A1. "The setup as written breaks the layer's own promise. The agent's shell holds the machine identity's client secret, so the agent can create its own sessions." Plan change: the agent shell now gets only a session token (README steps 8-10).

## Review B · a website fix plan, written by my own agent
| Field | Value |
|---|---|
| Plan | a 130-line plan to fix glossary pages that returned 404 on my website |
| Time | 11 min 50 s, all five stages, 9 reviewer runs |
| Cost (API-equivalent) | 113 requests, $5.81 at Opus 5.5 list prices (cache write $2.52, output $2.22, cache read $1.07) |

24 findings: **real 7 · known 1 · noise 16.** The real ones:
- Blocker: 13 of the 15 page drafts were already written; the plan would have rebuilt them.
- Blocker: the page generator would crash, because the plan's data format left out two fields the generator reads.
- A filled-in example of the data format, so the agent doesn't guess the shapes.
- Use `git status --short`: `git diff --stat` doesn't show new, untracked pages.
- Three more broken links the plan didn't cover.
- One false claim about what the site build updates.
- The exact command to run the generator.

The review also rejected six of its own proposals in its final stage.

## Marker test
| Who | PAPAYA-17 (CLAUDE.md) | MANGO-42 (AGENTS.md) | KIWI-88 (GEMINI.md) | BANANA-03 (plan, control) |
|---|---|---|---|---|
| Main session (the elephant) | **seen** | no | no | not asked (plan not read yet) |
| Plain subagent (Claude Code general-purpose) | **seen** | no | no | not asked |
| Goldfish reviewers (egm-review, 7 runs) | no (not in any report) | no | no | **read**: named in the plan critique, not as a probe answer |

Write: **seen** (in its starting context), **read** (found only with a tool), or **no**.
If BANANA-03 is "no" for a row, that row is inconclusive.

Run: 19 Nov 2026, Claude Code v2.1.328, in iTerm.
- Elephant (0:30): "One word follows "marker:" in my starting context: PAPAYA-17, from the project's CLAUDE.md".
- Plain subagent (0:53): answered "PAPAYA-17" in 3 s, relayed word for word by the main session.
- Goldfish: all 7 reviewer runs treated the probe question as document content and declined to answer it (consolidated report, note on lines 4-8). No report names PAPAYA-17, MANGO-42 or KIWI-88. So the goldfish row rests on silence, not on a direct answer: weaker evidence than rows 1-2, but it matches issue #237 (Claude Code adapters set omitClaudeMd).
- Claude Code loaded neither AGENTS.md nor GEMINI.md for any agent.
- Reviewers also flagged the probe block as out of place (A6, IZ-6): they did not obey an instruction hidden in the document.

## Drift report · my publishing toolkit
A style guide, a runbook and the scripts I use to render graphics and clean up audio. 146 places where the docs and the code disagree. I took the 12 that could hurt: **9 real, 3 noise**, and one of the 3 was a false finding (the report misread a rule).
Worst: the runbook promises an audio click check on every recording, but the check's tools sit in a different folder and none of my scripts run them.
