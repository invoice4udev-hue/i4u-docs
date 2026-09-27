# ‫שיעור מע״מ ומספור מסמכים‬

‫שיעור המע״מ שחל על כל הארגונים, ומספור המסמכים של הארגון — המספר ההתחלתי הבא לכל סוג מסמך, אילו סוגים כבר יש להם מסמכים, מספרי חשבון הנהלת החשבונות המשמשים לייצוא לספרים, ופרטי הבנק של הארגון.‬

## ‫שליפת שיעור המע״מ — `GetTaxRate`‬

‫מחזיר את שיעור המע״מ לתאריך נתון, או את **השיעור האחיד לכלל הארגונים** — אותו ערך לכל ארגון, ולא הגדרת המע״מ הפרטית של הארגון שלכם.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetTaxRate` |
| ‫**תשובה**‬ | `Tax` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |
| `date` | string | ‫לא‬ | ‫התאריך לתמחור שיעור המע״מ, בפורמט `yyyy-MM-dd` — מחרוזת תאריך פשוטה, לא תאריך WCF (ראו [תאריכים](../getting-started/welcome.md#dates)). מנותח באמצעות `DateTime.TryParse`. השמיטו כדי לקבל את השיעור האחיד הנוכחי לכלל הארגונים ללא תלות בתאריך היום.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetTaxRate HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>",
  "date": "2024-12-31"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "TaxRate": 17
  }
}
```

### ‫הערות‬

* ‫לפני `2025-01-01` השיעור קבוע על `17`; החל מתאריך זה מוחזר **השיעור האחיד לכלל הארגונים** (`18` נכון לזמן כתיבת שורות אלו), הנקרא מהגדרת האפליקציה `TaxRate` — אותו ערך לכל ארגון, ולא הגדרת המע״מ הפרטית של הארגון שלכם.‬
* ‫תאריך החיתוך `2025-01-01` והשיעור `17` שלפני 2025 מקודדים ישירות (hard-coded) בתוך `IsraelTaxService.GetTaxRate`; הם אינם נקראים מהגדרות האפליקציה `TaxRate2025Date` / `TaxRateTill2024` שקיימות גם הן על שרת זה.‬
* ‫`token` מוצהר כפרמטר הראשון בחתימת המתודה, אך כמו בכל מתודה ב-API הזה, סדר השדות בגוף ה-JSON אינו משנה.‬

### ‫שגיאות‬

| ‫מקרה‬ | ‫תשובה‬ |
| ---- | -------- |
| ‫טוקן לא תקין‬ | ‫`TaxRate: -1‎`, ו-`Errors` מכיל `UnauthorizedUser` (80).‬ |
| ‫חשבון שפג תוקפו (יותר מ-4 ימים לאחר פקיעתו)‬ | ‫זהה למקרה של טוקן לא תקין — `TaxRate: -1‎` עם `UnauthorizedUser` (80) בלבד; השגיאה `ExpiredAccount` (66) שנוספה פנימית על ידי [`IsAuthenticated`](../authentication/is-authenticated.md) אינה מועברת לתשובה.‬ |
| ‫`date` סופק אך אינו תאריך תקין לניתוח‬ | ‫חריגת `ArgumentException` שאינה נתפסת — הבקשה נכשלת בשגיאת שרת בלתי מטופלת (HTTP 500), ולא בתשובת `{ "d": ... }` רגילה.‬ |

---

## ‫שליפת מספור מסמכים — `DocumentsNumberingGet`‬

‫מחזיר את הגדרות מספור המסמכים של הארגון: מספרים התחלתיים, אילו סוגי מסמכים כבר יש להם מסמכים, מספרי חשבון הנהלת חשבונות, ופרטי בנק.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/DocumentsNumberingGet` |
| ‫**תשובה**‬ | `NumberingDefinition` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/DocumentsNumberingGet HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "Invoice": 1042,
    "Receipt": 875,
    "InvoiceReceipt": 613,
    "InvoiceCredit": 12,
    "ProformaInvoice": 58,
    "InvoiceOrder": 34,
    "InvoiceQuote": 210,
    "InvoiceShip": 97,
    "PurchaseOrder": 15,
    "InvoiceCreated": true,
    "ReceiptCreated": true,
    "InvoiceReceiptCreated": true,
    "InvoiceCreditCreated": false,
    "ProformaInvoiceCreated": true,
    "InvoiceOrderCreated": false,
    "InvoiceQuoteCreated": true,
    "InvoiceShipCreated": false,
    "PurchaseOrderCreated": false,
    "Register": 1000,
    "RegisterCreditCard": 1001,
    "RegisterCash": 1002,
    "RegisterCheck": 1003,
    "RegisterBankTransfer": 1004,
    "RegisterBankTransferUSD": 1005,
    "RegisterBankTransferEUR": 1006,
    "RegisterBankTransferGBP": 1007,
    "RegisterBankTransferJPY": 1008,
    "RegisterOther": 1009,
    "RegisterPaypal": 1010,
    "RegisterBit": 1011,
    "RegisterPeper": 1012,
    "RegisterCredit": 1013,
    "TaxCredit": 1014,
    "Income": 1015,
    "ExemptIncome": 1016,
    "Deal": 1017,
    "GeneralCustomer": 1018,
    "RegisterPurchase": 1019,
    "RegisterVATInputs": 1020,
    "LawyerExpenses": 1021,
    "LawyerDeposit": 1022,
    "BankDetails": {
      "ClientId": 0,
      "AccountNumber": "123456",
      "BranchName": "612",
      "BankName": "Bank Hapoalim",
      "AccountOwner": "Acme Ltd",
      "BIC": "POALILIT"
    },
    "EnglishBankDetails": {
      "BankNameEnglish": "Bank Hapoalim",
      "BranchNameEnglish": "612",
      "AccountNumberEnglish": "123456",
      "IBAN": "IL620108000000099999999",
      "SWIFT": "POALILIT",
      "ABA": "",
      "Beneficiary": "Acme Ltd",
      "IBANEn": "",
      "SWIFTEn": "",
      "ABAEn": "",
      "BeneficiaryEn": "Acme Ltd"
    },
    "IsBankDetails": true,
    "IsEnglishBankDetails": true
  }
}
```

### ‫הערות‬

‫**מספרים התחלתיים לכל סוג מסמך** — המספר הבא שיוקצה למסמך חדש מאותו סוג. ראו [סוגי מסמכים](../documents/document-types.md) לרשימה המלאה של `DocumentType`.‬

| ‫שדה‬ | DocumentType |
| ----- | ------------ |
| `Invoice` | `1` |
| `Receipt` | `2` |
| `InvoiceReceipt` | `3` |
| `InvoiceCredit` | `4` |
| `ProformaInvoice` | `5` |
| `InvoiceOrder` | `6` |
| `InvoiceQuote` | `7` |
| `InvoiceShip` | `8` |
| `PurchaseOrder` | `13` |

‫**דגלי `*Created`** — `true` ברגע שנוצר לפחות מסמך אחד מאותו סוג. כל עוד הדגל של סוג מסוים הוא `false`, ניתן עדיין לשנות את המספר ההתחלתי המתאים לו לעיל (באמצעות `UpdateDocumentNumbering`, שאינה מתועדת בעמוד זה); ברגע שהוא `true` המספר ההתחלתי קבוע.‬

`InvoiceCreated`, `ReceiptCreated`, `InvoiceReceiptCreated`, `InvoiceCreditCreated`, `ProformaInvoiceCreated`, `InvoiceOrderCreated`, `InvoiceQuoteCreated`, `InvoiceShipCreated`, `PurchaseOrderCreated`.

‫**מספרי חשבון הנהלת חשבונות** — מספרי חשבון/כרטיס הנהלת חשבונות של הארגון, אחד לכל אמצעי תשלום או סוג הכנסה, המשמשים בעת ייצוא מסמכים למערכת הנהלת חשבונות חיצונית.‬

‫`Register`, `RegisterCreditCard`, `RegisterCash`, `RegisterCheck`, `RegisterBankTransfer`, `RegisterBankTransferUSD`, `RegisterBankTransferEUR`, `RegisterBankTransferGBP`, `RegisterBankTransferJPY`, `RegisterOther`, `RegisterPaypal`, `RegisterBit`, `RegisterPeper`, `RegisterCredit`, `TaxCredit`, `Income`, `ExemptIncome`, `Deal`, `GeneralCustomer`, `RegisterPurchase`, `RegisterVATInputs`. ‏`LawyerExpenses` / `LawyerDeposit` מוצהרים כ-nullable (`long?`) במודל, אך הממפה (mapper) הופך DB `NULL` ל-`0` — מתודה זו לעולם לא מחזירה `null` בפועל עבור שני שדות אלו. הם רלוונטיים רק לארגונים במצב משרד עורכי דין.‬

‫**פרטי בנק** — ‏`BankDetails` (בעברית) ו-`EnglishBankDetails` (באנגלית) נושאים את אותו חשבון בנק, המודפס על מסמכים המציגים הוראות תשלום. ‏`IsBankDetails` / `IsEnglishBankDetails` מדווחים האם הארגון מילא כל צד. ‏`ClientId` בתוך `BankDetails` הוא תמיד `0` בתשובה זו.‬

‫שדות שאינם ממולאים על ידי מתודה זו — תמיד מוחזרים כברירת המחדל של ה-CLR שלהם (‏`0`, `false`, או `null`) ללא קשר לנתונים בפועל של הארגון: `ID`, `Deposit`, `OrganizationID`, קבוצת `*Current` (‏`InvoiceCurrent`, `ReceiptCurrent`, `InvoiceReceiptCurrent`, `InvoiceCreditCurrent`, `ProformaInvoiceCurrent`, `InvoiceOrderCurrent`, `InvoiceQuoteCurrent`, `InvoiceShipCurrent`), קבוצת `*DocMin` (‏`ReceiptDocMin`, `InvoiceReceiptDocMin`, `InvoiceCreditDocMin`, `ProformaInvoiceDocMin`, `InvoiceOrderDocMin`, `InvoiceQuoteDocMin`, `InvoiceShipDocMin`), ו-`IsAdvancedSearchDocumentReferences`.‬

### ‫שגיאות‬

| ‫מקרה‬ | ‫תשובה‬ |
| ---- | -------- |
| ‫טוקן לא תקין‬ | ‫אובייקט `NumberingDefinition` עם `Errors: [{ "ID": 80, "Error": "UnauthorizedUser" }]` בלבד ממולא — כל שדה אחר הוא ברירת המחדל של ה-CLR שלו (‏`0` / `false` / `null`).‬ |
| ‫חשבון שפג תוקפו (יותר מ-4 ימים לאחר פקיעתו)‬ | ‫תשובה זהה למקרה של טוקן לא תקין — `UnauthorizedUser` (80) בלבד; השגיאה `ExpiredAccount` (66) שנוספה פנימית על ידי [`IsAuthenticated`](../authentication/is-authenticated.md) אינה מועברת.‬ |
| ‫שגיאת שרת/מסד נתונים בלתי צפויה‬ | ‫התשובה היא `{ "d": null }`. השגיאה נרשמת ביומן בצד השרת בלבד, ואינה מוחזרת לקורא.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetTaxRate" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/DocumentsNumberingGet" method="post" %}
{% endopenapi-operation %}
