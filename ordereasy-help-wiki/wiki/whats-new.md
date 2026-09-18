# What’s new (wiki refresh, 18 Sep 2026)

This wiki was first written in August 2026. This page lists **user-visible** changes that landed after that, based on the live apps on GitHub `main` as of 18 Sep 2026.

Older pages in this wiki have been updated to match. Technical ticket snapshots still live in [`docs/tickets/`](../docs/tickets/README.md).

## For shop owners

| Change | Where you use it |
|--------|------------------|
| **Print Labels** — barcode stickers (50×25 or 38×25 mm) from Products, POS cart, or the Print Labels screen | Retailer sidebar → Print Labels |
| **Display Labels** — larger rack/shelf price tags, including square **1:1** (75×75) and strip **3:1** (75×25) | Retailer sidebar → Display Labels |
| **Exact-amount UPI QR on POS** — customer scans a QR for this bill (or the UPI part of a split bill) | POS → pay with UPI or Split |
| **UPI QR on thermal receipts** — optional; turn on in Profile | Profile → receipt settings |
| **Unknown barcode at POS** — create a new SKU or **link** the scan to an existing product | POS search / scan |
| **Supplier edit and deactivate** — keep khata history; hide from new purchase pickers | Khata / Suppliers |
| **Returned** tab on Orders — sales returns and fully returned online orders | Orders filters |
| **Parent pack visibility** — hide or show the bulk SKU on the customer app without changing child packs | Product form |
| **Show on customer app** per batch — sell a batch at the counter only | Product form → batches |
| **Shop map pin + GPS** — customers find you by location | Profile |
| **UPI ID** on Profile — required for the POS exact-amount QR | Profile → payments |
| **Unmet Demand** on Overview — searches that found zero products (last 30 days) | Overview |

## For customers

| Change | Where you use it |
|--------|------------------|
| **Credit / khata on Profile** — limit, outstanding, remaining, per shop | Profile |
| **Frequently bought together** — extra items other shoppers buy with yours | Product page and cart |
| **Location before shopping** — confirm city / GPS so nearby shops are real | App start |
| **Pack sizes** on product pages when the shop linked bulk and retail SKUs | Product page |
| **Out-of-stock items** are hidden from most catalog lists (you can still ask the shop) | Shop catalog |

## Still true (did not change)

- OrderEasy is **one shop**, not a marketplace
- OrderEasy does **not** send riders
- Payment still goes **to the shop** (cash, UPI, khata) — not to an OrderEasy wallet
- Scanner app **captures catalog**; it is not POS
- Retailer source of truth is `retailer_ordereasy_njs`; prod static export is `retailer_web_build`

## How this wiki is kept

- Canonical copy: Git folder [`wiki/`](README.md) in `RetailerCustomerPlatform`
- Last reviewed against code: **18 Sep 2026**
- Architecture for engineers: [`docs/02-ARCHITECTURE.md`](../docs/02-ARCHITECTURE.md)
