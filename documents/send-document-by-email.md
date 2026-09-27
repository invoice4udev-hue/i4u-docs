# Email a Document

Sends an existing document by email — the same delivery used automatically when `AssociatedEmails` is set on document creation, but callable at any later time (for example, when a customer asks for the invoice to be resent).

## Endpoint

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/SendDocumentByMail` |
| **Response** | `CommonObject` — no data payload, only `Errors` / `Info` |

## Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `doc.ID` | GUID | Yes | Document ID to send. The server reloads the document from the database by this ID — every other `doc` field you send is ignored. |
| `doc.AssociatedEmails` | [AssociatedEmail](document-object.md#associatedemail)[] | No | Recipients, e.g. `{ "Mail": "..." }`. When omitted, the document is sent to the customer's own email on file. |
| `token` | string | Yes | Authentication token. |

## Example request

```http
POST /Services/ApiService.svc/SendDocumentByMail HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "ID": "3f2b9c1e-7a4d-4e8b-9c1a-2b3c4d5e6f70",
    "AssociatedEmails": [
      { "Mail": "billing@acme.example" }
    ]
  },
  "token": "<token>"
}
```

## Example response

```json
{
  "d": {
    "Errors": [],
    "Info": [
      { "ID": 2, "Info": "SuccessfulAction", "Paramters": null }
    ],
    "OpenInfo": []
  }
}
```

## Notes

* This sends a **real email** through the same delivery path as document creation — there is no dry-run or preview mode. Avoid pointing it at production customer addresses from test scripts.
* Only `doc.ID` and `doc.AssociatedEmails` are read by the server; it reloads the document itself and ignores every other field on the `doc` you send.
* If `doc.AssociatedEmails` is omitted and the customer has no email on file, the call still reports success — nothing is actually delivered.

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Expired account, or the document belongs to another organization. |
| `GeneralError` (0) | Invalid/undecodable token, or any other failure while sending the email. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/SendDocumentByMail" method="post" %}
{% endopenapi-operation %}
