# ‫סקירת מתודות לקוחות‬

‫לקוחות ("clients") הם הגורמים שלהם אתם מפיקים מסמכים. כל לקוח שייך לארגון שלכם וניתן להפנות אליו ממסמכים באמצעות `ClientID`.‬

### ‫מתודות בסקשן הזה‬

| ‫מתודה‬ | ‫עמוד‬ |
| ----- | ---- |
| `CreateCustomer` | ‫[יצירת לקוח](create-customer.md)‬ |
| `UpdateCustomer` | ‫[עדכון לקוח](update-customer.md)‬ |
| `GetCustomerById`, `GetCustomerByName`, `GetCustomerByEmail`, `GetCustomerByGuid`, `GetCustomerByClientCode`, `GetCustomerByExternalNumber`, `GetCustomersByOrgId`, `GetCustomers`, `GetFullCustomer` | ‫[שליפת לקוחות](get-customers.md)‬ |

### ‫אובייקט ה-Customer‬ {#the-customer-object}

‫משמש כגוף הבקשה ביצירה/עדכון ומוחזר מכל מתודות השליפה. יורש את [מעטפת התשובה](../getting-started/welcome.md#response-envelope) (`Errors`, `Info`, `OpenInfo`).‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Name` | string | ‫**כן**‬ | ‫שם התצוגה של הלקוח. חייב להיות ייחודי בארגון אלא אם `IsNonUniqueNameCreation` הוא `true`.‬ |
| `ID` | int | ‫לא‬ | ‫מזהה הלקוח. `0`/מושמט ביצירה; חובה בעדכון.‬ |
| `UniqueID` | string | ‫לא‬ | ‫מספר עוסק/ח.פ/ת.ז של הלקוח. **ספרות בלבד** כאשר נשלח. נדרש לתהליכי מספרי הקצאה מול רשות המסים.‬ |
| `Email` | string | ‫לא‬ | ‫אימייל ראשי.‬ |
| `Phone` | string | ‫לא‬ | ‫טלפון קווי.‬ |
| `Cell` | string | ‫לא‬ | ‫טלפון נייד.‬ |
| `Fax` | string | ‫לא‬ | ‫פקס.‬ |
| `Address` | string | ‫לא‬ | ‫כתובת.‬ |
| `City` | string | ‫לא‬ | ‫עיר.‬ |
| `Zip` | string | ‫לא‬ | ‫מיקוד.‬ |
| `Country` / `CountryId` | string / int | ‫לא‬ | ‫שם מדינה / מזהה פנימי.‬ |
| `ExtNumber` | long | ‫לא‬ | ‫מספר הלקוח החיצוני שלכם. ייחודי בארגון. ברירת מחדל: ה-ID של הלקוח החדש אם מושמט.‬ |
| `Active` | boolean | ‫לא‬ | ‫האם הלקוח פעיל.‬ |
| `PayTerms` | int | ‫לא‬ | ‫תנאי תשלום בימים (למשל `0` = מיידי, `30` = שוטף+30). משפיע על `PaymentDueDate` האוטומטי במסמכים.‬ |
| `IsNonUniqueNameCreation` | boolean | ‫לא (ברירת מחדל `false`)‬ | ‫מאפשר יצירה/עדכון של לקוח ששמו כבר קיים.‬ |
| `Guid` | string | ‫לא‬ | ‫ה-GUID החיצוני שלכם ללקוח. ייחודי בארגון.‬ |
| `ClientCode` | int | ‫לא‬ | ‫קוד לקוח פנימי (ניתן לחיפוש).‬ |
| `ContactFirstName`, `ContactLastName`, `ContactName`, `ContactEmail` | string | ‫לא‬ | ‫פרטי איש קשר.‬ |
| `CustomerEmails` | AssociatedEmail[] | ‫לא‬ | ‫כתובות אימייל נוספות ללקוח.‬ |
| `AccountNumber`, `BankName`, `BranchName`, `BankCode`, `BranchCode` | string | ‫לא‬ | ‫פרטי בנק.‬ |
| `Website` | string | ‫לא‬ | ‫כתובת אתר.‬ |
| `InternalNote` | string | ‫לא‬ | ‫הערה חופשית. `PrintInternalNoteOnQuote` (bool) שולט בהדפסה על הצעות מחיר.‬ |
| `Retainer`, `RetainerAmount`, `RetainerTitle` | bool, double, string | ‫לא‬ | ‫הגדרות ריטיינר.‬ |
| `Discount`, `DiscountType`, `PricelistID` | decimal, int, int | ‫לא‬ | ‫הנחה / מחירון ברירת מחדל.‬ |

### ‫קודי תוצאה ביצירה/עדכון‬ {#createupdate-result-codes}

‫לאחר יצירה או עדכון, ה-`ID` המוחזר עשוי לשאת קוד שגיאה במקום מזהה אמיתי. ה-API גם מוסיף את השגיאה המתאימה ל-`Errors`:‬

| `ID` מוחזר | ‫שגיאה‬ | ‫משמעות‬ |
| ---------- | ----- | ------- |
| `-1` | `CustomerNameExists` (2) | ‫השם כבר קיים (ו-`IsNonUniqueNameCreation` הוא false).‬ |
| `-2` | `CustomerExternalNumberExists` (31) | ‫`ExtNumber` כבר בשימוש.‬ |
| `-3` | `CustomerUniqueIdExistsForUser` (78) | ‫`UniqueID` כבר בשימוש.‬ |
| `-4` | `CustomerGuidExists` (84) | ‫`Guid` כבר בשימוש.‬ |
