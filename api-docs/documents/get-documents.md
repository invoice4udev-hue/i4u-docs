# Retrieve Documents

Lookup and search endpoints for documents, plus Israel Tax allocation-number operations. All are scoped to the authenticated organization.

## Get by ID — `GetDocument`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocument` |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

`docId` is the document GUID. Returns the `Document`, or `ApiDocumentDoesNotExistForUser` (321) if it belongs to another organization; `null` on a malformed GUID.

## Get by number — `GetDocumentByNumber`

```json
{ "docNumber": 20260123, "documentType": 3, "token": "<token>" }
```

`POST /GetDocumentByNumber` (GET variant: `/GetDocumentByNumberREST`). Document numbers are sequential **per type**, so the type is required.

## Get by API identifier — `GetDocumentByApiIdentifier`

```json
{ "apiIdentifier": "order-10045-invoice", "docType": 1, "token": "<token>" }
```

`POST /GetDocumentByApiIdentifier` (GET variant: `/GetDocumentByApiIdentifierREST`). Fetch a document by your idempotency key — the recommended recovery path after a timed-out create.

Existence check only: `IsDocumentExistsByApiIdentifier` → `{ "apiIdentifier": "...", "token": "..." }` → boolean.

## Search — `GetDocuments`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocuments` |
| **Response** | `CommonCollection<Document[]>` — `{ "Response": [ ... ], "Errors": [] }` |

### Request schema — `dr` (DocumentsRequest)

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `DocumentType` | int | No | Filter by a single [document type](document-types.md). |
| `DocumentTypes` | string | No | Comma-separated list of types. |
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

### Example

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

## Allocation numbers (Israel Tax Authority)

### Fetch — `FetchAllocationNumber`

```json
{ "docId": "7f6a2c1e-...", "token": "<token>" }
```

`POST /FetchAllocationNumber` — requests an allocation number from the ITA for a document that doesn't have one yet. Returns the updated `Document` (`AllocationNumber`, `AllocationMessage`).

### Set manually — `UpdateAllocationNumber`

```json
{ "docId": "7f6a2c1e-...", "allocationNumber": "123456789", "token": "<token>" }
```

`POST /UpdateAllocationNumber` — stores an allocation number obtained elsewhere. Must be at least 9 characters — otherwise `AllocationNumberInvalid` (162).

## Errors (all endpoints)

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ApiDocumentDoesNotExistForUser` (321) | Document belongs to another organization. |
| `ClientDoesntExists` (7) | `CustomerName` filter didn't match a customer. |
| `AllocationNumberInvalid` (162) | Allocation number too short. |
