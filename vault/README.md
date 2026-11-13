# Layer 2: give the agent its own name (Infisical Agent Vault)

Infisical Agent Vault (open source, self-hostable) brokers credentials. The agent only ever holds a placeholder (`agent-vault`). A proxy you run puts the real key on the request on the way out, only for the services in the agent's access bundle, and every request is logged against the agent's machine identity. Remove the identity's access and only that agent stops.

Note: the older standalone `agent-vault` binary (get.agent-vault.dev) is no longer maintained. Its docs point to Infisical Agent Vault. Don't install the old one.

## Setup (as used in the video; status: tested on <date>)
1. Infisical web app → Agent Vault → New Project.
2. Access Bundles → Create `site-tester` → Add Service: host `slack.com`, Bearer credential = the Slack bot token.
3. Proxies → Create Proxy → copy the proxy token and the CA fingerprint.
4. Machine Identities → `site-tester` (Member) → Universal Auth: Client ID + Client Secret.
5. Bundle → Options → Manage Access → grant `site-tester`.
6. Mac: `brew install infisical/get-cli/infisical` (0.44.7+).
7. Terminal 1: `INFISICAL_AGENT_VAULT_PROXY_TOKEN=… infisical agent-vault proxy`
8. Terminal 2 (with the identity's env vars and `INFISICAL_AGENT_VAULT_PROXY_ADDRESS=127.0.0.1:17323`), in `demo-site/` with `SLACK_BOT_TOKEN=agent-vault` in `.env`:
   ```
   infisical agent-vault run --access-bundle site-tester --ttl 30m --telemetry=false -- claude
   ```
9. Switch it off: remove the identity's access to the bundle, or revoke the session on the Sessions page.

Docs: https://infisical.com/docs/documentation/platform/agent-vault/quickstart · https://infisical.com/docs/documentation/platform/agent-vault/sessions-cli.md
