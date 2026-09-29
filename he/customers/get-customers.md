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

‫מחזיר את ה-`Customer`, בהגבלה לארגון שלכם. ראו [שגיאות לפי מתודה](#errors-by-endpoint) בהמשך — פגם ב-BLL גורם לכך שטוקן לא תקין, חשבון שפג תוקפו ולקוח שלא נמצא אינם ניתנים להבחנה כאן.‬

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

‫`POST /GetCustomerByExternalNumber` — חיפוש לפי `ExtNumber`. כל נתיב כשל (טוקן לא תקין/חסר, חשבון שפג תוקפו, `number <= 0`, או היעדר התאמה) גורם ל-null-reference exception לא מטופל לפני שניתן לצרף שגיאה, ולכן מתקבל תמיד `{ "d": null }` — לעולם לא `CustomerNotFound` (136).‬

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
  "cust": { "Name": "Acme", "Active": true },
  "token": "<token>"
}
```

‫`POST /GetCustomers` — חיפוש מסונן; מוחזר `CommonCollection<Customer[]>` של ההתאמות. רק השדות הבאים ב-`Customer` נכבדים כפילטרים בתוך `cust` — כל שדה אחר שתמלאו מתעלם ממנו:‬

‫`UniqueID`, `Name`, `ExtNumber`, `Active`, `Retainer` (מוחל רק כאשר `true`), `HasBeenExported`, `Email`, `Phone`, `Cell`, `FreeUniqueID`.‬

{% hint style="warning" %}
‫`Active` הוא שדה שאינו nullable ב-`Customer`, ולכן הוא **תמיד** נשלח לחיפוש — גם כאשר משמיטים אותו מ-`cust`. השמטתו מחפשת לקוחות **לא פעילים** (`Active: false`). שלחו `"Active": true` במפורש כדי למצוא לקוחות פעילים.‬
{% endhint %}

‫האם כל שדה נתמך מתבצע כהתאמה מדויקת או חלקית (`LIKE`) אינו מתועד כאן — לוגיקת החיפוש הפנימית אינה חלק מהחוזה המפורסם.‬

## ‫שגיאות לפי מתודה‬ {#errors-by-endpoint}

‫ההתנהגות שונה בכל מתודה — אין טבלת שגיאות אחת המשותפת לכל השליפות האלה. ערכי `Errors` מופיעים על ה-`Customer`/האוסף המוחזר, אלא אם צוין אחרת.‬

| ‫מתודה‬ | ‫טוקן לא תקין‬ | ‫חשבון שפג תוקפו‬ | ‫לא נמצא‬ |
| ----- | ------------ | ---------------- | ------- |
| `GetCustomerById` | `Errors: [GeneralError (0)]`\* | `Errors: [GeneralError (0)]`\* | `Errors: [GeneralError (0)]`\* |
| `GetCustomerByName` | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | `Errors: [UnauthorizedUser (80)]` | `null` |
| `GetCustomerByEmail` | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | `Errors: [UnauthorizedUser (80)]` | ‫`null` (`Errors: [GeneralError (0)]` בשגיאת שרת/מסד נתונים לא קשורה)‬ |
| `GetCustomerByGuid` | `null` | `null` | `null` |
| `GetCustomerByGuidInnerSearch` | `null` | `null` | `null` |
| `GetCustomerByExternalNumber` | `null` | `null` | ‫`null` (גם עבור `number <= 0`)‬ |
| `GetCustomerByClientCode` | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | `null` |
| ‫`GetByClientCode` (כינוי)‬ | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | ‫HTTP 500 (שגיאת שרת לא מטופלת)‬ | `null` |
| `GetFullCustomer` | `Errors: [UnauthorizedUser (80)]` | `Errors: [ExpiredAccount (66)]` | `null` |
| `GetCustomersByOrgId` | ‫מעטפה ריקה — ללא `Response`, ללא `Errors`†‬ | ‫`Errors: [UnauthorizedUser (80)]`, ללא `Response`‬ | ‫לא רלוונטי — מערך `Response` ריק‬ |
| `GetCustomers` | ‫מעטפה ריקה — ללא `Response`, ללא `Errors`†‬ | ‫`Errors: [UnauthorizedUser (80)]`, ללא `Response`‬ | ‫לא רלוונטי — מערך `Response` ריק‬ |

‫\* פגם מסוג null-reference ב-`GetCustomerById` גורם לכך שטוקן לא תקין, חשבון שפג תוקפו ולקוח שלא נמצא כולם מניבים אותה תגובת `GeneralError (0)` גנרית; `ClientIDDoesntExists` (37) לא יכולה למעשה להתרחש, מכיוון שהשאילתה הבסיסית כבר מוגבלת לארגון שלכם, כך שלקוח מארגון אחר אינו ניתן להבחנה מ"לא נמצא".‬

‫† עבור `GetCustomersByOrgId`/`GetCustomers`, טוקן לא תקין או חסר גורם לחריגה לפני שניתן לצרף שגיאה לאוסף, ולכן מתקבלת מעטפה ריקה במקום שגיאה רגילה — לא ניתן להבחין בין "אין תוצאות" לבין "טוקן לא תקין" רק על סמך `Errors`.‬

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
