#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPOS=("trading_platform_app" "otree_trader_bridge" "london_trader_front")
REMOTES=(
  "https://github.com/chapkovski/trader_london.git"
  "https://github.com/chapkovski/otree_trader_bridge.git"
  "https://github.com/chapkovski/london_trader_front.git"
)

for i in "${!REPOS[@]}"; do
  repo="${REPOS[$i]}"
  remote="${REMOTES[$i]}"
  target="${ROOT_DIR}/${repo}"

  echo
  echo "==> ${repo}"

  if [[ -d "${target}/.git" ]]; then
    current_origin="$(git -C "${target}" remote get-url origin 2>/dev/null || true)"
    echo "Already present at ${target}"
    if [[ -n "${current_origin}" && "${current_origin}" != "${remote}" ]]; then
      echo "Warning: origin mismatch"
      echo "  expected: ${remote}"
      echo "  current:  ${current_origin}"
    else
      echo "Origin OK: ${current_origin:-<no origin remote>}"
    fi
    continue
  fi

  if [[ -e "${target}" ]]; then
    if [[ -d "${target}" ]] && [[ -z "$(ls -A "${target}")" ]]; then
      rmdir "${target}"
    else
      echo "Path exists and is not a git repo: ${target}"
      echo "Refusing to overwrite."
      exit 1
    fi
  fi

  echo "Cloning ${remote} -> ${target}"
  git clone "${remote}" "${target}"
done

echo
echo "Workspace bootstrap complete."
