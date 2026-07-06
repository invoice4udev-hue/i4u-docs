# Authentication Overview

All Invoice4U API calls (except the login endpoints themselves) require a **token**. The token is an encrypted string returned by a login endpoint and passed as the `token` parameter in the body of each request.

### How it works

1. Call a login endpoint once with your credentials or API key.
2. Store the returned token string.
3. Pass it as `token` in every subsequent call.

There are two ways to obtain a token:

| Method | Endpoint | Use when |
| ------ | -------- | -------- |
| Email + password | [`VerifyLogin`](verify-login.md) | Server-side integrations using your account credentials |
| API key (GUID) | [`VerifyLoginApiKey`](verify-login-api-key.md) | Recommended — avoids storing your password; the key can be rotated |

### Token behavior

* The token identifies your user and organization. Documents, customers and branches you access are always scoped to the authenticated organization.
* If your account uses a **password expiry policy** and the password has expired, login fails with error `ApiPasswordExpiredChangeYourPassword` (320). Change the password and log in again.
* Expired accounts return the `ExpiredAccount` (66) error on authenticated calls.
* When a call is made with an invalid or stale token, endpoints return the `UnauthorizedUser` (80) error inside the response object's `Errors` list.

{% hint style="warning" %}
Treat the token like a password. Send it only over HTTPS and never embed it in client-side (browser/mobile) code.
{% endhint %}

### Pages in this section

* [Login with Email & Password](verify-login.md)
* [Login with API Key](verify-login-api-key.md)
* [Managing Credentials](manage-credentials.md) — change password, rotate API key, logout
