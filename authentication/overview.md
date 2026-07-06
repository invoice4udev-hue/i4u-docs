# Authentication Overview

All Invoice4U API calls (except the login endpoints themselves) require a **token**. The token is an encrypted string returned by a login endpoint and passed as the `token` parameter in the body of each request.

### How it works

1. Call [`VerifyLoginApiKey`](verify-login-api-key.md) once with your organization API key (GUID).
2. Store the returned token string.
3. Pass it as `token` in every subsequent call.

{% hint style="warning" %}
Email + password login (`VerifyLogin`) is **no longer supported** — tokens it returns are not accepted by the API. Authenticate with your API key only.
{% endhint %}

### Token behavior

* The token identifies your user and organization. Documents, customers and branches you access are always scoped to the authenticated organization.
* Expired accounts return the `ExpiredAccount` (66) error on authenticated calls.
* When a call is made with an invalid or stale token, endpoints return the `UnauthorizedUser` (80) error inside the response object's `Errors` list.

{% hint style="warning" %}
Treat the token like a password. Send it only over HTTPS and never embed it in client-side (browser/mobile) code.
{% endhint %}

### Pages in this section

* [Login with API Key](verify-login-api-key.md)

To rotate your API key or change account credentials, use the Invoice4U web application (Settings) — these operations are not exposed through the public API.
