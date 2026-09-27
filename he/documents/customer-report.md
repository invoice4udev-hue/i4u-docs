# ‫דוח לקוח‬

‫מחזיר את כל המסמכים של לקוח בודד בתוך טווח תאריכים — חלופה קלה וממוקדת ל[חיפוש מסמכים](search-documents.md) עבור השימוש הנפוץ של "הראו לי את ההיסטוריה של הלקוח הזה".‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetCustomerReport` |
| ‫**תשובה**‬ | `CommonCollection<Document[]>` — `{ "Response": [ ... ], "Errors": [] }` |

## ‫סכימת הבקשה — `dr` (DocumentsRequest)‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `CustomerID` | int | ‫כן (בפועל)‬ | ‫הלקוח שעליו מדווחים.‬ |
| `From` / `To` | datetime | ‫לא‬ | ‫טווח תאריכי הפקה.‬ |
| `Status` | int | ‫לא‬ | ‫[סטטוס מסמך](document-types.md#statusid). מוחל רק כשהערך שונה מ-`0`.‬ |
| `DocumentType` | int | ‫לא‬ | ‫סינון לפי [סוג מסמך](document-types.md) בודד. מוחל רק כשהערך גדול מ-`0`.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetCustomerReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "dr": {
    "From": "/Date(1767218400000+0200)/",
    "To": "/Date(1782853199000+0300)/",
    "CustomerID": 88231,
    "Status": 0
  },
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "Response": [
      {
        "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
        "DocumentNumber": 20260123,
        "DocumentType": 3,
        "Total": 117.0,
        "CipherText": "zKlvEbG4Na3F9XzyXFa%2frM%2bVhJwl4Pwx...",
        "PrintOriginalPDFLink": "https://newview.invoice4u.co.il/Views/PDF.aspx?cipher=..."
      }
    ]
  }
}
```

## ‫הערות‬

* ‫רק `From`, `To`, `CustomerID`, `Status` ו-`DocumentType` נקראים מתוך `dr` — כל שדה אחר של `DocumentsRequest` שמקובל ב[חיפוש מסמכים](search-documents.md) (`ItemsIncluded`, `CustomerName`, `BranchID` ועוד) מתעלמים ממנו כאן.‬
* ‫`Status` מוחל רק כשהוא שונה מ-`0`; `DocumentType` מוחל רק כשהוא גדול מ-`0` — השאירו אותם ריקים (או `0`) כדי לקבל את כל הסטטוסים/הסוגים של הלקוח.‬
* ‫המסמכים חוזרים באותה צורה כמו ב[חיפוש מסמכים](search-documents.md) — [אובייקט המסמך](document-object.md) המלא.‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫חשבון שפג תוקפו.‬ |

{% hint style="info" %}
‫טוקן לא תקין (שלא ניתן לפענוח) לא מוסיף רשומה ל-`Errors` כאן — התשובה חוזרת בלי `Response` ובלי `Errors`. התייחסו למעטפה ריקה כאל כשל, ובדקו את הטוקן קודם עם [`IsAuthenticated`](../authentication/is-authenticated.md) אם צריך להבחין בין שני המקרים.‬
{% endhint %}

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetCustomerReport" method="post" %}
{% endopenapi-operation %}
