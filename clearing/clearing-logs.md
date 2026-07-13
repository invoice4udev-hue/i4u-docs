# Clearing Logs

Every clearing request and response is recorded as a `ClearingLog` row. Use these endpoints to query charge history and reconcile transactions.

## The ClearingLog object

| Field | Type | Description |
| ----- | ---- | ----------- |
| `Id` | int | Log row ID. |
| `Date` | datetime | Timestamp. |
| `LogType` | int | `1` Request, `2` Response. |
| `ClientName` | string | Customer name. |
| `Amount` | double | Charged amount. |
| `Currency` | int | `1` NIS, `2` USD, `3` EUR. |
| `PaymentNumber` | int | Number of installments. |
| `CreditNumber` | string | Last 4 card digits. |
| `ClearingCompany` / `ClearingCompanyName` | int / string | Clearing provider (`ClearingCompanies`): 1 Tranzilla, 2 ZCredit, 3 Pelecard, 4 ICreditInvoice4U, 5 ICreditUPay, 6 UPay, 7 Meshulam, 8 VisaCal, 9 TranzillaIframe, 10 Payme, 11 Isracard, 12 YaadSarig, 13 Verifone, 14 Paypal, 15 Cardcom. |
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
| `TransactionType` | int | Unified type: 1 Charge, 2 Credit/refund, 3 PaymentInNumbers, 4 PaymentWithFees, 5 TokenCreation, 6 TokenAndCharge, 7 ChargeByToken. |

## Get by ID — `GetClearingLogById`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetClearingLogById` |

```json
{ "clearingLogId": 123456, "token": "<token>" }
```

Returns the `ClearingLog`. Logs belonging to another organization return `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322).

## Search — `GetClearingLogByParams`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetClearingLogByParams` |

```json
{
  "searchParams": {
    "FromDate": "2026-06-01T00:00:00",
    "ToDate": "2026-06-30T23:59:59",
    "IsSuccess": true
  },
  "token": "<token>"
}
```

Returns `ClearingLog[]` matching the filters, scoped to your organization.

## Insert an external log — `ProcessApiRequestClearingLogInsertREST_V2`

For integrations that clear cards outside Invoice4U but want the charge recorded (e.g. to appear in reports):

| | |
| - | - |
| **Method** | `GET` |
| **Path** | `/ProcessApiRequestClearingLogInsertREST_V2` |

Pass a `ClearingLog` object (`clearingLog`) with at least `ClientName`, `Amount`, `PaymentNumber`, `Currency`, `CreditNumber` (last 4), `IsSuccess`, `ClearingConfirmationNumber`, plus your auth `token`. Legacy credential-based variants (`ProcessApiRequestClearingLogInsertREST`) exist for older integrations.

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token/credentials. |
| `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) | Log belongs to another organization. |
| `ClearingCompanyUndefined` (8) | No clearing account configured. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogByParams" method="post" %}
{% endopenapi-operation %}

