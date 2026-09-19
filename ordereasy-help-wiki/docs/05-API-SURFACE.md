# 05 – API surface

Inventory of the Django API as of **18 Sep 2026** (`RetailerCustomerPlatform` `main`). Host: `https://api.ordereasy.win/api/`.

This is a **route map**, not an OpenAPI spec. Behaviour lives in the view modules. Clients: `customer_ordereasy_njs`, `retailer_ordereasy_njs`, `buyeasy_retailer_scanner`.

Auth: JWT (SimpleJWT). Prefixes mounted in `ordering_platform/urls.py`.

## Mounts

| Mount | App |
|-------|-----|
| `/api/auth/` | `authentication.urls` |
| `/api/retailer/` and `/api/retailers/` | `retailers.urls` (same include twice) |
| `/api/customer/` | `customers.urls` |
| `/api/products/` | `products.urls` + ERP router |
| `/api/orders/` | `orders.urls` |
| `/api/cart/` | `cart.urls` |
| `/api/` | `offers.urls` (`/api/offers/…`) |
| `/api/returns/` | `returns.urls` |

## Auth (`/api/auth/`)

| Method implied | Path | Notes |
|----------------|------|--------|
| POST | `retailer/signup/` | Access code |
| POST | `retailer/login/` | |
| POST | `customer/signup/` | |
| POST | `customer/login/` | Phone + password |
| POST | `customer/google-login/` | May require phone + OTP |
| POST | `customer/verify-otp/`, `resend-otp/`, `request-verification/` | Phone bind / checkout verify |
| GET/PATCH | `profile/`, `profile/update/` | |
| POST | `change-password/`, `logout/` | |
| POST | `token/refresh/`, `token/verify/` | SimpleJWT |
| POST | `device/register/` | FCM |
| POST | `password/forgot/`, `password/reset/` | |
| POST | `password/email/forgot/`, `password/email/reset/` | |
| POST | `verify-email/`, `resend-email-otp/` | |

## Retailers (`/api/retailers/` or `/api/retailer/`)

| Path | Notes |
|------|--------|
| `profile/`, `profile/create/`, `profile/update/` | Includes UPI ID, lat/lng, receipt flags, `print_upi_qr_on_receipt` |
| `operating-hours/` | |
| `reward-config/` | |
| `` (list), `search/`, `categories/` | Public discovery |
| `cities/` | Operational cities (KAN-64) |
| `geo-estimate/` | IP / geo hint (KAN-64) |
| `<id>/` | Public shop detail |
| `<id>/reviews/`, `<id>/reviews/create/` | |

## Customers (`/api/customer/`)

| Path | Notes |
|------|--------|
| `profile/`, `profile/update/`, `dashboard/` | |
| `addresses/` CRUD | |
| `wishlist/` add/remove | |
| `notifications/` | |
| `loyalty/`, `loyalty/all/`, `loyalty/transactions/` | Per-shop points |
| `credit/all/` | Profile khata (KAN-70) |
| `reward-configuration/` | |
| `referral/apply/`, `referral/stats/` | |
| `retailer/list/`, `retailer/details/<id>/`, `retailer/update/<id>/` | CRM |
| `retailer/blacklist/toggle/` | |
| `retailer/ledger/<id>/`, `retailer/payment/record/`, `retailer/credit-limit/update/<id>/` | Khata |
| `loyalty/retailer-customers/` | |

## Products (`/api/products/`)

Retailer catalog: `''`, `search/`, `create/`, `<id>/`, `<id>/update/`, `<id>/delete/`, `bulk-update/`, `upload/`, `stats/`, `demand-insights/`, `master/search/`.

Scanner / bulk sessions: `upload/check/`, `upload/complete/`, `upload/session/create/`, `active/`, `add-item/`, `details/<session_id>/`, `update-items/`, `item/<id>/delete/`, `commit/`.

Public customer catalog (KAN-63 hides tracked OOS except product detail):

- `retailer/<id>/`, `search/`, `categories/`, `categories/<cat>/groups/`
- `featured/`, `best-selling/`, `buy-again/`, `recommended/`
- `frequently-bought-together/` (KAN-17)
- `deals-of-the-day/`, `budget-buys/`, `trending-now/`, `new-arrivals/`, `seasonal-picks/`
- `retailer/<id>/<product_id>/` (detail; not wrapped in hide-OOS)

Categories / groups / brands: `categories/`, `categories/all/`, create/update/delete, `product-groups/`, `brands/`.

### ERP (`/api/products/erp/`)

DRF viewsets: `suppliers`, `purchase-invoices`, `supplier-ledger`.

Extra: `pos-checkout/`, `verify-pos-customer/`, `search-pos-customers/` (includes online shoppers, KAN-73), `inventory-ledger/`, `daily-sales-summary/` (retailer **Daily Sales Report** at `/dashboard/reports` — today only, not in the sidebar), `dashboard/summary/`.

Supplier `PATCH` accepts `is_active` (KAN-78). Purchase invoices accept `bill_image`.

## Cart (`/api/cart/`)

`''`, `add/`, `items/<id>/`, `items/<id>/remove/`, `clear/`, `summary/`, `validate/`, `count/`.

## Orders (`/api/orders/`)

`place/`, `current/`, `history/`, `<id>/`, `<id>/status/`, `cancel/`, `modify/`, `confirm_modification/`, `submit_payment/`, `verify_payment/`, `estimated-time/`, `stats/`, `retailer-reviews/`, `<id>/feedback/`, `rate-customer/`, `return/`, chat `chat/`, `chat/send/`, `chat/read/`.

`?status=returned` matches sales returns (KAN-77).

## Offers (`/api/offers/`)

ViewSet CRUD. Public: `offers/public/retailer/<id>/`. POS/app calculate via offer engine (see [offer-calculation.md](07-KEY-FLOWS/offer-calculation.md)).

## Returns (`/api/returns/`)

ViewSets: `sales/`, `purchase/`.

## Not in this API

- Label HTML print (retailer browser)
- Dynamic UPI intent URI (retailer browser from profile UPI ID)
- Landing page
- Delivery/rider service

## Related

- User-facing map: [wiki/project/apis.md](../wiki/project/apis.md)
- Architecture: [02-ARCHITECTURE.md](02-ARCHITECTURE.md)
- Release notes: [releases/2026-08-agent-batch.md](releases/2026-08-agent-batch.md)
