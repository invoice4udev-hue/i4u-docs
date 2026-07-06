# Customer Endpoints Overview

Customers ("clients") are the entities you issue documents to. Every customer belongs to your organization and can be referenced from documents by `ClientID`.

### Endpoints in this section

| Endpoint                                                                                                                                                                                              | Page                                    |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `CreateCustomer`                                                                                                                                                                                      | [Create a Customer](create-customer.md) |
| `UpdateCustomer`                                                                                                                                                                                      | [Update a Customer](update-customer.md) |
| `GetCustomerById`, `GetCustomerByName`, `GetCustomerByEmail`, `GetCustomerByGuid`, `GetCustomerByClientCode`, `GetCustomerByExternalNumber`, `GetCustomersByOrgId`, `GetCustomers`, `GetFullCustomer` | [Retrieve Customers](get-customers.md)  |

### The Customer object

Used as request body for create/update and returned by all retrieval endpoints. Inherits the [response envelope](../#response-envelope) (`Errors`, `Info`, `OpenInfo`).

| Field                                                                | Type                 | Required             | Description                                                                                                     |
| -------------------------------------------------------------------- | -------------------- | -------------------- | --------------------------------------------------------------------------------------------------------------- |
| `Name`                                                               | string               | **Yes**              | Customer display name. Must be unique per organization unless `IsNonUniqueNameCreation` is `true`.              |
| `ID`                                                                 | int                  | No                   | Customer ID. `0`/omitted on create; required on update.                                                         |
| `UniqueID`                                                           | string               | No                   | Customer VAT/company/ID number. **Digits only** when supplied. Required for Israel Tax allocation-number flows. |
| `Email`                                                              | string               | No                   | Primary email.                                                                                                  |
| `Phone`                                                              | string               | No                   | Landline phone.                                                                                                 |
| `Cell`                                                               | string               | No                   | Mobile phone.                                                                                                   |
| `Fax`                                                                | string               | No                   | Fax.                                                                                                            |
| `Address`                                                            | string               | No                   | Street address.                                                                                                 |
| `City`                                                               | string               | No                   | City.                                                                                                           |
| `Zip`                                                                | string               | No                   | Postal code.                                                                                                    |
| `Country` / `CountryId`                                              | string / int         | No                   | Country name / internal ID.                                                                                     |
| `ExtNumber`                                                          | long                 | No                   | Your external customer number. Unique per organization. Defaults to the new customer's ID if omitted.           |
| `Active`                                                             | boolean              | No                   | Whether the customer is active.                                                                                 |
| `PayTerms`                                                           | int                  | No                   | Payment terms in days (e.g. `0` = due now, `30` = EOM+30). Affects the automatic `PaymentDueDate` on documents. |
| `IsNonUniqueNameCreation`                                            | boolean              | No (default `false`) | Allow creating/updating a customer whose name already exists.                                                   |
| `Guid`                                                               | string               | No                   | Your external GUID for the customer. Unique per organization.                                                   |
| `ClientCode`                                                         | int                  | No                   | Internal client code (searchable).                                                                              |
| `ContactFirstName`, `ContactLastName`, `ContactName`, `ContactEmail` | string               | No                   | Contact person details.                                                                                         |
| `CustomerEmails`                                                     | AssociatedEmail\[]   | No                   | Additional emails for the customer.                                                                             |
| `AccountNumber`, `BankName`, `BranchName`, `BankCode`, `BranchCode`  | string               | No                   | Bank details.                                                                                                   |
| `Website`                                                            | string               | No                   | Website URL.                                                                                                    |
| `InternalNote`                                                       | string               | No                   | Free-text note. `PrintInternalNoteOnQuote` (bool) controls printing on quotes.                                  |
| `Retainer`, `RetainerAmount`, `RetainerTitle`                        | bool, double, string | No                   | Retainer settings.                                                                                              |
| `Discount`, `DiscountType`, `PricelistID`                            | decimal, int, int    | No                   | Default discount / pricelist.                                                                                   |

### Create/update result codes

After a create or update, the returned `ID` may carry an error code instead of a real ID. The API also adds the matching error to `Errors`:

| Returned `ID` | Error                                | Meaning                                                       |
| ------------- | ------------------------------------ | ------------------------------------------------------------- |
| `-1`          | `CustomerNameExists` (2)             | Name already exists (and `IsNonUniqueNameCreation` is false). |
| `-2`          | `CustomerExternalNumberExists` (31)  | `ExtNumber` already used.                                     |
| `-3`          | `CustomerUniqueIdExistsForUser` (78) | `UniqueID` already used.                                      |
| `-4`          | `CustomerGuidExists` (84)            | `Guid` already used.                                          |
