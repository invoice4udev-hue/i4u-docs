# Create a Customer

Creates a customer in the authenticated organization. If `ID` is supplied and exists, the call behaves like an update.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/CreateCustomer` |
| **Response** | `Customer` object (check `Errors` and negative `ID` codes) |

Variants:

| Path | Method | Auth | Notes |
| ---- | ------ | ---- | ----- |
| `/CreateCustomer` | POST | token | Standard — full `Customer` object. |
| `/CreateCustomerREST` | GET | email+password | Query-string variant. |
| `/CreateCustomerParamsREST` | GET | email+password | Flat parameters (`name`, `customerEmail`, `uniqueId`, `phone`, `cell`, `externalNumber`); always allows non-unique names. |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `cu` | Customer | Yes | The customer to create. See [the Customer object](overview.md#the-customer-object). Minimum: `Name`. `UniqueID`, if given, must be numeric. |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/CreateCustomer HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "cu": {
    "Name": "Acme Ltd",
    "UniqueID": "512345678",
    "Email": "billing@acme.example",
    "Phone": "03-1234567",
    "Cell": "050-1234567",
    "Address": "1 Herzl St",
    "City": "Tel Aviv",
    "ExtNumber": 10045,
    "Active": true,
    "PayTerms": 30
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "CreateCustomerResult": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "UniqueID": "512345678",
    "Email": "billing@acme.example",
    "ExtNumber": 10045,
    "OrgID": 12345,
    "Active": true,
    "Errors": []
  }
}
```

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `CustomerNameCanNotBeEmpty` (28) | `Name` missing. |
| `CustomerUniqueIdNotNumeric` (79) | `UniqueID` contains non-digits. |
| `CustomerNameExists` (2) / `ID = -1` | Duplicate name. Set `IsNonUniqueNameCreation: true` to allow. |
| `CustomerExternalNumberExists` (31) / `ID = -2` | Duplicate `ExtNumber`. |
| `CustomerUniqueIdExistsForUser` (78) / `ID = -3` | Duplicate `UniqueID`. |
| `CustomerGuidExists` (84) / `ID = -4` | Duplicate `Guid`. |
| `ClientDoesntExists` (7) | `ID` supplied but no such customer (update path). |
