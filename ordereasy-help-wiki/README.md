# OrderEasy help wiki (18 Sep 2026)

Canonical location is **`vin8003/RetailerCustomerPlatform`** (`wiki/` + `docs/`). This folder is a proposed copy because `cursor[bot]` cannot push that repo (GitHub 403 on git, refs, blobs, contents, and forks). Issues:write works.

Last reviewed against live apps on GitHub `main`: **18 Sep 2026**.

## Land tickets

- Jira: [KAN-275](https://vin8003.atlassian.net/browse/KAN-275) (Dev In Progress)
- GitHub apply ticket: https://github.com/vin8003/RetailerCustomerPlatform/issues/132
- Patch download (no clone): https://github.com/vin8003/buyeasy_retailer_scanner/releases/tag/wiki-sep-2026-2c2e
- Confluence copy: https://vin8003.atlassian.net/wiki/spaces/OrderEasy/pages/40271873 (child pages now match the git wiki; still a copy, not SOT)

## What this is

User-facing help centre plus the technical pages that changed with this refresh:

| Path here | Apply onto RCP as |
|-----------|-------------------|
| `wiki/` | `RetailerCustomerPlatform/wiki/` |
| `docs/05-API-SURFACE.md` | `RetailerCustomerPlatform/docs/05-API-SURFACE.md` (new) |
| `docs/00-INDEX.md` | `RetailerCustomerPlatform/docs/00-INDEX.md` |
| `docs/01-OVERVIEW.md` | `RetailerCustomerPlatform/docs/01-OVERVIEW.md` |
| `docs/02-ARCHITECTURE.md` | `RetailerCustomerPlatform/docs/02-ARCHITECTURE.md` |
| `docs/03-USER-JOURNEYS.md` | `RetailerCustomerPlatform/docs/03-USER-JOURNEYS.md` |
| `docs/DOCUMENTATION.md` | unchanged SOT rules (included for agents) |
| `docs/visuals/README.md` | scanner-flow caption only |

## Start here

1. [wiki/README.md](wiki/README.md) — help home
2. [wiki/SUMMARY.md](wiki/SUMMARY.md) — table of contents
3. [wiki/whats-new.md](wiki/whats-new.md) — what changed since August 2026
4. [wiki/project/all-apps.md](wiki/project/all-apps.md) — every app
5. [wiki/project/apis.md](wiki/project/apis.md) — how apps talk to the API
6. [docs/05-API-SURFACE.md](docs/05-API-SURFACE.md) — Django route map

## How to land this on the canonical repo

On a machine with push access to `RetailerCustomerPlatform`:

```bash
git clone git@github.com:vin8003/RetailerCustomerPlatform.git
cd RetailerCustomerPlatform
git checkout -b feature/wiki-content-update-2c2e origin/main
cp -a ../buyeasy_retailer_scanner/ordereasy-help-wiki/wiki/. wiki/
cp ../buyeasy_retailer_scanner/ordereasy-help-wiki/docs/*.md docs/
cp ../buyeasy_retailer_scanner/ordereasy-help-wiki/docs/visuals/README.md docs/visuals/README.md
git add wiki docs
git commit -m "docs(wiki): refresh help centre for Sep 2026 product"
git push -u origin feature/wiki-content-update-2c2e
```

Open a PR into `main`. Do **not** treat Confluence or this scanner copy as the lasting edit (`docs/DOCUMENTATION.md`).

## Local RCP commits (cannot push)

These already exist on the agent checkout of `RetailerCustomerPlatform` `feature/wiki-content-update-2c2e`:

- `docs(wiki): refresh help centre for Sep 2026 product`
- `docs: point knowledge-base index at wiki what’s-new and labels`
- `docs(wiki): add API map, Unmet Demand, and remaining Sep 2026 pages`
- `docs: add Django API surface and correct scanner capture path`


## Apply with the helper script (preferred)

```bash
git clone git@github.com:vin8003/RetailerCustomerPlatform.git
./ordereasy-help-wiki/apply-to-rcp.sh ./RetailerCustomerPlatform
# then, from that clone:
git push -u origin feature/wiki-content-update-2c2e
```

Or `git am patches/*.patch` on `origin/main`, or `git fetch patches/wiki-content-update-2c2e.bundle HEAD && git checkout -b feature/wiki-content-update-2c2e FETCH_HEAD`.

Then open a PR into `main`. That is the lasting edit. Confluence and this scanner folder are copies.

Local RCP commits on this agent (cannot push):

- docs(wiki): refresh help centre for Sep 2026 product
- docs: point knowledge-base index at wiki what’s-new and labels
- docs(wiki): add API map, Unmet Demand, and remaining Sep 2026 pages
- docs: add Django API surface and correct scanner capture path
- docs(wiki): document display-label layouts and city/state picker
