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

`POST /GetCustomerByGuid` — lookup by the external `Guid` you set on creation. `GetCustomerByGuidInnerSearch` performs a broader (contains) search.

## Get by external number — `GetCustomerByExternalNumber`

```json
{ "number": 10045, "token": "<token>" }
```

`POST /GetCustomerByExternalNumber` — lookup by `ExtNumber`. Returns `CustomerNotFound` (136) when `number` is not positive.

## Get by client code — `GetCustomerByClientCode`

```json
{ "clientCode": 42, "token": "<token>" }
```

`POST /GetCustomerByClientCode` (alias: `/GetByClientCode`).

## Full record — `GetFullCustomer`

```json
{ "id": 88231, "orgID": 0, "token": "<token>" }
```

`POST /GetFullCustomer` — returns the full customer record including bank details, contacts and additional emails. Pass `orgID: 0` to use the token's organization.

## List all — `GetCustomersByOrgId`

```json
{ "token": "<token>" }
```

`POST /GetCustomersByOrgId` — returns `CommonCollection<Customer[]>`:

```json
{
  "GetCustomersByOrgIdResult": {
    "Response": [ { "ID": 88231, "Name": "Acme Ltd" }, ... ],
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

{% openapi-operation spec="invoice4u-api" path="/GetCustomersByOrgId" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomers" method="post" %}
{% endopenapi-operation %}

