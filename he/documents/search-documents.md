# חיפוש מסמכים

‫חיפוש מסמכים מסונן על פני הארגון המאומת.‬

## ‫מתודה‬

|             |                                                                           |
| ----------- | ------------------------------------------------------------------------- |
| ‫**מתודה**‬ | `POST`                                                                    |
| ‫**נתיב**‬  | `/GetDocuments`                                                           |
| ‫**תשובה**‬ | `CommonCollection<Document[]>` — ‏`{ "Response": [ ... ], "Errors": [] }` |

## ‫סכימת הבקשה — `dr` (DocumentsRequest)‬

| ‫שדה‬                                             | ‫טיפוס‬       | ‫חובה‬ | ‫תיאור‬                                                            |
| ------------------------------------------------- | ------------- | ------ | ------------------------------------------------------------------ |
| `DocumentType`                                    | int           | ‫כן    | ‫סינון לפי [סוג מסמך](document-types.md) בודד.‬                    |
| `From` / `To`                                     | datetime      | ‫לא‬   | ‫טווח תאריכי הפקה.‬                                                |
| `FromActualCreationDate` / `ToActualCreationDate` | datetime      | ‫לא‬   | ‫טווח תאריכי יצירה בפועל.‬                                         |
| `FromPaymentDueDate` / `ToPaymentDueDate`         | datetime      | ‫לא‬   | ‫טווח תאריכי פירעון.‬                                              |
| `Status`                                          | int           | ‫לא‬   | ‫[סטטוס מסמך](document-types.md#statusid).‬                        |
| `CustomerID`                                      | int           | ‫לא‬   | ‫סינון לפי לקוח.‬                                                  |
| `CustomerName`                                    | string        | ‫לא‬   | ‫סינון לפי שם לקוח (חייב להתקיים — אחרת `ClientDoesntExists`, 7).‬ |
| `BranchID`                                        | int           | ‫לא‬   | ‫סינון לפי סניף.‬                                                  |
| `DocumentNumber` / `ExectDocumentNumber`          | int           | ‫לא‬   | ‫תחילית מספר / מספר מדויק.‬                                        |
| `FromNumber` / `ToNumber`                         | int           | ‫לא‬   | ‫טווח מספרי מסמכים.‬                                               |
| `FromAmount` / `ToAmount`                         | float         | ‫לא‬   | ‫טווח סכום כולל.‬                                                  |
| `Currency`                                        | string        | ‫לא‬   | ‫סינון מטבע.‬                                                      |
| `PaymentType`                                     | int           | ‫לא‬   | ‫סינון קבלות לפי סוג תשלום.‬                                       |
| `ItemCode` / `ItemDescription`                    | string        | ‫לא‬   | ‫סינון לפי שדות פריט.‬                                             |
| `ItemsIncluded`                                   | boolean       | ‫לא‬   | ‫כלילת `Items` מלאים בתוצאות.‬                                     |
| `PaymentsIncluded`                                | boolean       | ‫לא‬   | ‫כלילת `Payments` מלאים בתוצאות.‬                                  |
| `OnlyGeneralClient` / `GeneralClientName`         | bool / string | ‫לא‬   | ‫סינוני לקוח מזדמן.‬                                               |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetDocuments HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "dr": {
    "DocumentType": 3,
    "From": "2026-06-01T00:00:00",
    "To": "2026-06-30T23:59:59",
    "CustomerID": 88231,
    "ItemsIncluded": true
  },
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "GetDocumentsResult": {
    "Response": [
      { "ID": "7f6a2c1e-...", "DocumentNumber": 20260123, "Total": 117.0 },
      { "ID": "8a7b3d2f-...", "DocumentNumber": 20260124, "Total": 234.0 }
    ],
    "Errors": []
  }
}
```

## ‫שגיאות‬

| ‫שגיאה (ID)‬             | ‫משמעות‬                               |
| ------------------------ | -------------------------------------- |
| `UnauthorizedUser` (80)  | ‫טוקן לא תקין.‬                        |
| `ClientDoesntExists` (7) | ‫פילטר `CustomerName` לא התאים ללקוח.‬ |

{% hint style="info" %}
‫המתודה מחזירה **סוג מסמך אחד בלבד לקריאה** — `DocumentType` מקבל ערך יחיד ולא רשימה. כדי לחפש כמה סוגים, בצעו קריאה נפרדת לכל סוג ואחדו את התוצאות בצד הלקוח.‬
{% endhint %}

{% hint style="info" %}
‫שולפים מסמך אחד ידוע? השתמשו ב[שליפות מסמך בודד](get-document.md) — מהיר ופשוט יותר.‬
{% endhint %}

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetDocuments" method="post" %}
[OpenAPI invoice4u-api](https://4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/gitbook-x-prod-openapi/raw/00f2f1d4bafc4d89c4d169eccebf65e6b1660dd5d59538b90e243188ebb90e52.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20260730%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260730T075128Z&X-Amz-Expires=172800&X-Amz-Signature=382e4474dd0c123f09b9ef313088bada0c846de1c0679efc63e220979aa7f607&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}
