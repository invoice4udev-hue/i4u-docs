# Verify Your API Key & Account Expiry

There is no separate login call. Your organization **API key (GUID)** is passed directly as the `token` parameter in every request — each endpoint validates it via `IsAuthenticated`. Email+password login (`VerifyLogin`) is **deprecated** — it still works during the migration period, but new integrations must use the API key and existing ones should migrate to it.

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": { ... },
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

## Verify a key: `IsAuthenticated`

Validates an API key (or token) and returns the resolved user. Useful for checking credentials during setup.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/IsAuthenticated` |
| **Body** | `{ "token": "<API key>" }` |
| **Response** | `User` object, or `null` if the key is invalid; check `Errors[]` for `ExpiredAccount` |

An unrecognized, malformed or revoked key returns `null` directly — there is no `User` object and no `Errors[]` to inspect. An account expired more than **4 days** ago still resolves to the `User`, with an `ExpiredAccount` error added to it.

## Example request

```http
POST /Services/ApiService.svc/IsAuthenticated HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

## Example response

Invalid key (verified live against `apiqa.invoice4u.co.il`):

```json
{
  "d": null
}
```

## Errors

| Result | Meaning |
| ------ | ------- |
| `null` response, no `User` object | Key not found, malformed, or revoked. |
| `Errors[]` contains `ExpiredAccount` (66) | Account expired more than 4 days ago. |

## Related: check account expiry

`GetExpDateByApiKey` returns the account expiration date for the authenticated user.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetExpDateByApiKey` |
| **Body** | `{ "token": "<API key>" }` |
| **Response** | Expiration date string, or `"UnauthorizedUser"` |

## Try it

{% openapi-operation spec="invoice4u-api" path="/IsAuthenticated" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetExpDateByApiKey" method="post" %}
{% endopenapi-operation %}

