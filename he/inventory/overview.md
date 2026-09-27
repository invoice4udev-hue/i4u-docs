# ‫סקירת מתודות מלאי‬

‫ממשקי ניהול המלאי מספקים כלים לניהול פריטי מלאי, יתרות מלאי, ספקים, מחסנים ותמחור. מתודות אלו מאפשרות יצירה וניהול של פריטים, קטגוריות, ספקים, מחסנים ומחירונים.‬

‫> **זה לא קטלוג הפריטים.** מתודות אלו עובדות על פריטי מלאי ודורשות את רכיב המלאי. לקריאת קטלוג הפריטים הרגיל (זמין לכל חשבון, ללא צורך ברכיב המלאי), ראו [קטלוג פריטים](../catalog/overview.md).‬

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
* ‫מעטפת התשובה: כל התשובות יורשות ממבנה מעטפת בסיסי עם השדות `Errors` (מערך), `Info` ו-`OpenInfo`. בדקו את `Errors.Count()` כדי לוודא הצלחה — למעט במתודות המפורטות בטבלה למטה, שאינן מחזירות אובייקט מעטפת כלל עבור חלק או כל אחד משלושת המקרים: טוקן לא תקין, חשבון שפג תוקפו, ורכיב מלאי כבוי (שלושת המקרים אינם מטופלים תמיד באותו אופן — ראו הטבלה).‬
* ‫אימות טוקן: טוקן חסר/לא תקין וחשבון שפג תוקפו **אינם** אותה תקלה, והמתודות אינן תמיד מטפלות בהן באותו אופן — ראו הטבלה למטה.‬
* ‫**תאריכים**: כל שדה `DateTime`/`DateTime?` בבקשה ובתשובה משתמש בפורמט התאריך של WCF: `"/Date(<מילישניות-מאז-epoch><±hhmm>)/"`. מחרוזות תאריך בפורמט ISO אינן נתמכות.‬
* ‫**תמיכה ב-RTL**: טקסט בעברית נתמך בכל שדות המחרוזת הרלוונטיים.‬

### ‫התנהגות כאשר הטוקן לא תקין/פג תוקף, או שרכיב המלאי כבוי‬ {#module-inactive-behavior}

‫כל מתודת מלאי קוראת ל-`IsAuthenticated` ולאחר מכן ל-`IsInventoryUser` לפני ביצוע כל פעולה ממשית — אבל מה שמוחזר בפועל כשמשהו נכשל תלוי בדיוק *באיזו* בדיקה נכשלה, ונקודה זו קל לטעות בה:‬

* ‫**טוקן חסר או שלא ניתן לפענח** גורם ל-`IsAuthenticated` עצמה להחזיר `null` (אומת בבדיקה חיה: `IsAuthenticated` עם מפתח שגוי מחזיר `{"d":null}`). השורה הראשונה בכל מתודה אחרי הקריאה הזו היא `if (u.Errors.Count() > 0)` — מכיוון ש-`u` הוא `null`, זה זורק `NullReferenceException` **לפני שנבנה אובייקט שגיאה כלשהו**. בלוק ה-`catch` של המתודה רק רושם ליומן את החריגה; הוא אינו מאפס את ערך ההחזרה. לכן טוקן לא תקין לחלוטין מחזיר את מה שמשתנה ההחזרה של המתודה אותחל אליו *לפני* בלוק ה-`try` (בדרך כלל `null`, לעיתים מערך/רשימה ריקים, ובמקרה אחד חריגה בלתי מטופלת — ראו הטבלה).‬
* ‫**חשבון שפג תוקפו** (`ExpiredAccount`, 66, מתווסף על ידי `IsAuthenticated` כאשר `ExpirationDate.AddDays(4) < DateTime.Now`) אינו גורם לקריסה הזו: `IsAuthenticated` עדיין מחזירה `User` אמיתי ולא-`null`, כך ש-`u.Errors.Count() > 0` מוערך כרגיל (ללא חריגה) ומתודת ה-API מריצה את ענף "לא מורשה" בכוונה, בונה אובייקט שגיאה חדש ומוסיפה לו `UnauthorizedUser` (80) — קוד ה-`ExpiredAccount` המקורי נזרק ומוחלף.‬
* ‫**רכיב מלאי כבוי** (טוקן תקין, אך `IsInventoryUser` הוא `false`) נבדק *אחרי* בדיקת הטוקן, כך שבשלב הזה `u` מובטח להיות לא-`null`; כל מתודה מגיעה לענף הזה כרגיל ובונה אובייקט שגיאה אמיתי עם `UnauthorizedInventoryAttempt` (403) — למעט קבוצת המתודות הקטנה עם תקלת ההפניה ל-null המתוארת למטה, שחלה גם על הענף הזה.‬

| ‫מתודה‬ | ‫טוקן חסר/לא תקין‬ | ‫חשבון שפג תוקפו‬ | ‫רכיב מלאי כבוי‬ |
| --- | --- | --- | --- |
| `CreateInventoryCategory`, `UpdateInventoryCategory`, `GetInventoryCategoryById`, `GetHighestByValue`, `ReceiveToStock` | `null` | ‫`null` (אותה תקלת הפניה ל-null חוזרת כשהמתודה מנסה להוסיף את השגיאה למשתנה ההחזרה שלה שעדיין `null`)‬ | ‫`null` (אותה תקלה)‬ |
| `RemoveCustomerFromInventoryPricelist` | `false` | `false` | `false` |
| `GetInventoryCategories`, `GetSuppliers`, `GetWarehouses`, `GetInventoryPricelists`, `GetInventoryPricelistByCustomerId`, `GetInventoryPricelistByCustomerIds`, `GetInventoryItems`, `GetActiveInventoryItems`, `GetTopSoldItems` | `null` | ‫מערך בעל איבר אחד הנושא `UnauthorizedUser` (80)‬ | ‫מערך בעל איבר אחד הנושא `UnauthorizedInventoryAttempt` (403)‬ |
| `CreateSupplier`, `UpdateSupplier`, `GetSupplier`, `CreateWarehouse`, `UpdateWarehouse`, `AddInventoryPricelist`, `UpdateInventoryPricelist`, `CreateInventoryItem`, `UpdateInventoryItem` | `null` | ‫אובייקט הנושא `UnauthorizedUser` (80)‬ | ‫אובייקט הנושא `UnauthorizedInventoryAttempt` (403)‬ |
| `GetInventoryItem` | ‫**חריגה בלתי מטופלת — תשובת WCF fault, לא גוף `{"d": …}` נקי.**¹‬ | ‫אובייקט `Item` הנושא `UnauthorizedUser` (80)‬ | ‫אובייקט `Item` הנושא `UnauthorizedInventoryAttempt` (403)‬ |
| `GetInventoryCostReport`, `GetTotalMovementReport` | ‫מערך ריק (`{"d":[]}`)‬ | ‫מערך בעל איבר אחד הנושא `UnauthorizedUser` (80)‬ | ‫מערך בעל איבר אחד הנושא `UnauthorizedInventoryAttempt` (403)‬ |
| `GetItemsMovementReport` | `null` (`{"d":null}`) | ‫אובייקט `ItemsMovement` הנושא `UnauthorizedUser` (80), כאשר `Item` ו-`ItemsBalance` שניהם `null`‬ | ‫אותה צורה, הנושאת `UnauthorizedInventoryAttempt` (403)‬ |

‫¹ בלוק ה-`catch` של `GetInventoryItem` רק רושם ליומן ואינו מקצה מחדש את המערך שלו, כך שהשורה האחרונה של המתודה — `return items.FirstOrDefault();`, שרצה *אחרי* בלוק ה-`catch` ולא בתוכו — זורקת `NullReferenceException` שנייה ובלתי מטופלת עבור טוקן לא תקין לחלוטין. צפו לתשובת WCF/ASP.NET fault, לא למעטפת JSON עם `d`.‬

‫אף אחת מהמתודות הללו אינה קובעת סטטוס שגיאת HTTP מפורש עבור המקרים שכן חוזרים בצורה נקייה — אלה חוזרים כ-`200 OK` עם הגוף שמוצג למעלה.‬

### ‫תהליך ניהול מלאי טיפוסי‬

1. ‫**הקמה**: צרו קטגוריות, ספקים ומחסנים.‬
2. ‫**פריטים**: הגדירו פריטי מלאי עם קטגוריות וגרסאות.‬
3. ‫**תמחור**: צרו מחירונים ושייכו אותם ללקוחות.‬
4. ‫**מלאי**: קלטו פריטים, עקבו אחר תנועות והפיקו דוחות.‬
5. ‫**דיווח**: שלפו דוחות עלות, הנמכרים ביותר ובעלי הערך הגבוה ביותר.‬
