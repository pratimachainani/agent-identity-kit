# Layer 3: put up a fence (nono)

nono (nolabs, open source) sandboxes the agent in the operating system kernel (Seatbelt on macOS, Landlock on Linux). The rules sit under the agent, so every process it starts, a shell, a script it wrote, a tool it downloaded, gets the same limits.

## Install
`brew install nono` (see https://github.com/nolabs-ai/nono). The first run installs the `nolabs-ai/claude` profile (Sigstore-verified).

## The command used in the video (macOS, nono v0.81.0, tested 13 Nov 2026)
From `demo-site/`, with the Agent Vault proxy running (see `../vault/`):
```
nono run --profile nolabs-ai/claude --read . --allow ./build --allow ~/.infisical --allow ~/.agents \
  --open-port 17323 --open-port 8080 \
  --allow-domain app.infisical.com --allow-domain slack.com \
  -- infisical agent-vault run --access-bundle site-tester --ttl 30m -- claude "$(cat TASK.txt)"
```
At "Share <folder> with read+write access?" answer **n**, so the folder stays read-only.

| Flag | Why |
|---|---|
| `--read .` | the project is read-only |
| `--allow ./build` | the only place the agent can write or delete |
| `--allow ~/.infisical` | the Infisical CLI saves the vault proxy's certificate |
| `--allow ~/.agents` | the Infisical CLI installs a skill that tells the agent about the placeholder |
| `--open-port 17323` | the Agent Vault proxy on localhost |
| `--open-port 8080` | the demo site on localhost |
| `--allow-domain app.infisical.com` | the CLI gets a time-bound session |
| `--allow-domain slack.com` | the one service the job needs |

What nono blocked in the test run: the Chrome profile folder (cookies, logins), a local debugging port the agent tried to open, and api.github.com.

Trade-off: everything inside nono shares one sandbox, so the agent can also read `~/.infisical`. In production, run the vault proxy outside the agent's sandbox or machine.

`site-tester.json` is an early draft of the same policy as a profile file and is not tested. Use the command above.
