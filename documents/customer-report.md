# Customer Report

Returns every document for a single customer within a date range — a lighter, purpose-built alternative to [Search Documents](search-documents.md) for the common "show me this customer's history" use case.

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetCustomerReport` |
| **Response** | `CommonCollection<Document[]>` — `{ "Response": [ ... ], "Errors": [] }` |

## Request schema — `dr` (DocumentsRequest)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `CustomerID` | int | Yes (in practice) | Customer to report on. |
| `From` / `To` | datetime | No | Issue-date range. |
| `Status` | int | No | [Document status](document-types.md#document-statuses-statusid). Applied only when different from `0`. |
| `DocumentType` | int | No | Filter by a single [document type](document-types.md). Applied only when greater than `0`. |

## Example request

```http
POST /Services/ApiService.svc/GetCustomerReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "dr": {
    "From": "/Date(1767218400000+0200)/",
    "To": "/Date(1782853199000+0300)/",
    "CustomerID": 88231,
    "Status": 0
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "Response": [
      {
        "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
        "DocumentNumber": 20260123,
        "DocumentType": 3,
        "Total": 117.0,
        "CipherText": "zKlvEbG4Na3F9XzyXFa%2frM%2bVhJwl4Pwx...",
        "CipherTextOriginal": "TBReFaFsHr1U%2fieSEr89F0G1N3P78jMtL...",
        "PrintOriginalPDFLink": null,
        "PrintCertifiedCopyPDFLink": null
      }
    ]
  }
}
```

{% hint style="info" %}
`Print*PDFLink` is set only by [document creation](create-document.md) — this report always carries `null` there. Build the PDF URL yourself from `CipherText` / `CipherTextOriginal`; see [Viewing the document (PDF links)](overview.md#viewing-the-document-pdf-links).
{% endhint %}

## Notes

* Only `From`, `To`, `CustomerID`, `Status` and `DocumentType` are read from `dr` — every other `DocumentsRequest` field accepted by [Search Documents](search-documents.md) (`ItemsIncluded`, `CustomerName`, `BranchID`, and the rest) is ignored here.
* `Status` is applied only when it differs from `0`; `DocumentType` is applied only when it is greater than `0` — leave them unset (or `0`) to return every status/type for the customer.
* Documents come back in the same shape as [Search Documents](search-documents.md) — the full [Document object](document-object.md).

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Expired account. |

{% hint style="info" %}
An invalid (undecodable) token doesn't add an entry to `Errors` here — the response comes back with neither `Response` nor `Errors` populated. Treat an empty envelope the same as a failure, and verify the token first with [`IsAuthenticated`](../authentication/is-authenticated.md) if you need to tell the two cases apart.
{% endhint %}

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetCustomerReport" method="post" %}
{% endopenapi-operation %}
