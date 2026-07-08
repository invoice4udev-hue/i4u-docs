# ‫אובייקט המסמך‬

‫תיעוד מלא של שדות אובייקט ה-`Document` והאובייקטים הבנים שלו. שדות המסומנים **כן** הם חובה ליצירת מסמך; דרישות מותנות תלויות ב[סוג המסמך](document-types.md).‬

## Document

### ‫שדות ליבה (בקשה)‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `DocumentType` | int | ‫**כן**‬ | ‫ראו [סוגי מסמכים](document-types.md).‬ |
| `Subject` | string | ‫מומלץ‬ | ‫נושא/כותרת המסמך.‬ |
| `ClientID` | int | ‫מותנה‬ | ‫מזהה לקוח קיים. חובה אלא אם נשלח `GeneralCustomer` (מותר לחשבונית מס קבלה, חשבונית זיכוי, הצעת מחיר) או שהסוג אינו דורש לקוח (הפקדה, חשבונית ספק למלאי, הזמנת רכש, חשבונית עצמית).‬ |
| `GeneralCustomer` | GenerelCustomer | ‫מותנה‬ | ‫לקוח מזדמן: `{ "Name": "...", "Identifier": "..." }`. נדחה בסוגים הדורשים לקוח אמיתי (`TypeOfDocumentDoesntAllowGeneralCustomer`, 38).‬ |
| `Items` | DocumentItem[] | ‫מותנה‬ | ‫שורות פריטים. חובה בסוגים מבוססי פריטים.‬ |
| `Payments` | Payment[] | ‫מותנה‬ | ‫תשלומים. חובה בקבלה / חשבונית מס קבלה / הפקדה.‬ |
| `Invoices` | Document[] | ‫מותנה‬ | ‫מסמכים מקושרים (כל אחד עם `ID` ו-`ReceiptAmount`). ראו [כללי הפניות](document-types.md#documentrefftype).‬ |
| `DocumentReffType` | int | ‫מותנה‬ | ‫סוג המסמכים המקושרים; חובה כאשר `Invoices` בשימוש.‬ |
| `IssueDate` | datetime | ‫לא‬ | ‫ברירת מחדל: היום. לא עתידי (חוץ מתעודת משלוח: עד +3 ימים) ולא מוקדם מהמסמך האחרון שלכם מאותו סוג — אחרת `InvalidDateRange` (3).‬ |
| `Currency` | string | ‫לא‬ | ‫סמל ISO, למשל `"ILS"`, `"USD"`, `"EUR"`. ברירת מחדל: מטבע הארגון. חייב להתקיים ברשימת המטבעות (`CurrencyDoesntExists`, 36).‬ |
| `ConversionRate` | double | ‫לא‬ | ‫שער מול מטבע הארגון. נקבע אוטומטית מהשערים היומיים כאשר `0`.‬ |
| `TaxPercentage` | double | ‫לא‬ | ‫ברירת מחדל: שיעור המס של החשבון. נכפה לשיעור המע"מ החוקי במסמכים בתאריך נוכחי אלא אם חל `ForceTaxRate`; ‏`0` לעסקים פטורים ממס.‬ |
| `TaxIncluded` | boolean | ‫לא‬ | ‫האם מחירי הפריטים כוללים מע"מ.‬ |
| `Discount` | Discount | ‫לא‬ | ‫הנחה ברמת המסמך.‬ |
| `BranchID` | int | ‫לא‬ | ‫שיוך לסניף; ברירת מחדל: סניף ברירת המחדל של הארגון. מזהה לא תקין ← `BranchIDDoesntExists` (63).‬ |
| `Language` | int | ‫לא‬ | `1` עברית, `2` אנגלית. ברירת מחדל: שפת החשבון. |
| `AssociatedEmails` | AssociatedEmail[] | ‫לא‬ | ‫כתובות לשליחת המסמך בעת היצירה.‬ |
| `SmsMessages` | Sms[] | ‫לא‬ | ‫הודעות SMS לשליחה עם קישור למסמך.‬ |
| `ExternalComments` | string | ‫לא‬ | ‫הערות המודפסות על המסמך. עד 5,000 תווים (`ExternalCommentsExceededLimit`, 151).‬ |
| `InternalComments` | string | ‫לא‬ | ‫הערות פנימיות. `PrintInternalComments` ‏(bool, ברירת מחדל `true`) שולט בהדפסה.‬ |
| `EmailCustomComment` | string | ‫לא‬ | ‫הערה מותאמת אישית באימייל המשלוח.‬ |
| `ApiIdentifier` | string | ‫לא‬ | ‫מפתח האידמפוטנטיות שלכם. נוצר אוטומטית אם חסר.‬ |
| `ApiDuplicityTimeValidation` | int | ‫לא‬ | ‫חלון הכפילויות בשניות (ברירת מחדל `60`).‬ |
| `PaymentDueDate` | datetime | ‫לא‬ | ‫מחושב אוטומטית מה-`PayTerms` של הלקוח כאשר מושמט (סוגים דמויי חשבונית).‬ |
| `Deduction` | double | ‫לא‬ | ‫ניכוי מס במקור (קבלות).‬ |
| `CloseReceipt` | boolean | ‫לא‬ | ‫מאפשר קבלה שהתשלומים בה אינם תואמים במלואם לסכומים המקושרים.‬ |
| `BankAccount` | BankAccount | ‫הפקדה בלבד‬ | ‫חשבון הבנק היעד: חייב להתקיים בארגון.‬ |
| `IsSelfInvoice` | boolean | ‫לא‬ | ‫דגל חשבונית עצמית (סוג Invoice).‬ |
| `SupplierId` / `SupplierName` | int / string | ‫הזמנת רכש‬ | ‫הפניית ספק — אחד מהם חובה (`InvalidSupplier`, 218).‬ |
| `UseDecimalValues` | boolean | ‫לא‬ | ‫חישוב סכומים בדיוק עשרוני.‬ |
| `AutoFixPaymentsMismatchItems` | boolean | ‫לא‬ | ‫כשקיים פער עיגול של ±0.01 בין תשלומים לפריטים, מוסיף פריט התאמה אוטומטית במקום להיכשל. `AutoFixMismatchItemName` קובע את שמו.‬ |
| `RoundAmount` / `ToRoundAmount` | double / bool | ‫לא‬ | ‫עיגול הסכום הכולל.‬ |
| `Attachments` | array | ‫חשבונית ספק למלאי‬ | ‫קבצים מצורפים הנשמרים עם המסמך.‬ |

### ‫שדות תשובה בלבד‬

| ‫שדה‬ | ‫טיפוס‬ | ‫תיאור‬ |
| --- | ----- | ----- |
| `ID` | GUID | ‫מזהה המסמך.‬ |
| `DocumentNumber` | long | ‫המספר הרציף החוקי.‬ |
| `UniqueID` | GUID | ‫GUID ייחודי של המסמך.‬ |
| `StatusID` / `Status` | int / string | ‫ראו [סטטוסים](document-types.md#statusid).‬ |
| `Total`, `TotalWithoutTax`, `TotalTaxAmount`, `TotalTaxExempt` | double | ‫סכומים מחושבים.‬ |
| `CipherText` / `CipherTextOriginal` | string | ‫צפנים לכתובות צפייה/הדפסה.‬ |
| `PrintOriginalPDFLink` | string | ‫קישור PDF ישיר — מקור.‬ |
| `PrintCertifiedCopyPDFLink` | string | ‫קישור PDF ישיר — העתק נאמן למקור.‬ |
| `AllocationNumber` | string | ‫מספר הקצאה מרשות המסים, כאשר רלוונטי.‬ |
| `Paid`, `CreditAmount`, `Balance` | double | ‫מצב תשלומים/זיכויים.‬ |

## DocumentItem

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Name` | string | ‫**כן**‬ | ‫שם הפריט (`DocumentItemMissingName`, 39).‬ |
| `Quantity` | double | ‫**כן**‬ | ‫לא יכול להיות `0` כאשר `Price` ≠ 0 (`DocumentItemQuantityCannotBeZero`, 40).‬ |
| `Price` | double | ‫**כן**‬ | ‫מחיר יחידה. פריט בודד במחיר אפס נדחה (`DocumentItemPriceCannotBeZero`, 41), למעט תעודות משלוח/מלאי.‬ |
| `Description` | string | ‫לא‬ | ‫תיאור הפריט.‬ |
| `Code` | string | ‫לא‬ | ‫קוד קטלוגי.‬ |
| `TaxPercentage` | double | ‫לא‬ | ‫דריסת מע"מ פר פריט.‬ |
| `Discount` | Discount | ‫לא‬ | ‫הנחה פר פריט.‬ |
| `PriceIncludeTax` | double | ‫לא‬ | ‫מחיר כולל מע"מ (כאשר `TaxIncluded`).‬ |
| `InventoryId` / `WarehouseId` | int | ‫תהליכי מלאי‬ | ‫הפניות לפריט מלאי / מחסן.‬ |
| `LawyerIdentifier` | string | ‫חשבונות עו"ד‬ | `"1"` פקדונות, `"2"` הוצאות. |

## Payment

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `PaymentType` | int | ‫**כן**‬ | `1` כרטיס אשראי, `2` צ'ק, `3` העברה בנקאית, `4` מזומן, `5` אשראי, `6` ניכוי במקור, `7` אחר, `8` ביט, `9` פייבוקס. לא תקין ← `PaymentTypeOutOfRange` (51). |
| `Amount` | double | ‫**כן**‬ | ‫לא יכול להיות `0` (`PaymentAmountCannotBeZero`, 47).‬ |
| `Date` או `DateStr` | datetime / string | ‫**כן**‬ | ‫תאריך התשלום (`PaymentDateMissing`, 46).‬ |
| `NumberOfPayments` | int | ‫לא‬ | ‫מספר תשלומים בכרטיס אשראי (או `NumberOfPaymentsStr`).‬ |
| `CreditCardName` | string | ‫לא‬ | ‫שם מותג הכרטיס; מזוהה מול חברות האשראי המוגדרות אצלכם.‬ |
| `CreditCardType` | int | ‫לא‬ | ‫מזהה חברת האשראי (ראו `GetCompanies`).‬ |
| `PaymentNumber` | string | ‫לא‬ | ‫מספר צ'ק / 4 ספרות אחרונות של הכרטיס.‬ |
| `BankName`, `BranchName`, `AccountNumber` | string | ‫צ'קים/העברות‬ | ‫פרטי בנק.‬ |
| `PayerID` | string | ‫לא‬ | ‫ת.ז המשלם.‬ |
| `ExpirationDate` | string | ‫לא‬ | ‫תוקף הכרטיס.‬ |
| `PaymentTypeOtherId` / `PaymentTypeLiteral` | int / string | `PaymentType=7` | ‫תת-סוג עבור "אחר" (למשל ביט, פייפאל) / טקסט תצוגה.‬ |
| `ID` | int | ‫הפקדה‬ | ‫מזהה תשלום קיים המופקד.‬ |

## Discount

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Value` | double | ‫**כן**‬ | ‫ערך ההנחה.‬ |
| `IsNominal` | boolean | ‫לא‬ | `true` = סכום קבוע, `false` = אחוז. |
| `BeforeTax` | boolean | ‫לא‬ | ‫החלה לפני מע"מ.‬ |

## AssociatedEmail

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Mail` | string | ‫**כן**‬ | ‫כתובת אימייל.‬ |
| `IsUserMail` | boolean | ‫לא‬ | `true` מסמן את העותק הנשלח לבעל החשבון. |

## GenerelCustomer

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Name` | string | ‫**כן**‬ | ‫שם הלקוח המזדמן.‬ |
| `Identifier` | string | ‫לא‬ | ‫מספר עוסק/ת.ז.‬ |
