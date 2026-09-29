# Receive to Stock

Record inventory receipts from suppliers or returns.

## Receive Items to Stock

Creates a document to record items received into inventory from a supplier. This endpoint acts as a wrapper around document creation with inventory-specific validation.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/ReceiveToStock` |
| **Response** | `Document` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `doc` | Document | Yes | The document representing the receipt. Use `DocumentType: 10` (`SupplierInvoiceToInventory`) to get stock effects — see [Actual validation](#actual-validation). Include `SupplierId`, `AddToInventory: true`, and `Items[]` with `Name`, `Quantity`, `Price`, `InventoryId` (link to the inventory item), and optionally `WarehouseId`. |
| `token` | string | Yes | Authentication token. |

### Notes

- This endpoint validates that the user has inventory permissions before calling the standard `CreateDocument` endpoint — it does not add any inventory-specific validation of its own beyond what `CreateDocument` already does for `DocumentType: 10`.
- Items are linked to inventory items via `InventoryId` (not `ItemId`), and optionally to a specific warehouse via `WarehouseId`. Both come from the [Inventory Items](items.md) and [Warehouses](warehouses.md) endpoints.
- The receipt creates an audit trail of stock movements, visible through [Inventory Reports](reports.md).

### Example request

```http
POST /Services/ApiService.svc/ReceiveToStock HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 10,
    "DocumentNumber": 0,
    "IssueDate": "/Date(1787518800000+0300)/",
    "SupplierId": 12,
    "AddToInventory": true,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "Name": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "InventoryId": 1001,
        "WarehouseId": 101
      },
      {
        "Name": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "InventoryId": 1002,
        "WarehouseId": 101
      }
    ]
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "ID": "3f2b9c1e-7a4d-4e8b-9c1a-2b3c4d5e6f70",
    "DocumentNumber": 20260501,
    "DocumentType": 10,
    "IssueDate": "/Date(1787518800000+0300)/",
    "SupplierId": 12,
    "SupplierName": "Global Electronics Inc",
    "AddToInventory": true,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "Name": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Total": 28000.00,
        "InventoryId": 1001,
        "WarehouseId": 101
      },
      {
        "Name": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Total": 3750.00,
        "InventoryId": 1002,
        "WarehouseId": 101
      }
    ],
    "PrintOriginalPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

### Document type for stock receipts

`ReceiveToStock` is just `CreateDocument` with an inventory-permission check in front of it — it does not restrict which `DocumentType` you send. Only **`10`** (`SupplierInvoiceToInventory`) is wired to update stock quantities and skips the usual client-existence check (so `SupplierId` — not `ClientID` — identifies the counterparty). Sending any other type creates a normal document with no stock effect. See [Document Types](../documents/document-types.md) for the full enum.

### Actual validation {#actual-validation}

- **Stock effects require `DocumentType: 10`.** Other document types create a document as usual but do not move inventory quantities.
- **A single-item receipt with no `InventoryId` fails with a misleading error.** For `DocumentType: 10`, if `Items` contains exactly **one** item and that item's `InventoryId` is missing or `0`, the response carries `DocumentItemPriceCannotBeZero` (41) — even though the actual problem is the missing `InventoryId`, not the price. This check does not fire when there are two or more items.
- **`WarehouseId` is accepted but not validated.** It is written to the document item only if you send it; there is no check that the warehouse exists or is active.
- **An invalid token, an expired account, or an inactive Inventory module all return `null`**, not an error object — see [module-inactive behavior](overview.md#module-inactive-behavior).

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `DocumentTypeNotInRange` (33) | Invalid document type. |
| `DocumentItemsNotSpecified` (34) | No items provided in the receipt. |
| `DocumentItemMissingName` (39) | Item `Name` missing. |
| `DocumentItemQuantityCannotBeZero` (40) | Item quantity must be > 0. |
| `DocumentItemPriceCannotBeZero` (41) | Item price must be > 0 — or, for a single-item `DocumentType: 10` receipt, a missing `InventoryId` (see [Actual validation](#actual-validation)). |

### Typical receipt flow

1. **Prepare items**: Ensure items exist in inventory (see [Inventory Items](items.md)).
2. **Create document**: Call `ReceiveToStock` with `DocumentType: 10`, `SupplierId`, `AddToInventory: true`, and items carrying `InventoryId`.
3. **Verify**: Check the returned `PrintOriginalPDFLink` to view the receipt.
4. **Track**: Use the returned `DocumentNumber` to reference the receipt in your system.
5. **Report**: Query [inventory reports](reports.md) to verify stock updates.

### Stock movement

When a `DocumentType: 10` receipt is recorded:
- Item quantities in inventory increase.
- Cost basis is tracked for future valuation reports.
- Movement history is logged for audit purposes.

See [Inventory Reports](reports.md) to query cost reports and verify stock movements.

## Try it

{% openapi-operation spec="invoice4u-api" path="/ReceiveToStock" method="post" %}
{% endopenapi-operation %}
