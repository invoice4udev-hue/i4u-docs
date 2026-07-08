# חיפוש מסמכים

חיפוש מסמכים מסונן על פני הארגון המאומת.

## מתודה

| | |
| - | - |
| ‏**מתודה** | `POST` |
| ‏**נתיב** | `/GetDocuments` |
| ‏**תשובה** | `CommonCollection<Document[]>` — ‏`{ "Response": [ ... ], "Errors": [] }` |

## סכימת הבקשה — `dr` (DocumentsRequest)

| ‏שדה | ‏טיפוס | ‏חובה | ‏תיאור |
| --- | ----- | ---- | ----- |
| `DocumentType` | int | ‏לא | ‏סינון לפי [סוג מסמך](document-types.md) בודד. |
| `DocumentTypes` | string | ‏לא | ‏רשימת סוגים מופרדת בפסיקים. |
| `From` / `To` | datetime | ‏לא | ‏טווח תאריכי הפקה. |
| `FromActualCreationDate` / `ToActualCreationDate` | datetime | ‏לא | ‏טווח תאריכי יצירה בפועל. |
| `FromPaymentDueDate` / `ToPaymentDueDate` | datetime | ‏לא | ‏טווח תאריכי פירעון. |
| `Status` | int | ‏לא | ‏[סטטוס מסמך](document-types.md#statusid). |
| `CustomerID` | int | ‏לא | ‏סינון לפי לקוח. |
| `CustomerName` | string | ‏לא | ‏סינון לפי שם לקוח (חייב להתקיים — אחרת `ClientDoesntExists`, 7). |
| `BranchID` | int | ‏לא | ‏סינון לפי סניף. |
| `DocumentNumber` / `ExectDocumentNumber` | int | ‏לא | ‏תחילית מספר / מספר מדויק. |
| `FromNumber` / `ToNumber` | int | ‏לא | ‏טווח מספרי מסמכים. |
| `FromAmount` / `ToAmount` | float | ‏לא | ‏טווח סכום כולל. |
| `Currency` | string | ‏לא | ‏סינון מטבע. |
| `PaymentType` | int | ‏לא | ‏סינון קבלות לפי סוג תשלום. |
| `ItemCode` / `ItemDescription` | string | ‏לא | ‏סינון לפי שדות פריט. |
| `ItemsIncluded` | boolean | ‏לא | ‏כלילת `Items` מלאים בתוצאות. |
| `PaymentsIncluded` | boolean | ‏לא | ‏כלילת `Payments` מלאים בתוצאות. |
| `OnlyGeneralClient` / `GeneralClientName` | bool / string | ‏לא | ‏סינוני לקוח מזדמן. |
| `Limit` | int | ‏לא | ‏מספר שורות מרבי. |

## דוגמת בקשה

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

## דוגמת תשובה

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

## שגיאות

| ‏שגיאה (ID) | ‏משמעות |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‏טוקן לא תקין. |
| `ClientDoesntExists` (7) | ‏פילטר `CustomerName` לא התאים ללקוח. |

{% hint style="info" %}
שולפים מסמך אחד ידוע? השתמשו ב[שליפות מסמך בודד](get-document.md) — מהיר ופשוט יותר.
{% endhint %}

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/GetDocuments" method="post" %}
{% endopenapi-operation %}
