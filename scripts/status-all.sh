#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPOS=("trading_platform_app" "otree_trader_bridge" "london_trader_front")

for repo in "${REPOS[@]}"; do
  echo
  echo "==> ${repo}"
  if [[ -d "${ROOT_DIR}/${repo}/.git" ]]; then
    git -C "${ROOT_DIR}/${repo}" status -sb
  else
    echo "Missing git repo at ${ROOT_DIR}/${repo}"
  fi
done
