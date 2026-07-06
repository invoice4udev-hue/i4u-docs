# Key Tips & Differences

Practical notes that save integration time. Read this before going live.

### Requests

* **Everything is POST + JSON** (unless a page says otherwise). Parameters are wrapped by name in the body — `{ "doc": {...}, "token": "..." }` — not sent as bare objects.
* Responses wrap the result in `<Operation>Result`, e.g. `CreateDocumentResult`.
* A few endpoints have `GET` variants (`...REST` suffixed) that take query-string parameters — useful for quick tests, not recommended for production (credentials in URLs).

### Errors

* HTTP status is almost always **200** — errors are inside the response object's `Errors` list. **Always check `Errors` before using the payload.**
* `Errors[].ID` is a stable numeric code (e.g. `80` UnauthorizedUser, `134` DocumentAlreadyCreated); `Paramters` often holds context such as `"Row Number - 0"`.
* Some login/lookup endpoints return `null` instead of an error object — treat `null` as failure.

### Tokens

* Your **API key** (GUID) *is* the token — pass it as `token` in every call; there is no login step ([details](../authentication/is-authenticated.md)). Email+password login is no longer supported.
* Invalid key → `UnauthorizedUser` (80). Check the key in the Invoice4U web app.

### Documents

* Documents are **immutable** once created — no update endpoint. Mistake? Issue an [InvoiceCredit](../documents/document-types.md) against it.
* **Always set `ApiIdentifier`** (your order/transaction ID). Use [CreateDocumentWithIdentifierValidation](../documents/create-document-with-validation.md) for safe retries — error `134` with a returned `DocumentNumber > 0` means "already exists", not failure.
* Totals are computed **server-side** from `Items`/`Payments` — don't compute and send `Total`.
* Document numbers are sequential **per document type** — `GetDocumentByNumber` needs both number and type.
* `IssueDate` can't be in the future and can't precede your latest document of the same type.
* For **InvoiceReceipt**, payments must equal items total; enable `AutoFixPaymentsMismatchItems` to absorb ±0.01 rounding gaps.

### Clearing

* The hosted-page flow is **asynchronous**: `ProcessApiRequestV2` returns `ClearingRedirectUrl`; the actual charge result arrives at your `CallBackUrl`.
* Token charges (`ChargeWithToken`) and refunds are **synchronous** — result in the response.
* Set `IsQaMode: true` when testing on QA.
* Keep the `PaymentId` from successful charges — you need it for [refunds](../clearing/process-api-request-v2.md#refunds).

### Environments

* QA and Production are **separate accounts and data** — a QA token doesn't work on Production.
* PDF links point to `newviewqa.invoice4u.co.il` on QA and `newview.invoice4u.co.il` on Production.

This page is also available [in Hebrew](key-tips-hebrew.md).
