# Inventory Endpoints Overview

Inventory management APIs provide tools to manage inventory items, stock, suppliers, warehouses, and pricing. These endpoints support creating and managing items, categories, suppliers, warehouses, and price lists.

> **Not the item catalog.** These endpoints work on inventory items and require the Inventory module. To read the regular item catalog (available to every account, no Inventory module needed), see [Catalog Items](../catalog/overview.md).

### Endpoints in this section

| Endpoint | Page |
| -------- | ---- |
| `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetInventoryCategories` | [Item Categories](categories.md) |
| `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `GetSuppliers` | [Suppliers](suppliers.md) |
| `CreateWarehouse`, `UpdateWarehouse`, `GetWarehouses` | [Warehouses](warehouses.md) |
| `AddInventoryPricelist`, `UpdateInventoryPricelist`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`, `RemoveCustomerFromInventoryPricelist` | [Price Lists](pricelists.md) |
| `GetInventoryItems`, `GetActiveInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem` | [Inventory Items](items.md) |
| `GetInventoryCostReport`, `GetTopSoldItems`, `GetHighestByValue`, `GetItemsMovementReport`, `GetTotalMovementReport` | [Inventory Reports](reports.md) |
| `ReceiveToStock` | [Receive to Stock](receive-to-stock.md) |

### Requirements

All inventory endpoints require:
- **Authentication**: A valid API token via the `token` parameter
- **Inventory User**: Your user account must have inventory module permissions (checked via `IsInventoryUser`)
- **Organization**: All operations are scoped to your authenticated organization

### Common patterns

* **Filtering**: Most list endpoints accept an optional `isActive` parameter to filter by status. Nullable filters (`isActive`, date ranges, `serialNumber`, `batchNumber`, `customerID`, …) should be omitted from the request or sent as JSON `null` — never as an empty string `""`. The server only forwards a filter to its stored procedure when it is present.
* **Response envelope**: All responses inherit from a base envelope structure with `Errors` (array), `Info`, and `OpenInfo` fields. Check `Errors.Count()` to validate success — except on the endpoints listed below, which do not return an envelope object at all for some or all of an invalid token, an expired account, and an inactive Inventory module (the three cases are not always handled the same way — see the table).
* **Token validation**: A missing/invalid token and an expired account are **not** the same failure, and endpoints don't always handle them the same way — see the table below.
* **Dates**: Every `DateTime`/`DateTime?` request and response field uses the WCF date format `"/Date(<milliseconds-since-epoch><±hhmm>)/"`. ISO date strings are not accepted.
* **RTL Support**: Hebrew text fields are supported in all string fields where applicable.

### Behavior when the token is invalid/expired, or the Inventory module is off {#module-inactive-behavior}

Every inventory endpoint calls `IsAuthenticated` and then `IsInventoryUser` before doing any real work — but what actually comes back on failure depends on exactly *which* check fails, and that is easy to get wrong:

* **A missing/undecryptable token** makes `IsAuthenticated` itself return `null` (verified live: `IsAuthenticated` with a bogus key returns `{"d":null}`). Every endpoint's very first line after that is `if (u.Errors.Count() > 0)` — since `u` is `null`, this throws a `NullReferenceException` **before any error object is built**. The endpoint's own `catch` block only logs the exception; it does not reset the return value. So a fully invalid token returns whatever the method's return variable was initialized to *before* the `try` block (typically `null`, sometimes an empty array/list, and in one case an unhandled exception — see the table).
* **An expired account** (`ExpiredAccount`, 66, added by `IsAuthenticated` when `ExpirationDate.AddDays(4) < DateTime.Now`) does **not** trigger this crash: `IsAuthenticated` still returns a real, non-null `User`, so `u.Errors.Count() > 0` evaluates normally (no exception) and the endpoint's own code runs the "unauthorized" branch on purpose, building a fresh error object and adding `UnauthorizedUser` (80) to it — the original `ExpiredAccount` code is discarded and replaced.
* **An inactive Inventory module** (valid token, but `IsInventoryUser` is `false`) is checked *after* the token check, so by then `u` is guaranteed non-null; every endpoint reaches this branch normally and builds a real error object with `UnauthorizedInventoryAttempt` (403) — except the small set of endpoints with the null-reference bug described below, which also apply to this branch.

| Endpoint | Invalid/missing token | Expired account | Inventory module inactive |
| --- | --- | --- | --- |
| `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetHighestByValue`, `ReceiveToStock` | `null` | `null` (same null-reference bug fires again when the endpoint tries to add the error to its own still-`null` return variable) | `null` (same bug) |
| `RemoveCustomerFromInventoryPricelist` | `false` | `false` | `false` |
| `GetInventoryCategories`, `GetSuppliers`, `GetWarehouses`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`, `GetInventoryItems`, `GetActiveInventoryItems`, `GetTopSoldItems` | `null` | one-element array carrying `UnauthorizedUser` (80) | one-element array carrying `UnauthorizedInventoryAttempt` (403) |
| `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `CreateWarehouse`, `UpdateWarehouse`, `AddInventoryPricelist`, `UpdateInventoryPricelist`, `CreateInventoryItem`, `UpdateInventoryItem` | `null` | object carrying `UnauthorizedUser` (80) | object carrying `UnauthorizedInventoryAttempt` (403) |
| `GetInventoryItem` | **Unhandled exception — a WCF fault, not a clean `{"d": …}` body.**¹ | `Item` object carrying `UnauthorizedUser` (80) | `Item` object carrying `UnauthorizedInventoryAttempt` (403) |
| `GetInventoryCostReport`, `GetTotalMovementReport` | empty array (`{"d":[]}`) | one-element array carrying `UnauthorizedUser` (80) | one-element array carrying `UnauthorizedInventoryAttempt` (403) |
| `GetItemsMovementReport` | `null` (`{"d":null}`) | `ItemsMovement` object carrying `UnauthorizedUser` (80), with `Item` and `ItemsBalance` both `null` | same shape, carrying `UnauthorizedInventoryAttempt` (403) |

¹ `GetInventoryItem`'s own `catch` block only logs and does not reassign its backing array, so the method's last line — `return items.FirstOrDefault();`, which runs *after* the `catch` block, not inside it — throws a second, unhandled `NullReferenceException` on a fully invalid token. Expect a WCF/ASP.NET fault response, not a JSON `d` envelope.

None of these methods set an explicit HTTP error status for the cases that *do* return cleanly — those come back as `200 OK` with the body shown above.

### Typical inventory management flow

1. **Setup**: Create categories, suppliers, and warehouses.
2. **Items**: Define inventory items with categories and variants.
3. **Pricing**: Create price lists and assign to customers.
4. **Stock**: Receive items, track movement, and generate reports.
5. **Reporting**: Query cost, top-sold, and high-value reports.
