# Branch Endpoints Overview

Branches represent business locations/units under your organization. Documents can be attributed to a branch via the document's `BranchID`; if omitted, the organization's default branch is used automatically.

### The Branch object

| Field | Type | Description |
| ----- | ---- | ----------- |
| `ID` | int | Branch ID. Use as `BranchID` on documents. |
| `Name` | string | Branch name. |
| `Description` | string | Free-text description. |
| `Enabled` | boolean | Whether the branch is active. |
| `IsDefault` | boolean | Default branch for new documents. |
| `IsMain` | boolean | Marks the main branch. |
| `Email` | string | Branch email. |
| `New` | boolean | Internal flag; not meaningful for integrations. |
| `Ucan2ID` | int | Internal link to the legacy Ucan2 system; not meaningful for integrations. |

### Pages in this section

* [Get Branches](get-branches.md) — list all branches for your organization
