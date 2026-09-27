# ‫מחסנים‬

‫נהלו מחסני מלאי.‬

## ‫יצירת מחסן‬

‫יוצר מחסן חדש בארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateWarehouse` |
| ‫**תשובה**‬ | ‫אובייקט `Warehouse`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `warehouse` | Warehouse | ‫כן‬ | ‫המחסן ליצירה. עבור מחסן חדש, הגדירו את `Id` ל-`0`. `IsActive` הוא שדה חובה (לא-nullable) בפרוטוקול — אם משמיטים אותו, WCF מפענח אותו כ-`false` והמחסן נוצר **לא פעיל** בלי אזהרה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateWarehouse HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "warehouse": {
    "Id": 0,
    "Name": "Central Warehouse",
    "Street": "123 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 101,
    "Name": "Central Warehouse",
    "Street": "123 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/פג תוקף או רכיב מלאי כבוי מחזירים אובייקט `Warehouse` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫עדכון מחסן‬

‫מעדכן מחסן קיים לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateWarehouse` |
| ‫**תשובה**‬ | ‫אובייקט `Warehouse` עם `Id` מעודכן‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `warehouse` | Warehouse | ‫כן‬ | ‫המחסן לעדכון. חובה לכלול `Id` > 0.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateWarehouse HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "warehouse": {
    "Id": 101,
    "Name": "Central Warehouse",
    "Street": "456 Industrial St",
    "City": "Tel Aviv",
    "ContactPhone": "03-1234567"
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 101,
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/פג תוקף או רכיב מלאי כבוי מחזירים אובייקט `Warehouse` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת כל המחסנים‬

‫שולף את כל המחסנים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetWarehouses` |
| ‫**תשובה**‬ | `Warehouse[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetWarehouses HTTP/1.1
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
      "Id": 101,
      "Name": "Central Warehouse",
      "Street": "123 Industrial St",
      "City": "Tel Aviv",
      "ContactPhone": "03-1234567",
      "Errors": []
    },
    {
      "Id": 102,
      "Name": "North Storage",
      "Street": "789 Logistics Ave",
      "City": "Haifa",
      "ContactPhone": "04-9876543",
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/פג תוקף או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬
