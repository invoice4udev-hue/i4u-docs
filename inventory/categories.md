# Item Categories

Manage item categories for organizing inventory items.

## Create a Category

Creates a new inventory category in the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/CreateInventoryCategory` |
| **Response** | `ItemCategory` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `itemCategory` | ItemCategory | Yes | The category to create. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/CreateInventoryCategory HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemCategory": {
    "Name": "Electronics",
    "Description": "Electronic devices and components",
    "IsActive": true
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Electronic devices and components",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid token, an expired account, or an inactive Inventory module does **not** return an error object here â€” the response is `null` (see [module-inactive behavior](overview.md#module-inactive-behavior)). There are no other documented error cases for this endpoint.

---

## Update a Category

Updates an existing inventory category by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateInventoryCategory` |
| **Response** | `ItemCategory` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `itemCategory` | ItemCategory | Yes | The category to update. Must include `Id`. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/UpdateInventoryCategory HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemCategory": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Updated: Electronic devices",
    "IsActive": true
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Updated: Electronic devices",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid token, an expired account, or an inactive Inventory module does **not** return an error object here â€” the response is `null` (see [module-inactive behavior](overview.md#module-inactive-behavior)). There are no other documented error cases for this endpoint.

---

## Get Category by ID

Retrieves a specific inventory category by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryCategoryById` |
| **Response** | `ItemCategory` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `id` | int | Yes | The category ID to retrieve. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryCategoryById HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 5,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Electronic devices and components",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid token, an expired account, or an inactive Inventory module does **not** return an error object here â€” the response is `null` (see [module-inactive behavior](overview.md#module-inactive-behavior)). There are no other documented error cases for this endpoint.

---

## Get All Categories

Retrieves all inventory categories for the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryCategories` |
| **Response** | `ItemCategory[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryCategories HTTP/1.1
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
      "Id": 1,
      "Name": "Hardware",
      "Description": "Computer hardware",
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 5,
      "Name": "Electronics",
      "Description": "Electronic devices and components",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/missing token returns `null`. An expired account or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively â€” see [module-inactive behavior](overview.md#module-inactive-behavior).
