#!/usr/bin/env bash
# Download the Sep 2026 wiki patches from the scanner GitHub Release and git-am
# them onto RetailerCustomerPlatform origin/main.
# Gmail blocked the .tgz attachment; this path does not need email or a scanner clone.
set -euo pipefail

RCP_DIR="${1:-}"
REL="${WIKI_RELEASE_URL:-https://github.com/vin8003/buyeasy_retailer_scanner/releases/download/wiki-sep-2026-2c2e}"

PATCHES=(
  0001-docs-wiki-refresh-help-centre-for-Sep-2026-product.patch
  0002-docs-point-knowledge-base-index-at-wiki-what-s-new-a.patch
  0003-docs-wiki-add-API-map-Unmet-Demand-and-remaining-Sep.patch
  0004-docs-add-Django-API-surface-and-correct-scanner-capt.patch
  0005-docs-wiki-document-display-label-layouts-and-city-st.patch
)

if [[ -z "$RCP_DIR" ]]; then
  echo "Usage: $0 /path/to/RetailerCustomerPlatform" >&2
  echo "Example:" >&2
  echo "  git clone git@github.com:vin8003/RetailerCustomerPlatform.git" >&2
  echo "  $0 ./RetailerCustomerPlatform" >&2
  exit 2
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading patches from $REL"
for f in "${PATCHES[@]}"; do
  curl -fsSL -o "$TMP/$f" "$REL/$f"
done

cd "$RCP_DIR"
git fetch origin main
git checkout -B feature/wiki-content-update-2c2e origin/main
git am "${PATCHES[@]/#/$TMP/}"
echo
echo "Patches applied onto origin/main $(git rev-parse --short origin/main)."
echo "HEAD=$(git rev-parse --short HEAD)"
test -f wiki/whats-new.md
test -f wiki/project/apis.md
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
