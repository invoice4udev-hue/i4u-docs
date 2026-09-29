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

Returns the `Customer`, scoped to your organization. See [Errors by endpoint](#errors-by-endpoint) below — a BLL bug means invalid token, expired account and not-found are indistinguishable here.

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

`POST /GetCustomerByExternalNumber` — lookup by `ExtNumber`. Every failure path (invalid/missing token, expired account, `number <= 0`, or no match) hits an unhandled null-reference exception before an error can be attached, so it always falls back to `{ "d": null }` — never `CustomerNotFound` (136).

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
  "cust": { "Name": "Acme", "Active": true },
  "token": "<token>"
}
```

`POST /GetCustomers` — filtered search; returns a `CommonCollection<Customer[]>` of matches. Only these `Customer` fields are honored as filters — any other field you populate in `cust` is ignored:

`UniqueID`, `Name`, `ExtNumber`, `Active`, `Retainer` (applied only when `true`), `HasBeenExported`, `Email`, `Phone`, `Cell`, `FreeUniqueID`.

{% hint style="warning" %}
`Active` is a non-nullable field on `Customer`, so it is **always** sent to the search — even when you omit it from `cust`. Omitting it searches for **inactive** customers (`Active: false`). Send `"Active": true` explicitly to find active customers.
{% endhint %}

Whether each honored field matches exactly or partially (`LIKE`) is not documented here — the underlying search logic isn't part of the published contract.

## Errors by endpoint

Behavior differs per endpoint — none of these lookups share one error table. `Errors` values are on the returned `Customer`/collection unless noted otherwise.

| Endpoint | Invalid token | Expired account | Not found |
| -------- | ------------- | ---------------- | --------- |
| `GetCustomerById` | `Errors: [GeneralError (0)]`\* | `Errors: [GeneralError (0)]`\* | `Errors: [GeneralError (0)]`\* |
| `GetCustomerByName` | HTTP 500 (unhandled fault) | `Errors: [UnauthorizedUser (80)]` | `null` |
| `GetCustomerByEmail` | HTTP 500 (unhandled fault) | `Errors: [UnauthorizedUser (80)]` | `null` (`Errors: [GeneralError (0)]` on an unrelated server/DB error) |
| `GetCustomerByGuid` | `null` | `null` | `null` |
| `GetCustomerByGuidInnerSearch` | `null` | `null` | `null` |
| `GetCustomerByExternalNumber` | `null` | `null` | `null` (also for `number <= 0`) |
| `GetCustomerByClientCode` | HTTP 500 (unhandled fault) | HTTP 500 (unhandled fault) | `null` |
| `GetByClientCode` (alias) | HTTP 500 (unhandled fault) | HTTP 500 (unhandled fault) | `null` |
| `GetFullCustomer` | `Errors: [UnauthorizedUser (80)]` | `Errors: [ExpiredAccount (66)]` | `null` |
| `GetCustomersByOrgId` | empty envelope — no `Response`, no `Errors`† | `Errors: [UnauthorizedUser (80)]`, no `Response` | n/a — empty `Response` array |
| `GetCustomers` | empty envelope — no `Response`, no `Errors`† | `Errors: [UnauthorizedUser (80)]`, no `Response` | n/a — empty `Response` array |

\* A null-reference bug in `GetCustomerById` collapses invalid token, expired account and not-found into the same generic `GeneralError (0)` response; `ClientIDDoesntExists` (37) cannot actually occur, because the underlying query is already scoped to your organization, so a customer from another org is indistinguishable from "not found."

† For `GetCustomersByOrgId`/`GetCustomers`, an invalid or missing token throws before any error can be attached to the collection, so you get back an empty envelope rather than a normal error — you cannot distinguish "no results" from "invalid token" by inspecting `Errors` alone.

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

