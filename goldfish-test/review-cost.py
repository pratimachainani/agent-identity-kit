#!/usr/bin/env python3
"""What did one Elephant-Goldfish review cost? Sums the token counts that
Claude Code writes to its local session logs, subagents included.

  python3 review-cost.py --project agent-identity-kit \
      --since 2026-11-19T15:31:00+05:30 --until 2026-11-19T15:40:00+05:30

Optional: --session ID (one session only)
          --price IN,OUT,CACHE_WRITE,CACHE_READ  (USD per million tokens)
Reads only. Works with any account: the logs are on this computer.
"""
import argparse, glob, json, os
from collections import defaultdict
from datetime import datetime

ap = argparse.ArgumentParser()
ap.add_argument("--project", required=True, help="part of the folder name, e.g. agent-identity-kit")
ap.add_argument("--since", required=True)
ap.add_argument("--until", required=True)
ap.add_argument("--session", help="count only this session id (the start of it is enough)")
ap.add_argument("--price", help="IN,OUT,CACHE_WRITE,CACHE_READ in USD per million tokens")
ap.add_argument("--root", default=os.path.expanduser("~/.claude/projects"))
a = ap.parse_args()

since, until = datetime.fromisoformat(a.since), datetime.fromisoformat(a.until)
dirs = [d for d in glob.glob(os.path.join(a.root, "*")) if a.project in os.path.basename(d)]
if not dirs:
    raise SystemExit(f"STOP: no folder in {a.root} has '{a.project}' in its name")

seen, files_used, sessions = set(), set(), set()
tot = defaultdict(lambda: defaultdict(int))
first = last = None
for d in dirs:
    for f in glob.glob(os.path.join(d, "**", "*.jsonl"), recursive=True):
        with open(f, errors="replace") as fh:
            for line in fh:
                try:
                    e = json.loads(line)
                except ValueError:
                    continue
                ts = e.get("timestamp")
                if not ts:
                    continue
                t = datetime.fromisoformat(ts.replace("Z", "+00:00"))
                if not (since <= t <= until):
                    continue
                if a.session and not str(e.get("sessionId", "")).startswith(a.session):
                    continue
                first = t if first is None or t < first else first
                last = t if last is None or t > last else last
                m = e.get("message") or {}
                u = m.get("usage") if isinstance(m, dict) else None
                if e.get("type") != "assistant" or not u:
                    continue
                key = (m.get("id"), e.get("requestId"))
                if key in seen:  # one response can be logged on several lines
                    continue
                seen.add(key)
                files_used.add(f)
                sessions.add(e.get("sessionId"))
                r = tot[m.get("model", "unknown")]
                r["requests"] += 1
                r["input"] += u.get("input_tokens", 0) or 0
                r["output"] += u.get("output_tokens", 0) or 0
                r["cache_write"] += u.get("cache_creation_input_tokens", 0) or 0
                r["cache_read"] += u.get("cache_read_input_tokens", 0) or 0

if not tot:
    raise SystemExit("STOP: no requests in that time window. Check --since/--until (give the UTC offset).")

print(f"Log files: {len(files_used)}  (main session + subagents)   Sessions: {len(sessions)}")
print(f"First / last log line: {first.astimezone():%H:%M:%S} / {last.astimezone():%H:%M:%S}"
      f"  =  {int((last-first).total_seconds()//60)} min {int((last-first).total_seconds()%60)} s")
print(f"{'model':32} {'requests':>8} {'input':>10} {'output':>10} {'cache_write':>12} {'cache_read':>12}")
g = defaultdict(int)
for model, r in sorted(tot.items()):
    print(f"{model:32} {r['requests']:>8} {r['input']:>10,} {r['output']:>10,} {r['cache_write']:>12,} {r['cache_read']:>12,}")
    for k, v in r.items():
        g[k] += v
print(f"{'TOTAL':32} {g['requests']:>8} {g['input']:>10,} {g['output']:>10,} {g['cache_write']:>12,} {g['cache_read']:>12,}")
if a.price:
    pi, po, pw, pr = (float(x) for x in a.price.split(","))
    usd = (g["input"]*pi + g["output"]*po + g["cache_write"]*pw + g["cache_read"]*pr) / 1e6
    print(f"API-equivalent cost: ${usd:,.2f}  (at {a.price} USD per million tokens)")
