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
| `supplier` | Supplier | Yes | The supplier to create. Must include `Name` (unique per organization). `IsActive` is a required (non-nullable) field on the wire — if you omit it, WCF deserializes it as `false` and the supplier is created **inactive** with no warning. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/CreateSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "supplier": {
    "Name": "Global Electronics Inc",
    "ContactEmail": "sales@globalelectronics.com",
    "ContactPhone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel",
    "IsActive": true
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
    "ContactEmail": "sales@globalelectronics.com",
    "ContactPhone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` (403) | User lacks inventory module permissions. |
| `InventorySupplierNameExists` (401) | A supplier with this name already exists for the organization. |

See [module-inactive behavior](overview.md#module-inactive-behavior) for the full envelope shape on the two error rows above.

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
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
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
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
    "Errors": []
  }
}
```

### Known behavior: same-name update fails

The duplicate-name check for `UpdateSupplier` looks up any supplier with the same `Name` in the organization, but it does not exclude the supplier being updated. Submitting an update that keeps the current `Name` unchanged can therefore return `InventorySupplierNameExists` (401) even though no *other* supplier has that name. Workaround: send a different transient name first, or avoid re-sending an unchanged `Name` field, until this is fixed server-side.

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or missing token. |
| `UnauthorizedInventoryAttempt` (403) | User lacks inventory module permissions. |
| `InventorySupplierNameExists` (401) | Another supplier already has this name — or, due to the bug above, the same supplier kept its own name. |

See [module-inactive behavior](overview.md#module-inactive-behavior) for the full envelope shape on the first two rows.

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
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a `Supplier` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

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
      "ContactEmail": "support@globalelectronics.com",
      "ContactPhone": "03-9876544",
      "City": "Ramat Gan",
      "Country": "Israel",
      "Errors": []
    },
    {
      "Id": 13,
      "Name": "Local Parts Ltd",
      "ContactEmail": "info@localparts.co.il",
      "ContactPhone": "02-5555555",
      "City": "Jerusalem",
      "Country": "Israel",
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).
