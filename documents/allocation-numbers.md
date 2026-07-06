# Allocation Numbers (Israel Tax Authority)

Israeli invoices above the legal threshold require an **allocation number** (מספר הקצאה) from the Israel Tax Authority. These endpoints fetch or set one for an existing document.

## Fetch from the ITA — `FetchAllocationNumber`

Requests an allocation number for a document that doesn't have one yet.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/FetchAllocationNumber` |
| **Response** | Updated `Document` (`AllocationNumber`, `AllocationMessage`) |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

Requires the organization to be connected to the Israel Invoices service (check via your account settings). Documents belonging to another organization are ignored.

## Set manually — `UpdateAllocationNumber`

Stores an allocation number obtained outside Invoice4U.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateAllocationNumber` |

```json
{
  "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
  "allocationNumber": "123456789",
  "token": "<token>"
}
```

The number must be at least **9 characters** — otherwise `AllocationNumberInvalid` (162).

## Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `AllocationNumberInvalid` (162) | Number shorter than 9 characters. |
| `AllocationNumberNotGenerated` (152) / `AllocationNumberNotSaved` (153) | ITA fetch/store failure. |
| `AllocationNumberDeclined` (156) / `AllocationNumberDeclinedWaitDecision` (157) | ITA declined the request / pending decision. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/FetchAllocationNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/UpdateAllocationNumber" method="post" %}
{% endopenapi-operation %}

