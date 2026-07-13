# Bit, Google Pay & Apple Pay

Alternative payment methods charged through the same [`ProcessApiRequestV2`](process-api-request-v2.md) endpoint, using dedicated flags. They differ from regular card clearing in enablement, vendor support and error behavior — treat them as a separate integration path.

## Request flags

Set exactly **one** of these on the clearing request:

| Field | Type | Description |
| ----- | ---- | ----------- |
| `IsBitPayment` | boolean | Charge via **Bit**. |
| `IsGooglePay` | boolean | Charge via **Google Pay**. |
| `IsApplePay` | boolean | Charge via **Apple Pay**. |

All other request fields work as in a [regular clearing request](process-api-request-v2.md) — `Sum`, customer details, `ReturnUrl`/`CallBackUrl`, `IsDocCreate`, etc.

## Example — Bit payment with auto document

```http
POST /Services/ApiService.svc/ProcessApiRequestV2 HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "request": {
    "Invoice4UUserApiKey": "<api-key>",
    "IsBitPayment": true,
    "Sum": 117.0,
    "FullName": "Israel Israeli",
    "Phone": "0501234567",
    "Email": "israel@example.com",
    "Description": "Order #10045",
    "IsDocCreate": true,
    "ReturnUrl": "https://shop.example/thanks",
    "CallBackUrl": "https://shop.example/api/i4u-callback",
    "IsQaMode": true
  }
}
```

The flow is the hosted-page flow: redirect the customer to the returned `ClearingRedirectUrl`, where they complete the payment in the wallet app / payment sheet.

## Flow — Bit

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[ProcessApiRequestV2<br/>IsBitPayment]:::step --> B{Auth + account OK?}:::dec
    B -- ✗ --> E1[UnauthorizedUser 80<br/>ClearingCompanyUndefined 8]:::err
    B -- ✓ --> C{Terminal<br/>supports Bit?}:::dec
    C -- ✗ --> E2[ClearingCompanyUndefined 8]:::err
    C -- ✓ --> D[🖥 Bit page — QR /<br/>app handoff]:::page
    D --> F[Customer approves<br/>in Bit app]:::step
    F --> G{Payment OK?}:::dec
    G -- ✓ --> H[CallBackUrl + doc if IsDocCreate<br/>log flagged IsBitPayment]:::cb
    G -- ✗ --> I[ClearingError 32<br/>posted to CallBackUrl]:::err
```

## Flow — Google Pay / Apple Pay

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[ProcessApiRequestV2<br/>IsGooglePay / IsApplePay]:::step --> B{Auth + account OK?}:::dec
    B -- ✗ --> E1[UnauthorizedUser 80<br/>ClearingCompanyUndefined 8]:::err
    B -- ✓ --> C{Wallet enabled<br/>on account?}:::dec
    C -- "GPay off" --> E2[ApiGooglePayNotAllowedForUser 316]:::err
    C -- "APay off" --> E3[ApiApplePayNotAllowedForUser 317]:::err
    C -- ✓ --> D[🖥 Wallet payment sheet<br/>single payment only]:::page
    D --> F{Payment OK?}:::dec
    F -- ✓ --> G[CallBackUrl + doc if IsDocCreate<br/>log flagged IsGooglePay/IsApplePay]:::cb
    F -- ✗ --> H[ClearingError 32<br/>posted to CallBackUrl]:::err
```

## Limitations

* **Account enablement required.** Google Pay and Apple Pay must be activated on your Invoice4U account — otherwise the request is rejected before reaching the provider (`ApiGooglePayNotAllowedForUser` 316 / `ApiApplePayNotAllowedForUser` 317).
* **Vendor support varies.** Not every clearing provider supports every wallet — availability depends on the clearing company and terminal configured on your account. Confirm with Invoice4U support which methods your terminal supports before integrating.
* **Hosted page only.** Wallet payments cannot be combined with `ChargeWithToken` — the customer must complete the payment interactively.
* **No installments.** Wallet charges are single-payment; `Type`/`PaymentsNum` installment options apply to card clearing only.
* Documents created for these charges record the payment with the matching payment type (e.g. Bit appears as payment type Bit/Other on the document), and the [clearing log](clearing-logs.md) rows carry the `IsBitPayment` / `IsGooglePay` / `IsApplePay` flags for reconciliation.

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `ApiGooglePayNotAllowedForUser` (316) | Google Pay not enabled on the account. |
| `ApiApplePayNotAllowedForUser` (317) | Apple Pay not enabled on the account. |
| `ClearingCompanyUndefined` (8) | No active clearing account, or the terminal doesn't support the requested method. |
| `ClearingError` (32) | Payment declined / provider error — details in `Paramters`. |
