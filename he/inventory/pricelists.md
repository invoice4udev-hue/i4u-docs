# ‫מחירונים‬

‫נהלו מחירוני מלאי ותמחור לקוחות.‬

## ‫הוספת מחירון‬

‫יוצר מחירון חדש בארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/AddInventoryPricelist` |
| ‫**תשובה**‬ | ‫אובייקט `Pricelist`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | ‫כן‬ | ‫המחירון ליצירה. בדרך כלל כולל `Name` וכללי תמחור.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/AddInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Name": "Wholesale Pricing",
    "Description": "Bulk discount pricing tier",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "AddInventoryPricelistResult": {
    "Id": 25,
    "Name": "Wholesale Pricing",
    "Description": "Bulk discount pricing tier",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |

---

## ‫עדכון מחירון‬

‫מעדכן מחירון קיים.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateInventoryPricelist` |
| ‫**תשובה**‬ | ‫אובייקט `Pricelist`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | ‫כן‬ | ‫המחירון לעדכון. חייב לכלול `Id`.‬ |
| `customerID` | int? | ‫לא‬ | ‫מזהה לקוח אופציונלי לשיוך למחירון זה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Id": 25,
    "Name": "Wholesale Pricing",
    "Description": "Updated bulk discount tier",
    "IsActive": true
  },
  "customerID": 88231,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "UpdateInventoryPricelistResult": {
    "Id": 25,
    "Name": "Wholesale Pricing",
    "Description": "Updated bulk discount tier",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |

---

## ‫שליפת כל המחירונים‬

‫מחזיר את כל המחירונים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelists` |
| ‫**תשובה**‬ | `Pricelist[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelists HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "GetInventoryPricelistsResult": [
    {
      "Id": 25,
      "Name": "Wholesale Pricing",
      "Description": "Bulk discount pricing tier",
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 26,
      "Name": "Retail Pricing",
      "Description": "Standard retail prices",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |

---

## ‫שליפת מחירונים לפי מזהה לקוח‬

‫מחזיר מחירונים המשויכים ללקוח ספציפי.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelistByCustomerId` |
| ‫**תשובה**‬ | `Pricelist[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerId` | int | ‫כן‬ | ‫מזהה הלקוח לשאילתה.‬ |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerId HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerId": 88231,
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "GetInventoryPricelistByCustomerIdResult": [
    {
      "Id": 25,
      "Name": "Wholesale Pricing",
      "Description": "Bulk discount pricing tier",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |

---

## ‫שליפת מחירונים לפי מזהי לקוחות מרובים‬

‫מחזיר מחירונים עבור לקוחות מרובים בבת אחת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelistByCustomerIds` |
| ‫**תשובה**‬ | `PricelistWithCustomer[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerIds` | string | ‫כן‬ | ‫רשימת מזהי לקוחות מופרדת בפסיקים (לדוגמה, "88231,88232,88233").‬ |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerIds HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIds": "88231,88232,88233",
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "GetInventoryPricelistByCustomerIdsResult": [
    {
      "CustomerId": 88231,
      "Id": 25,
      "Name": "Wholesale Pricing",
      "Description": "Bulk discount pricing tier",
      "IsActive": true,
      "Errors": []
    },
    {
      "CustomerId": 88232,
      "Id": 26,
      "Name": "Retail Pricing",
      "Description": "Standard retail prices",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |

---

## ‫הסרת לקוח ממחירון‬

‫מסיר לקוחות משיוכי מחירונים.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/RemoveCustomerFromInventoryPricelist` |
| ‫**תשובה**‬ | ‫`bool` — `true` בהצלחה, `false` בשגיאה‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerIDs` | string | ‫כן‬ | ‫רשימת מזהי לקוחות מופרדת בפסיקים להסרה ממחירונים.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/RemoveCustomerFromInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIDs": "88231,88232",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "RemoveCustomerFromInventoryPricelistResult": true
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |
| `false` | ‫הפעולה נכשלה בשגיאת שרת.‬ |
