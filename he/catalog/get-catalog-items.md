# ‫שליפת פריטי קטלוג‬

‫מחזיר את קטלוג הפריטים של הארגון המאומת. זמין לכל החשבונות, עם או בלי רכיב המלאי.‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetCatalogItems` |
| ‫**תשובה**‬ | ‫`CommonCollection<CatalogItem[]>` (הפריטים ב-`Response`), או `null` בשגיאת אימות/שרת‬ |

## ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `GetAll` | boolean | ‫כן‬ | ‫`false` מחזיר פריטים פעילים בלבד. `true` מחזיר את כל הפריטים, כולל לא פעילים.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetCatalogItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "GetAll": false,
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "GetCatalogItemsResult": {
    "Errors": [],
    "Info": [],
    "Response": [
      {
        "ID": 5001,
        "UserId": 12345,
        "Code": "SRV-01",
        "Name": "Consulting hour",
        "Price": 300.0,
        "PriceAfterTax": 354.0,
        "VatPercentage": 18.0,
        "IsActive": true
      },
      {
        "ID": 5002,
        "UserId": 12345,
        "Code": "PRD-17",
        "Name": "USB cable",
        "Price": 25.0,
        "PriceAfterTax": 29.5,
        "VatPercentage": 18.0,
        "IsActive": true
      }
    ]
  }
}
```

## ‫הערות‬

* ‫מוחזרת הרשימה המלאה; אין חיפוש או דפדוף. סננו בצד שלכם.‬
* ‫קריאה בלבד — אין מתודת API ליצירה או עדכון של פריטי קטלוג. ראו את [הסקירה](overview.md).‬

## ‫שגיאות‬

‫מחזיר `null` כאשר הטוקן אינו תקין או בשגיאת שרת.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetCatalogItems" method="post" %}
{% endopenapi-operation %}
