# Get Branches

Returns all branches for the authenticated organization.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetBranches` |
| **Response** | `Branch[]`, or `null` on auth/server error |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/GetBranches HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

## Example response

```json
{
  "GetBranchesResult": [
    {
      "ID": 101,
      "Name": "Head Office",
      "Description": "Main branch",
      "Enabled": true,
      "IsDefault": true,
      "IsMain": true,
      "Email": "office@acme.example"
    },
    {
      "ID": 102,
      "Name": "North Branch",
      "Enabled": true,
      "IsDefault": false,
      "IsMain": false
    }
  ]
}
```

## Errors

Returns `null` when the token is invalid or on server error. Use the returned `ID` values as `BranchID` when [creating documents](../documents/create-document.md).
