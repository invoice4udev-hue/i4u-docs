# ‫מחירונים‬

‫נהלו מחירוני מלאי ותמחור לקוחות.‬

## ‫הוספת מחירון‬

‫יוצר מחירון חדש בארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/AddInventoryPricelist` |
| ‫**תשובה**‬ | ‫אובייקט `Pricelist`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | ‫כן‬ | ‫המחירון ליצירה. שדות: `Name`, `Discount`, `DiscountType` (`0` = אחוז, `1` = סכום קבוע), `LinkedCustomers` (מזהי לקוחות מופרדים בפסיקים), `IsActive` — שדה חובה (לא-nullable) בפרוטוקול, כך שהשמטתו מפוענחת כ-`false` והמחירון נוצר **לא פעיל** בלי אזהרה. `OrganizationID` מתעלמים ממנו אם נשלח — השרת תמיד דורס אותו בערך הארגון המאומת.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/AddInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Name": "Wholesale Pricing",
    "Discount": 15,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true
  },
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 25,
    "OrganizationID": 4001,
    "Name": "Wholesale Pricing",
    "Discount": 15,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים אובייקט `Pricelist` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫עדכון מחירון‬

‫מעדכן מחירון קיים.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateInventoryPricelist` |
| ‫**תשובה**‬ | ‫אובייקט `Pricelist`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `pricelist` | Pricelist | ‫כן‬ | ‫המחירון לעדכון. חייב לכלול `Id`. אותם שדות כמו ביצירה: `Name`, `Discount`, `DiscountType`, `LinkedCustomers`, `IsActive`. `OrganizationID` מתעלמים ממנו אם נשלח.‬ |
| `customerID` | int? | ‫לא‬ | ‫מזהה לקוח אופציונלי לשיוך למחירון זה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "pricelist": {
    "Id": 25,
    "Name": "Wholesale Pricing",
    "Discount": 18,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true
  },
  "customerID": 88231,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Id": 25,
    "OrganizationID": 4001,
    "Name": "Wholesale Pricing",
    "Discount": 18,
    "DiscountType": 0,
    "LinkedCustomers": "88231",
    "IsActive": true,
    "Errors": []
  }
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים אובייקט `Pricelist` הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת כל המחירונים‬

‫מחזיר את כל המחירונים עבור הארגון המאומת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelists` |
| ‫**תשובה**‬ | `Pricelist[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelists HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231",
      "IsActive": true,
      "Errors": []
    },
    {
      "Id": 26,
      "OrganizationID": 4001,
      "Name": "Retail Pricing",
      "Discount": 5,
      "DiscountType": 1,
      "LinkedCustomers": "",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת מחירונים לפי מזהה לקוח‬

‫מחזיר מחירונים המשויכים ללקוח ספציפי.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelistByCustomerId` |
| ‫**תשובה**‬ | `Pricelist[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerId` | int | ‫כן‬ | ‫מזהה הלקוח לשאילתה.‬ |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerId HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerId": 88231,
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת מחירונים לפי מזהי לקוחות מרובים‬

‫מחזיר מחירונים עבור לקוחות מרובים בבת אחת.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryPricelistByCustomerIds` |
| ‫**תשובה**‬ | `PricelistWithCustomer[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerIds` | string | ‫כן‬ | ‫רשימת מזהי לקוחות מופרדת בפסיקים (לדוגמה, "88231,88232,88233").‬ |
| `isActive` | bool? | ‫לא‬ | ‫סננו לפי סטטוס פעיל. השמיטו כדי להחזיר את כולם.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryPricelistByCustomerIds HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIds": "88231,88232,88233",
  "isActive": true,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "CustomerId": 88231,
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231,88232",
      "IsActive": true,
      "Errors": []
    },
    {
      "CustomerId": 88232,
      "Id": 25,
      "OrganizationID": 4001,
      "Name": "Wholesale Pricing",
      "Discount": 18,
      "DiscountType": 0,
      "LinkedCustomers": "88231,88232",
      "IsActive": true,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫הסרת לקוח ממחירון‬

‫מסיר לקוחות משיוכי מחירונים.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/RemoveCustomerFromInventoryPricelist` |
| ‫**תשובה**‬ | ‫`bool` — `true` בהצלחה, `false` בשגיאה‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `customerIDs` | string | ‫כן‬ | ‫רשימת מזהי לקוחות מופרדת בפסיקים להסרה ממחירונים.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/RemoveCustomerFromInventoryPricelist HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "customerIDs": "88231,88232",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": true
}
```

### ‫שגיאות‬

‫מתודה זו אף פעם לא מחזירה אובייקט שגיאה — היא מחזירה את הבוליאני `false` הפשוט עבור טוקן לא תקין, חשבון שפג תוקפו, רכיב מלאי כבוי, או כל שגיאת שרת. אין דרך להבחין בין המקרים הללו מתוך התשובה בלבד; ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/AddInventoryPricelist" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/UpdateInventoryPricelist" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetInventoryPricelists" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetInventoryPricelistByCustomerId" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetInventoryPricelistByCustomerIds" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/RemoveCustomerFromInventoryPricelist" method="post" %}
{% endopenapi-operation %}
