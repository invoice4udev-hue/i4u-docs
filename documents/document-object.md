# The Document Object

Full field reference for the `Document` object and its child objects. Fields marked **Yes** are required for document creation; conditional requirements depend on the [document type](document-types.md).

## Document

### Core fields (request)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `DocumentType` | int | **Yes** | See [Document Types](document-types.md). |
| `Subject` | string | Recommended | Document subject/headline. |
| `ClientID` | int | Conditional | Existing customer ID. Required unless `GeneralCustomer` is supplied (allowed for InvoiceReceipt, InvoiceCredit, InvoiceQuote) or the type doesn't need a customer (Deposits, SupplierInvoiceToInventory, PurchaseOrder, self-invoice). |
| `GeneralCustomer` | GenerelCustomer | Conditional | One-off customer: `{ "Name": "...", "Identifier": "..." }`. Rejected for types that require a real customer (`TypeOfDocumentDoesntAllowGeneralCustomer`, 38). |
| `Items` | DocumentItem[] | Conditional | Line items. Required for item-based types. |
| `Payments` | Payment[] | Conditional | Payments. Required for Receipt / InvoiceReceipt / Deposits. |
| `Invoices` | Document[] | Conditional | Referenced documents (each with `ID` and `ReceiptAmount`). See [reference rules](document-types.md#referenced-document-rules-documentrefftype). |
| `DocumentReffType` | int | Conditional | Type of the referenced documents; required when `Invoices` is used. |
| `IssueDate` | datetime | No | Defaults to today. Must not be in the future (except InvoiceShip: up to +3 days) and not earlier than your latest document of that type — otherwise `InvalidDateRange` (3). |
| `Currency` | string | No | ISO symbol, e.g. `"ILS"`, `"USD"`, `"EUR"`. Defaults to the organization currency. Must exist in the currency list (`CurrencyDoesntExists`, 36). |
| `ConversionRate` | double | No | Rate vs. the organization currency. Auto-resolved from the daily rates when `0`. |
| `TaxPercentage` | double | No | Defaults to the account tax rate. Forced to the legal VAT rate for current-date documents unless `ForceTaxRate` applies; `0` for tax-exempt businesses. |
| `TaxIncluded` | boolean | No | Whether item prices include VAT. |
| `Discount` | Discount | No | Document-level discount. |
| `BranchID` | int | No | Branch attribution; defaults to the organization's default branch. Invalid ID → `BranchIDDoesntExists` (63). |
| `Language` | int | No | `1` Hebrew, `2` English. Defaults to the account language. |
| `AssociatedEmails` | AssociatedEmail[] | No | Emails to send the document to on creation. |
| `SmsMessages` | Sms[] | No | SMS messages to send with a link to the document. |
| `ExternalComments` | string | No | Comments printed on the document. Max 5,000 chars (`ExternalCommentsExceededLimit`, 151). |
| `InternalComments` | string | No | Internal comments. `PrintInternalComments` (bool, default `true`) controls printing. |
| `EmailCustomComment` | string | No | Custom comment in the delivery email. |
| `ApiIdentifier` | string | No | Your idempotency key. Auto-generated if missing. |
| `ApiDuplicityTimeValidation` | int | No | Duplicate-window seconds (default `60`). |
| `PaymentDueDate` | datetime | No | Auto-computed from the customer's `PayTerms` when omitted (invoice-like types). |
| `Deduction` | double | No | Withholding-tax deduction (receipts). |
| `CloseReceipt` | boolean | No | Allow a receipt whose payments don't fully match referenced amounts. |
| `BankAccount` | BankAccount | Deposits only | Target bank account: must exist for the organization. |
| `IsSelfInvoice` | boolean | No | Self-invoice flag (Invoice type). |
| `SupplierId` / `SupplierName` | int / string | PurchaseOrder | Supplier reference — one of them required (`InvalidSupplier`, 218). |
| `UseDecimalValues` | boolean | No | Use decimal-precision total calculation. |
| `AutoFixPaymentsMismatchItems` | boolean | No | When a ±0.01 rounding gap exists between payments and items, add an adjustment item automatically instead of failing. `AutoFixMismatchItemName` sets its name. |
| `RoundAmount` / `ToRoundAmount` | double / bool | No | Total rounding. |
| `Attachments` | array | SupplierInvoiceToInventory | File attachments stored with the document. |

### Response-only fields

| Field | Type | Description |
| ----- | ---- | ----------- |
| `ID` | GUID | Document ID. |
| `DocumentNumber` | long | The legal sequential number. |
| `UniqueID` | GUID | Unique document GUID. |
| `StatusID` / `Status` | int / string | See [statuses](document-types.md#document-statuses-statusid). |
| `Total`, `TotalWithoutTax`, `TotalTaxAmount`, `TotalTaxExempt` | double | Calculated totals. |
| `CipherText` / `CipherTextOriginal` | string | Ciphers for view/print URLs. |
| `PrintOriginalPDFLink` | string | Direct PDF link — original. |
| `PrintCertifiedCopyPDFLink` | string | Direct PDF link — certified copy. |
| `AllocationNumber` | string | Israel Tax Authority allocation number, when applicable. |
| `Paid`, `CreditAmount`, `Balance` | double | Payment/credit state. |

## DocumentItem

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Name` | string | **Yes** | Item name (`DocumentItemMissingName`, 39). |
| `Quantity` | double | **Yes** | Must not be `0` when `Price` ≠ 0 (`DocumentItemQuantityCannotBeZero`, 40). |
| `Price` | double | **Yes** | Unit price. A single zero-priced item is rejected (`DocumentItemPriceCannotBeZero`, 41), except delivery notes/inventory. |
| `Description` | string | No | Item description. |
| `Code` | string | No | Catalog code. |
| `TaxPercentage` | double | No | Per-item VAT override. |
| `Discount` | Discount | No | Per-item discount. |
| `PriceIncludeTax` | double | No | Price including VAT (when `TaxIncluded`). |
| `InventoryId` / `WarehouseId` | int | Inventory flows | Inventory item / warehouse references. |
| `LawyerIdentifier` | string | Lawyer accounts | `"1"` deposits, `"2"` expenses. |

## Payment

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `PaymentType` | int | **Yes** | `1` CreditCard, `2` Check, `3` MoneyTransfer, `4` Cash, `5` Credit, `6` WithholdingTax, `7` Other, `8` Bit, `9` PayBox. Invalid → `PaymentTypeOutOfRange` (51). |
| `Amount` | double | **Yes** | Must not be `0` (`PaymentAmountCannotBeZero`, 47). |
| `Date` or `DateStr` | datetime / string | **Yes** | Payment date (`PaymentDateMissing`, 46). |
| `NumberOfPayments` | int | No | Credit-card installments (or `NumberOfPaymentsStr`). |
| `CreditCardName` | string | No | Card brand name; resolved against your configured credit companies. |
| `CreditCardType` | int | No | Card company ID (see `GetCompanies`). |
| `PaymentNumber` | string | No | Check number / last 4 card digits. |
| `BankName`, `BranchName`, `AccountNumber` | string | Checks/transfers | Bank details. |
| `PayerID` | string | No | Payer's ID number. |
| `ExpirationDate` | string | No | Card expiry. |
| `PaymentTypeOtherId` / `PaymentTypeLiteral` | int / string | `PaymentType=7` | Sub-type for "Other" (e.g. Bit, Paypal) / display literal. |
| `ID` | int | Deposits | Existing payment ID being deposited. |

## Discount

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Value` | double | **Yes** | Discount value. |
| `IsNominal` | boolean | No | `true` = fixed amount, `false` = percent. |
| `BeforeTax` | boolean | No | Apply before VAT. |

## AssociatedEmail

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Mail` | string | **Yes** | Email address. |
| `IsUserMail` | boolean | No | `true` marks the copy sent to the account owner. |

## GenerelCustomer

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `Name` | string | **Yes** | One-off customer name. |
| `Identifier` | string | No | VAT/ID number. |
