#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPOS=("trading_platform_app" "otree_trader_bridge" "london_trader_front")

for repo in "${REPOS[@]}"; do
  echo
  echo "==> ${repo}"
  repo_path="${ROOT_DIR}/${repo}"

  if [[ ! -d "${repo_path}/.git" ]]; then
    echo "Missing git repo at ${repo_path}"
    exit 1
  fi

  branch="$(git -C "${repo_path}" rev-parse --abbrev-ref HEAD)"
  if [[ "${branch}" == "HEAD" ]]; then
    echo "Detached HEAD in ${repo}; refusing to push."
    exit 1
  fi

  origin="$(git -C "${repo_path}" remote get-url origin 2>/dev/null || true)"
  if [[ -z "${origin}" ]]; then
    echo "No origin remote configured for ${repo}; refusing to push."
    exit 1
  fi

  if [[ -n "$(git -C "${repo_path}" status --porcelain)" ]]; then
    echo "Working tree is dirty in ${repo}; commit or stash first."
    exit 1
  fi

  echo "Pushing ${branch} -> origin (${origin})"
  git -C "${repo_path}" push origin "${branch}"
done
