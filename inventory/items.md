# Inventory Items

Manage inventory items and product variants.

## Get Inventory Items

Retrieves inventory items with optional filtering by date range, status, and identifiers.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryItems` |
| **Response** | `Item[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `itemId` | int? | No | Filter by specific item ID. |
| `fromSellingDate` | DateTime? | No | Filter by selling date (from). |
| `toSellingDate` | DateTime? | No | Filter by selling date (to). |
| `fromPurchasingDate` | DateTime? | No | Filter by purchasing date (from). |
| `toPurchasingDate` | DateTime? | No | Filter by purchasing date (to). |
| `isActive` | bool? | No | Filter by active status. |
| `serialNumber` | int? | No | Filter by serial number. |
| `batchNumber` | int? | No | Filter by batch number. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "isActive": true,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "Code": "LP-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "Code": "WM-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 150.00,
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Active Inventory Items

Retrieves only active inventory items for the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetActiveInventoryItems` |
| **Response** | `Item[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetActiveInventoryItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "Code": "LP-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "Code": "WM-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 150.00,
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Inventory Item by ID

Retrieves a specific inventory item by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryItem` |
| **Response** | `Item` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `id` | int | Yes | The item ID to retrieve. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 1001,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "ManufacturerId": 3,
        "WarehouseId": 101,
        "TotalQuantity": 8
      }
    ],
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns an `Item` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Create an Inventory Item

Creates a new inventory item with optional item instances (variants/serial numbers).

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/CreateInventoryItem` |
| **Response** | `Item` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `item` | Item | Yes | The item to create. `Id` **must be `0`** — the API only creates when `Id` is `0`; if `Id > 0` the call returns `null` without creating or updating anything (see Errors below). Fields: `Name`, `Code`, `ItemCategoryId`, `UnitType` (see below), `SellingPrice`, `PurchasePrice`, `SerialNumber`, `BatchNumber` (both item-level, not per-instance), `IsActive`, `IsNonStockItem`. Optional: `ItemInstances` array. |
| `token` | string | Yes | Authentication token. |

`UnitType` values: `0` Units, `1` Kg, `2` Gr, `3` Liter, `4` Ml.

Each entry in `ItemInstances` uses `ItemStatusId` (`1` valid in stock and for sale, `2` not in stock, `3` sold), `ManufacturerId`, `WarehouseId`, and `TotalQuantity` — not `SerialNumber`/`BatchNumber`, which belong on the item itself.

### Example request

```http
POST /Services/ApiService.svc/CreateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 0,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 8
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
    "Id": 1001,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 8
      }
    ],
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns an `Item` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

| Error (ID) | Meaning |
| ---------- | ------- |
| `InventorySerialNumberItemExistsForUser` (402) | Another item already uses this `SerialNumber` for the organization. |
| `InventoryCodeItemExistsForUser` (404) | Another item already uses this `Code` for the organization. |

If `item.Id` is greater than `0`, the request is silently ignored and the response is `null` (no error object) — no new item is created.

---

## Update an Inventory Item

Updates an existing inventory item and/or its item instances.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateInventoryItem` |
| **Response** | `Item` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `item` | Item | Yes | The item to update. Must include `Id` > 0 — if `Id` is `0` or missing, the response is `null` (no update happens, no error object). Same fields as create: `Name`, `Code`, `ItemCategoryId`, `UnitType`, `SellingPrice`, `PurchasePrice`, `SerialNumber`, `BatchNumber`, `IsActive`. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/UpdateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop - Updated",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4750.00,
    "PurchasePrice": 2900.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 6
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
    "Id": 1001,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop - Updated",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4750.00,
    "PurchasePrice": 2900.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 6
      }
    ],
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns an `Item` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

| Error (ID) | Meaning |
| ---------- | ------- |
| `InventorySerialNumberItemExistsForUser` (402) | Another item already uses this `SerialNumber` for the organization. |
| `InventoryCodeItemExistsForUser` (404) | Another item already uses this `Code` for the organization. |
