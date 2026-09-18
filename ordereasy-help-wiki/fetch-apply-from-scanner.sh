#!/usr/bin/env bash
# Fast-forward the Sep 2026 help wiki onto RetailerCustomerPlatform origin/main
# by fetching scanner branch rcp-wiki-applied (original five commits on e9420db).
# Then tries git push + gh pr create when this machine has RCP write access.
set -euo pipefail

RCP_DIR="${1:-}"
SCANNER_REMOTE="${SCANNER_REMOTE:-https://github.com/vin8003/buyeasy_retailer_scanner.git}"
SCANNER_BRANCH="${SCANNER_BRANCH:-rcp-wiki-applied}"

if [[ -z "$RCP_DIR" ]]; then
  echo "Usage: $0 /path/to/RetailerCustomerPlatform" >&2
  echo "Example:" >&2
  echo "  git clone git@github.com:vin8003/RetailerCustomerPlatform.git" >&2
  echo "  $0 ./RetailerCustomerPlatform" >&2
  exit 2
fi

cd "$RCP_DIR"
git fetch origin main
git checkout -B feature/wiki-content-update-2c2e origin/main
git fetch "$SCANNER_REMOTE" "$SCANNER_BRANCH"
git merge --ff-only FETCH_HEAD
echo
echo "Fetched $SCANNER_BRANCH onto origin/main $(git rev-parse --short origin/main)."
echo "HEAD=$(git rev-parse --short HEAD)"
test -f wiki/whats-new.md
test -f wiki/project/apis.md
test -f wiki/retailer-guide/print-labels.md
test -f docs/05-API-SURFACE.md

echo "Attempting git push (needs RCP write access)..."
if git push -u origin feature/wiki-content-update-2c2e; then
  echo "Pushed feature/wiki-content-update-2c2e"
  if command -v gh >/dev/null 2>&1; then
    if gh pr list --repo vin8003/RetailerCustomerPlatform --head vin8003:feature/wiki-content-update-2c2e --json number --jq '.[0].number' | grep -q .; then
      echo "PR already exists for this branch."
    else
      gh pr create --repo vin8003/RetailerCustomerPlatform \
        --base main \
        --head feature/wiki-content-update-2c2e \
        --title "docs: refresh help wiki for Sep 2026 product" \
        --body "KAN-275 / https://github.com/vin8003/RetailerCustomerPlatform/issues/178

Applies the 18 Sep 2026 OrderEasy help wiki (\`wiki/\` + \`docs/05-API-SURFACE.md\`) onto \`main\`." \
        || echo "PR create failed; open one into main."
    fi
  else
    echo "Open a PR into main on GitHub."
  fi
else
  echo "Push failed. From this repo run:"
  echo "  git push -u origin feature/wiki-content-update-2c2e"
  echo "Then open a PR into main. That is the lasting wiki edit."
fi
