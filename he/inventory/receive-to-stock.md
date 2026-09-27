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
| `doc` | Document | ‫כן‬ | המסמך שמייצג את הקליטה. השתמשו ב-`DocumentType: 10` (`SupplierInvoiceToInventory`) כדי לקבל השפעה על המלאי — ראו [ולידציה בפועל](#actual-validation). כללו `SupplierId`, `AddToInventory: true`, ומערך `Items[]` עם `Name`, `Quantity`, `Price`, `InventoryId` (קישור לפריט המלאי), ואופציונלית `WarehouseId`. |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫הערות‬

- ‫מתודה זו מוודאת שלמשתמש יש הרשאות מלאי לפני קריאה למתודת `CreateDocument` הסטנדרטית — היא אינה מוסיפה ולידציה ייעודית למלאי משלה מעבר למה ש-`CreateDocument` כבר עושה עבור `DocumentType: 10`.‬
- ‫פריטים מקושרים לפריטי מלאי דרך `InventoryId` (לא `ItemId`), ואופציונלית למחסן ספציפי דרך `WarehouseId`. שניהם מגיעים מהמתודות [פריטי מלאי](items.md) ו[מחסנים](warehouses.md).‬
- ‫הקליטה יוצרת נתיב ביקורת של תנועות מלאי, הנראה דרך [דוחות מלאי](reports.md).‬

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/ReceiveToStock HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 10,
    "DocumentNumber": 0,
    "IssueDate": "/Date(1787518800000+0300)/",
    "SupplierId": 12,
    "AddToInventory": true,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "Name": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "InventoryId": 1001,
        "WarehouseId": 101
      },
      {
        "Name": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "InventoryId": 1002,
        "WarehouseId": 101
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
    "ID": "3f2b9c1e-7a4d-4e8b-9c1a-2b3c4d5e6f70",
    "DocumentNumber": 20260501,
    "DocumentType": 10,
    "IssueDate": "/Date(1787518800000+0300)/",
    "SupplierId": 12,
    "SupplierName": "Global Electronics Inc",
    "AddToInventory": true,
    "BranchID": 101,
    "Currency": "ILS",
    "Items": [
      {
        "Name": "Laptop Pro",
        "Quantity": 10,
        "Price": 2800.00,
        "Total": 28000.00,
        "InventoryId": 1001,
        "WarehouseId": 101
      },
      {
        "Name": "Wireless Mouse",
        "Quantity": 50,
        "Price": 75.00,
        "Total": 3750.00,
        "InventoryId": 1002,
        "WarehouseId": 101
      }
    ],
    "PrintOriginalPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newviewqa.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

### ‫סוג המסמך לקליטות מלאי‬

‫`ReceiveToStock` הוא בעצם `CreateDocument` עם בדיקת הרשאת מלאי לפניו — הוא אינו מגביל אילו `DocumentType` שולחים. רק **`10`** (`SupplierInvoiceToInventory`) מחובר לעדכון כמויות המלאי, ומדלג על בדיקת קיום הלקוח הרגילה (כך ש-`SupplierId` — לא `ClientID` — מזהה את הצד השני). שליחת סוג אחר יוצרת מסמך רגיל ללא השפעה על המלאי. ראו [סוגי מסמכים](../documents/document-types.md) לרשימה המלאה.‬

### ‫ולידציה בפועל‬ {#actual-validation}

- ‫**השפעה על המלאי דורשת `DocumentType: 10`.** סוגי מסמכים אחרים יוצרים מסמך כרגיל אך אינם מזיזים כמויות מלאי.‬
- ‫**קליטה עם פריט בודד וללא `InventoryId` נכשלת בשגיאה מטעה.** עבור `DocumentType: 10`, אם `Items` מכיל **פריט אחד בדיוק** וה-`InventoryId` שלו חסר או `0`, התשובה נושאת את `DocumentItemPriceCannotBeZero` (41) — למרות שהבעיה בפועל היא ה-`InventoryId` החסר, לא המחיר. הבדיקה הזו אינה מופעלת כאשר יש שני פריטים או יותר.‬
- ‫**`WarehouseId` מתקבל אך אינו מאומת.** הוא נכתב לפריט המסמך רק אם שולחים אותו; אין בדיקה שהמחסן קיים או פעיל.‬
- ‫**טוקן לא תקין או רכיב מלאי כבוי מחזירים `null`**, ולא אובייקט שגיאה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `DocumentTypeNotInRange` (33) | ‫סוג מסמך לא תקין.‬ |
| `DocumentItemsNotSpecified` (34) | ‫לא סופקו פריטים בקליטה.‬ |
| `DocumentItemMissingName` (39) | ‫חסר `Name` של הפריט.‬ |
| `DocumentItemQuantityCannotBeZero` (40) | ‫כמות הפריט חייבת להיות > 0.‬ |
| `DocumentItemPriceCannotBeZero` (41) | ‫מחיר הפריט חייב להיות > 0 — או, עבור קליטה עם פריט בודד מסוג `DocumentType: 10`, `InventoryId` חסר (ראו [ולידציה בפועל](#actual-validation)).‬ |

### ‫תהליך קליטה טיפוסי‬

1. ‫**הכנת פריטים**: ודאו שהפריטים קיימים במלאי (ראו [פריטי מלאי](items.md)).‬
2. ‫**יצירת מסמך**: קראו ל-`ReceiveToStock` עם `DocumentType: 10`, `SupplierId`, `AddToInventory: true`, ופריטים עם `InventoryId`.‬
3. ‫**אימות**: בדקו את `PrintOriginalPDFLink` שחוזר כדי לצפות בקבלה.‬
4. ‫**מעקב**: השתמשו ב-`DocumentNumber` שחוזר כדי להפנות לקבלה במערכת שלכם.‬
5. ‫**דיווח**: בצעו שאילתה ל-[דוחות מלאי](reports.md) כדי לוודא עדכוני מלאי.‬

### ‫תנועת מלאי‬

‫כאשר קליטה מסוג `DocumentType: 10` נרשמת:‬
- ‫כמויות הפריטים במלאי גדלות.‬
- ‫בסיס העלות מתועד עבור דוחות הערכת שווי עתידיים.‬
- ‫היסטוריית התנועות נרשמת לצורכי ביקורת.‬

‫ראו [דוחות מלאי](reports.md) כדי לבצע שאילתות על דוחות עלות ולאמת תנועות מלאי.‬
