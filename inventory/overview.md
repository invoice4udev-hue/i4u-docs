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
* **Response envelope**: All responses inherit from a base envelope structure with `Errors` (array), `Info`, and `OpenInfo` fields. Check `Errors.Count()` to validate success — except on the endpoints listed below, which do not return an envelope object at all when the token is invalid/expired or the Inventory module is off.
* **Token validation**: Most endpoints validate the authentication token first and return an `UnauthorizedUser` (80) error object when it is invalid or expired — see the table below for the endpoints that don't.
* **Dates**: Every `DateTime`/`DateTime?` request and response field uses the WCF date format `"/Date(<milliseconds-since-epoch><±hhmm>)/"`. ISO date strings are not accepted.
* **RTL Support**: Hebrew text fields are supported in all string fields where applicable.

### Behavior when the token is invalid/expired, or the Inventory module is off {#module-inactive-behavior}

Every inventory endpoint calls `IsAuthenticated` and then `IsInventoryUser` before doing any real work. What is actually returned when either check fails is **not** the same for every endpoint — most build a normal error object, but a handful have a null-reference bug or an early `return` that skips the error object entirely. Check this table before assuming an endpoint follows the general contract described above.

| What is returned | Endpoints |
| --- | --- |
| A normal error object (or, for list endpoints, a one-element array) carrying `UnauthorizedUser` (80) for an invalid/expired token, or `UnauthorizedInventoryAttempt` (403) for a valid token without Inventory-module access | `GetInventoryCategories`; `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `GetSuppliers`; `CreateWarehouse`, `UpdateWarehouse`, `GetWarehouses`; `AddInventoryPricelist`, `UpdateInventoryPricelist`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`; `GetInventoryItems`, `GetActiveInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem`; `GetInventoryCostReport`; `GetTopSoldItems`; `GetItemsMovementReport` (error object with `Item` and `ItemsBalance` both `null`); `GetTotalMovementReport` (as a one-element array) |
| `null` — a null-reference bug discards the error object before it can be added (`CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`), or the method returns early without building one (`GetHighestByValue`, `ReceiveToStock`) | `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetHighestByValue`, `ReceiveToStock` |
| `false` | `RemoveCustomerFromInventoryPricelist` |

None of these methods set an explicit HTTP error status — everything comes back as `200 OK` with the body described above (or the invalid-token shape noted per endpoint on its own page, e.g. `GetItemsMovementReport`/`GetTotalMovementReport` returning `{"d":null}`/`{"d":[]}` for a fully invalid token instead of an error object).

### Typical inventory management flow

1. **Setup**: Create categories, suppliers, and warehouses.
2. **Items**: Define inventory items with categories and variants.
3. **Pricing**: Create price lists and assign to customers.
4. **Stock**: Receive items, track movement, and generate reports.
5. **Reporting**: Query cost, top-sold, and high-value reports.
