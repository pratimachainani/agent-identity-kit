# Agent brief: site-tester (the one from the video)

- **Job:** clean old files in build/, test the signup form on the demo site, message me on Slack when done
- **Identity:** site-tester
- **Keys it needs:** Slack bot token with chat:write only (post the message), model API (to run)
- **May connect to:** the demo site, slack.com, the model API
- **May write to:** demo-site/
- **May delete in:** demo-site/build/ only
- **Must never:** read real secrets, delete outside build/, contact any other host
- **If a step fails:** stop and tell me on Slack
- **Done means:** build/ is empty, the form test result is in the Slack message
- **Owner:** Pratima
