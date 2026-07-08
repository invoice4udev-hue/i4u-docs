# ‫יצירת מסמך‬

‫יוצר מסמך חתום וממוספר. זוהי המתודה המרכזית של ה-API.‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateDocument` |
| ‫**תשובה**‬ | ‫אובייקט `Document` — בדקו את `Errors` תחילה‬ |

‫וריאציות:‬

| ‫נתיב‬ | ‫מתודה‬ | ‫הערות‬ |
| ---- | ----- | ----- |
| `/CreateDocument` | POST | ‫הסטנדרטי.‬ |
| `/CreateDocumentREST` | GET/POST | ‫וריאציית REST מפורשת, אותו גוף.‬ |
| `/CreateDocumentWithIdentifierValidation` | POST | ‫דוחה כפילויות לפי `ApiIdentifier` — ראו [עמוד ייעודי](create-document-with-validation.md).‬ |

## ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `doc` | Document | ‫כן‬ | ‫המסמך ליצירה. ראו [אובייקט המסמך](document-object.md) ודרישות פר סוג ב[סוגי מסמכים](document-types.md).‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה — חשבונית מס קבלה (סוג 3)‬

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "ClientID": 88231,
    "TaxIncluded": true,
    "Currency": "ILS",
    "ApiIdentifier": "my-system-order-10045",
    "Items": [
      {
        "Name": "Pro plan - June",
        "Quantity": 1,
        "Price": 117.00,
        "PriceIncludeTax": 117.00
      }
    ],
    "Payments": [
      {
        "PaymentType": 1,
        "Amount": 117.00,
        "Date": "2026-07-05T00:00:00",
        "NumberOfPayments": 1,
        "PaymentNumber": "4242"
      }
    ],
    "AssociatedEmails": [
      { "Mail": "billing@acme.example", "IsUserMail": false }
    ]
  },
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "CreateDocumentResult": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260123,
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "Total": 117.0,
    "TotalWithoutTax": 100.0,
    "TotalTaxAmount": 17.0,
    "StatusID": 2,
    "ApiIdentifier": "my-system-order-10045",
    "PrintOriginalPDFLink": "https://newview.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "PrintCertifiedCopyPDFLink": "https://newview.invoice4u.co.il/Views/PDF.aspx?cipher=...",
    "Errors": []
  }
}
```

{% hint style="info" %}
‫ב-QA קישורי ה-PDF מפנים ל-`newviewqa.invoice4u.co.il`; בפרודקשן ל-`newview.invoice4u.co.il`.‬
{% endhint %}

## ‫הערות התנהגות‬

* ‫**הסכומים מחושבים בצד השרת** מתוך `Items` (סוגים מבוססי פריטים) או `Payments` (+`Deduction`) — אתם לא שולחים `Total`.‬
* ‫ב**חשבונית מס קבלה**, סכום התשלומים חייב להיות שווה לסכום הפריטים (פער עיגול של ±0.01 ניתן לתיקון אוטומטי — ראו `AutoFixPaymentsMismatchItems` ב[אובייקט המסמך](document-object.md)). אי-התאמה ← `PaymentAmountDoesntMatchItemsAmount` (56) עם `OpenInfo.PaymentMismatchDelta`.‬
* ‫**משלוח אימייל** מתבצע אוטומטית כאשר `AssociatedEmails` מוגדר; **משלוח SMS** כאשר `SmsMessages` מוגדר.‬
* ‫ארגונים המחוברים ל-**2Sign** עם תהליכי מסמכים לחתימה מקבלים את המסמך כמשימת חתימה במקום אימייל רגיל.‬
* ‫חלון כפילויות: מסמך זהה בתוך `ApiDuplicityTimeValidation` שניות (ברירת מחדל 60) ← `DocumentAlreadyCreated` (134).‬

## ‫שגיאות נפוצות‬ {#common-errors}

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן לא תקין.‬ |
| `DocumentTypeNotInRange` (33) | ‫`DocumentType` לא מוכר.‬ |
| `ClientDoesntExists` (7) / `ClientIDDoesntExists` (37) | ‫לקוח חסר/לא מוכר.‬ |
| `DocumentItemsNotSpecified` (34) / `DocumentItemMissingName` (39) / `DocumentItemQuantityCannotBeZero` (40) / `DocumentItemPriceCannotBeZero` (41) | ‫ולידציית פריטים. `Paramters` מכיל את מספר השורה.‬ |
| `PaymentsNotSpecified` (45) / `PaymentDateMissing` (46) / `PaymentAmountCannotBeZero` (47) / `PaymentTypeOutOfRange` (51) | ‫ולידציית תשלומים.‬ |
| `PaymentAmountDoesntMatchItemsAmount` (56) | ‫תשלומים ≠ סכום הפריטים.‬ |
| `InvalidDateRange` (3) | ‫`IssueDate` עתידי או לפני המסמך האחרון שלכם.‬ |
| `DocumentAlreadyCreated` (134) | ‫זוהתה כפילות.‬ |
| `NotEnoughDocuments` (65) / `NotEnoughCredits` (18) | ‫מכסת המסמכים נגמרה.‬ |
| `ExpiredAccount` (66) | ‫תוקף מנוי החשבון פג.‬ |
| `ActionRestrictedForUser` (141) | ‫המשתמש מוגבל מיצירת סוג מסמך זה.‬ |
| `TimeoutDB` (147) | ‫שגיאת שרת בעת היצירה — אמתו עם [GetDocumentByApiIdentifier](get-document.md) לפני ניסיון חוזר.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/CreateDocument" method="post" %}
{% endopenapi-operation %}
