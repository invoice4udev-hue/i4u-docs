# Get Your Clearing Account

Returns the clearing account (terminal) configured for the authenticated user: which provider it uses, whether it is active, and which features (tokens, standing orders, Bit, Google Pay, Apple Pay) are enabled. Use it as a pre-flight check before calling [`ProcessApiRequestV2`](process-api-request-v2.md).

{% hint style="danger" %}
**The response contains your clearing provider credentials in plain text** — `UserName`, `Password` and `Terminal`. Call this endpoint only from your server, never from a browser or mobile app, and never log, cache or forward the raw response. Keep only the flags you need.
{% endhint %}

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetClearingAccount` |
| **Response** | `ClearingAccount` |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token (your API key). |

## Example request

```http
POST /Services/ApiService.svc/GetClearingAccount HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

## The ClearingAccount object

| Field | Type | Description |
| ----- | ---- | ----------- |
| `UserID` | int | The Invoice4U user the clearing account belongs to. |
| `CompanyType` | int | Clearing provider (`ClearingCompanies`): `6` UPay, `7` Meshulam, `15` Cardcom. `0` means no clearing account is configured. |
| `IsActive` | boolean | Whether the clearing account is active. |
| `UserName` | string | **Sensitive.** Provider username. |
| `Password` | string | **Sensitive.** Provider password / API secret. |
| `Terminal` | string | **Sensitive.** Provider terminal number. |
| `IsToken` | boolean | Saved-card tokens are enabled on the terminal. |
| `ExpirationDateToken` | datetime | Token feature expiry. `2000-01-01` when not set. |
| `IsStandingOrder` | boolean | Standing orders are enabled on the terminal. |
| `ExpirationDateSO` | datetime | Standing-order feature expiry. `2000-01-01` when not set. |
| `IsBitService` | boolean | Bit payments are enabled. |
| `IsGooglePay` / `IsApplePay` | boolean | Google Pay / Apple Pay are enabled. |
| `IsEMVService` / `EmvTerminalNumber` | boolean / string | Internal. EMV (physical card reader) settings; not used by the clearing API. |
| `IsNewApi` | boolean | Internal. |
| `DateCreated` | datetime | Not populated by this endpoint — always `null`. |
| `UpayType` | int | Not populated by this endpoint — always `0`. |

`Errors`, `Info` and `OpenInfo` are the standard response envelope — empty arrays on success.

## Example response

Cardcom terminal with tokens enabled and standing orders not enabled:

```json
{
  "d": {
    "__type": "ClearingAccount:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "CompanyType": 15,
    "DateCreated": null,
    "EmvTerminalNumber": null,
    "ExpirationDateSO": "/Date(946677600000+0200)/",
    "ExpirationDateToken": "/Date(1830290400000+0200)/",
    "IsActive": true,
    "IsApplePay": false,
    "IsBitService": true,
    "IsEMVService": false,
    "IsGooglePay": false,
    "IsNewApi": false,
    "IsStandingOrder": false,
    "IsToken": true,
    "Password": "<provider password>",
    "Terminal": "<terminal number>",
    "UpayType": 0,
    "UserID": 12345,
    "UserName": "<provider username>"
  }
}
```

* `<…>` values come from your account's configuration.
* `ExpirationDateSO` is `2000-01-01` here because standing orders were never enabled.

### No clearing account configured

If no clearing account is configured, the call still succeeds: `Errors` is empty, `CompanyType` is `0`, and every other field is `null` (`UserID` and `UpayType` are `0`). Check `CompanyType` rather than relying on `Errors`.

## Checking feature availability

Use the response to avoid predictable `ProcessApiRequestV2` errors:

| Before you… | Check | Error otherwise |
| ----------- | ----- | --------------- |
| Charge at all | `CompanyType` is not `0`, and `Terminal` / `UserName` / `Password` are filled in for your provider | `ClearingTerminalDoesntExists` (96) |
| Save or charge a token | `IsToken` is `true` and `ExpirationDateToken` is in the future | `ApiTokenizationNotApprovedInClearingTerminal` (309) |
| Create a standing order | the token check above, plus `IsStandingOrder` is `true` and `ExpirationDateSO` is in the future | `ApiStandingOrderNotApprovedInClearingTerminal` (310) |
| Offer Google Pay / Apple Pay | `IsGooglePay` / `IsApplePay` is `true` | `ApiGooglePayNotAllowedForUser` (316) / `ApiApplePayNotAllowedForUser` (317) |

`IsBitService` is informational — `ProcessApiRequestV2` does not check it. See [Bit, Google Pay & Apple Pay](alternative-payment-methods.md) for wallet requirements.

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid or unknown token. |
| `ExpiredAccount` (66) | Account expired more than 4 days ago. |
| `GeneralError` (0) | Server error. |

Errors are returned inside the `ClearingAccount` object, with all other fields empty. Invalid token (verified live against `apiqa.invoice4u.co.il`):

```json
{
  "d": {
    "__type": "ClearingAccount:#Invoice.Common",
    "Errors": [
      { "__type": "CommonError:#Invoice.Common", "Error": "UnauthorizedUser", "ID": 80, "Paramters": null }
    ],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "CompanyType": 0,
    "DateCreated": null,
    "EmvTerminalNumber": null,
    "ExpirationDateSO": null,
    "ExpirationDateToken": null,
    "IsActive": null,
    "IsApplePay": null,
    "IsBitService": null,
    "IsEMVService": null,
    "IsGooglePay": null,
    "IsNewApi": null,
    "IsStandingOrder": null,
    "IsToken": null,
    "Password": null,
    "Terminal": null,
    "UpayType": 0,
    "UserID": 0,
    "UserName": null
  }
}
```

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetClearingAccount" method="post" %}
{% endopenapi-operation %}
