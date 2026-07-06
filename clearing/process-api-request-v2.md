# Process a Clearing Request (V2)

The main clearing endpoint. Creates a hosted payment page, charges a saved token, or refunds a previous charge — and optionally creates the matching document.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/ProcessApiRequestV2` |
| **Response** | The same `ApiClearingRequest` object, enriched with results (`ClearingRedirectUrl`, `PaymentId`, `DocumentNumber`, …) — check `Errors` first |

## Request schema — `request` (ApiClearingRequest)

### Authentication (one required)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Invoice4UUserApiKey` | string (GUID) | One of | Recommended. |
| `Invoice4UUserEmail` + `Invoice4UUserPassword` | string | One of | Credential alternative. |

### Charge details

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Sum` | double | **Yes** | Amount to charge. |
| `Currency` | string | No | `"NIS"` (default), `"USD"`, `"EUR"`. |
| `Type` | int | No | `1` Regular (default), `2` Payments (installments), `3` CreditPayments, `4` Refund. |
| `PaymentsNum` | int | No | Number of installments when `Type` is 2/3. |
| `Description` | string | No | Charge description (shown on page/document). |
| `IsQaMode` | boolean | No | `true` when testing against QA. |
| `OrderIdClientUsage` | string | No | Your order reference, echoed back in callbacks. |
| `CreditCardCompanyType` | int | No | Card company override. |

Bit / Google Pay / Apple Pay charges use the `IsBitPayment` / `IsGooglePay` / `IsApplePay` flags — see [Bit, Google Pay & Apple Pay](alternative-payment-methods.md) for enablement, limitations and errors.

### Customer

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `CustomerId` | int | Conditional | Existing customer. Its name/email/phone are used for the page and notifications. |
| `FullName` | string | Conditional | Customer full name (required when no `CustomerId`). |
| `Phone` | string | Conditional | Customer phone (used for payment-page SMS/identification). |
| `Email` | string | No | Customer email — receives the document. |
| `IsAutoCreateCustomer` | boolean | No | Find-or-create a real customer record by phone/email; otherwise the charge uses a general customer. |
| `IsGeneralClient` | boolean | No (default `true`) | Document is issued to a general (one-off) customer. |

### Redirects & callbacks

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `ReturnUrl` | string | Hosted page | Where the customer is redirected after payment. |
| `CallBackUrl` | string | Recommended | Server-to-server notification URL. |

### Document creation

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `IsDocCreate` | boolean | No | Create a document automatically after a successful charge. |
| `DocHeadline` | string | No | Document subject (defaults to `Description`). |
| `IsManualDocCreationsWithParams` | boolean | No | Provide explicit line items via the pipe-separated `DocItem*` fields below. |
| `DocItemName` / `DocItemQuantity` / `DocItemPrice` | string | With manual items | Pipe-separated lists, equal length, e.g. `"Item A\|Item B"`, `"1\|2"`, `"100\|50"`. |
| `DocItemCode` / `DocItemTaxRate` | string | No | Optional pipe-separated code/VAT-rate lists. |
| `IsItemsBase64Encoded` | boolean | No | `DocItem*` values are Base64-encoded (for special characters). |
| `DocBranchId` | string | No | Branch for the document. |
| `DocComments` | string | No | Document comments. |
| `Language` / `DocLanguage` | string | No | Page / document language (`"he"` / `"en"`). |
| `TaxPercentage` | double | No | VAT override for the document. |

### Tokens, standing orders, refunds

See [Tokens & Standing Orders](tokens-and-standing-orders.md) for `AddToken`, `AddTokenAndCharge`, `ChargeWithToken`, `IsStandingOrderClearance`, `StandingOrderDuration`, `StandingOrderFirstChargeAmount`, `StandingOrderCallBackUrl` — and [Refunds](#refunds) below for `Refund` + `PaymentId`.

## Example request — hosted page + auto document

```http
POST /Services/ApiService.svc/ProcessApiRequestV2 HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "request": {
    "Invoice4UUserApiKey": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f",
    "Sum": 117.0,
    "Currency": "NIS",
    "Type": 1,
    "FullName": "Israel Israeli",
    "Phone": "0501234567",
    "Email": "israel@example.com",
    "Description": "Order #10045",
    "OrderIdClientUsage": "10045",
    "IsDocCreate": true,
    "DocHeadline": "Order #10045",
    "ReturnUrl": "https://shop.example/thanks",
    "CallBackUrl": "https://shop.example/api/i4u-callback",
    "IsQaMode": true
  }
}
```

## Example response

```json
{
  "ProcessApiRequestV2Result": {
    "Sum": 117.0,
    "OrderIdClientUsage": "10045",
    "ClearingRedirectUrl": "https://pay.example-provider.co.il/page/abc123",
    "PaymentId": "ab12cd34",
    "Errors": []
  }
}
```

Redirect the customer to `ClearingRedirectUrl`. After payment you receive the callback and, when `IsDocCreate` is set, the document fields (`DocumentId`, `DocumentNumber`, `CipherText`) are populated.

## Refunds

Set `Refund: true` and identify the original charge:

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Refund` | boolean | Yes | Refund mode. |
| `PaymentId` | string | Provider-dependent | Original payment/transaction reference (required for UPay). |
| `Sum` | double | Yes | Amount to refund — must not exceed the remaining un-refunded balance. |

Refund constraints: Cardcom refunds are validated against the remaining balance; UPay refunds are possible up to 5 months after the charge (`ClearingErrorRefundTimeExceeded`, 158).

## Common errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `EmptyObjectInRequest` (146) | Request body missing. |
| `UnauthorizedUser` (80) | Bad API key / credentials. |
| `ClearingCompanyUndefined` (8) | No active clearing account, or account misconfigured. |
| `ApiBadRequestChargeMethodMustBeSelected` (319) | Conflicting flags (e.g. `AddTokenAndCharge` + `IsStandingOrderClearance`). |
| `ApiTokenizationNotApprovedInClearingTerminal` (309) | Token features not enabled on the terminal. |
| `ApiStandingOrderNotApprovedInClearingTerminal` (310) | Standing orders not enabled. |
| `ApiGooglePayNotAllowedForUser` (316) / `ApiApplePayNotAllowedForUser` (317) | Wallet method not enabled. |
| `ClientIDDoesntExists` (37) | `CustomerId` not found. |
| `NumberOfItemsIsNotEqual` (24) | `DocItem*` pipe-lists have different lengths. |
| `ClearingError` (32) | Charge declined / provider error — details in `Paramters`. |
| `ClearingErrorRefundTimeExceeded` (158) | Refund window exceeded. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/ProcessApiRequestV2" method="post" %}
{% endopenapi-operation %}

