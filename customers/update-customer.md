# Update a Customer

Updates an existing customer. The customer must exist and belong to the authenticated organization.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateCustomer` |
| **Response** | `Customer` object (check `Errors` and negative `ID` codes) |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `cu` | Customer | Yes | The customer to update. `ID` **must** be a valid existing customer ID (`ID = 0` is rejected). All other fields per [the Customer object](overview.md#the-customer-object) — supply the full desired state. |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/UpdateCustomer HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "cu": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Email": "accounts@acme.example",
    "PayTerms": 60,
    "Active": true
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "UpdateCustomerResult": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Email": "accounts@acme.example",
    "PayTerms": 60,
    "Errors": []
  }
}
```

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ClientDoesntExists` (7) | `ID` is `0` or the customer doesn't exist in your organization. |
| `CustomerNameCanNotBeEmpty` (28) | `Name` missing. |
| `CustomerUniqueIdNotNumeric` (79) | `UniqueID` contains non-digits. |
| `ID = -1 … -4` | Duplicate name / external number / unique ID / GUID — see [result codes](overview.md#createupdate-result-codes). |

## Try it

{% openapi-operation spec="invoice4u-api" path="/UpdateCustomer" method="post" %}
{% endopenapi-operation %}

