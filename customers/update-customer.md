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
| `cu` | Customer | Yes | The customer to update. `ID` **must** be a valid existing customer ID (`ID = 0` is rejected). All other fields per [the Customer object](overview.md#the-customer-object). |
| `token` | string | Yes | Authentication token. |

{% hint style="warning" %}
`PayTerms`, `Active` and `Retainer` are non-nullable on the `Customer` object, so the API always writes back whatever value you send for them — omitting one from `cu` **resets** it to its default (`PayTerms: 0`, `Active: false`, `Retainer: false`). Always send the customer's **current** values for these three fields. Every other field — strings and nullable fields such as `Email`, `Phone` or `RetainerAmount` — is only updated when you include it; omitting it leaves the existing value unchanged.
{% endhint %}

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
    "Active": true,
    "Retainer": false
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "d": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Email": "accounts@acme.example",
    "PayTerms": 60,
    "Active": true,
    "Retainer": false,
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

