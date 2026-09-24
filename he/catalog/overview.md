# ‫סקירת מתודות קטלוג פריטים‬

‫הקטלוג הוא רשימת המוצרים והשירותים של הארגון: קוד, שם, מחיר ומע"מ. זהו אותו קטלוג פריטים שקיים לכל חשבון Invoice4U באתר. **הוא אינו דורש את רכיב המלאי.**‬

### ‫זמינות‬

| ‫מתודה‬ | ‫פעולה‬ | ‫דורש רכיב מלאי‬ |
| ----- | ----- | -------------- |
| [`GetCatalogItems`](get-catalog-items.md) | ‫קריאה (רשימה)‬ | ‫לא‬ |
| [`GetCatalogItemByCode`](get-catalog-item-by-code.md) | ‫קריאה (פריט בודד לפי קוד)‬ | ‫לא‬ |

* ‫**קריאה בלבד.** אין ב-API מתודה ליצירה, עדכון או מחיקה של פריטי קטלוג. ניהול הקטלוג מתבצע באתר Invoice4U.‬
* ‫**אין חיפוש חופשי.** `GetCatalogItems` מחזירה את הרשימה המלאה (סננו בצד שלכם); `GetCatalogItemByCode` מחפשת לפי התאמה מדויקת של קוד.‬
* ‫**מתודות המלאי נפרדות.** `GetInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem` ושאר מתודות ה-`*Inventory*` עובדות על פריטי מלאי, לא על הקטלוג, ודורשות רכיב מלאי פעיל. בלעדיו הן מחזירות `UnauthorizedInventoryAttempt` (403). ראו [סקירת מתודות מלאי](../inventory/overview.md).‬

### ‫אובייקט ה-CatalogItem‬

| ‫שדה‬ | ‫טיפוס‬ | ‫תיאור‬ |
| --- | ----- | ----- |
| `ID` | int | ‫מזהה פריט הקטלוג.‬ |
| `UserId` | int | ‫מזהה הארגון.‬ |
| `Code` | string | ‫קוד הפריט (מק"ט). מחרוזת ריקה אם לא הוגדר.‬ |
| `Name` | string | ‫שם הפריט.‬ |
| `Price` | double | ‫מחיר יחידה לפני מע"מ.‬ |
| `PriceAfterTax` | double | ‫מחיר יחידה כולל מע"מ.‬ |
| `VatPercentage` | double | ‫אחוז המע"מ של הפריט.‬ |
| `IsActive` | boolean | ‫האם הפריט פעיל. מוחזר רק ב-`GetCatalogItems` (אחרת `null`).‬ |
| `IsNonStockItem`, `TotalQuantityInStock`, `TotalQuantity`, `SerialNumber`, `BatchNumber`, `IsNew` | — | ‫שדות הקשורים למלאי. התעלמו מהם בחשבונות ללא רכיב המלאי.‬ |

‫האובייקט כולל גם את שדות המעטפת הסטנדרטיים `Errors` / `Info`.‬

### ‫עמודים בסקשן הזה‬

* ‫[שליפת פריטי קטלוג](get-catalog-items.md) — רשימת קטלוג הארגון‬
* ‫[שליפת פריט קטלוג לפי קוד](get-catalog-item-by-code.md) — איתור פריט בודד לפי הקוד שלו‬
