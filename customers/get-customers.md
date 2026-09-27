# Retrieve Customers

Lookup endpoints for customers. All take a `token` and return either a single `Customer` or a collection. All results are scoped to the authenticated organization.

## Get by ID — `GetCustomerById`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/GetCustomerById` |

```json
{ "custId": 88231, "token": "<token>" }
```

Returns the `Customer`. If the customer belongs to another organization: `ClientIDDoesntExists` (37).

## Get by name — `GetCustomerByName`

```json
{ "name": "Acme Ltd", "token": "<token>" }
```

`POST /GetCustomerByName` — exact-name lookup.

## Get by email — `GetCustomerByEmail`

```json
{ "email": "billing@acme.example", "name": "Acme Ltd", "token": "<token>" }
```

`POST /GetCustomerByEmail` — email lookup, with optional name to disambiguate.

## Get by GUID — `GetCustomerByGuid`

```json
{ "guid": "d2f1a6b3-...", "token": "<token>" }
```

`POST /GetCustomerByGuid` — lookup by the external `Guid` you set on creation. If it returns nothing, try `GetCustomerByGuidInnerSearch` below.

## Get by GUID (inner search) — `GetCustomerByGuidInnerSearch`

```json
{ "guid": "d2f1a6b3-...", "token": "<token>" }
```

```json
{
  "d": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Guid": "d2f1a6b3-...",
    "Errors": []
  }
}
```

`POST /GetCustomerByGuidInnerSearch` — also searches additional customer identifiers (the lookup's inner-search option); use it when `GetCustomerByGuid` returns nothing. Returns `null` both when no customer matches and when the token is invalid or expired — the two cases are indistinguishable from the response alone.

## Get by external number — `GetCustomerByExternalNumber`

```json
{ "number": 10045, "token": "<token>" }
```

`POST /GetCustomerByExternalNumber` — lookup by `ExtNumber`. Returns `CustomerNotFound` (136) when `number` is not positive.

## Get by client code — `GetCustomerByClientCode`

```json
{ "clientCode": 1045, "token": "<token>" }
```

`POST /GetCustomerByClientCode` (alias: `/GetByClientCode`). Returns `null` when no customer matches. An invalid or expired token is **not** caught: the check runs before the method's try block, so it raises an unhandled server error (HTTP 500) instead of a normal error response.

## Get by client code (alias) — `GetByClientCode`

```json
{ "clientCode": 1045, "token": "<token>" }
```

```json
{
  "d": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "ClientCode": 1045,
    "Errors": []
  }
}
```

`POST /GetByClientCode` — identical implementation to `GetCustomerByClientCode` (same lookup, same organization scoping). Returns `null` when no customer matches. As with `GetCustomerByClientCode`, an invalid or expired token raises an unhandled server error (HTTP 500) rather than a normal error response.

## Full record — `GetFullCustomer`

```json
{ "id": 88231, "orgID": 0, "token": "<token>" }
```

`POST /GetFullCustomer` — returns the full customer record including bank details, contacts and additional emails. Send `orgID` as `0` to use the token's own organization.

## List all — `GetCustomersByOrgId`

```json
{ "token": "<token>" }
```

`POST /GetCustomersByOrgId` — returns `CommonCollection<Customer[]>`:

```json
{
  "d": {
    "Response": [
      { "ID": 88231, "Name": "Acme Ltd" },
      { "ID": 88232, "Name": "Beta Corp" }
    ],
    "Errors": []
  }
}
```

## Search — `GetCustomers`

```json
{
  "cust": { "Name": "Acme" },
  "token": "<token>"
}
```

`POST /GetCustomers` — filtered search. Populate any subset of `Customer` fields (`Name`, `Email`, `UniqueID`, …) as the filter; returns a `CommonCollection<Customer[]>` of matches.

## Errors (all endpoints)

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ClientIDDoesntExists` (37) | Customer not found / belongs to another organization. |
| `CustomerNotFound` (136) | Invalid lookup value. |
| `GeneralError` (0) | Server error. |

## Try it

{% openapi-operation spec="invoice4u-api" path="/GetCustomerById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByName" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByEmail" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByGuid" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByGuidInnerSearch" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByExternalNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByClientCode" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetByClientCode" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetFullCustomer" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomersByOrgId" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomers" method="post" %}
{% endopenapi-operation %}

