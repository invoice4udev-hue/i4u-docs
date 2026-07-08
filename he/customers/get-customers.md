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

‫`POST /GetCustomerByGuid` — חיפוש לפי ה-`Guid` החיצוני שהגדרתם ביצירה. `GetCustomerByGuidInnerSearch` מבצע חיפוש רחב יותר (contains).‬

## ‫שליפה לפי מספר חיצוני — `GetCustomerByExternalNumber`‬

```json
{ "number": 10045, "token": "<token>" }
```

‫`POST /GetCustomerByExternalNumber` — חיפוש לפי `ExtNumber`. מחזיר `CustomerNotFound` (136) כאשר `number` אינו חיובי.‬

## ‫שליפה לפי קוד לקוח — `GetCustomerByClientCode`‬

```json
{ "clientCode": 42, "token": "<token>" }
```

‫`POST /GetCustomerByClientCode` (כינוי נוסף: `/GetByClientCode`).‬

## ‫רשומה מלאה — `GetFullCustomer`‬

```json
{ "id": 88231, "orgID": 0, "token": "<token>" }
```

‫`POST /GetFullCustomer` — מחזיר את רשומת הלקוח המלאה כולל פרטי בנק, אנשי קשר ואימיילים נוספים. שלחו `orgID: 0` כדי להשתמש בארגון של הטוקן.‬

## ‫רשימה מלאה — `GetCustomersByOrgId`‬

```json
{ "token": "<token>" }
```

‫`POST /GetCustomersByOrgId` — מחזיר `CommonCollection<Customer[]>`:‬

```json
{
  "GetCustomersByOrgIdResult": {
    "Response": [ { "ID": 88231, "Name": "Acme Ltd" }, ... ],
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

{% openapi-operation spec="invoice4u-api" path="/GetCustomersByOrgId" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetCustomers" method="post" %}
{% endopenapi-operation %}
