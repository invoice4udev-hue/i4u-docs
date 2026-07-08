# ‫סקירת מתודות מסמכים‬

‫מסמכים הם הליבה של ה-API של Invoice4U: חשבוניות, קבלות, חשבוניות מס קבלה, חשבוניות זיכוי, הצעות מחיר, הזמנות ועוד. מרגע היצירה, המסמך חתום, ממוספר וסופי מבחינה חוקית — לא ניתן לערוך אותו, רק לזכות או לבטל באמצעות מסמך המשך.‬

### ‫מתודות בסקשן הזה‬

| ‫מתודה‬ | ‫עמוד‬ |
| ----- | ---- |
| `CreateDocument` | ‫[יצירת מסמך](create-document.md)‬ |
| `CreateDocumentWithIdentifierValidation` | ‫[יצירה עם ולידציית מזהה](create-document-with-validation.md)‬ |
| `GetDocument`, `GetDocumentByNumber`, `GetDocumentByApiIdentifier`, `IsDocumentExistsByApiIdentifier` | ‫[שליפת מסמך בודד](get-document.md)‬ |
| `GetDocuments` | ‫[חיפוש מסמכים](search-documents.md)‬ |
| `FetchAllocationNumber`, `UpdateAllocationNumber` | ‫[מספרי הקצאה (רשות המסים)](allocation-numbers.md)‬ |

### ‫עמודי עזר‬

* ‫[סוגי מסמכים](document-types.md) — ה-enum של `DocumentType` ומה כל סוג דורש‬
* ‫[אובייקט המסמך](document-object.md) — תיעוד מלא של שדות `Document`, `DocumentItem`, `Payment`, `Discount` ואובייקטים קשורים‬

### ‫תהליך יצירה טיפוסי‬

1. ‫אימות ← טוקן.‬
2. ‫זיהוי הלקוח: `ClientID` קיים, או שליחת `GeneralCustomer` (מותר רק לחלק מהסוגים).‬
3. ‫בניית ה-`Document`: סוג, פריטים ו/או תשלומים, כתובות למשלוח.‬
4. `POST /CreateDocument`.
5. ‫בדיקת `Errors`; בהצלחה, השתמשו ב-`DocumentNumber`, `ID` ובשדות `PrintOriginalPDFLink` / `PrintCertifiedCopyPDFLink`.‬

### ‫הגנה מכפילויות‬

‫שני מנגנונים מונעים חיוב כפול כשהמערכת שלכם מבצעת ניסיונות חוזרים:‬

| ‫מנגנון‬ | ‫איך זה עובד‬ |
| ------ | ----------- |
| `ApiIdentifier` | ‫המזהה הייחודי שלכם למסמך. אם לא שלחתם, ה-API מייצר `I4U-APIGEN-<guid>`. עם [CreateDocumentWithIdentifierValidation](create-document-with-validation.md) הקריאה נדחית עם `DocumentAlreadyCreated` (134) אם מסמך עם אותו מזהה כבר קיים — המסמך הקיים מוחזר.‬ |
| `ApiDuplicityTimeValidation` | ‫חלון זמן ב**שניות** (ברירת מחדל `60`). אם מסמך זהה נוצר בתוך החלון, `CreateDocument` נכשל עם `DocumentAlreadyCreated` (134). הגדילו את הערך עבור תורי retry איטיים.‬ |

### ‫שליחה באימייל וב-SMS‬

* `AssociatedEmails` על המסמך מפעיל משלוח המסמך באימייל בעת היצירה.
* `SmsMessages` מפעיל משלוח SMS (דורש קרדיט SMS בחשבון).
* `EmailCustomComment` מתאים אישית את ההערה בגוף האימייל.
