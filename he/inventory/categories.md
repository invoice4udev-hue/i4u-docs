# ‫קטגוריות פריטים‬

‫נהלו קטגוריות פריטים לארגון פריטי מלאי.‬

## ‫יצירת קטגוריה‬

‫יוצר קטגוריית פריטים חדשה בארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateInventoryCategory` |
| ‫**תשובה**‬ | ‫אובייקט `ItemCategory`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `itemCategory` | ItemCategory | ‫כן‬ | ‫הקטגוריה ליצירה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateInventoryCategory HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemCategory": {
    "Name": "Electronics",
    "Description": "Electronic devices and components",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Electronic devices and components",
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

## ‫עדכון קטגוריה‬

‫מעדכן קטגוריית פריטים קיימת לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateInventoryCategory` |
| ‫**תשובה**‬ | ‫אובייקט `ItemCategory`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `itemCategory` | ItemCategory | ‫כן‬ | ‫הקטגוריה לעדכון. חובה לכלול `Id`.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateInventoryCategory HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemCategory": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Updated: Electronic devices",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Updated: Electronic devices",
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

## ‫שליפת קטגוריה לפי מזהה‬

‫שולף קטגוריית פריטים מסוימת לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryCategoryById` |
| ‫**תשובה**‬ | ‫אובייקט `ItemCategory`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `id` | int | ‫כן‬ | ‫מזהה הקטגוריה לשליפה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryCategoryById HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 5,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 5,
    "Name": "Electronics",
    "Description": "Electronic devices and components",
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

## ‫שליפת כל הקטגוריות‬

‫שולף את כל קטגוריות הפריטים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryCategories` |
| ‫**תשובה**‬ | `ItemCategory[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryCategories HTTP/1.1
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
      "Id": 1,
      "Name": "Hardware",
      "Description": "Computer hardware",
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 5,
      "Name": "Electronics",
      "Description": "Electronic devices and components",
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
