# Search Documents

Filtered document search across the authenticated organization.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocuments` |
| **Response** | `CommonCollection<Document[]>` — `{ "Response": [ ... ], "Errors": [] }` |

## Request schema — `dr` (DocumentsRequest)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `DocumentType` | int | **Yes** | Filter by a single [document type](document-types.md) — required; one call searches one type. |
| `From` / `To` | datetime | No | Issue-date range. |
| `FromActualCreationDate` / `ToActualCreationDate` | datetime | No | Actual creation-date range. |
| `FromPaymentDueDate` / `ToPaymentDueDate` | datetime | No | Payment due-date range. **Ignored by `GetDocuments`** — accepted by the shared `DocumentsRequest` schema but not forwarded to the search. |
| `Status` | int | No | [Document status](document-types.md#document-statuses-statusid). |
| `CustomerID` | int | No | Filter by customer. |
| `CustomerName` | string | No | Only verifies that a customer with this name exists (`ClientDoesntExists`, 7 otherwise) — it does **not** filter the results for new-system documents. Use `CustomerID` to actually filter by customer. |
| `BranchID` | int | No | Filter by branch. |
| `DocumentNumber` / `ExectDocumentNumber` | int | No | Number range prefix / exact number. |
| `FromNumber` / `ToNumber` | int | No | **Ignored by `GetDocuments`** — use `DocumentNumber` / `ExectDocumentNumber` instead. |
| `FromAmount` / `ToAmount` | float | No | Total amount range. |
| `Currency` | string | No | Currency filter. |
| `PaymentType` | int | No | Filter receipts by payment type. |
| `ItemCode` | string | No | Filter by item catalog code. |
| `ItemDescription` | string | No | Accepted by the shared schema, but **ignored by `GetDocuments`**. |
| `ItemsIncluded` | boolean | No | **Ignored by `GetDocuments`** — has no effect on whether `Items` come back in the results. |
| `PaymentsIncluded` | boolean | No | **Ignored by `GetDocuments`** — has no effect on whether `Payments` come back in the results. |
| `OnlyGeneralClient` / `GeneralClientName` | bool / string | No | General-customer filters. |
| `Limit` | int | No | Max rows. |

## Example request

```http
POST /Services/ApiService.svc/GetDocuments HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "dr": {
    "DocumentType": 3,
    "From": "/Date(1780261200000+0300)/",
    "To": "/Date(1782853199000+0300)/",
    "CustomerID": 88231
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "d": {
    "Response": [
      {
        "ID": "7f6a2c1e-...",
        "DocumentNumber": 20260123,
        "Total": 117.0,
        "CipherText": "zKlvEbG4Na3F9XzyXFa%2frM%2bVhJwl4Pwx...",
        "CipherTextOriginal": "TBReFaFsHr1U%2fieSEr89F0G1N3P78jMtL...",
        "PrintOriginalPDFLink": null,
        "PrintCertifiedCopyPDFLink": null
      },
      { "ID": "8a7b3d2f-...", "DocumentNumber": 20260124, "Total": 234.0 }
    ],
    "Errors": []
  }
}
```

{% hint style="info" %}
`Print*PDFLink` is set only by [document creation](create-document.md) — search results always carry `null` there. Build the PDF URL yourself from `CipherText` / `CipherTextOriginal`; see [Viewing the document (PDF links)](overview.md#viewing-the-document-pdf-links).
{% endhint %}

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ClientDoesntExists` (7) | No customer exists with the `CustomerName` you sent. |

{% hint style="info" %}
This endpoint can only retrieve **one document type per call** — `DocumentType` accepts a single value, not a list. To search across several types, issue one call per type and merge the results client-side.
{% endhint %}

{% hint style="info" %}
Fetching one known document? Use the [single-document lookups](get-document.md) instead — faster and simpler.
{% endhint %}

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetDocuments" method="post" %}
{% endopenapi-operation %}
