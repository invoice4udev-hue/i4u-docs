# ‫דוחות מלאי‬

‫שלפו דוחות עלות מלאי, תנועות ומכירות.‬

## ‫שליפת דוח עלות מלאי‬

‫מחזיר את דוח עלות המלאי לתאריך ספציפי, ומציג את כל הפריטים והערכות השווי שלהם.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryCostReport` |
| ‫**תשובה**‬ | `ItemBalance[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `date` | DateTime | ‫כן‬ | ‫התאריך שעבורו יש להפיק את הדוח.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryCostReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "date": "/Date(1787518800000+0300)/",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "ItemId": 1001,
      "ItemName": "Laptop Pro",
      "Quantity": 15,
      "Cost": 2800.00,
      "TotalValue": 42000.00,
      "Errors": []
    },
    {
      "ItemId": 1002,
      "ItemName": "Wireless Mouse",
      "Quantity": 50,
      "Cost": 75.00,
      "TotalValue": 3750.00,
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

## ‫שליפת הפריטים הנמכרים ביותר‬

‫מחזיר את הפריטים הנמכרים ביותר על בסיס נפח המכירות או הערך.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetTopSoldItems` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `filterType` | int | ‫כן‬ | ‫סוג סינון: `1` = לפי כמות, `2` = לפי ערך.‬ |
| `type` | int | ‫כן‬ | ‫תקופת זמן: `1` = השבוע האחרון, `2` = החודש האחרון, `3` = הרבעון האחרון, `4` = השנה האחרונה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetTopSoldItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "filterType": 1,
  "type": 2,
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
      "SKU": "LP-001",
      "QuantitySold": 120,
      "SalesValue": 540000.00,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "SKU": "WM-001",
      "QuantitySold": 450,
      "SalesValue": 67500.00,
      "Errors": []
    },
    {
      "Id": 1003,
      "Name": "USB-C Cable",
      "SKU": "USB-C-001",
      "QuantitySold": 300,
      "SalesValue": 9000.00,
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

## ‫שליפת פריטים בעלי הערך הגבוה ביותר‬

‫מחזיר את הפריטים עם ערך המלאי הכולל הגבוה ביותר.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetHighestByValue` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetHighestByValue HTTP/1.1
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
      "SKU": "LP-001",
      "Quantity": 15,
      "Cost": 2800.00,
      "TotalValue": 42000.00,
      "Errors": []
    },
    {
      "Id": 1050,
      "Name": "Server Unit",
      "SKU": "SRV-001",
      "Quantity": 5,
      "Cost": 8000.00,
      "TotalValue": 40000.00,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "SKU": "WM-001",
      "Quantity": 50,
      "Cost": 75.00,
      "TotalValue": 3750.00,
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
