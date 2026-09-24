# Get a Catalog Item by Code

Returns a single catalog item by its exact code. Available to all accounts, with or without the Inventory module.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetCatalogItemByCode` |
| **Response** | `CatalogItem`, or `null` when not found or on auth/server error |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `code` | string | Yes | Item code (exact match). |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/GetCatalogItemByCode HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "code": "SRV-01",
  "token": "<token>"
}
```

## Example response

```json
{
  "GetCatalogItemByCodeResult": {
    "Errors": [],
    "Info": [],
    "ID": 5001,
    "UserId": 12345,
    "Code": "SRV-01",
    "Name": "Consulting hour",
    "Price": 300.0,
    "PriceAfterTax": 354.0,
    "VatPercentage": 18.0
  }
}
```

## Notes

* Only `ID`, `UserId`, `Code`, `Name`, `Price`, `PriceAfterTax` and `VatPercentage` are populated. `IsActive` is not returned by this endpoint — use [Get Catalog Items](get-catalog-items.md) if you need it.

## Errors

Returns `null` when no item matches the code, when the token is invalid, or on server error.

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetCatalogItemByCode" method="post" %}
{% endopenapi-operation %}
