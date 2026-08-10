# artifact-demo

Working demo of **Gitea Actions artifacts + Gitea Packages** on the homelab
Gitea (192.168.1.2:3000). Full runbook: `ops/gitea-artifacts-packages.md` in
reeds/homelab-docs.

## What it does

| Workflow | Trigger | Produces / consumes |
|---|---|---|
| `.gitea/workflows/ci.yml` | push to main | builds `demo-bin` → **artifact** `demo-bin` → **container** `reeds/artifact-demo:{latest,sha8}` → **generic package** `artifact-demo/{sha8}/{demo-bin,.sha256}`; `verify` job re-downloads the artifact and the package and asserts identical bytes |
| `.gitea/workflows/consume.yml` | manual (`workflow_dispatch`) | finds the **latest successful** ci.yml run, downloads its artifact zip via REST API, fetches the generic package, pulls + runs the container image — all three must agree on the same sha8 |

## API surface used

- `GET /api/v1/repos/{owner}/{repo}/actions/workflows/{file}/runs?status=success&limit=1`
- `GET /api/v1/repos/{owner}/{repo}/actions/runs/{run}/artifacts?name={name}`
- `GET /api/v1/repos/{owner}/{repo}/actions/artifacts/{id}/zip`
- `PUT|GET /api/packages/{owner}/generic/{name}/{version}/{filename}`
- Container registry: `docker login 192.168.1.2:3000` + `docker push/pull`

## Secrets

- `REGISTRY_PUSH_TOKEN` (repo-level): PAT with `write:package,write:repository`.
  `GITHUB_TOKEN` has **no** permissions here (owner `actions.config` mode is
  unset → default none), so every authenticated call uses this secret.

## Local build

```bash
go build -trimpath -ldflags "-s -w -X main.version=local" -o demo-bin ./...
./demo-bin            # hello from gitea artifact local
./demo-bin --version  # local
```
