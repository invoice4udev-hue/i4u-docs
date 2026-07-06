# Welcome to the Invoice4U API

The Invoice4U API lets you create tax-compliant documents (invoices, receipts, credit invoices and more), manage customers and branches, and charge credit cards through the Invoice4U clearing service — all from your own application.

Use it to automate billing flows, sync your CRM or e-commerce store with Invoice4U, and collect payments with hosted clearing pages, saved card tokens, or standing orders.

### Get access

1. Create an account at [invoice4u.co.il](https://invoice4u.co.il).
2. Enable API access for your organization (Settings → API, or contact support).
3. Authenticate with your credentials or API key and use the returned token in your API requests.

### Base URLs

| Environment  | Base URL                                                |
| ------------ | ------------------------------------------------------- |
| Production   | `https://api.invoice4u.co.il/Services/ApiService.svc`   |
| QA (staging) | `https://apiqa.invoice4u.co.il/Services/ApiService.svc` |

All endpoints in this documentation are relative to these base URLs. Develop and test against **QA** first, then switch the base URL to **Production**.

{% hint style="info" %}
The API is a WCF service exposed over REST (JSON). A SOAP endpoint is also available at `{baseUrl}/Soap` (basicHttpBinding) for legacy integrations, but REST/JSON is the recommended and documented surface.
{% endhint %}

### Request format

Unless stated otherwise, endpoints are called with **POST** and a JSON body that wraps the operation parameters by name (WCF "wrapped request" style):

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: api.invoice4u.co.il
Content-Type: application/json

{
  "doc": { ... },
  "token": "<your-token>"
}
```

### Authentication

Almost every endpoint takes a `token` parameter. You obtain a token once via a login endpoint and pass it in the body of each subsequent call:

1. [Login with Email & Password](authentication/verify-login.md) — `VerifyLogin`
2. [Login with API Key](authentication/verify-login-api-key.md) — `VerifyLoginApiKey`

### Response envelope

Most response objects inherit a common envelope. Always check `Errors` before using the payload:

| Field      | Type   | Description                                                                                                                                    |
| ---------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `Errors`   | array  | List of errors. Empty on success. Each item: `ID` (numeric error code), `Error` (error name), `Paramters` (optional context, e.g. row number). |
| `Info`     | array  | Informational messages (e.g. `SuccessfulAction`).                                                                                              |
| `OpenInfo` | object | Key/value extras returned by some endpoints (e.g. `PaymentMismatchDelta`).                                                                     |

### First steps

Follow the [Quick Start](getting-started/quick-start.md), then read [Key Tips & Differences](getting-started/key-tips.md) (also available [in Hebrew](getting-started/key-tips-hebrew.md)).

### Support

For integration help, contact Invoice4U support through your account. Include the request payload, the response payload, and the environment (QA/Production) with every report.

### Next pages

* [Quick Start](getting-started/quick-start.md)
* [Authentication Overview](authentication/overview.md)
* [Document Endpoints Overview](documents/overview.md)
