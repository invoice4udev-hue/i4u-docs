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
      "CategoryId": 5,
      "SKU": "LP-001",
      "Price": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "CategoryId": 5,
      "SKU": "WM-001",
      "Price": 150.00,
      "IsActive": true,
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
      "CategoryId": 5,
      "SKU": "LP-001",
      "Price": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "CategoryId": 5,
      "SKU": "WM-001",
      "Price": 150.00,
      "IsActive": true,
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
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |

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
| `item` | Item | Yes | The item to create. Set `Id` to `0`. Include `Name`, `CategoryId`, `Price`. Optional: `ItemInstances` array. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/CreateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 0,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
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
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |

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
| `item` | Item | Yes | The item to update. Must include `Id` > 0. |
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
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop - Updated",
    "Price": 4750.00,
    "Cost": 2900.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
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
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop - Updated",
    "Price": 4750.00,
    "Cost": 2900.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |
