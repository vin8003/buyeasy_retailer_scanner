# POS billing (counter sales)

**POS Billing** is your digital cash register for walk-in customers. It is built for the speed of a busy kirana counter.

## When to use POS

- Customer is physically at your shop
- You are scanning or searching products and taking payment now
- You may sell on **cash**, **UPI**, **credit (khata)**, or **split payment**

Online orders use the **Orders** section instead — but they draw from the **same stock** as POS.

## Starting a new bill

1. Open **POS Billing** from the sidebar
2. Search for a product by **name** or scan **barcode**
3. Tap product to add to bill — adjust quantity as needed
4. Repeat for all items

Shortcuts that help on a busy counter:

| Action | How |
|--------|-----|
| Search | Focus the search box and type or scan |
| Quantity from barcode | Scan or type `barcode*qty` then Enter (example: `8901234567890*3`) |
| Several open bills | Use bill **tabs** so one customer can wait while you serve another |
| Keyboard help | Open the shortcuts panel / onboarding tour on POS |

## Product not in catalog / unknown barcode

If a scan does not match a product:

1. Create a **new SKU** from that barcode, or
2. **Link** the barcode to an existing product as another batch (common when a dummy barcode was used at first)

Do not invent a second product for the same pack if you can link it.

If one barcode matches **several batches** (different MRP or lots), POS asks which batch to sell.

## Attaching a customer (optional)

You can bill anonymously or link the sale to a customer:

- Search by **phone** (from about 3 digits) — name appears when known
- Results are **your shop’s customers**, including people who ordered **online** before
- Linking helps track purchase history and credit

Useful for regulars who buy on udhaar.

## Applying offers

If you have active offers for POS:

- Eligible discounts may apply automatically
- You can also enter a **manual ₹ discount** — the bill uses the better of the two

Configure offers in **Offers**. The same engine can run on POS and the customer app.

## Taking payment

| Payment type | When to use |
|--------------|-------------|
| **Cash** | Customer pays notes/coins |
| **UPI** | Customer pays via UPI to your shop |
| **Credit (khata)** | Customer owes you — added to their ledger |
| **Split** | Part cash, part UPI, and/or part credit |

Credit sales need a **10-digit mobile** on the bill and stay within the customer’s **credit limit** (if you set one).

### Exact-amount UPI QR

When you choose **UPI** or a **split** that includes UPI, POS can show a **QR for this bill’s amount** (or just the UPI portion of a split).

- Customer scans with any UPI app and pays that amount
- You must save a **UPI ID** under **Profile** first — without it, POS tells you to add one
- This is still **your** UPI. Money goes to the shop, not to OrderEasy

You can also keep a static QR image on Profile for cases where you prefer that. The POS QR is generated for the current total so the customer does not type the amount.

## Complete the bill

1. Review total
2. Confirm payment method(s)
3. **Complete** the sale
4. **Print receipt** if you use a printer (58 mm or 80 mm — set in Profile)

Optional on the receipt: shop GST, footer message, and a **UPI QR** (Profile toggle **Print UPI QR on receipt**).

Stock reduces immediately for sold items.

After checkout you can optionally **rate** the linked customer.

## Print labels from the cart

If you just added new packs and need stickers, use **Print Labels** from the POS cart. That opens the same barcode-sticker list as the Print Labels menu.

→ [Print labels and rack tags](print-labels.md)

## Returns at POS

If a customer returns something from a previous bill:

- Use the **return** flow from POS
- Find the original sale by order number, mobile, or name
- Stock goes back in; refund cash or UPI as you choose

Process returns carefully — they affect inventory and customer balance. Fully returned sales also show under Orders → **Returned**.

## Tips for fast billing

| Tip | Benefit |
|-----|---------|
| Keep barcodes on products | Scan instead of search |
| Print labels after a price change | Sticker matches the bill |
| Create customer records for regulars | Faster credit sales |
| Save UPI ID in Profile | Exact-amount QR appears on UPI bills |
| Train staff on split payment | Common at kirana counters |

## Common situations

| Situation | What to do |
|-----------|------------|
| Product not found | Add or link the barcode; or search by name |
| Wrong quantity entered | Tap the line to edit before completing |
| Customer over credit limit | Take partial cash / UPI, or raise the limit if you intend to |
| Price dispute | Check product master price; edit product if the change is permanent |
| UPI QR missing | Add UPI ID in Profile |

→ [Products and stock](products-and-stock.md) · [Customers and credit](customers-and-credit.md) · [Payments](../shared/payments.md)
