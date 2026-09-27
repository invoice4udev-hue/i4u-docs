# Authentication Overview

All Invoice4U API calls require your organization **API key** (GUID). There is no separate login call — pass the key directly as the `token` parameter in the body of each request.

### How it works

1. Get your organization API key from the Invoice4U web application (Settings).
2. Pass it as `token` in every call.
3. Optionally verify it with [`IsAuthenticated`](is-authenticated.md) during setup.

{% hint style="warning" %}
Email + password login (`VerifyLogin`) is **deprecated**. It still works during the migration period, but it will be removed — migrate your integration to API-key authentication and pass the key as `token`.
{% endhint %}

### Token behavior

* The API key identifies your organization. Documents, customers and branches you access are always scoped to the authenticated organization.
* `ExpiredAccount` (66) is returned as-is by some endpoints (e.g. document creation); many others replace it with `UnauthorizedUser` (80). See each endpoint's own Errors section for its exact behavior.
* Most endpoints report an invalid key as `UnauthorizedUser` (80) inside the response object's `Errors` list; some — including [`IsAuthenticated`](is-authenticated.md) and the [Inventory endpoints](../inventory/overview.md#module-inactive-behavior) — return `null`, an empty result, or an HTTP 500 fault instead. Each endpoint page lists its exact behavior.

{% hint style="warning" %}
Treat the API key like a password. Send it only over HTTPS and never embed it in client-side (browser/mobile) code.
{% endhint %}

### Pages in this section

* [Verify Your API Key & Account Expiry](is-authenticated.md)

To change account credentials, use the Invoice4U web application (Settings). Partners can rotate an organization's API key programmatically with `UpdateAKU`, as part of the partner [User Registration](../registration/user-registration.md) flow — this operation is not available to regular API users.
