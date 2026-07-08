# ‫יצירת מסמך עם ולידציית מזהה‬

‫זהה ל[יצירת מסמך](create-document.md), אך עם אידמפוטנטיות קפדנית: אם מסמך עם אותו `ApiIdentifier` (ואותו סוג) כבר קיים בארגון שלכם, הקריאה **לא יוצרת מסמך חדש** — היא מחזירה את הקיים עם שגיאת `DocumentAlreadyCreated` מצורפת.‬

‫השתמשו במתודה זו כאשר המערכת שלכם עלולה לבצע בקשות חוזרות (תורים, webhooks, פסקי זמן ברשת).‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/CreateDocumentWithIdentifierValidation` |
| ‫**תשובה**‬ | `Document` — חדש, או הקיים + `DocumentAlreadyCreated` (134) |

## ‫סכימת הבקשה‬

‫זהה ל[יצירת מסמך](create-document.md):‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `doc` | Document | ‫כן‬ | ‫המסמך. **תמיד קבעו `ApiIdentifier`** — מפתח הדה-דופליקציה, ייחודי פר מסמך במערכת שלכם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/CreateDocumentWithIdentifierValidation HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 1,
    "Subject": "Order #10045",
    "ClientID": 88231,
    "ApiIdentifier": "order-10045-invoice",
    "Items": [
      { "Name": "Widget", "Quantity": 2, "Price": 50.0 }
    ],
    "AssociatedEmails": [
      { "Mail": "billing@acme.example" }
    ]
  },
  "token": "<token>"
}
```

## ‫תשובה במקרה של כפילות‬

‫כאשר `ApiIdentifier` כבר קיים, התשובה היא המסמך **הקיים** בתוספת השגיאה:‬

```json
{
  "CreateDocumentWithIdentifierValidationResult": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260119,
    "ApiIdentifier": "order-10045-invoice",
    "Errors": [
      { "ID": 134, "Error": "DocumentAlreadyCreated" }
    ]
  }
}
```

‫התייחסו לשגיאה `134` עם `DocumentNumber > 0` מוחזר כהצלחה אידמפוטנטית: המסמך כבר קיים, אין צורך בפעולה.‬

## ‫שגיאות‬

‫כל [שגיאות יצירת מסמך](create-document.md#common-errors) חלות, בתוספת התנהגות הכפילות שלמעלה.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/CreateDocumentWithIdentifierValidation" method="post" %}
{% endopenapi-operation %}
