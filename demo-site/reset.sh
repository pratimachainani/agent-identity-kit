#!/usr/bin/env bash
# Reset the demo before each run. Usage, from the demo folder:
#   ./reset.sh run0    (Run 0: the real Slack token must be in .env)
#   ./reset.sh vault   (Run 1 and Run 2: only the placeholder agent-vault may be in .env)
# It puts back the five old build files, checks the Slack token line in .env, and restarts the local site on port 8080.
mode="${1:-}"
cd "$(dirname "$0")" || exit 1
if [ "$mode" != "run0" ] && [ "$mode" != "vault" ]; then
  echo "Say which run: ./reset.sh run0   or   ./reset.sh vault"; exit 1
fi

# 1. Old build files
mkdir -p build
for i in 1 2 3 4 5; do echo "// old build artefact $i" > "build/old-$i.js"; done
echo "OK    build/ has $(ls build | wc -l | tr -d ' ') files"

# 2. Slack token line in .env (the value is never printed)
if [ ! -f .env ]; then echo "STOP  no .env here. Run: cp .env.example .env"; exit 1; fi
line=$(grep '^SLACK_BOT_TOKEN=' .env | head -1)
if [ "$mode" = "vault" ]; then
  if [ "$line" = "SLACK_BOT_TOKEN=agent-vault" ]; then echo "OK    .env has only the placeholder agent-vault"
  else echo "STOP  .env must say SLACK_BOT_TOKEN=agent-vault for this run (the real token must not be in .env)"; exit 1; fi
else
  case "$line" in
    SLACK_BOT_TOKEN=xoxb-*) echo "OK    .env has a real xoxb token (Run 0)";;
    *) echo "STOP  Run 0 needs the real token: SLACK_BOT_TOKEN=xoxb-..."; exit 1;;
  esac
fi
grep -q '^SLACK_CHANNEL=C' .env && echo "OK    SLACK_CHANNEL is set" || echo "CHECK SLACK_CHANNEL looks empty or wrong (it starts with C)"

# 3. Local site on port 8080
pkill -f "http.server 8080" 2>/dev/null; sleep 1
nohup python3 -m http.server 8080 >/dev/null 2>&1 &
sleep 1
code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ || true)
[ "$code" = "200" ] && echo "OK    site is up at http://localhost:8080" || echo "STOP  site did not start (got $code)"
echo "Ready. Now clear the screen and start recording."
