# Login with API Key

Returns an authentication token for a valid organization API key (GUID). This is the **only supported login method** — email+password login (`VerifyLogin`) has been retired and its tokens are not accepted by the API.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/VerifyLoginApiKey` |
| **Response** | JSON — token string, or an error name, or `null` |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `apiKey` | string (GUID) | Yes | Your organization API key, e.g. `"d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"`. Trimmed automatically. |

## Example request

```http
POST /Services/ApiService.svc/VerifyLoginApiKey HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "apiKey": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

## Example response

```json
{
  "VerifyLoginApiKeyResult": "AQAAANCMnd8BFdERjHoAwE_Cl-sBAAAA..."
}
```

## Errors

| Result | Meaning |
| ------ | ------- |
| `null` | Empty key, key not found, malformed GUID, or server error. |
| Error name string | First validation error for the key/account. |

## Related: check account expiry

`GetExpDateByApiKey` returns the account expiration date for the authenticated user.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetExpDateByApiKey` |
| **Body** | `{ "token": "<token>" }` |
| **Response** | Expiration date string, or `"UnauthorizedUser"` |
