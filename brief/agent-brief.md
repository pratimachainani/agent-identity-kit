# Agent brief: <agent name>

Write this before the agent runs. Ten lines is enough. Then have a reviewer with no memory of your project read it (see below).

- **Job:** <one sentence: what done looks like>
- **Identity:** <the agent's own name in your vault, e.g. site-tester>
- **Keys it needs:** <service: why> (nothing else)
- **May connect to:** <hosts>
- **May write to:** <paths>
- **May delete in:** <paths, or "nothing">
- **Must never:** <the actions that would hurt>
- **If a step fails:** <retry N times / stop and tell me>
- **Done means:** <the check you will run>
- **Owner:** <the human who can switch it off>

## Review it with a goldfish
Install Elephant-Goldfish in Claude Code (see its README), then from this folder:

```
/egm:egm-review agent-brief.md
```

The reviewer only sees this file and the code it points to, so it asks about everything you assumed.
