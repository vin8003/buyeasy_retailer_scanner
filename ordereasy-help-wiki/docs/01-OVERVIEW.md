# 01 – Project Overview

## Project Identity

**Name**: OrderEasy / BuyEasy / Shopeasy  
**Production API**: `https://api.ordereasy.win/api/`  
**Purpose**: A complete local retail ordering + store management platform for neighbourhood retailers and their customers in India.

## Value Proposition

- **For Customers**: Modern ordering experience from local stores (browse, cart, track, rewards, chat, per-shop khata on Profile).
- **For Retailers**: Full digital store operating system (online orders + POS + barcode/display labels + inventory with batches + supplier purchases + loyalty + CRM + credit/khata).

## Component Map

| Component | Repository | Technology | Role |
|-----------|------------|------------|------|
| Backend API | `RetailerCustomerPlatform` | Django + Django REST Framework | Core platform (auth, products, inventory, orders, cart, offers, loyalty, returns, purchases) |
| Customer App | `customer_ordereasy_njs` | Next.js + TypeScript + Capacitor | Customer-facing web + hybrid mobile app |
| Retailer Dashboard + POS | `retailer_ordereasy_njs` | Next.js 16 + React 19 + TypeScript + shadcn/ui | Retailer web app (dashboard, POS, print/display labels, product management, purchases, offers, customers, reports). Prod static export: `retailer_web_build`. |
| Retailer Scanner | `buyeasy_retailer_scanner` | Flutter + ML Kit | Barcode scan, pack photo, master-catalog fill-in, upload sessions. An OCR form screen exists in the repo but is **not** on the live capture path. |

## User Personas

| Persona | Description | Main Goals |
|---------|-------------|------------|
| Customer | Local shoppers | Discover nearby stores, place orders, track status, earn rewards |
| Retailer / Shop Owner | Store owners or staff | Manage inventory, process online + walk-in orders, handle purchases, create offers, manage customers & credit |
