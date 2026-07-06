# Get a Single Document

Three lookups for fetching one document. All are scoped to the authenticated organization.

## Get by ID — `GetDocument`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocument` |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

`docId` is the document GUID (the `ID` returned on creation). Returns the `Document`, or `ApiDocumentDoesNotExistForUser` (321) if it belongs to another organization; `null` on a malformed GUID.

## Get by number — `GetDocumentByNumber`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocumentByNumber` |

```json
{ "docNumber": 20260123, "documentType": 3, "token": "<token>" }
```

Document numbers are sequential **per type**, so the type is required. GET variant: `/GetDocumentByNumberREST`.

## Get by API identifier — `GetDocumentByApiIdentifier`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetDocumentByApiIdentifier` |

```json
{ "apiIdentifier": "order-10045-invoice", "docType": 1, "token": "<token>" }
```

Fetch a document by your idempotency key — the recommended recovery path after a timed-out create. GET variant: `/GetDocumentByApiIdentifierREST`.

Existence check only: `IsDocumentExistsByApiIdentifier` → `{ "apiIdentifier": "...", "token": "..." }` → boolean.

## Example response

All three return the full [Document object](document-object.md):

```json
{
  "GetDocumentResult": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260123,
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "Total": 117.0,
    "StatusID": 2,
    "Errors": []
  }
}
```

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ApiDocumentDoesNotExistForUser` (321) | Document belongs to another organization. |
