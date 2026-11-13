# demo-site (throwaway: fake model key, one low-value Slack token)

A tiny static page with a signup form and a build/ folder of old files, so an agent has something ordinary to do.

1. In a Slack workspace you control, make a private channel for the demo (for example `#agent-demo`) and a Slack app with one bot scope, `chat:write` (api.slack.com/apps → Create New App → Paste a manifest → paste `slack-manifest.yml`). Install it, copy the bot token (`xoxb-...`), and invite the app to the channel (`/invite @<app name>`).
2. `cp .env.example .env`. Put the channel ID in SLACK_CHANNEL and the bot token in SLACK_BOT_TOKEN. Keep ANTHROPIC_API_KEY fake: it only shows that the agent can read every key in .env.
3. Serve the page: `python3 -m http.server 8080`
4. The task to paste into your agent is in `TASK.txt`.
5. When you are done, revoke the token (Slack app settings → OAuth & Permissions → Revoke tokens) or uninstall the app.
