#!/usr/bin/env bash
# Land the 18 Sep 2026 help wiki on vin8003/RetailerCustomerPlatform.
# Run from a clone of this scanner repo, or pass the patches directory.
set -euo pipefail

PATCH_DIR="$(cd "$(dirname "$0")/patches" && pwd)"
RCP_DIR="${1:-}"

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
git am "$PATCH_DIR"/*.patch
echo
echo "Patches applied. Push with:"
echo "  git push -u origin feature/wiki-content-update-2c2e"
echo "Then open a PR into main. That is the lasting wiki edit."
