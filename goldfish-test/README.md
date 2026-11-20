# goldfish-test

Three checks for Google's Elephant-Goldfish plugin (`google/elephant-goldfish-model`), from the Agentic Ajrak video on the Elephant-Goldfish Model, tested on real plans.
The plugin has no published accuracy benchmark. These checks give you your own numbers, on your own plans, in your own host.

## 1. Marker test: does your goldfish really forget? (10 min)
A reviewer with no memory of your chat can still get your instruction files from the host. This test shows what each agent sees.

```
./marker-test.sh setup            # makes ~/goldfish-marker-test
cd ~/goldfish-marker-test && claude
```
1. Ask the main session: "List every word that follows marker: in your starting context." This is the elephant. It should see PAPAYA-17.
2. Paste `probe-subagent.txt`. This is a plain subagent in your host.
3. Run `/egm:egm-review plan.md`. Let it finish.
4. Back in the shell: `./marker-test.sh check`.

Fill the marker table in `findings-sheet.md`. BANANA-03 is in the plan itself, so every reviewer must report it. If it does not come back, the probe failed. Run the same steps in every host your team uses (Codex CLI, Antigravity CLI): the host decides what the reviewer loads, not the plugin.

If a marker comes back, run reviews from a clean checkout that holds only the plan, or use a host that leaves the instruction files out. Then run this test again. Run it again after each host update.

## 2. Real or noise (about 20 min per plan)
Pick a plan that someone will follow and that you have not reviewed before. Copy it first, so you can diff:
```
cp plan.md plan.before.md
/egm:egm-review plan.md
```
Grade every finding in `findings-sheet.md`. A finding is real only if you change a line in the plan. `diff -u plan.before.md plan.md` is the proof. Note the time and usage before and after.

## 3. Drift report (about 15 min)
```
/egm:egm-drift-report <folder with your docs and code>
```
It compares what your docs say with what your code does. Grade each finding, and decide which side is right: the doc or the code. Your agents read those docs every session.

## 4. What did the review cost? (2 min)
Claude Code logs every request on your own computer, subagents included. This script adds them up for a time window:
```
python3 review-cost.py --project <part of the project folder name> \
  --since 2026-11-19T16:50:00+05:30 --until 2026-11-19T17:03:00+05:30 \
  --price 4,20,5,0.20
```
Prices are USD per million tokens (input, output, cache write, cache read). Use `--session <id>` to count one session only.

## My results
`my-findings-19nov.md`: 13 of 36 plan findings were real, about $9 at API prices for two reviews, and what each agent saw in the marker test.

## Limits
One person's grades on a few plans are not a benchmark. A review does not replace tests or human judgement (the plugin's README says the same).
