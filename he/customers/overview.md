# ‫סקירת מתודות לקוחות‬

‫לקוחות ("clients") הם הגורמים שלהם אתם מפיקים מסמכים. כל לקוח שייך לארגון שלכם וניתן להפנות אליו ממסמכים באמצעות `ClientID`.‬

### ‫מתודות בסקשן הזה‬

| ‫מתודה‬ | ‫עמוד‬ |
| ----- | ---- |
| `CreateCustomer` | ‫[יצירת לקוח](create-customer.md)‬ |
| `UpdateCustomer` | ‫[עדכון לקוח](update-customer.md)‬ |
| `GetCustomerById`, `GetCustomerByName`, `GetCustomerByEmail`, `GetCustomerByGuid`, `GetCustomerByGuidInnerSearch`, `GetCustomerByClientCode`, `GetByClientCode`, `GetCustomerByExternalNumber`, `GetCustomersByOrgId`, `GetCustomers`, `GetFullCustomer` | ‫[שליפת לקוחות](get-customers.md)‬ |

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
| `AccountNumber`, `BankName`, `BranchName`, `BankCode`, `BranchCode` | string | ‫לא‬ | ‫פרטי בנק. `BankCode` ו-`BranchCode` מתקבלים אך אינם מקושרים כרגע לנתונים מאוחסנים — הם תמיד מוחזרים ריקים.‬ |
| `Website` | string | ‫לא‬ | ‫כתובת אתר.‬ |
| `InternalNote` | string | ‫לא‬ | ‫הערה חופשית. `PrintInternalNoteOnQuote` (bool) שולט בהדפסה על הצעות מחיר.‬ |
| `Retainer`, `RetainerAmount`, `RetainerTitle` | bool, double, string | ‫לא‬ | ‫הגדרות ריטיינר.‬ |
| `Discount`, `DiscountType`, `PricelistID` | decimal, int, int | ‫לא‬ | ‫הנחה / מחירון ברירת מחדל.‬ |

### ‫שדות נוספים המוחזרים‬

‫ה-API מסריאליז גם את שדות ה-`Customer` הבאים בכל תשובה. שדות המסומנים **read-only** מנוהלים על ידי השרת — כל ערך שתשלחו עבורם ב-`CreateCustomer`/`UpdateCustomer` מתעלם ממנו.‬

| ‫שדה‬ | ‫טיפוס‬ | ‫Read-only‬ | ‫תיאור‬ |
| --- | ----- | :---: | ----- |
| `OrgID` | int | ‫כן‬ | ‫הארגון שאליו שייך הלקוח. תמיד נקבע מהטוקן שלכם.‬ |
| `DateCreated` | date | ‫כן‬ | ‫מועד יצירת הלקוח. מוחזר על ידי מתודות הרשימה/החיפוש (`GetCustomers`, `GetCustomersByOrgId`) כאשר קיים.‬ |
| `IdNewAndOldSystem` | string | ‫כן‬ | ‫מזהה פנימי המגשר בין המערכת הישנה לחדשה.‬ |
| `HasBeenExported` | boolean | ‫—‬ | ‫האם הלקוח סומן כמיוצא להנהלת חשבונות. נקבע על ידי תהליך הייצוא, לא על ידי `CreateCustomer`/`UpdateCustomer`; ניתן לשימוש כפילטר ב-[`GetCustomers`](get-customers.md).‬ |
| `FreeUniqueID` | string | ‫לא‬ | ‫שדה מזהה חופשי. ניתן לשימוש גם כפילטר ב-`GetCustomers`.‬ |
| `FreeZip` | string | ‫לא‬ | ‫שדה מיקוד משני.‬ |
| `Ucan2ClientID` | int | ‫לא‬ | ‫קישור פנימי למערכת ה-Ucan2 הישנה, אם קיים.‬ |
| `CreditCardNumber` | string | ‫כן‬ | ‫פרטי כרטיס אשראי מאוחסנים (מוסתרים) המשמשים לחיוב ריטיינר/הוראת קבע.‬ |
| `CreditCardType` | int | ‫כן‬ | ‫קוד סוג הכרטיס.‬ |
| `NameAccounting`, `EmailAccounting`, `PhoneAccounting` | string | ‫לא‬ | ‫פרטי איש קשר המשמשים לייצוא להנהלת חשבונות חיצונית.‬ |
| `IsFromLead` | boolean | ‫לא‬ | ‫האם הלקוח מקורו בליד CRM.‬ |
| `LeadId` | int | ‫לא‬ | ‫מזהה ה-CRM לליד המקושר.‬ |
| `HasToken` | boolean | ‫כן‬ | ‫האם קיים טוקן תשלום שמור ללקוח — ערך הטוקן עצמו אינו מוחזר לעולם.‬ |
| `PaymentDetailsIsDefault` | boolean | ‫כן‬ | ‫האם פרטי התשלום המאוחסנים הם ברירת המחדל של הלקוח. מוחזר רק על ידי `GetFullCustomer`/`GetCustomerById`.‬ |

‫`IsUniqueIdValid`, `IsAutomaicInvoices`, `AddToMailChimp`, `Token`, `BankNameEnglish`, `BranchNameEnglish` ו-`FreeBalance` מסריאליזים גם הם על `Customer` אך אינם מאוכלסים כרגע על ידי אף מתודה — הם תמיד מוחזרים ריקים/כברירת מחדל.‬

### ‫קודי תוצאה ביצירה/עדכון‬ {#createupdate-result-codes}

‫לאחר יצירה או עדכון, ה-`ID` המוחזר עשוי לשאת קוד שגיאה במקום מזהה אמיתי. ה-API גם מוסיף את השגיאה המתאימה ל-`Errors`:‬

| `ID` מוחזר | ‫שגיאה‬ | ‫משמעות‬ |
| ---------- | ----- | ------- |
| `-1` | `CustomerNameExists` (2) | ‫השם כבר קיים (ו-`IsNonUniqueNameCreation` הוא false).‬ |
| `-2` | `CustomerExternalNumberExists` (31) | ‫`ExtNumber` כבר בשימוש.‬ |
| `-3` | `CustomerUniqueIdExistsForUser` (78) | ‫`UniqueID` כבר בשימוש.‬ |
| `-4` | `CustomerGuidExists` (84) | ‫`Guid` כבר בשימוש.‬ |
