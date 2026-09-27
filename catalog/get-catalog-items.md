# Get Catalog Items

Returns the item catalog of the authenticated organization. Available to all accounts, with or without the Inventory module.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetCatalogItems` |
| **Response** | `CommonCollection<CatalogItem[]>` (items in `Response`), or `null` on auth/server error |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `GetAll` | boolean | Yes | `false` returns active items only. `true` returns all items, including inactive ones. |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/GetCatalogItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "GetAll": false,
  "token": "<token>"
}
```

## Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "Response": [
      {
        "ID": 5001,
        "UserId": 12345,
        "Code": "SRV-01",
        "Name": "Consulting hour",
        "Price": 300.0,
        "PriceAfterTax": 354.0,
        "VatPercentage": 18.0,
        "IsActive": true
      },
      {
        "ID": 5002,
        "UserId": 12345,
        "Code": "PRD-17",
        "Name": "USB cable",
        "Price": 25.0,
        "PriceAfterTax": 29.5,
        "VatPercentage": 18.0,
        "IsActive": true
      }
    ]
  }
}
```

## Notes

* The full list is returned; there is no search or paging. Filter on your side.
* Read-only — there is no API endpoint for creating or updating catalog items. See the [overview](overview.md).

## Errors

Returns `null` when the token is invalid or on server error.

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetCatalogItems" method="post" %}
{% endopenapi-operation %}
