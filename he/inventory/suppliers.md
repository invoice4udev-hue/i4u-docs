# ‫ספקים‬

‫נהלו ספקים עבור המלאי שלכם.‬

## ‫יצירת ספק‬

‫יוצר ספק חדש בארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateSupplier` |
| ‫**תשובה**‬ | ‫אובייקט `Supplier`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `supplier` | Supplier | ‫כן‬ | ‫הספק ליצירה. חייב לכלול `Name` (ייחודי לכל ארגון). `IsActive` הוא שדה חובה (לא-nullable) בפרוטוקול — אם משמיטים אותו, WCF מפענח אותו כ-`false` והספק נוצר **לא פעיל** בלי אזהרה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "supplier": {
    "Name": "Global Electronics Inc",
    "ContactEmail": "sales@globalelectronics.com",
    "ContactPhone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "ContactEmail": "sales@globalelectronics.com",
    "ContactPhone": "03-9876543",
    "City": "Tel Aviv",
    "Country": "Israel",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` (403) | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |
| `InventorySupplierNameExists` (401) | ‫קיים כבר ספק אחר עם שם זהה בארגון.‬ |

‫ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior) לצורת המעטפה המלאה בשתי השורות הראשונות למעלה.‬

---

## ‫עדכון ספק‬

‫מעדכן ספק קיים לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateSupplier` |
| ‫**תשובה**‬ | ‫אובייקט `Supplier`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `supplier` | Supplier | ‫כן‬ | ‫הספק לעדכון. חייב לכלול `Id`.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "supplier": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel"
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
    "Errors": []
  }
}
```

### ‫התנהגות ידועה: עדכון עם אותו שם נכשל‬

‫בדיקת הכפילות בשם עבור `UpdateSupplier` מחפשת כל ספק עם אותו `Name` בארגון, אך אינה מוציאה מהבדיקה את הספק המתעדכן עצמו. לכן עדכון ששומר על ה-`Name` הקיים ללא שינוי עלול להחזיר `InventorySupplierNameExists` (401) גם כאשר אף ספק *אחר* לא נושא את השם הזה. פתרון עקיפה: שלחו שם זמני שונה תחילה, או הימנעו משליחת `Name` שלא השתנה, עד שהתקלה תתוקן בצד השרת.‬

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` (403) | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |
| `InventorySupplierNameExists` (401) | ‫ספק אחר כבר נושא שם זה — או, בשל התקלה שתוארה למעלה, אותו ספק ששמר על שמו שלו.‬ |

‫ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior) לצורת המעטפה המלאה בשתי השורות הראשונות.‬

---

## ‫שליפת ספק לפי מזהה‬

‫מחזיר ספק ספציפי לפי מזהה.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetSupplier` |
| ‫**תשובה**‬ | ‫אובייקט `Supplier`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `id` | int | ‫כן‬ | ‫מזהה הספק לשליפה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetSupplier HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "id": 12,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 12,
    "Name": "Global Electronics Inc",
    "ContactEmail": "support@globalelectronics.com",
    "ContactPhone": "03-9876544",
    "City": "Ramat Gan",
    "Country": "Israel",
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/פג תוקף או רכיב מלאי כבוי מחזירים אובייקט `Supplier` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת כל הספקים‬

‫מחזיר את כל הספקים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetSuppliers` |
| ‫**תשובה**‬ | `Supplier[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetSuppliers HTTP/1.1
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
      "Id": 12,
      "Name": "Global Electronics Inc",
      "ContactEmail": "support@globalelectronics.com",
      "ContactPhone": "03-9876544",
      "City": "Ramat Gan",
      "Country": "Israel",
      "Errors": []
    },
    {
      "Id": 13,
      "Name": "Local Parts Ltd",
      "ContactEmail": "info@localparts.co.il",
      "ContactPhone": "02-5555555",
      "City": "Jerusalem",
      "Country": "Israel",
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/פג תוקף או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬
