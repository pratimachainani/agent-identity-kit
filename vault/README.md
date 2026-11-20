# Layer 2: give the agent its own name (Infisical Agent Vault)

Part of [agent-identity-kit](../README.md): layer 2 of 3 from the Agentic Ajrak video "AI agent identity: who let the agent do that?". The `demo-site/` folder is in the kit root.

Infisical Agent Vault brokers credentials. The agent only ever holds a placeholder (`agent-vault`). A proxy you run puts the real key on the request on the way out, only for the services in the agent's access bundle. Each session's requests are logged (Agent Vault → Sessions → View session logs). Revoke the agent's session and that agent stops. Remove its identity's grant and it can't start new sessions. This holds only if each agent has its own machine identity, with a grant on only its own bundle.

Note: the older standalone `agent-vault` binary (get.agent-vault.dev) is no longer maintained. Its docs point to Infisical Agent Vault (docs.agent-vault.dev, checked 13 Nov 2026). Don't install the old one.

## Setup (status: the earlier one-shell flow was tested on 13 Nov 2026 on macOS; the session-token flow in steps 8-10 follows the vendor docs and is not re-tested yet)
1. Infisical web app → Agent Vault → New Project. Copy the Project ID (Administration → Settings).
2. Access Bundles → create the bundle `site-tester` → Add Service: host `slack.com`, Bearer credential = the Slack bot token.
3. Proxies → Create Proxy → copy the proxy token and the CA fingerprint.
4. Machine Identities → create the identity `site-tester` (Member) → Universal Auth: Client ID + Client Secret.
5. Bundle `site-tester` → Options → Manage Access → grant the `site-tester` identity.
6. Mac: `brew install infisical/get-cli/infisical` (0.44.7 or later: the version used in the 13 Nov 2026 test).
7. Terminal 1 (proxy). Paste the proxy token at the prompt, so it stays out of shell history:
   ```bash
   read -s INFISICAL_AGENT_VAULT_PROXY_TOKEN && export INFISICAL_AGENT_VAULT_PROXY_TOKEN
   infisical agent-vault proxy
   ```
8. Terminal 2 (session shell, never the agent's). Create one session with a time limit. It prints only the session token:
   ```bash
   export INFISICAL_UNIVERSAL_AUTH_CLIENT_ID=<client-id>
   read -s INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET && export INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET
   export INFISICAL_AGENT_VAULT_PROJECT_ID=<project-id>
   export INFISICAL_AGENT_VAULT_PROXY_ADDRESS=127.0.0.1:17323
   infisical agent-vault sessions create --access-bundle site-tester --ttl 30m
   ```
9. Terminal 3 (agent shell: a new window with none of the identity variables), in `demo-site/` with `SLACK_BOT_TOKEN=agent-vault` in `.env`. Paste the session token at the prompt:
   ```bash
   read -s INFISICAL_AGENT_VAULT_SESSION_TOKEN && export INFISICAL_AGENT_VAULT_SESSION_TOKEN
   infisical agent-vault run --proxy 127.0.0.1:17323 --ca-fingerprint <fingerprint> --telemetry=false -- claude
   ```
   `--telemetry=false` worked in the 13 Nov 2026 test. If your CLI version rejects it, remove it.
   The agent can now reach only the session's bundle, until the session ends. It can't create new sessions, because it never sees the client secret.
10. Switch the agent off:
    - Now: revoke its session. In Terminal 3 after the agent exits: `infisical agent-vault sessions revoke`. Or Sessions page → the session → Revoke. The CLI doesn't revoke a session that it was given as a token.
    - No new sessions: remove the `site-tester` identity's grant on the bundle. Sessions that already exist keep working until they expire or you revoke them.
    - Full shutdown: rotate the identity's client secret.

Docs: https://infisical.com/docs/documentation/platform/agent-vault/quickstart · https://infisical.com/docs/documentation/platform/agent-vault/sessions-cli.md
