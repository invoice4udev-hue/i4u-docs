# User Registration (Partners)

The API includes a partner-only endpoint for registering new Invoice4U accounts programmatically:

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UserRegistrationApi` |
| **Response** | `UserRegApiObject` (check `Errors`) |

{% hint style="warning" %}
This endpoint is **restricted**. It requires a partner-specific unique token issued by Invoice4U **and** the calling server's IP address must be whitelisted. It is not available to regular API users.
{% endhint %}

### The UserRegApiObject (for reference)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Email` | string | Yes | New account email. Must be unique and valid. |
| `UserPassword` | string | Yes | Must pass the password policy. |
| `FirstName` / `LastName` | string | Yes | Account owner name. |
| `CompanyName` | string | Yes | Business name. |
| `OrganizationUniqueId` | string | Yes | Business VAT/company number. Must be unique. |
| `Phone` / `Mobile` | string | No | Contact numbers. |
| `TaxRate` | int | No | Must be the current legal VAT rate or `0` (tax-exempt). |
| `BusinessType` | int | No | Business type enum (default `1` — authorized dealer). |
| `BundleID` | int | No | Subscription bundle. |
| `ApiKey` | string (GUID) | No | Pre-provisioned API key for the new account. |

### Common errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `ApiInvalidUniqueToken` (308) | Missing/invalid partner token. |
| `ApiUnauthorizedAccessInvalidIPAddress` (306) | Calling IP not whitelisted. |
| `EmailExists` (1) / `EmailNotValid` (16) | Email conflict/invalid. |
| `UniqueIdExists` (9) / `UniqueIDNotValid` (64) | Business number conflict/invalid. |
| `PasswordNotValid` (17) | Weak password. |
| `InvalidVatPercentage` (77) | `TaxRate` isn't the legal rate or 0. |

## Set a new API key: `UpdateAKU`

Also part of the partner registration flow: replaces an organization's current API key with a new GUID you supply. The old key stops working immediately, so use this right after `UserRegistrationApi` to hand the new account a known key, or to rotate a key you previously issued.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateAKU` |
| **Body** | `{ "newAkU": "<new API key (GUID)>", "token": "<current API key>" }` |
| **Response** | `User` object; only `Errors` and `Info` are meaningful |

### Example request

```http
POST /Services/ApiService.svc/UpdateAKU HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "newAkU": "0f9e8d7c-6b5a-4c3d-2e1f-a0b1c2d3e4f5",
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

### Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [
      { "ID": 0, "Info": "success" }
    ]
  }
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `ApiKeyNotInCorrectFormat` (303) | `newAkU` isn't a valid GUID. |
| `ApiKeyWasntGenerated` (144) | The new key couldn't be saved. |
| `UnauthorizedUser` (80) | `token` is invalid or expired. |
| `GeneralError` (0) | Unexpected server error. |

### Becoming a partner

If you need to create Invoice4U accounts on behalf of your users (platforms, marketplaces, accounting suites), contact Invoice4U business development to receive a partner token and register your server IPs. Onboarding includes bundle mapping and QA-environment access.

## Try it

{% openapi-operation spec="invoice4u-api" path="/UserRegistrationApi" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/UpdateAKU" method="post" %}
{% endopenapi-operation %}

