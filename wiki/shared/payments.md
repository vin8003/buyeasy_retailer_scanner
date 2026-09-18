# Payments

How money moves in OrderEasy — simple and shop-direct.

## Important principle

**Payment goes directly to the shop**, not to OrderEasy. The system records *how* the customer paid for the shop’s books. OrderEasy is not a wallet or a payment processor.

## Customer app payments

| Method | How it works |
|--------|--------------|
| **Cash on Delivery (COD)** | Customer pays cash when order arrives or at pickup |
| **UPI** | Customer pays the shop’s UPI when receiving the order |

Checkout selects the **intended** method. On the order screen the shop may show UPI ID / QR and ask for a transaction reference. Credit/khata is **not** a checkout button on the customer app — it is a shop-side ledger (you can **see remaining credit** on Profile after the shop has given you a limit).

## POS payments (counter)

| Method | How it works |
|--------|--------------|
| **Cash** | Till receives notes/coins |
| **UPI** | POS shows an **exact-amount QR** for this bill (or the UPI part of a split). Customer scans it. Requires **UPI ID** in Profile |
| **Credit (khata)** | Amount added to customer ledger — pay later |
| **Split** | Combination e.g. part cash + part UPI + part credit |

You can still print or display a **static** shop QR if you prefer. The generated POS QR exists so the customer does not type the amount.

Thermal receipts can optionally include a UPI QR — turn that on under Profile → receipt settings.

## Customer credit vs payment

**Credit is not a payment gateway** — it is bookkeeping:

- Shop trusts customer to pay later
- Balance tracked in **Customers → ledger** (shop) and **Profile → Credit / Khata** (customer)
- Settlement happens offline (cash/UPI to shop)

## Supplier payments (shop side)

Separate from customer payments — **supplier khata** tracks what **shop owes wholesalers**. Record payments when you pay supplier.

## Rewards and discounts

- **Offers** reduce order total before payment
- **Reward points** may reduce amount due at checkout
- Shop still receives net amount (or records credit for balance)

## Reconciliation tips for retailers

| Daily | Weekly |
|-------|--------|
| Match COD collected vs delivered orders | Reconcile customer khata collections |
| Check UPI receipts vs UPI-tagged POS bills | Match supplier payments to khata |

→ [Cart and checkout (customers)](../customer-guide/cart-and-checkout.md) · [POS billing](../retailer-guide/pos-billing.md) · [Customers and credit](../retailer-guide/customers-and-credit.md)
