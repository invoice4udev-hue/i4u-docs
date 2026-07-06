# Authentication Overview

All Invoice4U API calls require your organization **API key** (GUID). There is no separate login call — pass the key directly as the `token` parameter in the body of each request.

### How it works

1. Get your organization API key from the Invoice4U web application (Settings).
2. Pass it as `token` in every call.
3. Optionally verify it with [`IsAuthenticated`](is-authenticated.md) during setup.

{% hint style="warning" %}
Email + password login (`VerifyLogin`) is **no longer supported** — tokens it returns are not accepted by the API. Authenticate with your API key only.
{% endhint %}

### Token behavior

* The API key identifies your organization. Documents, customers and branches you access are always scoped to the authenticated organization.
* Expired accounts return the `ExpiredAccount` (66) error on authenticated calls.
* When a call is made with an invalid key, endpoints return the `UnauthorizedUser` (80) error inside the response object's `Errors` list.

{% hint style="warning" %}
Treat the API key like a password. Send it only over HTTPS and never embed it in client-side (browser/mobile) code.
{% endhint %}

### Pages in this section

* [Authenticate with Your API Key](is-authenticated.md)

To rotate your API key or change account credentials, use the Invoice4U web application (Settings) — these operations are not exposed through the public API.
