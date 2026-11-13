# agent-identity-kit

Who is your agent, and what is it allowed to touch? This kit goes with the Agentic Ajrak video **"AI agent identity: who let the agent do that?"** It is the same setup I used on my own laptop: one coding agent, one ordinary job, three layers.

| Layer | Question it answers | In this repo |
|---|---|---|
| 1. Write the job down | What should the agent do, and what must it never do? | [`brief/`](brief/) · agent brief template, reviewed with [Elephant-Goldfish](https://github.com/google/elephant-goldfish-model) |
| 2. Give it its own name | Which keys can it use, and can you switch off just this one? | [`vault/`](vault/) · [Agent Vault](https://github.com/Infisical/agent-vault) setup |
| 3. Put up a fence | What can it physically reach? | [`sandbox/`](sandbox/) · [nono](https://github.com/nolabs-ai/nono) policy |

Plus [`demo-site/`](demo-site/), a tiny throwaway project (a fake model key and one low-value Slack bot token you revoke after), so you can run the same three runs without touching anything that matters, and [`INCIDENTS.md`](INCIDENTS.md), every incident from the video with its primary source.

## Three questions for every agent you run
1. Who is it? (Its own identity, not yours, not a shared key.)
2. Which keys can it use? (Named, scoped, and never readable by the agent itself.)
3. How fast can you switch off just that one, without breaking everything else?

## What this kit does not fix
- An allowed host can still receive bad data.
- A key you paste into a prompt is a key in the open.
- None of this tells you the agent did the job well. Keep your tests, and read the diff.

## Status
Not yet tested end to end: this changes after the demo run. Every command in this repo is one I ran; anything not yet run is marked **untested**.

Video: `<YouTube link>` · Write-ups every Wednesday: https://agenticajrak.com · by Pratima Chainani · @the.agenticajrak

MIT licence. Never commit your `.env`.
