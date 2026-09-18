# How the apps talk to the API

This page is the **plain-language API map**. Engineers who need every path should read [`docs/05-API-SURFACE.md`](../../docs/05-API-SURFACE.md). Shop owners do not need this page to run the store.

## One backend

Every app talks to **the same Django API**:

`https://api.ordereasy.win/api/`

| App | Repo | How it authenticates |
|-----|------|----------------------|
| Customer web / Android | `customer_ordereasy_njs` | JWT after phone+password or Google |
| Retailer web | `retailer_ordereasy_njs` | JWT after username+password |
| Scanner | `buyeasy_retailer_scanner` | Same retailer login JWT |
| Static prod sites | `customer_web_build`, `retailer_web_build` | Same API; they are exports of the njs apps |

There is **no** separate marketplace API, delivery API, or payment-processor API. Images go through `images.ordereasy.win` (CORS proxy).

```
Customer app ──┐
Retailer app ──┼── HTTPS + JWT ──► api.ordereasy.win ──► PostgreSQL
Scanner app  ──┘                         │
                                         └── Firebase FCM (push)
```

## Prefixes

| Prefix | Used by | Job |
|--------|---------|-----|
| `/api/auth/` | Both | Login, signup, Google, OTP/email verify, JWT refresh, profile, password reset, FCM device |
| `/api/retailer/` and `/api/retailers/` | Retailer + customer discovery | Shop profile, hours, rewards config, city list, geo estimate, public shop list |
| `/api/customer/` | Customer + retailer CRM | Addresses, wishlist, loyalty, **credit/all**, retailer customer list, khata ledger |
| `/api/products/` | Both + scanner | Catalog, search, batches, bulk/session upload, public shop catalog, FBT, POS checkout |
| `/api/cart/` | Customer | Guest-capable cart |
| `/api/orders/` | Both | Place, track, modify, chat, pay reference, stats, reviews |
| `/api/offers/` | Both | Retailer CRUD + public offers for a shop |
| `/api/returns/` | Retailer | Sales returns and purchase returns |

ERP-style retailer paths live under `/api/products/erp/` (suppliers, purchase invoices, supplier ledger, POS checkout, POS customer search, inventory ledger, dashboard summary, **daily-sales-summary**).

## Flows that matter

| What the user does | API (simplified) |
|--------------------|------------------|
| Customer logs in | `POST /api/auth/customer/login/` or `.../google-login/` |
| Customer sees shops | `GET /api/retailers/` + `GET /api/retailers/cities/` |
| Customer browses a shop | `GET /api/products/retailer/<id>/` (out-of-stock hidden when tracked) |
| Frequently bought together | `GET /api/products/retailer/<id>/frequently-bought-together/` |
| Checkout | cart endpoints then `POST /api/orders/place/` |
| Remaining khata on Profile | `GET /api/customer/credit/all/` |
| Retailer POS sale | `POST /api/products/erp/pos-checkout/` |
| POS customer typeahead | `GET /api/products/erp/search-pos-customers/` |
| Scanner capture | `POST /api/products/upload/session/create/` then `add-item/` then web `commit/` |
| Supplier deactivate | `PATCH /api/products/erp/suppliers/<id>/` with `is_active` |
| Daily Sales Report (today closing) | `GET /api/products/erp/daily-sales-summary/` |

Label printing and the POS UPI QR are **browser-side**. They do not add new payment APIs. The QR is built from the shop’s saved **UPI ID** on the retailer profile.

## Auth rules of thumb

- Access + refresh JWT (`/api/auth/token/refresh/`).
- Customer Google may return `phone_required` / `otp_required` — bind mobile before treating login as complete.
- Guest cart is local until login; then it syncs. Do not wipe it with an empty token.
- Scanner uses **retailer** login, not a customer account.

## What is not an API

- Print Labels / Display Labels — print HTML in the retailer browser
- Thermal receipts — same
- Landing page — static HTML at ordereasy.win
- Delivery dispatch — no rider service; status is just `Order` fields

→ [All apps](all-apps.md) · [How everything works together](how-it-works-together.md) · [Architecture](../../docs/02-ARCHITECTURE.md)
