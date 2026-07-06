# Quick Start

Create your first document in five steps. Work against the **QA environment** (`https://apiqa.invoice4u.co.il/Services/ApiService.svc`) until your flow is stable.

### 1. Get your API key

Copy your organization API key (GUID) from the Invoice4U web application (Settings). You'll pass it as `token` in every call — there is no separate login step. Optionally verify it:

```http
POST /Services/ApiService.svc/IsAuthenticated HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{ "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f" }
```

See [Authentication Overview](../authentication/overview.md).

### 2. Create a customer

```http
POST /Services/ApiService.svc/CreateCustomer HTTP/1.1

{
  "cu": { "Name": "Acme Ltd", "Email": "billing@acme.example" },
  "token": "<token>"
}
```

Save the returned `ID`. See [Create a Customer](../customers/create-customer.md).

### 3. Create a document

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1

{
  "doc": {
    "DocumentType": 3,
    "Subject": "First invoice-receipt",
    "ClientID": 88231,
    "TaxIncluded": true,
    "ApiIdentifier": "my-first-doc-001",
    "Items": [ { "Name": "Test item", "Quantity": 1, "Price": 117.0 } ],
    "Payments": [ { "PaymentType": 4, "Amount": 117.0, "Date": "2026-07-06T00:00:00" } ]
  },
  "token": "<token>"
}
```

See [Create a Document](../documents/create-document.md).

### 4. Check the response

* `Errors` empty → success. Use `DocumentNumber`, `ID`, and the `PrintOriginalPDFLink` / `PrintCertifiedCopyPDFLink` fields.
* `Errors` non-empty → fix and retry with a **new** `ApiIdentifier` (or use [Create with Identifier Validation](../documents/create-document-with-validation.md) and keep the same one).

### 5. Verify by fetching

```http
POST /Services/ApiService.svc/GetDocumentByApiIdentifier HTTP/1.1

{ "apiIdentifier": "my-first-doc-001", "docType": 3, "token": "<token>" }
```

See [Get a Single Document](../documents/get-document.md).

### Next

* Charging cards? Read the [Clearing Endpoints Overview](../clearing/overview.md).
* Before going live, read [Key Tips & Differences](key-tips.md).
* Prefer Postman? Download the ready-made [Invoice4U Postman collection](https://drive.google.com/uc?export=download&id=1qiCp0kNrWvgOGEzrqoCTrnAfoFLdCORp) — or download the [OpenAPI spec](https://drive.google.com/uc?export=download&id=1lkmSOUi5S1smYy61EVoXObqpV96fBu2F) and import it directly into Postman.
