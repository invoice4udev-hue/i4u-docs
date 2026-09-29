# Welcome to the Invoice4U API

The Invoice4U API lets you create tax-compliant documents (invoices, receipts, credit invoices and more), manage customers and branches, and charge credit cards through the Invoice4U clearing service — all from your own application.

Use it to automate billing flows, sync your CRM or e-commerce store with Invoice4U, and collect payments with hosted clearing pages, saved card tokens, or standing orders.

The clearing service supports three providers — **Cardcom**, **UPay** and **Meshulam** (`ClearingCompanies` values `15`, `6`, `7`); the one configured on your account is used automatically. See the [clearing overview](../clearing/overview.md).

### Get access

1. Create an account at [invoice4u.co.il](https://invoice4u.co.il).
2. Enable API access for your organization (Settings → API, or contact support).
3. Pass your organization API key as `token` in every call — there is no separate login step.

### Base URLs

| Environment | Base URL |
| ----------- | -------- |
| Production | `https://api.invoice4u.co.il/Services/ApiService.svc` |
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

Almost every endpoint takes a `token` parameter — this is your organization **API key** (GUID), passed in the body of each call. See [Authentication Overview](../authentication/overview.md).

### Response envelope

Every response is a JSON object with a single `d` property that holds the result:

```json
{
  "d": {
    "__type": "Document:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "DocumentNumber": 10045
  }
}
```

Depending on the endpoint, `d` can also be a plain value (`true`, a string, an array) or `null`. The `__type` hint can be ignored.

Most result objects inherit a common envelope. Always check `Errors` before using the payload:

| Field | Type | Description |
| ----- | ---- | ----------- |
| `Errors` | array | List of errors. Empty on success. Each item: `ID` (numeric error code), `Error` (error name), `Paramters` (optional context, e.g. row number). |
| `Info` | array | Informational messages. Each item: `ID`, `Info` (message name, e.g. `SuccessfulAction`), `Paramters`. |
| `OpenInfo` | array | Key/value extras returned by some endpoints, as `{ "Key": "...", "Value": "..." }` pairs — e.g. `[{ "Key": "PaymentMismatchDelta", "Value": "0.01" }]`. |

### Dates

Date fields are sent and returned in the WCF JSON date format: milliseconds since 1970-01-01 UTC, optionally followed by the time-zone offset.

```json
"IssueDate": "/Date(1788210000000+0300)/"
```

That value is 1 September 2026, 00:00 Israel time. JSON encoders may escape the slashes (`"\/Date(1788210000000+0300)\/"`) — both forms are accepted. ISO-8601 strings such as `"2026-09-01T00:00:00"` are **not** accepted in requests. Exception: [`GetTaxRate`](../account/vat-rate-and-numbering.md)'s optional `date` is a plain `yyyy-MM-dd` string, not a WCF date.

To build a value, take the Unix time in milliseconds (JavaScript `date.getTime()`, C# `DateTimeOffset.ToUnixTimeMilliseconds()`, PHP `$date->getTimestamp() * 1000`) and append the offset.

### First steps

Follow the [Quick Start](quick-start.md), then read [Key Tips & Differences](key-tips.md) (also available [in Hebrew](https://invoice4u.gitbook.io/invoice4u-docs/he/getting-started/key-tips)).

### Machine-readable resources

* [OpenAPI 3.0 spec (JSON)](https://raw.githubusercontent.com/invoice4udev-hue/i4u-docs/main/openapi/invoice4u-openapi.json) — the full API surface for code generators, Postman, and AI agents.
* [Postman collection](https://raw.githubusercontent.com/invoice4udev-hue/i4u-docs/main/openapi/Invoice4u%20API%20collection.postman_collection.json) — ready-made requests for almost every documented endpoint (the partner-only `GetExpDateByApiKey` is the sole exception).
* AI agents: this site serves [llms.txt](https://invoice4u.gitbook.io/invoice4u-docs/llms.txt), and every page is available as Markdown by appending `.md` to its URL.

### Support

For integration help, contact Invoice4U support through your account. Include the endpoint called, the request payload, the response payload, and the environment (QA/Production) with every report.

### Next pages

* [Quick Start](quick-start.md)
* [Authentication Overview](../authentication/overview.md)
* [Document Endpoints Overview](../documents/overview.md)
