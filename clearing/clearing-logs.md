# Clearing Logs

Every clearing request and response is recorded as a `ClearingLog` row. Use these endpoints to query charge history and reconcile transactions.

## The ClearingLog object

| Field | Type | Description |
| ----- | ---- | ----------- |
| `Id` | int | Log row ID. |
| `OrganizationId` | int | Your organization's ID; used internally for the ownership check on `GetClearingLogById`. |
| `Date` | datetime | Timestamp. |
| `LogType` | int | `1` Request, `2` Response. |
| `ClientName` | string | Customer name. |
| `CustomerUniqueId` | string | Payer identity/ID number captured at the hosted page — the same value as `UniqueId` in the [callback payload](process-api-request-v2.md#callback-payload). |
| `Amount` | double | Charged amount. |
| `Currency` | int | `1` NIS, `2` USD, `3` EUR, `4` GBP. |
| `CurrencyName` | string | Text name of `Currency`: `"ILS"`, `"USD"`, `"EUR"` or `"GBP"`. |
| `PaymentNumber` | int | Number of installments. |
| `CreditNumber` | string | Last 4 card digits. |
| `CreditType` / `CreditTypeName` | int / string | Your organization's credit-card company ID and name, as configured on your account — not a fixed system-wide code. |
| `ClearingCompany` / `ClearingCompanyName` | int / string | Clearing provider (`ClearingCompanies`): 6 UPay, 7 Meshulam, 12 YaadSarig (historical records only), 15 Cardcom. |
| `IsSuccess` | boolean | Charge result. |
| `ErrorMessage` | string | Provider error text on failure. |
| `ClearingConfirmationNumber` | string | Provider confirmation/auth number. |
| `ClearingTraceId` | string | Trace ID linking request↔response. |
| `PaymentId` | string | Provider payment reference — use for [refunds](process-api-request-v2.md#refunds). |
| `IsCredit` | boolean | `true` for refund rows. |
| `CreditedTransaction` / `CreditAmount` | bool / double | Whether/how much this charge was later refunded. |
| `IsToken` | boolean | Token-based charge. |
| `IsBitPayment` / `IsGooglePay` / `IsApplePay` | boolean | Alternative payment method flags. |
| `IsDocumentCreated` / `DocId` | bool / GUID | Auto-created document reference. |
| `TransactionType` | int | Unified type: 0 Charge, 1 TokenCreation, 2 TokenAndCharge, 3 ChargeByToken, 4 PaymentInNumbers, 5 PaymentWithFees, 6 Credit/refund, 7 MobileAppPersonalPayment, 8 TokenPaymentInNumbers. |
| `CreateDocumentType` | int | Internal. Document-type code recorded when a document was auto-created for the charge (`0` when none was created). |
| `ClearingLogBaseId` | int | Internal. Links a charge's request row (`LogType` `1`) and response row (`LogType` `2`); `0` until the response row exists. To pair the rows, match on `ClearingTraceId` instead. |
| `TransactionId` / `TransactionToken` | string | Internal. Provider-specific transaction identifiers; not required for integration. |
| `UpdateRequestLog` | boolean | Internal. Used only when inserting a log via `ProcessApiRequestClearingLogInsertREST_V2`; not meaningful when reading existing logs. |

## Get by ID — `GetClearingLogById`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetClearingLogById` |

```json
{ "clearingLogId": 123456, "token": "<token>" }
```

Returns the `ClearingLog`, or `{ "d": null }` when no log has that ID. Example — the request row that the [Process a Clearing Request example](process-api-request-v2.md#example-response) wrote when it created the Cardcom hosted page, fetched with its `I4UClearingLogId` before the customer paid:

```json
{
  "d": {
    "__type": "ClearingLog:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "Amount": 117,
    "ClearingCompany": 15,
    "ClearingCompanyName": "<clearing company name>",
    "ClearingConfirmationNumber": "",
    "ClearingLogBaseId": 0,
    "ClearingTraceId": "a1b2c3d4-0000-4000-8000-000000000002",
    "ClientName": "Israel Israeli",
    "CreateDocumentType": 1,
    "CreditAmount": 0,
    "CreditNumber": "",
    "CreditType": 1,
    "CreditTypeName": "<credit company name>",
    "CreditedTransaction": false,
    "Currency": 1,
    "CurrencyName": "ILS",
    "CustomerUniqueId": null,
    "Date": "/Date(1788210000000+0300)/",
    "DocId": null,
    "ErrorMessage": "",
    "Id": 123455,
    "IsApplePay": false,
    "IsBitPayment": false,
    "IsCredit": false,
    "IsDocumentCreated": false,
    "IsGooglePay": false,
    "IsSuccess": true,
    "IsToken": false,
    "LogType": 1,
    "OrganizationId": 12345,
    "PaymentId": "0",
    "PaymentNumber": 1,
    "TransactionId": "",
    "TransactionToken": "",
    "TransactionType": 0,
    "UpdateRequestLog": false
  }
}
```

* `<…>` values come from your account's configuration.
* A request row (`LogType` `1`) holds what was known when the page was created: no card details yet, `PaymentId` `"0"` on Cardcom, and `ClearingTraceId` = the `ClearingTraceId` from the response's `OpenInfo`.
* When the customer pays, a response row (`LogType` `2`) is added with the result — `IsSuccess`, `CreditNumber` (last 4 digits), `ClearingConfirmationNumber` (the callback's `AuthNumber`), the provider `PaymentId` (the callback's `PaymentId`) and the same `ClearingTraceId`. Find it with `GetClearingLogByParams` by `PaymentId`.
* `Errors`, `Info` and `OpenInfo` are empty arrays on success. `UpdateRequestLog` is always `false` when reading.

A log belonging to another organization is rejected with `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) — see [Errors](#errors) for how errors currently arrive.

## Search — `GetClearingLogByParams`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetClearingLogByParams` |

### Filters — `searchParams` (ClearingLogSearch)

Every field below is optional; omit a filter to skip it.

| Field | Type | Description |
| ----- | ---- | ----------- |
| `ClearingLogId` | int | Filter to a single log by ID. Only applied when greater than `0`. |
| `OrganizationId` | int | Ignored — the API always scopes results to your token's organization; any value you send is overwritten. |
| `FromDate` / `ToDate` | datetime | Date range (WCF format, see example). |
| `IsSuccess` | boolean | Filter by charge result. |
| `CreditCardNumber` | string | Filter by the card number/last digits as stored on the log. |
| `Currency` | int | Filter by `Currency` code (`1` NIS, `2` USD, `3` EUR, `4` GBP). |
| `CreditCardType` | int | Filter by your organization's credit-card company ID (matches the returned `CreditType`/`CreditTypeName`). |
| `FromAmount` / `ToAmount` | double | Amount range. |
| `ClearingConfirmationNumber` | string | Filter by the provider confirmation/auth number. |
| `IsCredit` | boolean | `true` to return only refund/credit rows. |
| `IsBitPayment` / `IsGooglePay` / `IsApplePay` | boolean | Filter by alternative payment method flags. |
| `CompanyType` | int | Filter by clearing provider (`ClearingCompanies`): `6` UPay, `7` Meshulam, `12` YaadSarig (historical records only), `15` Cardcom. |
| `ClientName` | string | Filter by customer name. |
| `PaymentId` | string | Filter by the provider payment reference. |
| `TransactionType` | int | Filter by the unified transaction type — see the [ClearingLog object](#the-clearinglog-object) above. |

```json
{
  "searchParams": {
    "FromDate": "/Date(1780261200000+0300)/",
    "ToDate": "/Date(1782853199000+0300)/",
    "IsSuccess": true,
    "PaymentId": "100200300",
    "CompanyType": 15
  },
  "token": "<token>"
}
```

Returns `{ "d": [ … ] }` — an array of `ClearingLog` objects like the example above, scoped to your organization (`[]` when nothing matches).

## Insert an external log — `ProcessApiRequestClearingLogInsertREST_V2`

For integrations that clear cards outside Invoice4U but want the charge recorded (e.g. to appear in reports):

| | |
| - | - |
| **Method** | `GET` |
| **Path** | `/ProcessApiRequestClearingLogInsertREST_V2` |

Pass a `ClearingLog` object (`clearingLog`) with at least `ClientName`, `Amount`, `PaymentNumber`, `Currency`, `CreditNumber` (last 4), `IsSuccess`, `ClearingConfirmationNumber`, plus your auth `token`. Legacy credential-based variants (`ProcessApiRequestClearingLogInsertREST`) exist for older integrations.

## Errors

| Error (ID) | Endpoint(s) | Meaning |
| ---------- | ----------- | ------- |
| `UnauthorizedUser` (80) | All three | Invalid token/credentials. |
| `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) | `GetClearingLogById` | Log belongs to another organization. |
| `ClearingTerminalDoesntExists` (96) | `ProcessApiRequestClearingLogInsertREST_V2` | No clearing account, or the terminal for your provider is misconfigured (missing terminal/username/password). |

`GetClearingLogById` and `GetClearingLogByParams` do not validate whether a clearing account is configured — they only check the token.

{% hint style="warning" %}
**Error responses from `GetClearingLogById` and `GetClearingLogByParams` currently don't reach the client.** Instead of returning `UnauthorizedUser` (80) or `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322), the server closes the connection without a response (e.g. curl: `Recv failure: Connection was reset`) — verified on Production and QA with an invalid token. Treat a dropped connection on these endpoints as an authentication or ownership failure: check the token and the log ID.
{% endhint %}

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogByParams" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/ProcessApiRequestClearingLogInsertREST_V2" method="get" %}
{% endopenapi-operation %}
