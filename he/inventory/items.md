# ‫פריטי מלאי‬

‫נהלו פריטי מלאי ווריאציות מוצר.‬

## ‫שליפת פריטי מלאי‬

‫מחזירה פריטי מלאי עם סינון אופציונלי לפי טווח תאריכים, סטטוס ומזהים.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryItems` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `itemId` | int? | ‫לא‬ | ‫סינון לפי מזהה פריט מסוים.‬ |
| `fromSellingDate` | DateTime? | ‫לא‬ | ‫סינון לפי תאריך מכירה (מ-).‬ |
| `toSellingDate` | DateTime? | ‫לא‬ | ‫סינון לפי תאריך מכירה (עד).‬ |
| `fromPurchasingDate` | DateTime? | ‫לא‬ | ‫סינון לפי תאריך רכישה (מ-).‬ |
| `toPurchasingDate` | DateTime? | ‫לא‬ | ‫סינון לפי תאריך רכישה (עד).‬ |
| `isActive` | bool? | ‫לא‬ | ‫סינון לפי סטטוס פעיל.‬ |
| `serialNumber` | int? | ‫לא‬ | ‫סינון לפי מספר סידורי.‬ |
| `batchNumber` | int? | ‫לא‬ | ‫סינון לפי מספר אצווה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryItems HTTP/1.1
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
  "d": [
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "CategoryId": 5,
      "SKU": "LP-001",
      "Price": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "CategoryId": 5,
      "SKU": "WM-001",
      "Price": 150.00,
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

## ‫שליפת פריטי מלאי פעילים‬

‫מחזירה רק פריטי מלאי פעילים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetActiveInventoryItems` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetActiveInventoryItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "CategoryId": 5,
      "SKU": "LP-001",
      "Price": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "CategoryId": 5,
      "SKU": "WM-001",
      "Price": 150.00,
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

## ‫שליפת פריט מלאי לפי מזהה‬

‫מחזירה פריט מלאי מסוים לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryItem` |
| ‫**תשובה**‬ | ‫אובייקט `Item`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `id` | int | ‫כן‬ | ‫מזהה הפריט לשליפה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 1001,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
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

## ‫יצירת פריט מלאי‬

‫יוצרת פריט מלאי חדש עם מופעי פריט אופציונליים (וריאציות/מספרים סידוריים).‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateInventoryItem` |
| ‫**תשובה**‬ | ‫אובייקט `Item`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `item` | Item | ‫כן‬ | ‫הפריט ליצירה. הגדירו את `Id` ל-`0`. כללו `Name`, `CategoryId`, `Price`. אופציונלי: מערך `ItemInstances`.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 0,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ]
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop",
    "Price": 4500.00,
    "Cost": 2800.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
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

## ‫עדכון פריט מלאי‬

‫מעדכנת פריט מלאי קיים ו/או את מופעי הפריט שלו.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateInventoryItem` |
| ‫**תשובה**‬ | ‫אובייקט `Item`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `item` | Item | ‫כן‬ | ‫הפריט לעדכון. חייב לכלול `Id` > 0.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop - Updated",
    "Price": 4750.00,
    "Cost": 2900.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ]
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 1001,
    "Name": "Laptop Pro",
    "CategoryId": 5,
    "SKU": "LP-001",
    "Description": "High-performance laptop - Updated",
    "Price": 4750.00,
    "Cost": 2900.00,
    "IsActive": true,
    "ItemInstances": [
      {
        "Id": 5001,
        "SerialNumber": "SN12345",
        "BatchNumber": "BN001"
      }
    ],
    "Errors": []
  }
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |
