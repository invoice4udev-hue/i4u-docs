# Catalog Item Endpoints Overview

The catalog is the organization's list of products and services: code, name, price and VAT. It's the same item catalog every Invoice4U account has in the web app. **It does not require the Inventory module.**

### Availability

| Endpoint | Operation | Requires Inventory module |
| -------- | --------- | ------------------------- |
| [`GetCatalogItems`](get-catalog-items.md) | Read (list) | No |
| [`GetCatalogItemByCode`](get-catalog-item-by-code.md) | Read (single item by code) | No |

* **Read-only.** The API has no endpoint to create, update or delete catalog items. Manage the catalog in the Invoice4U web app.
* **No free-text search.** `GetCatalogItems` returns the full list (filter it on your side); `GetCatalogItemByCode` matches an exact code.
* **Inventory endpoints are separate.** `GetInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem` and the other `*Inventory*` endpoints work on inventory items, not on the catalog, and require an active Inventory module. Without it they return `UnauthorizedInventoryAttempt` (403). See [Inventory Endpoints Overview](../inventory/overview.md).

### The CatalogItem object

| Field | Type | Description |
| ----- | ---- | ----------- |
| `ID` | int | Catalog item ID. |
| `UserId` | int | Owning organization ID. |
| `Code` | string | Item code (SKU). Empty string when not set. |
| `Name` | string | Item name. |
| `Price` | double | Unit price before VAT. |
| `PriceAfterTax` | double | Unit price including VAT. |
| `VatPercentage` | double | VAT percentage for the item. |
| `IsActive` | boolean | Whether the item is active. Returned by `GetCatalogItems` only (`null` otherwise). |
| `IsNonStockItem`, `TotalQuantityInStock`, `TotalQuantity`, `SerialNumber`, `BatchNumber`, `IsNew` | — | Inventory-related fields. Ignore them for accounts without the Inventory module. |

The object also carries the standard `Errors` / `Info` envelope fields.

### Pages in this section

* [Get Catalog Items](get-catalog-items.md) — list the organization's catalog
* [Get a Catalog Item by Code](get-catalog-item-by-code.md) — look up one item by its code
