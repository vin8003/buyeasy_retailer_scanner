# Common questions

Quick answers for customers and shop owners.

## General

### What is OrderEasy?

Software for a **local kirana or shop** — counter billing, stock, supplier accounts, and online orders from customers who already know you. [Learn more](../welcome/what-is-ordereasy.md)

### Is OrderEasy a marketplace like Blinkit or Amazon?

**No.** Customers pick **one specific shop** and order from that shop’s catalog only. [What it is not](../welcome/what-it-is-not.md)

### Does OrderEasy deliver my order?

**No.** The **shop** delivers or you pick up. OrderEasy does not send its own riders.

### Do I need to install an app?

**Customers:** No — use [customer.ordereasy.win](https://customer.ordereasy.win) in your browser.  
**Retailers:** No — use [retailer.ordereasy.win](https://retailer.ordereasy.win).  
**Scanner:** Yes — Android app for bulk product capture.

### What changed recently?

See [What’s new](../whats-new.md) (last reviewed 18 Sep 2026).

---

## For customers

### How do I find my shop?

Open the customer app, confirm location or pick a city, then search the shop list. [Find your shop](../customer-guide/find-your-shop.md)

### How do I log in?

Use **phone + password**, or **Google**. New accounts also verify **email**. Google may ask for phone + OTP once so the shop has a mobile number. This is not passwordless SMS login every time. [Your account](../customer-guide/your-account.md)

### Can I order without signing up?

You can browse and add to cart as a guest. Signup is usually required at checkout. Your cart should stay after signup.

### Why was my order changed?

The shop may be out of something. They modify the order and you must **approve** the changes in the app.

### How do I pay?

Usually **Cash on Delivery** or **UPI** when you receive the order. Payment goes to the shop, not to OrderEasy. At the counter, the shop can show a QR for the **exact bill amount**.

### Where do I see my khata / remaining credit?

**Profile → Credit / Khata**, per shop (limit, outstanding, remaining). Loyalty points are a separate block on the same screen.

### Can I use reward points at any shop?

**No.** Points are **per shop** — only at the shop where you earned them.

### What is “frequently bought together”?

Suggestions on the product page and cart of items other people at **this shop** often buy with yours. Optional.

### My order says Pending for a long time

The shop may be busy or closed. Message them via **order chat** or call the shop phone on their profile.

---

## For retailers

### How do I sign up?

Go to [retailer.ordereasy.win](https://retailer.ordereasy.win) → Sign up with your **access code** from OrderEasy onboarding. [Getting started](../getting-started/for-retailers.md)

### Do online orders use different stock than POS?

**No.** One inventory. Selling at counter reduces what customers see online.

### How do I add many products quickly?

Use the **scanner app** to capture barcodes and pack photos, then **Bulk Add** in retailer web to review and commit. [Scanner guide](../scanner-guide/README.md)

### How do I print barcodes and rack prices?

**Print Labels** for pack stickers, **Display Labels** for shelf tags. You can also start from Products or the POS cart. [Print labels](../retailer-guide/print-labels.md)

### Why is there no UPI QR on POS?

Save a **UPI ID** under Profile. POS then shows an exact-amount QR for UPI and split bills.

### Can I sell on credit (udhaar)?

**Yes** at POS for customers you trust. Balance shows in **Customers → ledger**. Customers see remaining credit on their Profile. [Customers and credit](../retailer-guide/customers-and-credit.md)

### What if I need to change a customer’s order?

Use **modify** in Orders. Customer must **approve** before you pack.

### Can I hide a pack from the customer app but still sell it at POS?

**Yes** — turn off **Show on customer app** for that batch, or hide the parent bulk SKU while leaving child packs visible.

### How do I stop using a supplier without losing khata?

**Deactivate** them in Khata / Suppliers. Old bills stay; they disappear from new purchase pickers. You can still record payments.

### Is there a rider app?

**No.** Your staff delivers or customer picks up. [Delivery and pickup](../shared/delivery-and-pickup.md)

### How do I track what I owe suppliers?

**Purchases** and **Supplier khata** in retailer app. Attach a **bill photo** when you record inward stock. [Purchases and suppliers](../retailer-guide/purchases-and-suppliers.md)

### What is Unmet Demand on Overview?

Customer searches in **your** shop that returned **zero products** in the last 30 days. Add the SKU or fix the product name. [Dashboard](../retailer-guide/dashboard.md)

### Where is Reports in the retailer menu?

**Daily Sales Report** is not in the sidebar. Open `/dashboard/reports` for a printable **today** closing summary (cash vs digital, POS vs online). Date-filtered stats stay on **Overview**. [Reports and reviews](../retailer-guide/reports-and-reviews.md)

---

## Troubleshooting

| Problem | Try |
|---------|-----|
| Customer cannot see my shop | Check shop **map pin**, that you are active, and that the customer confirmed the right city |
| Barcode not scanning at POS | Add barcode on product; print a new sticker; or search by name |
| POS UPI QR missing | Add UPI ID in Profile |
| Cannot find Reports in the sidebar | Open `/dashboard/reports` for today’s closing summary; Overview has date filters |
| Label print looks stretched | Pick the sticker paper size in the print dialog; do not “fit to page” |
| Scanner session missing on web | Wait for sync; refresh Bulk Add page |
| Email / reset OTP not arriving | Check spam; retry; contact support |
| Wrong stock count | Review recent sales, purchases, returns in product ledger |

---

## Still need help?

- **Customers:** Support in profile, or chat on specific order
- **Retailers:** Your OrderEasy onboarding contact
- **Developers:** See [`docs/`](../docs/DOCUMENTATION.md)
