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
| `GetInventoryCostReport`, `GetTopSoldItems`, `GetHighestByValue`, `GetItemsMovementReport`, `GetTotalMovementReport` | ‫[דוחות מלאי](reports.md)‬ |
| `ReceiveToStock` | ‫[קליטה למלאי](receive-to-stock.md)‬ |

### ‫דרישות‬

‫כל מתודות המלאי דורשות:‬
- ‫**אימות**: טוקן API תקין בפרמטר `token`‬
- ‫**משתמש מלאי**: לחשבון המשתמש שלכם חייבת להיות הרשאה לרכיב המלאי (נבדק באמצעות `IsInventoryUser`)‬
- ‫**ארגון**: כל הפעולות מוגבלות לארגון המאומת שלכם‬

### ‫דפוסים נפוצים‬

* ‫**סינון**: רוב מתודות הרשימה מקבלות פרמטר `isActive` אופציונלי לסינון לפי סטטוס. פילטרים אופציונליים (`isActive`, טווחי תאריכים, `serialNumber`, `batchNumber`, `customerID` וכדומה) יש להשמיט מהבקשה או לשלוח כ-`null` ב-JSON — לעולם לא כמחרוזת ריקה `""`. השרת מעביר פילטר לפרוצדורה המאוחסנת רק כשהוא קיים בפועל.‬
* ‫**מעטפת התשובה**: כל התשובות יורשות ממבנה מעטפת בסיסי עם השדות `Errors` (מערך), `Info` ו-`OpenInfo`. בדקו את `Errors.Count()` כדי לוודא הצלחה — למעט במתודות המפורטות בטבלה למטה, שאינן מחזירות אובייקט מעטפת כלל כאשר הטוקן לא תקין/פג תוקף או שרכיב המלאי כבוי.‬
* ‫**אימות טוקן**: רוב המתודות מאמתות תחילה את טוקן האימות ומחזירות אובייקט שגיאה `UnauthorizedUser` (80) כאשר הוא לא תקין או פג תוקף — ראו בטבלה למטה אילו מתודות אינן פועלות כך.‬
* ‫**תאריכים**: כל שדה `DateTime`/`DateTime?` בבקשה ובתשובה משתמש בפורמט התאריך של WCF: `"/Date(<מילישניות-מאז-epoch><±hhmm>)/"`. מחרוזות תאריך בפורמט ISO אינן נתמכות.‬
* ‫**תמיכה ב-RTL**: טקסט בעברית נתמך בכל שדות המחרוזת הרלוונטיים.‬

### ‫התנהגות כאשר הטוקן לא תקין/פג תוקף, או שרכיב המלאי כבוי‬ {#module-inactive-behavior}

‫כל מתודת מלאי קוראת ל-`IsAuthenticated` ולאחר מכן ל-`IsInventoryUser` לפני ביצוע כל פעולה ממשית. מה שמוחזר בפועל כאשר אחת הבדיקות נכשלת **אינו** זהה בכל המתודות — רובן בונות אובייקט שגיאה תקין, אך בחלקן קיימת תקלת הפניה ל-null (null-reference bug) או `return` מוקדם שמדלג על בניית אובייקט השגיאה לחלוטין. בדקו בטבלה הזו לפני שאתם מניחים שמתודה מסוימת פועלת לפי החוזה הכללי שתואר למעלה.‬

| ‫מה מוחזר‬ | ‫מתודות‬ |
| --- | --- |
| ‫אובייקט שגיאה תקין (או, במתודות רשימה, מערך בעל איבר אחד) הנושא את `UnauthorizedUser` (80) עבור טוקן לא תקין/פג תוקף, או `UnauthorizedInventoryAttempt` (403) עבור טוקן תקין ללא הרשאת רכיב מלאי‬ | ‫`GetInventoryCategories`; `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `GetSuppliers`; `CreateWarehouse`, `UpdateWarehouse`, `GetWarehouses`; `AddInventoryPricelist`, `UpdateInventoryPricelist`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`; `GetInventoryItems`, `GetActiveInventoryItems`, `GetInventoryItem`, `CreateInventoryItem`, `UpdateInventoryItem`; `GetInventoryCostReport`; `GetTopSoldItems`; `GetItemsMovementReport` (אובייקט שגיאה שבו `Item` ו-`ItemsBalance` הם `null`); `GetTotalMovementReport` (כמערך בעל איבר אחד)‬ |
| ‫`null` — תקלת הפניה ל-null מבטלת את אובייקט השגיאה לפני שניתן להוסיף אליו שגיאה (`CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`), או שהמתודה חוזרת מוקדם מבלי לבנות אובייקט שגיאה כלל (`GetHighestByValue`, `ReceiveToStock`)‬ | `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetHighestByValue`, `ReceiveToStock` |
| `false` | `RemoveCustomerFromInventoryPricelist` |

‫אף אחת מהמתודות הללו אינה קובעת סטטוס שגיאת HTTP מפורש — הכול חוזר כ-`200 OK` עם הגוף שתואר למעלה (או בצורת "טוקן לא תקין" המפורטת בעמוד של כל מתודה, לדוגמה `GetItemsMovementReport`/`GetTotalMovementReport` שמחזירות `{"d":null}`/`{"d":[]}` עבור טוקן לא תקין לחלוטין, במקום אובייקט שגיאה).‬

### ‫תהליך ניהול מלאי טיפוסי‬

1. ‫**הקמה**: צרו קטגוריות, ספקים ומחסנים.‬
2. ‫**פריטים**: הגדירו פריטי מלאי עם קטגוריות וגרסאות.‬
3. ‫**תמחור**: צרו מחירונים ושייכו אותם ללקוחות.‬
4. ‫**מלאי**: קלטו פריטים, עקבו אחר תנועות והפיקו דוחות.‬
5. ‫**דיווח**: שלפו דוחות עלות, הנמכרים ביותר ובעלי הערך הגבוה ביותר.‬
