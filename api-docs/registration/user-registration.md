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

### Becoming a partner

If you need to create Invoice4U accounts on behalf of your users (platforms, marketplaces, accounting suites), contact Invoice4U business development to receive a partner token and register your server IPs. Onboarding includes bundle mapping and QA-environment access.
