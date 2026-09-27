# Inventory Reports

Query inventory cost, movement, and sales reports.

## Get Inventory Cost Report

Retrieves the inventory cost report for a specific date, showing all items and their valuations.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryCostReport` |
| **Response** | `ItemBalance[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `date` | DateTime | Yes | The date for which to generate the report. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryCostReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "date": "/Date(1787518800000+0300)/",
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "InventoryId": 1001,
      "ItemName": "Laptop Pro",
      "ItemCode": "LP-001",
      "UnitType": 0,
      "Cost": 2800.00,
      "Price": 4500.00,
      "TotalPrice": 42000.00,
      "Qty": 15,
      "Errors": []
    },
    {
      "InventoryId": 1002,
      "ItemName": "Wireless Mouse",
      "ItemCode": "WM-001",
      "UnitType": 0,
      "Cost": 75.00,
      "Price": 150.00,
      "TotalPrice": 3750.00,
      "Qty": 50,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Top Sold Items

Retrieves the top-selling items based on sales quantity or sales value, for a fixed time window.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetTopSoldItems` |
| **Response** | `Item[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `filterType` | int | Yes | Time period: `0` all time, `1` this month, `2` last month, `3` this week. There is no quarter/year option. |
| `type` | int | Yes | Metric: `0` quantity sold, `1` sales value. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetTopSoldItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "filterType": 2,
  "type": 0,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "QuantityToNotify": 450,
      "Errors": []
    },
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "QuantityToNotify": 120,
      "Errors": []
    },
    {
      "Id": 1003,
      "Name": "USB-C Cable",
      "QuantityToNotify": 300,
      "Errors": []
    }
  ]
}
```

`QuantityToNotify` doubles as the report's metric column: it holds the quantity sold when `type: 0`, and the sales value when `type: 1`. No other item fields (`Code`, prices, …) are populated on this response.

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Highest by Value

Retrieves the items with the highest total inventory value.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetHighestByValue` |
| **Response** | `Item[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetHighestByValue HTTP/1.1
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
      "Name": "Laptop Pro",
      "QuantityToNotify": 42000.00,
      "Errors": []
    },
    {
      "Name": "Server Unit",
      "QuantityToNotify": 40000.00,
      "Errors": []
    },
    {
      "Name": "Wireless Mouse",
      "QuantityToNotify": 3750.00,
      "Errors": []
    }
  ]
}
```

Only `Name` and `QuantityToNotify` (the total inventory value) are populated — there is no `Id`, `Code`, `Quantity`, `Cost`, or `TotalValue` field on this response.

### Errors

An invalid or expired token, or an inactive Inventory module, both return `null` — not an error object — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Items Movement Report

Returns the movement history (receipts, sales, and adjustments) for one item, or across the organization if no item is specified.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetItemsMovementReport` |
| **Response** | `ItemsMovement` object — `{ Item, ItemsBalance[] }` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `itemId` | int? | No | The inventory item to report on. Omit or send `null` for none. |
| `fromDate` | DateTime? | No | Start of the reporting window. Omit or send `null` for none. |
| `toDate` | DateTime? | No | End of the reporting window. Omit or send `null` for none. |
| `token` | string | Yes | Authentication token. |

`Item` carries `Id`, `Name`, `Code`, `Description`, `SellingPrice`, `PurchasePrice`, `SellingCurrency`, `PurchaseCurrency`, `QuantityToNotify` (current quantity on hand), and `UnitType`. Each `ItemsBalance` row carries `Date`, `Qty`, `Entry`, `Exit`, and `Op` (no per-row item identifiers — they all describe the single `Item` above).

### Example request

```http
POST /Services/ApiService.svc/GetItemsMovementReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemId": 1001,
  "fromDate": "/Date(1788210000000+0300)/",
  "toDate": "/Date(1790801999000+0300)/",
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Item": {
      "Id": 1001,
      "Name": "Laptop Pro",
      "Code": "LP-001",
      "Description": "High-performance laptop",
      "SellingPrice": 4500.00,
      "PurchasePrice": 2800.00,
      "SellingCurrency": "ILS",
      "PurchaseCurrency": "ILS",
      "QuantityToNotify": 8,
      "UnitType": 0
    },
    "ItemsBalance": [
      {
        "Date": "/Date(1788296400000+0300)/",
        "Qty": 10,
        "Entry": 10,
        "Exit": 0,
        "Op": 10
      },
      {
        "Date": "/Date(1789074000000+0300)/",
        "Qty": 8,
        "Entry": 0,
        "Exit": 2,
        "Op": 8
      }
    ],
    "Errors": []
  }
}
```

### Errors

| What happens | Response |
| --- | --- |
| Fully invalid token (fails to decrypt) | `{"d":null}` |
| Expired token | `ItemsMovement` object with `Errors: [{"ID": 80, ...}]` (`UnauthorizedUser`), `Item` and `ItemsBalance` both `null` |
| Inactive Inventory module | Same shape as above with `UnauthorizedInventoryAttempt` (403) |

See [module-inactive behavior](overview.md#module-inactive-behavior) for why the invalid-token and expired-token cases differ.

---

## Get Total Movement Report

Returns aggregated movement totals for every item in the organization, without needing to query one item at a time.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetTotalMovementReport` |
| **Response** | `ItemBalance[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `fromDate` | DateTime? | No | Start of the reporting window. Omit or send `null` for none. |
| `toDate` | DateTime? | No | End of the reporting window. Omit or send `null` for none. |
| `token` | string | Yes | Authentication token. |

Each `ItemBalance` row carries `InventoryId`, `ItemName`, `ItemCode`, `Price`, `TotalPrice`, `Qty`, `Entry`, `Exit`, and `Op` — unlike the cost report above, this report does not populate `Cost` or `UnitType`.

### Example request

```http
POST /Services/ApiService.svc/GetTotalMovementReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "fromDate": "/Date(1788210000000+0300)/",
  "toDate": "/Date(1790801999000+0300)/",
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "InventoryId": 1001,
      "ItemName": "Laptop Pro",
      "ItemCode": "LP-001",
      "Price": 4500.00,
      "TotalPrice": 36000.00,
      "Qty": 8,
      "Entry": 10,
      "Exit": 2,
      "Op": 8
    },
    {
      "InventoryId": 1002,
      "ItemName": "Wireless Mouse",
      "ItemCode": "WM-001",
      "Price": 150.00,
      "TotalPrice": 7200.00,
      "Qty": 48,
      "Entry": 50,
      "Exit": 2,
      "Op": 48
    }
  ]
}
```

### Errors

| What happens | Response |
| --- | --- |
| Fully invalid token (fails to decrypt) | `{"d":[]}` |
| Expired token | One-element array carrying `UnauthorizedUser` (80) |
| Inactive Inventory module | One-element array carrying `UnauthorizedInventoryAttempt` (403) |

See [module-inactive behavior](overview.md#module-inactive-behavior) for why the invalid-token and expired-token cases differ.
