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

### Only check that it exists — `IsDocumentExistsByApiIdentifier`

| | |
| - | - |
| **Method** | `GET` |
| **Path** | `/IsDocumentExistsByApiIdentifier` |
| **Response** | `bool` |

```http
GET /Services/ApiService.svc/IsDocumentExistsByApiIdentifier?apiIdentifier=my-first-doc-001&token=<token> HTTP/1.1
Host: apiqa.invoice4u.co.il
```

```json
{ "d": true }
```

A lighter existence check when you don't need the full document — same `apiIdentifier` as above, but sent as query-string parameters instead of a JSON body. Returns `false` both when no document with that identifier exists **and** when the token is invalid or expired — verify the token first with [`IsAuthenticated`](../authentication/is-authenticated.md) if you need to tell the two apart.

## Example response

All three return the full [Document object](document-object.md):

```json
{
  "d": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260123,
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "Total": 117.0,
    "StatusID": 2,
    "CipherText": "zKlvEbG4Na3F9XzyXFa%2frM%2bVhJwl4Pwx...",
    "CipherTextOriginal": "TBReFaFsHr1U%2fieSEr89F0G1N3P78jMtL...",
    "PrintOriginalPDFLink": "https://newview.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newview.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

{% hint style="info" %}
Same `PrintOriginalPDFLink` / `PrintCertifiedCopyPDFLink` fields as [document creation](create-document.md) — QA points to `newviewqa.invoice4u.co.il`, production to `newview.invoice4u.co.il`. `CipherText` / `CipherTextOriginal` (also on the object) are the Base64-encoded cipher tokens behind those links, not the rendered PDF itself — there's no field with the raw file bytes. Both `Print*PDFLink` fields can come back `null` on a lookup; if so, build the URL from `CipherText`/`CipherTextOriginal` yourself.
{% endhint %}

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ApiDocumentDoesNotExistForUser` (321) | Document belongs to another organization. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetDocument" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByApiIdentifier" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/IsDocumentExistsByApiIdentifier" method="get" %}
{% endopenapi-operation %}

