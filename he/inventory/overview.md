# ‫סקירת מתודות מלאי‬

‫ממשקי ניהול המלאי מספקים כלים לניהול פריטי מלאי, יתרות מלאי, ספקים, מחסנים ותמחור. מתודות אלו מאפשרות יצירה וניהול של פריטים, קטגוריות, ספקים, מחסנים ומחירונים.‬

> ‫**זה לא קטלוג הפריטים.** מתודות אלו עובדות על פריטי מלאי ודורשות את רכיב המלאי. לקריאת קטלוג הפריטים הרגיל (זמין לכל חשבון, ללא צורך ברכיב המלאי), ראו [קטלוג פריטים](../catalog/overview.md).‬

### ‫מתודות בסקשן הזה‬

| ‫מתודה‬ | ‫עמוד‬ |
| -------- | ---- |
| `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetInventoryCategories` | ‫[קטגוריות פריטים](categories.md)‬ |
| `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `GetSuppliers` | ‫[ספקים](suppliers.md)‬ |
| `CreateWarehouse`, `UpdateWarehouse`, `GetWarehouses` | ‫[מחסנים](warehouses.md)‬ |
| `AddInventoryPricelist`, `UpdateInventoryPricelist`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`, `RemoveCustomerFromInventoryPricelist` | ‫[מחירונים](pricelists.md)‬ |
| `GetInventoryItems`, `GetActiveInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem` | ‫[פריטי מלאי](items.md)‬ |
| `GetInventoryCostReport`, `GetTopSoldItems`, `GetHighestByValue` | ‫[דוחות מלאי](reports.md)‬ |
| `ReceiveToStock` | ‫[קליטה למלאי](receive-to-stock.md)‬ |

### ‫דרישות‬

‫כל מתודות המלאי דורשות:‬
- ‫**אימות**: טוקן API תקין בפרמטר `token`‬
- ‫**משתמש מלאי**: לחשבון המשתמש שלכם חייבת להיות הרשאה לרכיב המלאי (נבדק באמצעות `IsInventoryUser`)‬
- ‫**ארגון**: כל הפעולות מוגבלות לארגון המאומת שלכם‬

### ‫דפוסים נפוצים‬

* ‫**סינון**: רוב מתודות הרשימה מקבלות פרמטר `isActive` אופציונלי לסינון לפי סטטוס.‬
* ‫**מעטפת התשובה**: כל התשובות יורשות ממבנה מעטפת בסיסי עם השדות `Errors` (מערך), `Info` ו-`OpenInfo`. בדקו את `Errors.Count()` כדי לוודא הצלחה.‬
* ‫**אימות טוקן**: כל מתודה מאמתת קודם את טוקן האימות; טוקן חסר או לא תקין מחזיר שגיאת `UnauthorizedUser` (80).‬
* ‫**תמיכה ב-RTL**: טקסט בעברית נתמך בכל שדות המחרוזת הרלוונטיים.‬

### ‫תהליך ניהול מלאי טיפוסי‬

1. ‫**הקמה**: צרו קטגוריות, ספקים ומחסנים.‬
2. ‫**פריטים**: הגדירו פריטי מלאי עם קטגוריות וגרסאות.‬
3. ‫**תמחור**: צרו מחירונים ושייכו אותם ללקוחות.‬
4. ‫**מלאי**: קלטו פריטים, עקבו אחר תנועות והפיקו דוחות.‬
5. ‫**דיווח**: שלפו דוחות עלות, הנמכרים ביותר ובעלי הערך הגבוה ביותר.‬
