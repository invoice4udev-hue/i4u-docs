# Suppliers

Manage suppliers for your inventory.

## Create a Supplier

Creates a new supplier in the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/CreateSupplier` |
| **Response** | `Supplier` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `supplier` | Supplier | Yes | The supplier to create. Must include `Name` (unique per organization). |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/CreateSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "supplier": {
    "Name": "Global Electronics Inc",
    "Email": "sales@globalelectronics.com",
    "Phone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel"
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "Email": "sales@globalelectronics.com",
    "Phone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel",
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |
| `InventorySupplierNameExists` | Supplier with this name already exists. |

---

## Update a Supplier

Updates an existing supplier by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateSupplier` |
| **Response** | `Supplier` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `supplier` | Supplier | Yes | The supplier to update. Must include `Id`. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/UpdateSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "supplier": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "Email": "support@globalelectronics.com",
    "Phone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel"
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "Email": "support@globalelectronics.com",
    "Phone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` | User lacks inventory module permissions. |
| `InventorySupplierNameExists` | Another supplier with this name already exists. |

---

## Get Supplier by ID

Retrieves a specific supplier by ID.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetSupplier` |
| **Response** | `Supplier` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `id` | int | Yes | The supplier ID to retrieve. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 12,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "Email": "support@globalelectronics.com",
    "Phone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
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

## Get All Suppliers

Retrieves all suppliers for the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetSuppliers` |
| **Response** | `Supplier[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetSuppliers HTTP/1.1
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
      "Id": 12,
      "Name": "Global Electronics Inc",
      "Email": "support@globalelectronics.com",
      "Phone": "03-9876544",
      "City": "Ramat Gan",
      "Country": "Israel",
      "Errors": []
    },
    {
      "Id": 13,
      "Name": "Local Parts Ltd",
      "Email": "info@localparts.co.il",
      "Phone": "02-5555555",
      "City": "Jerusalem",
      "Country": "Israel",
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
