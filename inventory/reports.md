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
      "ItemId": 1001,
      "ItemName": "Laptop Pro",
      "Quantity": 15,
      "Cost": 2800.00,
      "TotalValue": 42000.00,
      "Errors": []
    },
    {
      "ItemId": 1002,
      "ItemName": "Wireless Mouse",
      "Quantity": 50,
      "Cost": 75.00,
      "TotalValue": 3750.00,
      "Errors": []
    }
  ]
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |

---

## Get Top Sold Items

Retrieves the top-selling items based on sales volume or value.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetTopSoldItems` |
| **Response** | `Item[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `filterType` | int | Yes | Filter type: `1` = by quantity, `2` = by value. |
| `type` | int | Yes | Time period: `1` = last week, `2` = last month, `3` = last quarter, `4` = last year. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetTopSoldItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "filterType": 1,
  "type": 2,
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
      "SKU": "LP-001",
      "QuantitySold": 120,
      "SalesValue": 540000.00,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "SKU": "WM-001",
      "QuantitySold": 450,
      "SalesValue": 67500.00,
      "Errors": []
    },
    {
      "Id": 1003,
      "Name": "USB-C Cable",
      "SKU": "USB-C-001",
      "QuantitySold": 300,
      "SalesValue": 9000.00,
      "Errors": []
    }
  ]
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |

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
      "Id": 1001,
      "Name": "Laptop Pro",
      "SKU": "LP-001",
      "Quantity": 15,
      "Cost": 2800.00,
      "TotalValue": 42000.00,
      "Errors": []
    },
    {
      "Id": 1050,
      "Name": "Server Unit",
      "SKU": "SRV-001",
      "Quantity": 5,
      "Cost": 8000.00,
      "TotalValue": 40000.00,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "SKU": "WM-001",
      "Quantity": 50,
      "Cost": 75.00,
      "TotalValue": 3750.00,
      "Errors": []
    }
  ]
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |
