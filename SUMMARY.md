# Table of contents

## Getting Started

* [Welcome to the Invoice4U API](README.md)
* [Quick Start](getting-started/quick-start.md)
* [Key Tips & Differences](getting-started/key-tips.md)
* [טיפים וחידודים - עברית](getting-started/key-tips-hebrew.md)

## Authentication

* [Authentication Overview](authentication/overview.md)
* [Login with Email & Password](authentication/verify-login.md)
* [Login with API Key](authentication/verify-login-api-key.md)
* [Managing Credentials](authentication/manage-credentials.md)

## Customers

* [Customer Endpoints Overview](customers/overview.md)
* [Create a Customer](customers/create-customer.md)
* [Update a Customer](customers/update-customer.md)
* [Retrieve Customers](customers/get-customers.md)

## Branches

* [Branch Endpoints Overview](branches/overview.md)
* [Get Branches](branches/get-branches.md)

## Documents

* [Document Endpoints Overview](documents/overview.md)
* [Document Types](documents/document-types.md)
* [The Document Object](documents/document-object.md)
* [Create a Document](documents/create-document.md)
* [Create a Document with Identifier Validation](documents/create-document-with-validation.md)
* [Retrieve Documents](documents/get-documents.md)

## Clearing (Payments)

* [Clearing Endpoints Overview](clearing/overview.md)
* [Process a Clearing Request (V2)](clearing/process-api-request-v2.md)
* [Tokens & Standing Orders](clearing/tokens-and-standing-orders.md)
* [Clearing Logs](clearing/clearing-logs.md)

## User Registration

* [User Registration (Partners)](registration/user-registration.md)

## OpenAPI Specs

* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
    grouping: by-operation
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: invoice4u-api
  ```
