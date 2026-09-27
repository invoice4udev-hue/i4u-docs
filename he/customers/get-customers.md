# ‫שליפת לקוחות‬

‫מתודות חיפוש ושליפה של לקוחות. כולן מקבלות `token` ומחזירות `Customer` בודד או אוסף. כל התוצאות מוגבלות לארגון המאומת.‬

## ‫שליפה לפי מזהה — `GetCustomerById`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetCustomerById` |

```json
{ "custId": 88231, "token": "<token>" }
```

‫מחזיר את ה-`Customer`. אם הלקוח שייך לארגון אחר: `ClientIDDoesntExists` (37).‬

## ‫שליפה לפי שם — `GetCustomerByName`‬

```json
{ "name": "Acme Ltd", "token": "<token>" }
```

‫`POST /GetCustomerByName` — חיפוש לפי שם מדויק.‬

## ‫שליפה לפי אימייל — `GetCustomerByEmail`‬

```json
{ "email": "billing@acme.example", "name": "Acme Ltd", "token": "<token>" }
```

‫`POST /GetCustomerByEmail` — חיפוש לפי אימייל, עם שם אופציונלי להבחנה.‬

## ‫שליפה לפי GUID — `GetCustomerByGuid`‬

```json
{ "guid": "d2f1a6b3-...", "token": "<token>" }
```

‫`POST /GetCustomerByGuid` — חיפוש לפי ה-`Guid` החיצוני שהגדרתם ביצירה. אם החיפוש לא מחזיר תוצאה, נסו את `GetCustomerByGuidInnerSearch` בהמשך.‬

## ‫שליפה לפי GUID (חיפוש פנימי) — `GetCustomerByGuidInnerSearch`‬

```json
{ "guid": "d2f1a6b3-...", "token": "<token>" }
```

```json
{
  "d": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "Guid": "d2f1a6b3-...",
    "Errors": []
  }
}
```

‫`POST /GetCustomerByGuidInnerSearch` — מחפש גם לפי מזהי לקוח נוספים (אפשרות החיפוש הפנימי של השליפה); השתמשו בו כאשר `GetCustomerByGuid` לא מחזיר תוצאה. מחזיר `null` גם כאשר לא נמצא לקוח מתאים וגם כאשר הטוקן אינו תקין או פג תוקף — שני המקרים אינם ניתנים להבחנה מהתגובה בלבד.‬

## ‫שליפה לפי מספר חיצוני — `GetCustomerByExternalNumber`‬

```json
{ "number": 10045, "token": "<token>" }
```

‫`POST /GetCustomerByExternalNumber` — חיפוש לפי `ExtNumber`. מחזיר `CustomerNotFound` (136) כאשר `number` אינו חיובי.‬

## ‫שליפה לפי קוד לקוח — `GetCustomerByClientCode`‬

```json
{ "clientCode": 1045, "token": "<token>" }
```

‫`POST /GetCustomerByClientCode` (כינוי נוסף: `/GetByClientCode`). מחזיר `null` כאשר לא נמצא לקוח מתאים. טוקן לא תקין או שפג תוקפו **אינו** נתפס: הבדיקה מתבצעת לפני בלוק ה-try של המתודה, ולכן מתקבלת שגיאת שרת לא מטופלת (HTTP 500) במקום תגובת שגיאה רגילה.‬

## ‫שליפה לפי קוד לקוח (כינוי) — `GetByClientCode`‬

```json
{ "clientCode": 1045, "token": "<token>" }
```

```json
{
  "d": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "ClientCode": 1045,
    "Errors": []
  }
}
```

‫`POST /GetByClientCode` — מימוש זהה ל-`GetCustomerByClientCode` (אותו חיפוש, אותה הגבלה לארגון). מחזיר `null` כאשר לא נמצא לקוח מתאים. כמו ב-`GetCustomerByClientCode`, טוקן לא תקין או שפג תוקפו גורם לשגיאת שרת לא מטופלת (HTTP 500) במקום תגובת שגיאה רגילה.‬

## ‫רשומה מלאה — `GetFullCustomer`‬

```json
{ "id": 88231, "orgID": 0, "token": "<token>" }
```

‫`POST /GetFullCustomer` — מחזיר את רשומת הלקוח המלאה כולל פרטי בנק, אנשי קשר ואימיילים נוספים. שלחו את `orgID` כ-`0` כדי להשתמש בארגון של הטוקן עצמו.‬

## ‫רשימה מלאה — `GetCustomersByOrgId`‬

```json
{ "token": "<token>" }
```

‫`POST /GetCustomersByOrgId` — מחזיר `CommonCollection<Customer[]>`:‬

```json
{
  "d": {
    "Response": [
      { "ID": 88231, "Name": "Acme Ltd" },
      { "ID": 88232, "Name": "Beta Corp" }
    ],
    "Errors": []
  }
}
```

## ‫חיפוש — `GetCustomers`‬

```json
{
  "cust": { "Name": "Acme" },
  "token": "<token>"
}
```

‫`POST /GetCustomers` — חיפוש מסונן. מלאו כל תת-קבוצה של שדות `Customer`‏ (`Name`, `Email`, `UniqueID`, …) כפילטר; מוחזר `CommonCollection<Customer[]>` של ההתאמות.‬

## ‫שגיאות (כל המתודות)‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן לא תקין.‬ |
| `ClientIDDoesntExists` (37) | ‫לקוח לא נמצא / שייך לארגון אחר.‬ |
| `CustomerNotFound` (136) | ‫ערך חיפוש לא תקין.‬ |
| `GeneralError` (0) | ‫שגיאת שרת.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetCustomerById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByName" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByEmail" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByGuid" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByGuidInnerSearch" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByExternalNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomerByClientCode" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetByClientCode" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetFullCustomer" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomersByOrgId" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomers" method="post" %}
{% endopenapi-operation %}
