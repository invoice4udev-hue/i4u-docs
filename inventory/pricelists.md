# Price Lists

Manage inventory price lists and customer pricing.

## Add a Price List

Creates a new price list in the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/AddInventoryPricelist` |
| **Response** | `Pricelist` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | Yes | The price list to create. Fields: `Name`, `Discount`, `DiscountType` (`0` = percent, `1` = fixed amount), `LinkedCustomers` (comma-separated customer IDs), `IsActive` — a required (non-nullable) field on the wire, so omitting it deserializes as `false` and the price list is created **inactive** with no warning. `OrganizationID` is ignored if sent — the server always overwrites it with the authenticated organization. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/AddInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Name": "Wholesale Pricing",
    "Discount": 15,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true
  },
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 25,
    "OrganizationID": 4001,
    "Name": "Wholesale Pricing",
    "Discount": 15,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a `Pricelist` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Update a Price List

Updates an existing price list.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateInventoryPricelist` |
| **Response** | `Pricelist` object |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | Yes | The price list to update. Must include `Id`. Same fields as create: `Name`, `Discount`, `DiscountType`, `LinkedCustomers`, `IsActive`. `OrganizationID` is ignored if sent. |
| `customerID` | int? | No | Optional customer ID to associate with this price list. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/UpdateInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Id": 25,
    "Name": "Wholesale Pricing",
    "Discount": 18,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true
  },
  "customerID": 88231,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Id": 25,
    "OrganizationID": 4001,
    "Name": "Wholesale Pricing",
    "Discount": 18,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true,
    "Errors": []
  }
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a `Pricelist` object carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get All Price Lists

Retrieves all price lists for the authenticated organization.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryPricelists` |
| **Response** | `Pricelist[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryPricelists HTTP/1.1
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
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231",
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 26,
      "OrganizationID": 4001,
      "Name": "Retail Pricing",
      "Discount": 5,
      "DiscountType": 1,
      "LinkedCustomers": "",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Price Lists by Customer ID

Retrieves price lists assigned to a specific customer.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryPricelistByCustomerId` |
| **Response** | `Pricelist[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `customerId` | int | Yes | The customer ID to query. |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerId HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerId": 88231,
  "isActive": true,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Get Price Lists by Multiple Customer IDs

Retrieves price lists for multiple customers at once.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetInventoryPricelistByCustomerIds` |
| **Response** | `PricelistWithCustomer[]` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `customerIds` | string | Yes | Comma-separated list of customer IDs (e.g., "88231,88232,88233"). |
| `isActive` | bool? | No | Filter by active status. Omit to return all. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerIds HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIds": "88231,88232,88233",
  "isActive": true,
  "token": "<token>"
}
```

### Example response

```json
{
  "d": [
    {
      "CustomerId": 88231,
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231,88232",
      "IsActive": true,
      "Errors": []
    },
    {
      "CustomerId": 88232,
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231,88232",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### Errors

An invalid/expired token or an inactive Inventory module returns a one-element array carrying `UnauthorizedUser` (80) or `UnauthorizedInventoryAttempt` (403) respectively — see [module-inactive behavior](overview.md#module-inactive-behavior).

---

## Remove Customer from Price List

Removes customers from price list assignments.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/RemoveCustomerFromInventoryPricelist` |
| **Response** | `bool` — `true` on success, `false` on error |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `customerIDs` | string | Yes | Comma-separated list of customer IDs to remove from price lists. |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/RemoveCustomerFromInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIDs": "88231,88232",
  "token": "<token>"
}
```

### Example response

```json
{
  "d": true
}
```

### Errors

This endpoint never returns an error object — it returns the plain boolean `false` on an invalid/expired token, an inactive Inventory module, or any server error. There is no way to distinguish those cases from the response alone; see [module-inactive behavior](overview.md#module-inactive-behavior).
