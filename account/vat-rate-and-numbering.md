# VAT Rate & Document Numbering

Two read-only account settings: the VAT rate to apply on documents, and the organization's document numbering — the next starting number per document type, which types already have documents, the accounting ledger numbers used for bookkeeping exports, and the organization's bank details.

## Get the VAT rate — `GetTaxRate`

Returns the VAT rate to use for a given date, or the organization's current configured rate.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetTaxRate` |
| **Response** | `Tax` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token. |
| `date` | string | No | Date to price the VAT rate for, `yyyy-MM-dd`. Parsed with `DateTime.TryParse`. Omit it to get the organization's current configured rate regardless of today's date. |

### Example request

```http
POST /Services/ApiService.svc/GetTaxRate HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>",
  "date": "2024-12-31"
}
```

### Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "TaxRate": 17
  }
}
```

### Notes

* Before `2025-01-01` the rate is fixed at `17`; on or after that date it returns the organization's currently configured rate (`18` at the time of writing), read from the `TaxRate` app setting.
* The `2025-01-01` cutoff and the `17` pre-2025 rate are hard-coded in `IsraelTaxService.GetTaxRate`; they do not read the `TaxRate2025Date` / `TaxRateTill2024` app settings that also exist on this server.
* `token` is declared as the first parameter in the method signature, but as with every endpoint on this API, field order in the JSON body doesn't matter.

### Errors

| Case | Response |
| ---- | -------- |
| Invalid token | `TaxRate: -1`, `Errors` contains `UnauthorizedUser` (80). |
| Expired account (more than 4 days past expiry) | Same as an invalid token — `TaxRate: -1` with only `UnauthorizedUser` (80); the `ExpiredAccount` (66) error that [`IsAuthenticated`](../authentication/is-authenticated.md) added internally is not carried over to the response. |
| `date` is provided but is not a parseable date | An uncaught `ArgumentException` — the request fails with an unhandled server error (HTTP 500), not a normal `{ "d": ... }` response. |

---

## Get document numbering — `DocumentsNumberingGet`

Returns the organization's document numbering configuration: starting numbers, which document types already have documents, accounting ledger numbers, and bank details.

### Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/DocumentsNumberingGet` |
| **Response** | `NumberingDefinition` |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `token` | string | Yes | Authentication token. |

### Example request

```http
POST /Services/ApiService.svc/DocumentsNumberingGet HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

### Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "Invoice": 1042,
    "Receipt": 875,
    "InvoiceReceipt": 613,
    "InvoiceCredit": 12,
    "ProformaInvoice": 58,
    "InvoiceOrder": 34,
    "InvoiceQuote": 210,
    "InvoiceShip": 97,
    "PurchaseOrder": 15,
    "InvoiceCreated": true,
    "ReceiptCreated": true,
    "InvoiceReceiptCreated": true,
    "InvoiceCreditCreated": false,
    "ProformaInvoiceCreated": true,
    "InvoiceOrderCreated": false,
    "InvoiceQuoteCreated": true,
    "InvoiceShipCreated": false,
    "PurchaseOrderCreated": false,
    "Register": 1000,
    "RegisterCreditCard": 1001,
    "RegisterCash": 1002,
    "RegisterCheck": 1003,
    "RegisterBankTransfer": 1004,
    "RegisterBankTransferUSD": 1005,
    "RegisterBankTransferEUR": 1006,
    "RegisterBankTransferGBP": 1007,
    "RegisterBankTransferJPY": 1008,
    "RegisterOther": 1009,
    "RegisterPaypal": 1010,
    "RegisterBit": 1011,
    "RegisterPeper": 1012,
    "RegisterCredit": 1013,
    "TaxCredit": 1014,
    "Income": 1015,
    "ExemptIncome": 1016,
    "Deal": 1017,
    "GeneralCustomer": 1018,
    "RegisterPurchase": 1019,
    "RegisterVATInputs": 1020,
    "LawyerExpenses": 1021,
    "LawyerDeposit": 1022,
    "BankDetails": {
      "ClientId": 0,
      "AccountNumber": "123456",
      "BranchName": "612",
      "BankName": "Bank Hapoalim",
      "AccountOwner": "Acme Ltd",
      "BIC": "POALILIT"
    },
    "EnglishBankDetails": {
      "BankNameEnglish": "Bank Hapoalim",
      "BranchNameEnglish": "612",
      "AccountNumberEnglish": "123456",
      "IBAN": "IL620108000000099999999",
      "SWIFT": "POALILIT",
      "ABA": "",
      "Beneficiary": "Acme Ltd",
      "IBANEn": "",
      "SWIFTEn": "",
      "ABAEn": "",
      "BeneficiaryEn": "Acme Ltd"
    },
    "IsBankDetails": true,
    "IsEnglishBankDetails": true
  }
}
```

### Notes

**Starting numbers per document type** — the next number that will be assigned to a new document of that type. See [Document Types](../documents/document-types.md) for the full `DocumentType` list.

| Field | DocumentType |
| ----- | ------------ |
| `Invoice` | `1` |
| `Receipt` | `2` |
| `InvoiceReceipt` | `3` |
| `InvoiceCredit` | `4` |
| `ProformaInvoice` | `5` |
| `InvoiceOrder` | `6` |
| `InvoiceQuote` | `7` |
| `InvoiceShip` | `8` |
| `PurchaseOrder` | `13` |

**`*Created` flags** — `true` once at least one document of that type has been created. While a type's flag is still `false`, its starting number above can still be changed (via `UpdateDocumentNumbering`, not covered on this page); once `true` the starting number is fixed.

`InvoiceCreated`, `ReceiptCreated`, `InvoiceReceiptCreated`, `InvoiceCreditCreated`, `ProformaInvoiceCreated`, `InvoiceOrderCreated`, `InvoiceQuoteCreated`, `InvoiceShipCreated`, `PurchaseOrderCreated`.

**Accounting ledger numbers** — the organization's bookkeeping account/ledger numbers, one per payment method or income type, used when exporting documents to an external accounting system.

`Register`, `RegisterCreditCard`, `RegisterCash`, `RegisterCheck`, `RegisterBankTransfer`, `RegisterBankTransferUSD`, `RegisterBankTransferEUR`, `RegisterBankTransferGBP`, `RegisterBankTransferJPY`, `RegisterOther`, `RegisterPaypal`, `RegisterBit`, `RegisterPeper`, `RegisterCredit`, `TaxCredit`, `Income`, `ExemptIncome`, `Deal`, `GeneralCustomer`, `RegisterPurchase`, `RegisterVATInputs`. `LawyerExpenses` / `LawyerDeposit` are declared as nullable (`long?`) on the model, but the mapper turns a DB `NULL` into `0` — this endpoint never actually returns `null` for these two fields. They are only meaningful for law-firm-mode organizations.

**Bank details** — `BankDetails` (Hebrew) and `EnglishBankDetails` (English) carry the same bank account, printed on documents that show payment instructions. `IsBankDetails` / `IsEnglishBankDetails` report whether the organization has filled in each side. `ClientId` inside `BankDetails` is always `0` in this response.

Members **not** populated by this endpoint — always returned as their CLR default (`0`, `false`, or `null`) regardless of the organization's actual data: `ID`, `Deposit`, `OrganizationID`, the `*Current` group (`InvoiceCurrent`, `ReceiptCurrent`, `InvoiceReceiptCurrent`, `InvoiceCreditCurrent`, `ProformaInvoiceCurrent`, `InvoiceOrderCurrent`, `InvoiceQuoteCurrent`, `InvoiceShipCurrent`), the `*DocMin` group (`ReceiptDocMin`, `InvoiceReceiptDocMin`, `InvoiceCreditDocMin`, `ProformaInvoiceDocMin`, `InvoiceOrderDocMin`, `InvoiceQuoteDocMin`, `InvoiceShipDocMin`), and `IsAdvancedSearchDocumentReferences`.

### Errors

| Case | Response |
| ---- | -------- |
| Invalid token | A `NumberingDefinition` object with only `Errors: [{ "ID": 80, "Error": "UnauthorizedUser" }]` populated — every other field is its CLR default (`0` / `false` / `null`). |
| Expired account (more than 4 days past expiry) | Identical response to an invalid token — only `UnauthorizedUser` (80); the `ExpiredAccount` (66) error that [`IsAuthenticated`](../authentication/is-authenticated.md) added internally is not carried over. |
| Unexpected server/database error | The response is `{ "d": null }`. The error is logged server-side only, not returned to the caller. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetTaxRate" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/DocumentsNumberingGet" method="post" %}
{% endopenapi-operation %}
