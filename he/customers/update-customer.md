# ‫עדכון לקוח‬

‫מעדכן לקוח קיים. הלקוח חייב להתקיים ולהשתייך לארגון המאומת.‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateCustomer` |
| ‫**תשובה**‬ | ‫אובייקט `Customer` (בדקו את `Errors` וקודי `ID` שליליים)‬ |

## ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `cu` | Customer | ‫כן‬ | ‫הלקוח לעדכון. `ID` **חייב** להיות מזהה לקוח קיים ותקין (`ID = 0` נדחה). שאר השדות לפי [אובייקט ה-Customer](overview.md#the-customer-object) — שלחו את המצב המלא הרצוי.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateCustomer HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "cu": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Email": "accounts@acme.example",
    "PayTerms": 60,
    "Active": true
  },
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "UpdateCustomerResult": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Email": "accounts@acme.example",
    "PayTerms": 60,
    "Errors": []
  }
}
```

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן לא תקין.‬ |
| `ClientDoesntExists` (7) | ‫`ID` הוא `0` או שהלקוח לא קיים בארגון שלכם.‬ |
| `CustomerNameCanNotBeEmpty` (28) | ‫חסר `Name`.‬ |
| `CustomerUniqueIdNotNumeric` (79) | ‫`UniqueID` מכיל תווים שאינם ספרות.‬ |
| `ID = -1 … -4` | ‫כפילות שם / מספר חיצוני / מזהה ייחודי / GUID — ראו [קודי תוצאה](overview.md#createupdate-result-codes).‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/UpdateCustomer" method="post" %}
{% endopenapi-operation %}
