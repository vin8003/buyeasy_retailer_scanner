# Print labels and rack tags

Print **barcode stickers** for packs and **larger display labels** for racks. Both use the browser print dialog — typically a thermal label printer connected to the computer or phone that is running the retailer app.

These screens are in the retailer sidebar as **Print Labels** and **Display Labels**. You can also send products here from the **Products** list and from the **POS** cart.

## Two kinds of labels

| Kind | Menu | Typical use | Sizes |
|------|------|-------------|-------|
| **Barcode stickers** | Print Labels | Stick on the pack so POS can scan | 50×25 mm or 38×25 mm |
| **Display / rack tags** | Display Labels | Sit on the shelf so customers see price | Thermal rolls: 100×75 (4:3), 75×50 (3:2), **75×75 (1:1)**, **75×25 (3:1)**, or A4 sheet (21 labels) |

Barcode stickers are for **staff and scanners**. Display labels are for **shoppers looking at the rack**.

## Print Labels (barcode stickers)

### Build a print list

1. Open **Print Labels**
2. Search products by name or barcode and tap to add
3. Or from **Products**, select items and choose Print Labels
4. Or from **POS**, use the Print Labels action on the current cart

Each row is one product. Set **how many copies** you need (one sticker per pack on the shelf).

### What can appear on a sticker

Turn fields on or off in the template:

| Field | Typical |
|-------|---------|
| Shop name | On |
| Product name | On |
| MRP | On |
| Selling price | On |
| Barcode (CODE128) | On — this is what POS scans |
| Weight | Off unless you pack loose goods |
| Packing date | Off unless you need it |
| Expiry date | Off unless you need it |

Preview updates as you change size, columns, and fields.

### Print

1. Check the live preview
2. Tap **Print**
3. In the browser dialog, pick your **label printer**
4. Paper size should match the sticker (50×25 or 38×25). Do not scale to A4 unless you meant to

Works with common thermal label printers (for example TVS LP46NEO). If barcodes look stretched, check printer paper size and disable “fit to page”.

## Display Labels (rack / shelf tags)

1. Open **Display Labels**
2. Search and add products
3. Pick a size. Layout follows the paper:

| Size | Shape |
|------|--------|
| 100×75 mm | Tall (4:3) |
| 75×50 mm | Tall (3:2) — default |
| 75×75 mm | Square (1:1) |
| 75×25 mm | Wide strip (3:1) |
| A4 21-up | 3 columns × 7 rows on A4 |

4. Turn fields on or off: product name, MRP, selling price, savings (“Save ₹…”), discount (“18% OFF”), barcode (CODE128 or EAN13)
5. Preview, then print. If a thermal tag looks stretched landscape, pick the matching roll size and do not “fit to page”

Use these when you want a **large price** at eye level. You can still print a barcode on the rack tag; pack stickers remain the POS scan surface.

## After a price change

When you change selling price or MRP on a product, the app can prompt you to **print updated labels**. Print the new sticker before the old one confuses customers or staff.

## Tips

| Tip | Why |
|-----|-----|
| Put a barcode on every SKU you sell at POS | Scan instead of search |
| Reprint after a price change | Rack price matches the bill |
| Keep barcode stickers on the pack, display labels on the shelf | Two jobs, two sizes |
| Set **UPI ID** in Profile if you also print UPI QR on receipts | Separate from product labels |

## Related

- [Products and stock](products-and-stock.md)
- [POS billing](pos-billing.md)
- [Shop settings](shop-settings.md) (receipt printer size is for bills, not stickers)
