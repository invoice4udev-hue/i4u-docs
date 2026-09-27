# Warehouses

Manage inventory warehouses.

## Create a Warehouse

Creates a new warehouse in the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/CreateWarehouse` |
| **Response** | `Warehouse` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `warehouse` | Warehouse | Yes | The warehouse to create. For new warehouse, set `Id` to `0`. `IsActive` is a required (non-nullable) field on the wire — if you omit it, WCF deserializes it as `false` and the warehouse is created **inactive** with no warning. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/CreateWarehouse HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "warehouse": {
    "Id": 0,
    "Name": "Central Warehouse",
    "Street": "123 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567",
    "IsActive": true
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 101,
    "Name": "Central Warehouse",
    "Street": "123 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid/missing token returns `null`. An expired account or an inactive Inventory module returns a `Warehouse` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Update a Warehouse

Updates an existing warehouse by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateWarehouse` |
| **Response** | `Warehouse` object with updated `Id` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `warehouse` | Warehouse | Yes | The warehouse to update. Must include `Id` > 0. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/UpdateWarehouse HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "warehouse": {
    "Id": 101,
    "Name": "Central Warehouse",
    "Street": "456 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567"
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 101,
    "Errors": []
  }
}
```

### Errors

An invalid/missing token returns `null`. An expired account or an inactive Inventory module returns a `Warehouse` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get All Warehouses

Retrieves all warehouses for the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetWarehouses` |
| **Response** | `Warehouse[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetWarehouses HTTP/1.1
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
      "Id": 101,
      "Name": "Central Warehouse",
      "Street": "123 Industrial St",
      "City": "Tel Aviv",
      "ContactPhone": "03-1234567",
      "Errors": []
    },
    {
      "Id": 102,
      "Name": "North Storage",
      "Street": "789 Logistics Ave",
      "City": "Haifa",
      "ContactPhone": "04-9876543",
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/missing token returns `null`. An expired account or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).
