# Using the scanner app

Step-by-step guide for capturing products on your Android phone.

The scanner **captures** barcodes, names, prices, and pack photos into an **upload session**. It is not the POS and it does not publish the catalog. The manager reviews sessions on the retailer website.

## Install and login

1. Install the **Retailer Scanner** app (also called BuyEasy Scanner in some docs) on your Android phone
2. Open app → **Login**
3. Use the **same username and password** as retailer.ordereasy.win
4. If your shop uses a custom server (staging), configure API URL in settings — production shops use default

## Home / gateway

After login you choose to **create or resume an upload session**. Sessions are named batches of products you are capturing — e.g. "Aisle 1 March" or "New stock 18 Sep".

Review and processing still happen in the **retailer app**.

## Create or resume a session

| Action | When |
|--------|------|
| **New session** | Starting a fresh batch of products |
| **Resume session** | Continue yesterday’s work |

Give sessions clear names so the manager knows what to review.

## Capture a product

Inside a session:

### Scan barcode

1. Point camera at barcode
2. App reads barcode automatically
3. Barcode field fills in

You can also **enter the barcode manually** if the camera cannot read it.

### Master catalog fill-in

If that barcode is already known to OrderEasy, **name, MRP, and product group** may fill in automatically. Check they match the pack in your hand.

### Photograph the pack

1. Tap camera to capture the product front
2. Retake if the photo is dark or cropped
3. The photo is uploaded with the item for the manager to review

The live capture path is **barcode + optional catalog lookup + photo + typed fields**. Do not wait for the app to “read” the whole label as OCR — if a field is blank, type it.

### Enter or edit details

| Field | Notes |
|-------|-------|
| Barcode | From scan or manual |
| Name | Product title customers will see |
| MRP | Printed maximum retail price |
| Selling price | Your shop price |
| Quantity | How many on shelf (optional at capture) |
| Product group | Link bulk/parent items if applicable |

### Save to session

Tap save — item joins the session queue. Repeat for next product.

## Sync

Sessions sync to the cloud when online. The manager can review on retailer web even while you keep scanning.

## Tips for fast capture

| Tip | Why |
|-----|-----|
| Good lighting | Better barcode read and pack photo |
| Hold steady on barcode | Fewer failed scans |
| One aisle per session | Easier review |
| Fix wrong auto-filled names now | Less work at review |

## Troubleshooting

| Problem | Try |
|---------|-----|
| Barcode not scanning | Clean lens; enter manually |
| Name or price blank | Type it — catalog lookup only works for known barcodes |
| Cannot login | Check credentials; check internet |
| Session not visible on web | Wait for sync; pull to refresh on web Bulk Add |

→ Next: [Adding products in bulk](adding-products-in-bulk.md)
