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

## Environments — QA vs ITA sandbox

Which ITA environment (sandbox `tsandbox` or production) serves the allocation number is a **server-side Invoice4U platform setting** — it is **not** controlled by your request:

* Calling the QA base URL (`apiqa.invoice4u.co.il`) does **not** by itself route allocation requests to the ITA sandbox.
* The `IsQaMode` flag has no effect on the ITA environment.
* The organization must be connected to the Israel Invoices service (OAuth consent) in the environment you're testing on — without that connection no allocation number is issued.

{% hint style="warning" %}
If you need to verify which ITA environment your QA organization is wired to, contact Invoice4U support before relying on QA allocation numbers in your tests.
{% endhint %}

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

