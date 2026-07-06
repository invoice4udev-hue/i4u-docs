# Login with Email & Password

Returns an authentication token for the given Invoice4U account credentials.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/VerifyLogin` |
| **Response** | JSON — token string, or an error name, or `null` |

Variants of the same operation:

| Path | Method | Notes |
| ---- | ------ | ----- |
| `/VerifyLogin` | POST | Standard |
| `/VerifyLoginREST` | GET | Query-string style: `?email=...&password=...` |
| `/VerifyLoginPostREST` | POST | JSON body, explicit REST variant |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `email` | string | Yes | Account email. Trimmed automatically. |
| `password` | string | Yes | Account password. Trimmed automatically. |

## Example request

```http
POST /Services/ApiService.svc/VerifyLoginPostREST HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "<your-password>"
}
```

## Example response

```json
{
  "VerifyLoginPostRESTResult": "AQAAANCMnd8BFdERjHoAwE_Cl-sBAAAA..."
}
```

The result value is your token. Pass it as `token` in subsequent calls.

## Errors

| Result | Meaning |
| ------ | ------- |
| `null` | Missing/empty credentials, wrong credentials, or server error. |
| `"ApiPasswordExpiredChangeYourPassword"` | Password policy is on and the password expired. Change it via [UpdatePU](manage-credentials.md) or in the Invoice4U UI. |
| Other error name string | The first error from the login validation (e.g. blocked login attempts). |

{% hint style="info" %}
Prefer [API-key login](verify-login-api-key.md) for production integrations so you don't store account passwords in your system.
{% endhint %}
