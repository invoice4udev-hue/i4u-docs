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
| `DocumentType` | int | No | Filter by a single [document type](document-types.md). |
| `From` / `To` | datetime | No | Issue-date range. |
| `FromActualCreationDate` / `ToActualCreationDate` | datetime | No | Actual creation-date range. |
| `FromPaymentDueDate` / `ToPaymentDueDate` | datetime | No | Payment due-date range. |
| `Status` | int | No | [Document status](document-types.md#document-statuses-statusid). |
| `CustomerID` | int | No | Filter by customer. |
| `CustomerName` | string | No | Filter by customer name (must exist — otherwise `ClientDoesntExists`, 7). |
| `BranchID` | int | No | Filter by branch. |
| `DocumentNumber` / `ExectDocumentNumber` | int | No | Number range prefix / exact number. |
| `FromNumber` / `ToNumber` | int | No | Document-number range. |
| `FromAmount` / `ToAmount` | float | No | Total amount range. |
| `Currency` | string | No | Currency filter. |
| `PaymentType` | int | No | Filter receipts by payment type. |
| `ItemCode` / `ItemDescription` | string | No | Filter by item fields. |
| `ItemsIncluded` | boolean | No | Include full `Items` in results. |
| `PaymentsIncluded` | boolean | No | Include full `Payments` in results. |
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
    "From": "2026-06-01T00:00:00",
    "To": "2026-06-30T23:59:59",
    "CustomerID": 88231,
    "ItemsIncluded": true
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "GetDocumentsResult": {
    "Response": [
      { "ID": "7f6a2c1e-...", "DocumentNumber": 20260123, "Total": 117.0 },
      { "ID": "8a7b3d2f-...", "DocumentNumber": 20260124, "Total": 234.0 }
    ],
    "Errors": []
  }
}
```

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ClientDoesntExists` (7) | `CustomerName` filter didn't match a customer. |

{% hint style="info" %}
This endpoint can only retrieve **one document type per call** — `DocumentType` accepts a single value, not a list. To search across several types, issue one call per type and merge the results client-side.
{% endhint %}

{% hint style="info" %}
Fetching one known document? Use the [single-document lookups](get-document.md) instead — faster and simpler.
{% endhint %}

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetDocuments" method="post" %}
{% endopenapi-operation %}

