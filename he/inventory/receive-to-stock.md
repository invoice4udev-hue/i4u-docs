# ‫קליטה למלאי‬

‫רשמו קליטות מלאי מספקים או החזרות.‬

## ‫קליטת פריטים למלאי‬

‫יוצרת מסמך לתיעוד פריטים שנקלטו למלאי מספק. מתודה זו משמשת כמעטפת סביב יצירת מסמך עם ולידציה ייעודית למלאי.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/ReceiveToStock` |
| ‫**תשובה**‬ | ‫אובייקט `Document`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `doc` | Document | ‫כן‬ | ‫המסמך שמייצג את הקליטה. בדרך כלל משתמש בסוג מסמך לקליטות מלאי. חייב לכלול פריטים עם כמויות.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫הערות‬

- ‫מתודה זו מוודאת שלמשתמש יש הרשאות מלאי לפני קריאה למתודת `CreateDocument` הסטנדרטית.‬
- ‫יש להגדיר את המסמך כסוג מסמך קבלה או קבלת רכש (ראו [סוגי מסמכים](../documents/document-types.md)).‬
- ‫לכל הפריטים חייבות להיות הפניות `ItemId` תקינות לפריטי מלאי קיימים.‬
- ‫הקליטה יוצרת נתיב ביקורת של תנועות מלאי.‬

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/ReceiveToStock HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 5,
    "DocumentNumber": 0,
    "IssueDate": "2026-08-24",
    "ClientID": 12,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "ItemID": 1001,
        "Description": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Unit": "יחידה"
      },
      {
        "ItemID": 1002,
        "Description": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Unit": "יחידה"
      }
    ]
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "ReceiveToStockResult": {
    "ID": 50001,
    "DocumentNumber": "REC-2026-1234",
    "DocumentType": 5,
    "IssueDate": "2026-08-24",
    "ClientID": 12,
    "ClientName": "Global Electronics Inc",
    "BranchID": 101,
    "Currency": "ILS",
    "TotalAmount": 31250.00,
    "Items": [
      {
        "ItemID": 1001,
        "Description": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Amount": 28000.00
      },
      {
        "ItemID": 1002,
        "Description": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Amount": 3750.00
      }
    ],
    "PrintOriginalPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

### ‫סוגי מסמכים לקליטות‬

‫סוגי מסמכים נפוצים שמשמשים לקליטות מלאי:‬

| ‫מזהה סוג‬ | ‫שם‬ | ‫שימוש‬ |
| ------- | ---- | ----- |
| 5 | ‫קבלה‬ | ‫קבלת סחורה כללית‬ |
| ‫(בדקו [סוגי מסמכים](../documents/document-types.md) לרשימה המלאה)‬ | | |

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן חסר או לא תקין.‬ |
| `UnauthorizedInventoryAttempt` | ‫למשתמש אין הרשאה לרכיב המלאי.‬ |
| `DocumentTypeNotInRange` (33) | ‫סוג מסמך לא תקין.‬ |
| `ClientDoesntExists` (7) | ‫מזהה ספק/לקוח אינו קיים.‬ |
| `DocumentItemsNotSpecified` (34) | ‫לא סופקו פריטים בקליטה.‬ |
| `DocumentItemMissingName` (39) | ‫חסרים תיאור/שם פריט.‬ |
| `DocumentItemQuantityCannotBeZero` (40) | ‫כמות הפריט חייבת להיות > 0.‬ |
| `DocumentItemPriceCannotBeZero` (41) | ‫מחיר הפריט חייב להיות > 0.‬ |

### ‫תהליך קליטה טיפוסי‬

1. ‫**הכנת פריטים**: ודאו שהפריטים קיימים במלאי (ראו [פריטי מלאי](items.md)).‬
2. ‫**יצירת מסמך**: קראו ל-`ReceiveToStock` עם פריטים וכמויות.‬
3. ‫**אימות**: בדקו את `PrintOriginalPDFLink` שחוזר כדי לצפות בקבלה.‬
4. ‫**מעקב**: השתמשו ב-`DocumentNumber` שחוזר כדי להפנות לקבלה במערכת שלכם.‬
5. ‫**דיווח**: בצעו שאילתה ל-[דוחות מלאי](reports.md) כדי לוודא עדכוני מלאי.‬

### ‫תנועת מלאי‬

‫כאשר קליטה נרשמת:‬
- ‫כמויות הפריטים במלאי גדלות.‬
- ‫בסיס העלות מתועד עבור דוחות הערכת שווי עתידיים.‬
- ‫היסטוריית התנועות נרשמת לצורכי ביקורת.‬

‫ראו [דוחות מלאי](reports.md) כדי לבצע שאילתות על דוחות עלות ולאמת תנועות מלאי.‬
