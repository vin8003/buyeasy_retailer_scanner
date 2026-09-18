# Reports and reviews

Understand how your shop is performing today and what customers think.

## Daily Sales Report

The retailer app has a **Daily Sales Report** page at `/dashboard/reports` titled **Daily Sales Report**. It is a **today-only closing summary** (not a weekly/monthly analytics suite).

It is **not** in the sidebar or bottom navigation today. Open it by going to:

`https://retailer.ordereasy.win/dashboard/reports`

(or the same path on your shop’s retailer origin).

The page loads `GET /api/products/erp/daily-sales-summary/` and shows:

| Block | What it is |
|-------|------------|
| **Total Sales Today** | Today’s rupees and order count, plus average order value |
| **Payment Breakdown** | Cash in hand vs digital, with refund deductions when present |
| **Channel Performance** | POS sales vs online store for today |
| **Print Closing Summary** | Browser print of this page |

**Refresh** reloads today’s numbers. There is no date picker and no product-level report on this screen.

Period stats (today / week / month / custom) live on **Overview** — see [Dashboard overview](dashboard.md). **Unmet Demand** on Overview is a different question: which searches in your shop returned nothing in the last 30 days.

Use the Daily Sales Report at close of day to print a till-vs-digital snapshot. Use Overview during the day for the date-filtered pulse.

## Reviews

**Reviews** (sidebar) shows ratings and comments customers leave after delivery.

### Why reviews matter

- Build trust with new online customers
- Spot recurring problems (packing, timing, wrong items)
- Respond to feedback and improve

### Responding to bad reviews

1. Read calmly — fix process not argument
2. Contact customer if appropriate via order chat
3. Fix root cause (stock, delivery time, staff training)

Public reviews influence whether neighbours try your online ordering.

## Dashboard vs Daily Sales Report vs Reviews

| Tool | Where | Best for |
|------|-------|----------|
| **Overview** | Sidebar | Date-filtered pulse, Unmet Demand, recent sales |
| **Daily Sales Report** | `/dashboard/reports` (not in the sidebar) | Printable **today** closing summary |
| **Reviews** | Sidebar | Ratings and comments |

## Order stats

Some builds show live order counts or polling stats on dashboard — useful during festivals when online volume spikes.

→ [Dashboard overview](dashboard.md) · [Online orders](online-orders.md)
