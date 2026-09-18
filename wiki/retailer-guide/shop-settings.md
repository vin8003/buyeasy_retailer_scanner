# Shop settings

Configure how your shop appears to customers and how online ordering behaves.

## Profile

**Profile** holds your shop’s public identity:

| Setting | Customers see this |
|---------|-------------------|
| Shop name | On shop list and storefront |
| Description | Short intro optional |
| Phone | For calls about orders (you can verify with OTP) |
| Logo / images | Branding in app |
| Payment methods accepted | At checkout |

Keep name consistent with what locals call your shop — easier to find.

## Shop location

Pin your shop on the **map**:

- Search the address, use **GPS**, or drag the pin
- Customers use this for distance and discovery
- Set pin at your actual storefront
- Update if you move (rare)

Customers are asked for **their** location at app start — your pin is where **you** are.

## Operating hours

**Operating hours** define when you are open each day. You can copy Monday’s hours to the rest of the week.

Customers may still place orders outside hours — those wait until you open. Confirm that with staff.

## Delivery and pickup

Configure what you offer:

| Option | Settings |
|--------|----------|
| **Pickup** | Always available if enabled — customer collects |
| **Delivery** | Delivery radius, minimum order, delivery charge, serviceable pincodes, free-delivery threshold |

Be realistic with radius — overpromising causes bad reviews.

### Delivery charges

Common models:

- Flat fee per order
- Free above minimum cart value
- No delivery (pickup only)

Set charges customers see **before** checkout.

## Payment settings

Enable methods you actually accept:

- Cash on delivery
- UPI on delivery
- Credit for known customers (POS mainly)

Also set:

| Field | Why |
|-------|-----|
| **UPI ID** | POS shows an **exact-amount QR** from this ID |
| **UPI QR image** | Optional static QR you already use |
| **Accept COD / Accept UPI** | What customers see at checkout |

Mismatch between settings and reality frustrates customers.

## Receipts (thermal bills)

| Setting | Effect |
|---------|--------|
| Show GST on receipt | Prints shop GSTIN when you have one |
| Printer size | 58 mm or 80 mm |
| Footer message | Extra line on the bill |
| Print UPI QR on receipt | Adds a UPI QR to the printed bill (uses your UPI ID) |

Product **stickers** and **rack tags** are separate — see [Print labels](print-labels.md). Receipt size is for bills, not stickers.

## Notifications

Ensure staff devices allow **push notifications** for new online orders. Missing alerts means delayed confirmations. Order counts on the sidebar refresh when a new order arrives — they do not poll all day.

## Access and staff

Currently one retailer account model per shop onboarding. Train all staff on:

- Who confirms online orders
- Who can change prices
- Who handles supplier payments

Document internal roles even if the app has one login today.

## Before going live checklist

- [ ] Shop name, phone, and **map pin** correct
- [ ] **UPI ID** saved if you take UPI at POS
- [ ] Operating hours set
- [ ] Delivery/pickup rules match what you tell customers
- [ ] Top products added with prices and barcodes
- [ ] Test order from customer app completed once
- [ ] Test POS sale + receipt print

→ [Getting started for retailers](../getting-started/for-retailers.md) · [POS billing](pos-billing.md)
