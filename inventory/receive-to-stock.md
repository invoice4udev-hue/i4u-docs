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
| `doc` | Document | Yes | The document representing the receipt. Typically uses document type for stock receipts. Must include items with quantities. |
| `token` | string | Yes | Authentication token. |

### Notes

- This endpoint validates that the user has inventory permissions before calling the standard `CreateDocument` endpoint.
- The document should be configured as a receipt or purchase receipt document type (see [Document Types](../documents/document-types.md)).
- All items must have valid `ItemId` references to existing inventory items.
- The receipt creates an audit trail of stock movements.

### Example request

```http
POST /Services/ApiService.svc/ReceiveToStock HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 5,
    "DocumentNumber": 0,
    "IssueDate": "/Date(1787518800000+0300)/",
    "ClientID": 12,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "ItemID": 1001,
        "Description": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Unit": "יחידה"
      },
      {
        "ItemID": 1002,
        "Description": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Unit": "יחידה"
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
    "ID": 50001,
    "DocumentNumber": "REC-2026-1234",
    "DocumentType": 5,
    "IssueDate": "/Date(1787518800000+0300)/",
    "ClientID": 12,
    "ClientName": "Global Electronics Inc",
    "BranchID": 101,
    "Currency": "ILS",
    "TotalAmount": 31250.00,
    "Items": [
      {
        "ItemID": 1001,
        "Description": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Amount": 28000.00
      },
      {
        "ItemID": 1002,
        "Description": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Amount": 3750.00
      }
    ],
    "PrintOriginalPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

### Document Types for Receipts

Common document types used for inventory receipts:

| Type ID | Name | Usage |
| ------- | ---- | ----- |
| 5 | Receipt | General receipt of goods |
| (Check [Document Types](../documents/document-types.md) for full list) | | |

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |
| `DocumentTypeNotInRange` (33) | Invalid document type. |
| `ClientDoesntExists` (7) | Supplier/client ID does not exist. |
| `DocumentItemsNotSpecified` (34) | No items provided in the receipt. |
| `DocumentItemMissingName` (39) | Item description/name missing. |
| `DocumentItemQuantityCannotBeZero` (40) | Item quantity must be > 0. |
| `DocumentItemPriceCannotBeZero` (41) | Item price must be > 0. |

### Typical receipt flow

1. **Prepare items**: Ensure items exist in inventory (see [Inventory Items](items.md)).
2. **Create document**: Call `ReceiveToStock` with items and quantities.
3. **Verify**: Check the returned `PrintOriginalPDFLink` to view the receipt.
4. **Track**: Use the returned `DocumentNumber` to reference the receipt in your system.
5. **Report**: Query [inventory reports](reports.md) to verify stock updates.

### Stock movement

When a receipt is recorded:
- Item quantities in inventory increase.
- Cost basis is tracked for future valuation reports.
- Movement history is logged for audit purposes.

See [Inventory Reports](reports.md) to query cost reports and verify stock movements.
