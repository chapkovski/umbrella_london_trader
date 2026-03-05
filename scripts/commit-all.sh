#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMIT_MESSAGE="${1:-}"
NODE20_BIN="${HOME}/.nvm/versions/node/v20.19.6/bin"

if [[ -z "${COMMIT_MESSAGE}" ]]; then
  echo "Usage: ./scripts/commit-all.sh \"your commit message\""
  exit 1
fi

ensure_repo() {
  local repo_dir="$1"
  if [[ ! -d "${ROOT_DIR}/${repo_dir}/.git" ]]; then
    echo "Missing git repo at ${ROOT_DIR}/${repo_dir}"
    exit 1
  fi
}

commit_repo_if_dirty() {
  local repo_dir="$1"
  local repo_path="${ROOT_DIR}/${repo_dir}"
  local branch
  branch="$(git -C "${repo_path}" rev-parse --abbrev-ref HEAD)"

  echo
  echo "==> ${repo_dir} (branch: ${branch})"
  if [[ -z "$(git -C "${repo_path}" status --porcelain)" ]]; then
    echo "No changes; skipping commit."
    return
  fi

  git -C "${repo_path}" add -A
  git -C "${repo_path}" commit -m "${COMMIT_MESSAGE}"
}

build_front_to_otree_static() {
  echo
  echo "==> london_trader_front build:otree (Node 20)"

  if [[ -x "${NODE20_BIN}/npm" ]]; then
    PATH="${NODE20_BIN}:${PATH}" npm --prefix "${ROOT_DIR}/london_trader_front" run build:otree
    return
  fi

  if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.nvm/nvm.sh"
    nvm use 20 >/dev/null
    npm --prefix "${ROOT_DIR}/london_trader_front" run build:otree
    return
  fi

  echo "Node 20 not found in ~/.nvm; using current npm from PATH."
  npm --prefix "${ROOT_DIR}/london_trader_front" run build:otree
}

ensure_repo "london_trader_front"
ensure_repo "otree_trader_bridge"
ensure_repo "trading_platform_app"

build_front_to_otree_static

# Commit order: frontend source, generated oTree static/integration, backend.
commit_repo_if_dirty "london_trader_front"
commit_repo_if_dirty "otree_trader_bridge"
commit_repo_if_dirty "trading_platform_app"

echo
echo "Done. Use './scripts/status-all.sh' to verify and push each repo as needed."
