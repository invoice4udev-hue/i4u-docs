# Credit Invoices (Full & Partial Credits)

A **credit invoice** (`DocumentType: 4`) reverses all or part of a previously issued invoice or invoice-receipt. It is created with the regular [Create a Document](create-document.md) endpoint — what makes it special is the `Invoices` reference array and the validation rules around it.

{% hint style="info" %}
**Partial credits are the most common support issue.** The key rule: each referenced document can only be credited up to its **remaining creditable balance** — `Total − CreditAmount` (what hasn't been credited yet). Read the [validation rules](#validation-rules) before integrating.
{% endhint %}

## The three ways to issue a credit

| Mode | How | When to use |
| ---- | --- | ----------- |
| **Full credit** | Reference the original document with `ReceiptAmount` equal to its full remaining balance. | Cancel an invoice entirely. Original becomes `FullyCredited` (StatusID 3). |
| **Partial credit** | Reference the original with `ReceiptAmount` **less than** the remaining balance. | Refund one item, correct an overcharge. Original becomes `PartiallyCredited` (StatusID 4); you can credit the remainder later. |
| **Standalone credit** | No `Invoices` array — just `Items` (and/or `Payments`). | Credit for something not tied to a specific system document (e.g. imported/legacy invoices). |

A credit invoice with **no** references, no items, and no payments is rejected with `InvoiceCreditMustHaveRefDocuments` (57).

## Request structure (referenced credit)

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 4,
    "DocumentReffType": 1,
    "ClientID": 88231,
    "Subject": "Credit for invoice 20260123",
    "TaxIncluded": true,
    "Invoices": [
      { "ID": "7f6a2c1e-1111-2222-3333-444455556666", "ReceiptAmount": 50.0 }
    ],
    "Items": [
      { "Name": "Refund - Pro plan June", "Quantity": 1, "Price": 50.0 }
    ]
  },
  "token": "<token>"
}
```

Field notes:

| Field | Rule |
| ----- | ---- |
| `DocumentType` | `4` (InvoiceCredit). |
| `DocumentReffType` | Type of the documents being credited: `1` (Invoice) or `3` (InvoiceReceipt) **only**. Anything else → `DocumentReffTypeNotInRange`. |
| `Invoices[].ID` | GUID of the document to credit (`ID` field of the original, not `DocumentNumber`). Must belong to your organization. |
| `Invoices[].ReceiptAmount` | The amount to credit against **that** document. Positive numbers — do **not** negate. |
| `Items` | Item lines describing what is credited, with **positive** prices. The server handles the accounting sign. |
| `ClientID` | Must match the customer on the referenced documents. |

You can credit **multiple documents in one credit invoice** — add one entry per document to `Invoices`, each with its own `ReceiptAmount`.

## Validation rules

Checked per row of `Invoices` (error `Paramters` contains `"Row Number - N"`):

1. **Existence & ownership** — the GUID must resolve to a document in your organization → `DocumentIDDoesntExists`.
2. **Customer match** — the referenced document's `ClientID` must equal the credit's `ClientID` → `ReceiptClientNameDoesntMatchInvoiceClientName`.
3. **Type match** — the referenced document's type must equal `DocumentReffType` → `ReceiptDocumentReffTypeDoesntMatchInvoiceDocumentType`.
4. **Status** — a document that is already `FullyCredited` (StatusID 3) cannot be credited again → `DocumentStatusInValid`.
5. **Amount ceiling** — the partial-credit rule:

$$0 < \text{ReceiptAmount} \le \text{Total} - \text{CreditAmount}$$

`CreditAmount` is the sum of all credits already applied to that document. Exceeding the remaining balance (or sending `0`/negative) → `DocumentReceiptAmountOutOfRange`.

## What happens after a successful credit

* The referenced document's `CreditAmount` increases by your `ReceiptAmount`.
* Its `StatusID` becomes `4` (PartiallyCredited) or `3` (FullyCredited) when the running credit reaches `Total`.
* The credit invoice itself gets its own legal `DocumentNumber` in the credit-invoice sequence.
* Fetch the original with [Get a Single Document](get-document.md) to read the updated `CreditAmount`, `Balance` and `StatusID` before issuing further credits.

## Common pitfalls

| Symptom | Cause | Fix |
| ------- | ----- | --- |
| `DocumentReceiptAmountOutOfRange` on a "valid" amount | Earlier partial credits already consumed part of the balance. | Fetch the original first; credit at most `Total − CreditAmount`. |
| `DocumentReceiptAmountOutOfRange` with negative amounts | Sending negative `ReceiptAmount`/prices to "subtract". | Send positive values — the document type carries the sign. |
| `DocumentStatusInValid` | Original is already fully credited. | Nothing left to credit; check `StatusID` before the call. |
| `DocumentReffTypeNotInRange` | Trying to credit a receipt, quote or order. | Only Invoice (1) and InvoiceReceipt (3) can be credited. Cancel receipts with a cancelling receipt instead. |
| Sum mismatches on multi-row credits | Rounding across rows. | Round each `ReceiptAmount` to 2 decimals; keep items total equal to the sum of `ReceiptAmount`s. |

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `InvoiceCreditMustHaveRefDocuments` (57) | No references, items or payments supplied. |
| `DocumentReffTypeNotInRange` (53) | `DocumentReffType` is not Invoice/InvoiceReceipt. |
| `DocumentIDDoesntExists` | Referenced GUID not found in your organization. |
| `ReceiptClientNameDoesntMatchInvoiceClientName` | Customer mismatch between credit and referenced document. |
| `ReceiptDocumentReffTypeDoesntMatchInvoiceDocumentType` | Referenced document's type ≠ `DocumentReffType`. |
| `DocumentStatusInValid` (49) | Referenced document already fully credited. |
| `DocumentReceiptAmountOutOfRange` (50) | `ReceiptAmount` ≤ 0 or exceeds the remaining creditable balance. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/CreateDocument" method="post" %}
{% endopenapi-operation %}
