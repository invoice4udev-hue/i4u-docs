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
      "Code": "LP-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "Code": "WM-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 150.00,
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

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
      "Code": "LP-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 4500.00,
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "Code": "WM-001",
      "ItemCategoryId": 5,
      "UnitType": 0,
      "SellingPrice": 150.00,
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

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
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "ManufacturerId": 3,
        "WarehouseId": 101,
        "TotalQuantity": 8
      }
    ],
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר גורם לחריגה בלתי מטופלת כאן (בלוק ה-`catch` של מתודה זו אינו מאפס את המערך שלה לפני קריאת `.FirstOrDefault()` בסוף), כך שהתשובה היא WCF fault, לא גוף `{"d": …}` נקי. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים אובייקט `Item` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

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
| `item` | Item | ‫כן‬ | ‫הפריט ליצירה. `Id` **חייב להיות `0`** — ה-API יוצר רק כאשר `Id` הוא `0`; אם `Id > 0` הקריאה מחזירה `null` בלי ליצור או לעדכן דבר (ראו שגיאות למטה). שדות: `Name`, `Code`, `ItemCategoryId`, `UnitType` (ראו למטה), `SellingPrice`, `PurchasePrice`, `SerialNumber`, `BatchNumber` (שניהם ברמת הפריט, לא לכל מופע), `IsActive`, `IsNonStockItem`. אופציונלי: מערך `ItemInstances`.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

‫ערכי `UnitType`: `0` יחידות, `1` ק"ג, `2` גרם, `3` ליטר, `4` מ"ל.‬

‫כל רשומה במערך `ItemInstances` משתמשת ב-`ItemStatusId` (`1` תקין במלאי וזמין למכירה, `2` לא במלאי, `3` נמכר), `ManufacturerId`, `WarehouseId` ו-`TotalQuantity` — לא `SerialNumber`/`BatchNumber`, שנמצאים על הפריט עצמו.‬

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateInventoryItem HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "item": {
    "Id": 0,
    "Name": "Laptop Pro",
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 8
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
    "Code": "LP-001",
    "Description": "High-performance laptop",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4500.00,
    "PurchasePrice": 2800.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 8
      }
    ],
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים אובייקט `Item` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `InventorySerialNumberItemExistsForUser` (402) | ‫פריט אחר כבר משתמש ב-`SerialNumber` הזה עבור הארגון.‬ |
| `InventoryCodeItemExistsForUser` (404) | ‫פריט אחר כבר משתמש ב-`Code` הזה עבור הארגון.‬ |

‫אם `item.Id` גדול מ-`0`, הבקשה מתעלמת בשקט והתשובה היא `null` (בלי אובייקט שגיאה) — לא נוצר פריט חדש.‬

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
| `item` | Item | ‫כן‬ | ‫הפריט לעדכון. חייב לכלול `Id` > 0 — אם `Id` הוא `0` או חסר, התשובה היא `null` (אין עדכון, בלי אובייקט שגיאה). אותם שדות כמו ביצירה: `Name`, `Code`, `ItemCategoryId`, `UnitType`, `SellingPrice`, `PurchasePrice`, `SerialNumber`, `BatchNumber`, `IsActive`.‬ |
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
    "Code": "LP-001",
    "Description": "High-performance laptop - Updated",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4750.00,
    "PurchasePrice": 2900.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 6
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
    "Code": "LP-001",
    "Description": "High-performance laptop - Updated",
    "ItemCategoryId": 5,
    "UnitType": 0,
    "SellingPrice": 4750.00,
    "PurchasePrice": 2900.00,
    "IsActive": true,
    "SerialNumber": 12345,
    "BatchNumber": 1,
    "ItemInstances": [
      {
        "Id": 5001,
        "ItemStatusId": 1,
        "WarehouseId": 101,
        "TotalQuantity": 6
      }
    ],
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים אובייקט `Item` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `InventorySerialNumberItemExistsForUser` (402) | ‫פריט אחר כבר משתמש ב-`SerialNumber` הזה עבור הארגון.‬ |
| `InventoryCodeItemExistsForUser` (404) | ‫פריט אחר כבר משתמש ב-`Code` הזה עבור הארגון.‬ |
