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
echo "Push with:"
echo "  git push -u origin feature/wiki-content-update-2c2e"
echo "Then open a PR into main. That is the lasting wiki edit."
