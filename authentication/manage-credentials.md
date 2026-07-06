# Managing Credentials

Endpoints to change the account password, rotate the API key, and log out.

## Change password — `UpdatePU`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdatePU` |
| **Response** | `User` object (check `Errors`) |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `newPU` | string | Yes | New password. Must pass the Invoice4U password policy. |
| `token` | string | Yes | Authentication token. |

### Example

```json
{
  "newPU": "N3w-Str0ng-P@ss",
  "token": "<token>"
}
```

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `PasswordNotValid` (17) | New password fails the password policy. |
| `GeneralError` (0) | Server error. |

***

## Rotate API key — `UpdateAKU`

Sets a new API key for the authenticated user.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateAKU` |
| **Response** | `User` object (check `Errors`) |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `newAkU` | string (GUID) | Yes | The new API key. Must be a valid GUID. |
| `token` | string | Yes | Authentication token. |

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Invalid token. |
| `ApiKeyNotInCorrectFormat` (303) | `newAkU` is not a valid GUID. |

***

## Set API key with credentials — `UpdateUserApiKey`

Alternative that authenticates with email + password instead of a token. Useful for first-time key provisioning.

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/UpdateUserApiKey` |
| **Response** | `CommonObject` (check `Errors`) |

### Request schema

| Field | Type | Required | Description |
| ----- | ---- | -------- | ----------- |
| `email` | string | Yes | Account email. |
| `password` | string | Yes | Account password. |
| `newApiKey` | string (GUID) | Yes | The key to set. Must be a valid, non-empty GUID not used by another account. |
| `isForceUpdate` | boolean | No (default `false`) | If `false` and the user already has a key, the call fails. Set `true` to overwrite. |

### Errors

| Error (ID) | Meaning |
| ---------- | ------- |
| `UnauthorizedUser` (80) | Bad credentials. |
| `InvalidGuid` (142) | Malformed GUID, or the GUID is already used by another account. |
| `GeneralError` (0) | User already has an API key and `isForceUpdate` is `false`. |

***

## Logout — `Logout`

| | |
| - | - |
| **Method** | `POST` |
| **Path** | `/Logout` |
| **Body** | `{}` |
| **Response** | none |

Signs out the current forms-authentication session. Stateless integrations that just hold a token can simply discard it.
