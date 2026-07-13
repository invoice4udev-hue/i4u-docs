# Clearing Endpoints Overview

The clearing API charges credit cards (and Bit / Google Pay / Apple Pay) through the clearing account configured on your Invoice4U organization, and can automatically create the matching document.

### Supported clearing companies

The API works with the clearing provider configured on your account — including **Meshulam**, **Cardcom**, **UPay** and **YaadSarig**. The flow is identical from your side; the API routes to your provider.

### The hosted-page flow

Most charges use a hosted payment page:

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[Your server:<br/>ProcessApiRequestV2]:::step --> B{Request, API key &<br/>terminal valid?}:::dec
    B -- ✗ --> E1[EmptyObjectInRequest 146<br/>ApiKeyNotInCorrectFormat 303 · UnauthorizedUser 80<br/>ClearingTerminalDoesntExists 96]:::err
    B -- ✓ --> C[ClearingRedirectUrl<br/>returned]:::step
    C --> D[🖥 Customer pays on<br/>hosted page]:::page
    D --> F{Charge OK?}:::dec
    F -- ✓ --> G[Document created<br/>if IsDocCreate]:::step
    F -- ✗ --> H
    G --> H[POST CallBackUrl<br/>server-to-server result]:::cb
    H --> I[Customer redirected<br/>to ReturnUrl]:::cb
```

1. Call [`ProcessApiRequestV2`](process-api-request-v2.md) with the amount, customer details and flags.
2. Redirect your customer to the returned `ClearingRedirectUrl`.
3. Invoice4U notifies your `CallBackUrl` and redirects the customer to your `ReturnUrl`.
4. If `IsDocCreate` was `true`, the document is created automatically after a successful charge.

**Token charges** (`ChargeWithToken`) and **refunds** (`Refund`) are server-to-server — no redirect; the result is returned synchronously.

### Variations

| Variation | Flag(s) | Page |
| --------- | ------- | ---- |
| Regular charge (hosted page) | — | [Process a Clearing Request (V2)](process-api-request-v2.md) |
| Charge with installments / credit | `Type` = 2/3 | [Process a Clearing Request (V2)](process-api-request-v2.md) |
| Bit / Google Pay / Apple Pay | `IsBitPayment` / `IsGooglePay` / `IsApplePay` | [Bit, Google Pay & Apple Pay](alternative-payment-methods.md) |
| Save card token only | `AddToken` | [Tokens & Standing Orders](tokens-and-standing-orders.md) |
| Save token + charge | `AddTokenAndCharge` | [Tokens & Standing Orders](tokens-and-standing-orders.md) |
| Charge saved token | `ChargeWithToken` | [Tokens & Standing Orders](tokens-and-standing-orders.md) |
| Standing order (recurring) | `IsStandingOrderClearance` | [Tokens & Standing Orders](tokens-and-standing-orders.md) |
| Refund | `Refund` | [Process a Clearing Request (V2)](process-api-request-v2.md#refunds) |
| Query charge history | — | [Clearing Logs](clearing-logs.md) |

{% hint style="warning" %}
`ProcessApiRequest` (V1) and the `ProcessApiRequestFullContents*` GET variants still work but are **legacy**. New integrations should use `ProcessApiRequestV2` only.
{% endhint %}

### Prerequisites

* A clearing account configured and active on your organization (`GetClearingAccount` returns it).
* For tokens / standing orders: the token / standing-order feature enabled on your clearing terminal (`ApiTokenizationNotApprovedInClearingTerminal` 309 / `ApiStandingOrderNotApprovedInClearingTerminal` 310 otherwise).
* For Bit / Google Pay / Apple Pay: see [Bit, Google Pay & Apple Pay](alternative-payment-methods.md) — wallet methods need account enablement and vendor support.
