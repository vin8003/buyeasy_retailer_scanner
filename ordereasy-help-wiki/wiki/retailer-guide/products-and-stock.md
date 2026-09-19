# Products and stock

Your **product catalog** is what customers see online and what staff search at POS. Keeping it accurate is one of the most important jobs on OrderEasy.

## Product list

Open **Products** to see everything in your catalog. Filter by category, stock (in / out / low), active vs inactive, featured, or seasonal. Search matches **product barcodes and batch barcodes**.

Each product typically has:

| Field | Purpose |
|-------|---------|
| Name | What customers and staff search for |
| Selling price | Current price |
| MRP | Printed price on pack (optional) |
| Barcode | For POS scan and label print |
| Category | Organisation and browsing |
| Stock quantity | How many available |
| Images | Photos for customer app |
| Active / inactive | Hide without deleting |

From the list you can edit a product, change price quickly, print labels, or open **product ledger**.

## Adding one product

1. Products → **Add product**
2. Fill name, price, unit, category
3. Add barcode if available (camera scan on the form works)
4. Upload photo (helps online sales)
5. Set opening stock if tracking inventory
6. Save

If the barcode is already in the **master catalog**, name and MRP may fill in for you.

## Categories

**Categories** group products for customer browsing (e.g. "Snacks", "Cleaning").

- Create categories before bulk-adding products
- A product usually belongs to one primary category
- Keep category names simple — customers scan them quickly

## Stock tracking

OrderEasy can track stock in two ways:

### Simple quantity

One number per product — goes down on sale, up on purchase or return.

### Batch tracking

For items bought at different costs, MRP, or lots:

- Each **batch** has its own barcode, quantity, MRP, and selling price
- Sales use the batch you pick at POS, or the oldest batch first (FIFO) when the system chooses
- You can hide a batch from the **customer app** (`Show on customer app`) while still selling it at POS — same prices, different visibility

![Inventory and batches](../../docs/visuals/inventory-and-batches.jpg)

*Illustration: how batch stock ties to purchases and sales.*

→ Technical detail: [inventory flow in docs](../docs/07-KEY-FLOWS/inventory-and-batches.md)

## Bulk products (parent / child)

Some items sell both wholesale and retail:

- **Parent:** Carton of 24 bottles
- **Child:** Single bottle

Linking them keeps stock in sync when you break a case. Child stock is derived from the parent using the conversion factor.

You can show or hide the **parent** on the customer app independently of the child packs (so shoppers see “1 bottle” without seeing the carton).

## Print labels

After prices and barcodes are right, print **stickers** and **rack tags** from Products or the dedicated Print Labels / Display Labels screens.

→ [Print labels and rack tags](print-labels.md)

## Adding many products at once

### Excel upload

1. Products → **Bulk add** → Excel template
2. Fill rows offline
3. Upload file
4. Review errors and confirm

Best when you already have a spreadsheet.

### Scanner app + review

1. Staff walks aisle with **scanner app** — scan barcodes, photograph the pack
2. Known barcodes may fill name and MRP from the master catalog
3. Session syncs to cloud
4. Retailer app → Products → **Bulk add** → open session
5. Review, fix names/prices, **commit** to live catalog

![Scanner to catalog flow](../../docs/visuals/scanner-to-catalog-flow.jpg)

→ [Scanner guide](../scanner-guide/README.md)

## Editing and deactivating

| Action | When |
|--------|------|
| **Edit price** | Regular price change — reprint labels if you use stickers |
| **Deactivate** | Seasonal item, not selling now — hidden from customers |
| **Edit inactive products** | You can still open and update an inactive SKU, then activate when ready |
| **Delete** | Rare — prefer deactivate to keep history |

Inactive products may still appear in old orders and reports.

## Featured and seasonal

Mark products as **featured** or **seasonal** so they show in special lanes on the customer shop home.

## Track inventory off

For items you do not count (for example prepared food), turn **Track inventory** off. They stay available without a stock number.

## Product ledger

**Product ledger** shows stock movements — sales, purchases, returns, removals. Use it to answer "why is stock X?" Rows that belong to an order open that order.

## Tips

| Tip | Why |
|-----|-----|
| Photograph top sellers first | Online conversion improves with images |
| Barcode every SKU you can | Faster POS |
| Reprint labels after a price change | Rack and pack match the bill |
| Reconcile stock weekly | Catch theft, damage, or data entry gaps |
| Match online price to counter | Avoid customer arguments — hide a batch from the app if it is counter-only |

→ [Purchases and suppliers](purchases-and-suppliers.md) · [POS billing](pos-billing.md)
