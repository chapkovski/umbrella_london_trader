# trader_london Workspace

This directory is a workspace that contains three independent git repositories:

- `trading_platform_app/` (FastAPI + WebSocket trading backend)
- `otree_trader_bridge/` (oTree participant-facing app)
- `london_trader_front/` (Vue frontend, built into oTree static assets)

Child repository remotes:

- `trading_platform_app` -> https://github.com/chapkovski/trader_london.git
- `otree_trader_bridge` -> https://github.com/chapkovski/otree_trader_bridge.git
- `london_trader_front` -> https://github.com/chapkovski/london_trader_front.git

Quick start (clone missing child repos into this workspace):

```bash
make bootstrap-workspace
```

Keep release/version history in each child repository.  
Use this workspace for local orchestration, shared docs, and cross-repo workflow.

## Local Development

Run these three processes in parallel.

1. Build frontend into oTree static assets:
```bash
cd london_trader_front
npm run build:otree
```

2. Run trading backend:
```bash
cd trading_platform_app
uvicorn client_connector.main:app --reload --port 8001
```

3. Run oTree:
```bash
cd otree_trader_bridge
otree devserver
```

Set oTree `trading_api_base` to `http://localhost:8001`.

## Workspace Commands

From the workspace root:

```bash
make bootstrap-workspace
make status-all
make branch-all
make pull-all
make push-all
make origins-all
make commit-all MSG="TL-142: short summary"
```

Equivalent scripts:

```bash
./scripts/bootstrap-workspace.sh
./scripts/status-all.sh
./scripts/branch-all.sh
./scripts/pull-all.sh
./scripts/push-all.sh
./scripts/origins-all.sh
./scripts/commit-all.sh "TL-142: short summary"
```

`bootstrap-workspace` behavior:

- clones missing child repositories into expected folder names,
- skips already-cloned repos,
- warns if an existing repo's `origin` does not match the documented remote.

`push-all` safety check:

- refuses to push if any child repo has uncommitted changes.

`commit-all` workflow:

1. Builds Vue -> oTree static (`london_trader_front npm run build:otree`) with Node 20 when available.
2. Commits `london_trader_front/` if dirty.
3. Commits `otree_trader_bridge/` if dirty (including refreshed static assets).
4. Commits `trading_platform_app/` if dirty.

All commits use the same commit message.

## Cross-Repo Workflow

Use one ticket ID across all related branches/PRs:

- `trading_platform_app`: `feat/TL-142-something`
- `otree_trader_bridge`: `feat/TL-142-something`
- `london_trader_front`: `feat/TL-142-something`

When a feature spans multiple repositories:

1. Open separate PRs per repository.
2. Cross-link PRs to each other and to the same ticket.
3. Merge in dependency order (backend/API, then frontend/oTree integration).

## Workspace Git Repo Notes

If you initialize a git repo at workspace root (`trader_london/.git`):

- keep child repos independent (recommended here),
- do **not** track child repo contents from the parent repo.

This workspace already has ignore rules for:

- `/london_trader_front/`
- `/otree_trader_bridge/`
- `/trading_platform_app/`

So a parent repo will track only workspace files (`README.md`, `scripts/`, `Makefile`, etc.).

To reference child repositories from automation, use their configured origins:

```bash
make origins-all
```
