# ‫דוחות מלאי‬

‫שלפו דוחות עלות מלאי, תנועות ומכירות.‬

## ‫שליפת דוח עלות מלאי‬

‫מחזיר את דוח עלות המלאי לתאריך ספציפי, ומציג את כל הפריטים והערכות השווי שלהם.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetInventoryCostReport` |
| ‫**תשובה**‬ | `ItemBalance[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `date` | DateTime | ‫כן‬ | ‫התאריך שעבורו יש להפיק את הדוח.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetInventoryCostReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "date": "/Date(1787518800000+0300)/",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "InventoryId": 1001,
      "ItemName": "Laptop Pro",
      "ItemCode": "LP-001",
      "UnitType": 0,
      "Cost": 2800.00,
      "Price": 4500.00,
      "TotalPrice": 42000.00,
      "Qty": 15,
      "Errors": []
    },
    {
      "InventoryId": 1002,
      "ItemName": "Wireless Mouse",
      "ItemCode": "WM-001",
      "UnitType": 0,
      "Cost": 75.00,
      "Price": 150.00,
      "TotalPrice": 3750.00,
      "Qty": 50,
      "Errors": []
    }
  ]
}
```

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר מערך ריק (`{"d":[]}`) — הרשימה הפנימית של מתודה זו מאותחלת ל-`new List<ItemBalance>()` במקום ל-`null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת הפריטים הנמכרים ביותר‬

‫מחזיר את הפריטים הנמכרים ביותר לפי כמות שנמכרה או לפי ערך מכירות, עבור חלון זמן קבוע.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetTopSoldItems` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `filterType` | int | ‫כן‬ | ‫תקופת זמן: `0` כל הזמנים, `1` החודש הזה, `2` החודש שעבר, `3` השבוע האחרון (`EInventoryReportFilterTypes.LastWeek`; בממשק ה-Angular הטאב לערך זה מתוייג במפתח התרגום `Item.PassingWeek`). אין אפשרות רבעון/שנה.‬ |
| `type` | int | ‫כן‬ | ‫מדד: `0` כמות שנמכרה, `1` ערך מכירות.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetTopSoldItems HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "filterType": 2,
  "type": 0,
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "Id": 1002,
      "Name": "Wireless Mouse",
      "QuantityToNotify": 450,
      "Errors": []
    },
    {
      "Id": 1001,
      "Name": "Laptop Pro",
      "QuantityToNotify": 120,
      "Errors": []
    },
    {
      "Id": 1003,
      "Name": "USB-C Cable",
      "QuantityToNotify": 300,
      "Errors": []
    }
  ]
}
```

‫`QuantityToNotify` משמש גם כעמודת המדד של הדוח: הוא נושא את הכמות שנמכרה כאשר `type: 0`, ואת ערך המכירות כאשר `type: 1`. שדות פריט אחרים (`Code`, מחירים וכו') אינם ממולאים בתשובה זו.‬

### ‫שגיאות‬

‫טוקן לא תקין/חסר מחזיר `null`. חשבון שפג תוקפו או רכיב מלאי כבוי מחזירים מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80) או `UnauthorizedInventoryAttempt` (403) בהתאמה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת פריטים בעלי הערך הגבוה ביותר‬

‫מחזיר את הפריטים עם ערך המלאי הכולל הגבוה ביותר.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetHighestByValue` |
| ‫**תשובה**‬ | `Item[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetHighestByValue HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "Name": "Laptop Pro",
      "QuantityToNotify": 42000.00,
      "Errors": []
    },
    {
      "Name": "Server Unit",
      "QuantityToNotify": 40000.00,
      "Errors": []
    },
    {
      "Name": "Wireless Mouse",
      "QuantityToNotify": 3750.00,
      "Errors": []
    }
  ]
}
```

‫רק `Name` ו-`QuantityToNotify` (ערך המלאי הכולל) ממולאים — אין שדה `Id`, `Code`, `Quantity`, `Cost` או `TotalValue` בתשובה זו.‬

### ‫שגיאות‬

‫טוקן לא תקין, חשבון שפג תוקפו, או רכיב מלאי כבוי, כולם מחזירים `null` — לא אובייקט שגיאה — ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior).‬

---

## ‫שליפת דוח תנועות פריטים‬

‫מחזיר את היסטוריית התנועות (קליטות, מכירות והתאמות) עבור פריט אחד, או עבור כל הארגון אם לא צוין פריט.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetItemsMovementReport` |
| ‫**תשובה**‬ | ‫אובייקט `ItemsMovement` — `{ Item, ItemsBalance[] }`‬ |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `itemId` | int? | ‫לא‬ | ‫פריט המלאי לדווח עליו. השמיטו או שלחו `null` אם אין.‬ |
| `fromDate` | DateTime? | ‫לא‬ | ‫תחילת חלון הדיווח. השמיטו או שלחו `null` אם אין.‬ |
| `toDate` | DateTime? | ‫לא‬ | ‫סוף חלון הדיווח. השמיטו או שלחו `null` אם אין.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

‫`Item` נושא את `Id`, `Name`, `Code`, `Description`, `SellingPrice`, `PurchasePrice`, `SellingCurrency`, `PurchaseCurrency`, `QuantityToNotify` (הכמות הנוכחית במלאי), ו-`UnitType`. כל שורת `ItemsBalance` נושאת `Date`, `Qty`, `Entry`, `Exit` ו-`Op` (בלי מזהי פריט לכל שורה — כולן מתארות את `Item` היחיד שלמעלה).‬

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetItemsMovementReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "itemId": 1001,
  "fromDate": "/Date(1788210000000+0300)/",
  "toDate": "/Date(1790801999000+0300)/",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Item": {
      "Id": 1001,
      "Name": "Laptop Pro",
      "Code": "LP-001",
      "Description": "High-performance laptop",
      "SellingPrice": 4500.00,
      "PurchasePrice": 2800.00,
      "SellingCurrency": "ILS",
      "PurchaseCurrency": "ILS",
      "QuantityToNotify": 8,
      "UnitType": 0
    },
    "ItemsBalance": [
      {
        "Date": "/Date(1788210000000+0300)/",
        "Qty": 10,
        "Entry": 10,
        "Exit": 0,
        "Op": 10
      },
      {
        "Date": "/Date(1790801999000+0300)/",
        "Qty": 8,
        "Entry": 0,
        "Exit": 2,
        "Op": 8
      }
    ],
    "Errors": []
  }
}
```

### ‫שגיאות‬

| ‫מה קורה‬ | ‫תשובה‬ |
| --- | --- |
| ‫טוקן לא תקין לגמרי (נכשל בפענוח)‬ | `{"d":null}` |
| ‫חשבון שפג תוקפו‬ | ‫אובייקט `ItemsMovement` עם `Errors: [{"ID": 80, ...}]` (`UnauthorizedUser`), כאשר `Item` ו-`ItemsBalance` שניהם `null`‬ |
| ‫רכיב מלאי כבוי‬ | ‫אותה צורה כמו למעלה עם `UnauthorizedInventoryAttempt` (403)‬ |

‫ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior) להסבר מדוע מקרי הטוקן הלא-תקין והטוקן שפג תוקפו שונים זה מזה.‬

---

## ‫שליפת דוח תנועות כולל‬

‫מחזיר סיכומי תנועות עבור כל פריט בארגון, בלי צורך לשאול פריט אחד בכל פעם.‬

### ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetTotalMovementReport` |
| ‫**תשובה**‬ | `ItemBalance[]` |

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `fromDate` | DateTime? | ‫לא‬ | ‫תחילת חלון הדיווח. השמיטו או שלחו `null` אם אין.‬ |
| `toDate` | DateTime? | ‫לא‬ | ‫סוף חלון הדיווח. השמיטו או שלחו `null` אם אין.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

‫כל שורת `ItemBalance` נושאת `InventoryId`, `ItemName`, `ItemCode`, `Price`, `TotalPrice`, `Qty`, `Entry`, `Exit` ו-`Op` — בניגוד לדוח העלות למעלה, דוח זה אינו ממלא את `Cost` או `UnitType`.‬

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetTotalMovementReport HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "fromDate": "/Date(1788210000000+0300)/",
  "toDate": "/Date(1790801999000+0300)/",
  "token": "<token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": [
    {
      "InventoryId": 1001,
      "ItemName": "Laptop Pro",
      "ItemCode": "LP-001",
      "Price": 4500.00,
      "TotalPrice": 36000.00,
      "Qty": 8,
      "Entry": 10,
      "Exit": 2,
      "Op": 8
    },
    {
      "InventoryId": 1002,
      "ItemName": "Wireless Mouse",
      "ItemCode": "WM-001",
      "Price": 150.00,
      "TotalPrice": 7200.00,
      "Qty": 48,
      "Entry": 50,
      "Exit": 2,
      "Op": 48
    }
  ]
}
```

### ‫שגיאות‬

| ‫מה קורה‬ | ‫תשובה‬ |
| --- | --- |
| ‫טוקן לא תקין לגמרי (נכשל בפענוח)‬ | `{"d":[]}` |
| ‫חשבון שפג תוקפו‬ | ‫מערך בעל איבר אחד הנושא את `UnauthorizedUser` (80)‬ |
| ‫רכיב מלאי כבוי‬ | ‫מערך בעל איבר אחד הנושא את `UnauthorizedInventoryAttempt` (403)‬ |

‫ראו [התנהגות כאשר רכיב המלאי כבוי](overview.md#module-inactive-behavior) להסבר מדוע מקרי הטוקן הלא-תקין והטוקן שפג תוקפו שונים זה מזה.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetInventoryCostReport" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetTopSoldItems" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetHighestByValue" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetItemsMovementReport" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetTotalMovementReport" method="post" %}
{% endopenapi-operation %}
