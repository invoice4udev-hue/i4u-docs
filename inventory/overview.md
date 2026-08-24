# Inventory Endpoints Overview

Inventory management APIs provide comprehensive tools to manage product catalogs, stock, suppliers, warehouses, and pricing. These endpoints support creating and managing items, categories, suppliers, warehouses, and price lists.

### Endpoints in this section

| Endpoint | Page |
| -------- | ---- |
| `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetInventoryCategories` | [Item Categories](categories.md) |
| `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `GetSuppliers` | [Suppliers](suppliers.md) |
| `CreateWarehouse`, `UpdateWarehouse`, `GetWarehouses` | [Warehouses](warehouses.md) |
| `AddInventoryPricelist`, `UpdateInventoryPricelist`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`, `RemoveCustomerFromInventoryPricelist` | [Price Lists](pricelists.md) |
| `GetInventoryItems`, `GetActiveInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem` | [Inventory Items](items.md) |
| `GetInventoryCostReport`, `GetTopSoldItems`, `GetHighestByValue` | [Inventory Reports](reports.md) |
| `ReceiveToStock` | [Receive to Stock](receive-to-stock.md) |

### Requirements

All inventory endpoints require:
- **Authentication**: A valid API token via the `token` parameter
- **Inventory User**: Your user account must have inventory module permissions (checked via `IsInventoryUser`)
- **Organization**: All operations are scoped to your authenticated organization

### Common patterns

* **Filtering**: Most list endpoints accept an optional `isActive` parameter to filter by status.
* **Response envelope**: All responses inherit from a base envelope structure with `Errors` (array), `Info`, and `OpenInfo` fields. Check `Errors.Count()` to validate success.
* **Token validation**: Every endpoint first validates the authentication token; invalid/missing tokens return an `UnauthorizedUser` (80) error.
* **RTL Support**: Hebrew text fields are supported in all string fields where applicable.

### Typical inventory management flow

1. **Setup**: Create categories, suppliers, and warehouses.
2. **Items**: Define inventory items with categories and variants.
3. **Pricing**: Create price lists and assign to customers.
4. **Stock**: Receive items, track movement, and generate reports.
5. **Reporting**: Query cost, top-sold, and high-value reports.
