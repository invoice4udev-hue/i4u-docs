# ‫שליפת פריט קטלוג לפי קוד‬

‫מחזיר פריט קטלוג בודד לפי התאמה מדויקת של הקוד שלו. זמין לכל החשבונות, עם או בלי רכיב המלאי.‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetCatalogItemByCode` |
| ‫**תשובה**‬ | ‫`CatalogItem`, או `null` כשלא נמצא או בשגיאת אימות/שרת‬ |

## ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `code` | string | ‫כן‬ | ‫קוד הפריט (התאמה מדויקת).‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetCatalogItemByCode HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "code": "SRV-01",
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [],
    "ID": 5001,
    "UserId": 12345,
    "Code": "SRV-01",
    "Name": "Consulting hour",
    "Price": 300.0,
    "PriceAfterTax": 354.0,
    "VatPercentage": 18.0
  }
}
```

## ‫הערות‬

* ‫רק השדות `ID`, `UserId`, `Code`, `Name`, `Price`, `PriceAfterTax` ו-`VatPercentage` מאוכלסים. `IsActive` אינו מוחזר במתודה זו — השתמשו ב[שליפת פריטי קטלוג](get-catalog-items.md) אם אתם צריכים אותו.‬

## ‫שגיאות‬

‫מחזיר `null` כאשר אין פריט עם הקוד, כאשר הטוקן אינו תקין, או בשגיאת שרת.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetCatalogItemByCode" method="post" %}
{% endopenapi-operation %}
