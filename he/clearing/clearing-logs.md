# ‫לוגי סליקה‬

‫כל בקשת סליקה ותשובה נרשמות כשורת `ClearingLog`. השתמשו במתודות האלה לשאילתת היסטוריית חיובים ולהתאמת עסקאות.‬

## ‫אובייקט ה-ClearingLog‬ {#the-clearinglog-object}

| ‫שדה‬ | ‫טיפוס‬ | ‫תיאור‬ |
| --- | ----- | ----- |
| `Id` | int | ‫מזהה שורת הלוג.‬ |
| `OrganizationId` | int | ‫מזהה הארגון שלכם; משמש באופן פנימי לבדיקת הבעלות ב-`GetClearingLogById`.‬ |
| `Date` | datetime | ‫חותמת זמן.‬ |
| `LogType` | int | ‫`1` בקשה, `2` תשובה.‬ |
| `ClientName` | string | ‫שם הלקוח.‬ |
| `CustomerUniqueId` | string | ‫מספר זהות של המשלם שנקלט בדף המתארח — אותו ערך כמו `UniqueId` ב[גוף הקולבק](process-api-request-v2.md#callback-payload).‬ |
| `Amount` | double | ‫הסכום שחויב.‬ |
| `Currency` | int | ‫`1` שקל, `2` דולר, `3` אירו, `4` פאונד.‬ |
| `CurrencyName` | string | ‫שם טקסטואלי של `Currency`: `"ILS"`, `"USD"`, `"EUR"` או `"GBP"`.‬ |
| `PaymentNumber` | int | ‫מספר תשלומים.‬ |
| `CreditNumber` | string | ‫4 ספרות אחרונות של הכרטיס.‬ |
| `CreditType` / `CreditTypeName` | int / string | ‫מזהה ושם חברת האשראי, כפי שמוגדרים בחשבון הארגון שלכם — אינו קוד מערכתי קבוע.‬ |
| `ClearingCompany` / `ClearingCompanyName` | int / string | ‫ספק הסליקה (`ClearingCompanies`): 6 UPay, 7 Meshulam, 12 YaadSarig (רשומות היסטוריות בלבד), 15 Cardcom.‬ |
| `IsSuccess` | boolean | ‫תוצאת החיוב.‬ |
| `ErrorMessage` | string | ‫טקסט השגיאה מהספק בכישלון.‬ |
| `ClearingConfirmationNumber` | string | ‫מספר אישור/אסמכתא מהספק.‬ |
| `ClearingTraceId` | string | ‫מזהה מעקב המקשר בקשה↔תשובה.‬ |
| `PaymentId` | string | ‫אסמכתת התשלום אצל הספק — לשימוש ב[זיכויים](process-api-request-v2.md#refunds).‬ |
| `IsCredit` | boolean | ‫`true` עבור שורות זיכוי.‬ |
| `CreditedTransaction` / `CreditAmount` | bool / double | ‫האם/בכמה חיוב זה זוכה מאוחר יותר.‬ |
| `IsToken` | boolean | ‫חיוב מבוסס טוקן.‬ |
| `IsBitPayment` / `IsGooglePay` / `IsApplePay` | boolean | ‫דגלי אמצעי תשלום חלופיים.‬ |
| `IsDocumentCreated` / `DocId` | bool / GUID | ‫הפניה למסמך שנוצר אוטומטית.‬ |
| `TransactionType` | int | ‫סוג מאוחד: 0 חיוב, 1 יצירת טוקן, 2 טוקן+חיוב, 3 חיוב בטוקן, 4 תשלומים, 5 תשלומים עם עמלה, 6 זיכוי/החזר, 7 תשלום אישי מהאפליקציה, 8 תשלומים בטוקן.‬ |
| `CreateDocumentType` | int | ‫פנימי. קוד סוג מסמך שנרשם כאשר מסמך נוצר אוטומטית עבור החיוב (`0` כשלא נוצר מסמך).‬ |
| `ClearingLogBaseId` | int | ‫פנימי. מקשר בין שורת הבקשה (`LogType` `1`) לשורת התשובה (`LogType` `2`) של חיוב; `0` עד ששורת התשובה קיימת. כדי להתאים בין השורות, השתמשו ב-`ClearingTraceId`.‬ |
| `TransactionId` / `TransactionToken` | string | ‫פנימי. מזהי עסקה ספציפיים לספק; אינם נדרשים לאינטגרציה.‬ |
| `UpdateRequestLog` | boolean | ‫פנימי. משמש רק בעת הוספת לוג דרך `ProcessApiRequestClearingLogInsertREST_V2`; חסר משמעות בקריאת לוגים קיימים.‬ |

## ‫שליפה לפי מזהה — `GetClearingLogById`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetClearingLogById` |

```json
{ "clearingLogId": 123456, "token": "<token>" }
```

‫מחזיר את ה-`ClearingLog`, או `{ "d": null }` כשאין לוג עם המזהה הזה. דוגמה — שורת הבקשה ש[דוגמת עיבוד בקשת הסליקה](process-api-request-v2.md#example-response) כתבה כשיצרה את דף התשלום המתארח של Cardcom, כפי שנשלפה עם ה-`I4UClearingLogId` שלה לפני שהלקוח שילם:‬

```json
{
  "d": {
    "__type": "ClearingLog:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "Amount": 117,
    "ClearingCompany": 15,
    "ClearingCompanyName": "<clearing company name>",
    "ClearingConfirmationNumber": "",
    "ClearingLogBaseId": 0,
    "ClearingTraceId": "a1b2c3d4-0000-4000-8000-000000000002",
    "ClientName": "Israel Israeli",
    "CreateDocumentType": 1,
    "CreditAmount": 0,
    "CreditNumber": "",
    "CreditType": 1,
    "CreditTypeName": "<credit company name>",
    "CreditedTransaction": false,
    "Currency": 1,
    "CurrencyName": "ILS",
    "CustomerUniqueId": null,
    "Date": "/Date(1788210000000+0300)/",
    "DocId": null,
    "ErrorMessage": "",
    "Id": 123455,
    "IsApplePay": false,
    "IsBitPayment": false,
    "IsCredit": false,
    "IsDocumentCreated": false,
    "IsGooglePay": false,
    "IsSuccess": true,
    "IsToken": false,
    "LogType": 1,
    "OrganizationId": 12345,
    "PaymentId": "0",
    "PaymentNumber": 1,
    "TransactionId": "",
    "TransactionToken": "",
    "TransactionType": 0,
    "UpdateRequestLog": false
  }
}
```

* ‫ערכים בתוך `<…>` מגיעים מהגדרות החשבון שלכם.‬
* ‫שורת בקשה (`LogType` `1`) מכילה את מה שהיה ידוע ביצירת הדף: עדיין אין פרטי כרטיס, `PaymentId` הוא `"0"` ב-Cardcom, ו-`ClearingTraceId` זהה ל-`ClearingTraceId` שב-`OpenInfo` של התשובה.‬
* ‫כשהלקוח משלם, נוספת שורת תשובה (`LogType` `2`) עם התוצאה — `IsSuccess`, `CreditNumber` (4 ספרות אחרונות), `ClearingConfirmationNumber` (ה-`AuthNumber` של הקולבק), `PaymentId` של הספק (ה-`PaymentId` של הקולבק) ואותו `ClearingTraceId`. אתרו אותה עם `GetClearingLogByParams` לפי `PaymentId`.‬
* ‫`Errors`, `Info` ו-`OpenInfo` הם מערכים ריקים בהצלחה. `UpdateRequestLog` תמיד `false` בקריאה.‬

‫לוג השייך לארגון אחר נדחה עם `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) — ראו [שגיאות](#errors) לגבי האופן שבו שגיאות מגיעות כרגע.‬

## ‫חיפוש — `GetClearingLogByParams`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetClearingLogByParams` |

### ‫פילטרים — `searchParams` (ClearingLogSearch)‬

‫כל השדות הבאים הם אופציונליים; השמיטו פילטר כדי לדלג עליו.‬

| ‫שדה‬ | ‫טיפוס‬ | ‫תיאור‬ |
| --- | ----- | ----- |
| `ClearingLogId` | int | ‫סינון ללוג בודד לפי מזהה. מוחל רק כאשר הערך גדול מ-`0`.‬ |
| `OrganizationId` | int | ‫מתעלמים ממנו — ה-API תמיד מגביל את התוצאות לארגון של הטוקן שלכם; כל ערך שתשלחו נדרס.‬ |
| `FromDate` / `ToDate` | datetime | ‫טווח תאריכים (בפורמט WCF, ראו דוגמה).‬ |
| `IsSuccess` | boolean | ‫סינון לפי תוצאת החיוב.‬ |
| `CreditCardNumber` | string | ‫סינון לפי מספר הכרטיס/הספרות האחרונות כפי שמאוחסנות בלוג.‬ |
| `Currency` | int | ‫סינון לפי קוד `Currency` (`1` שקל, `2` דולר, `3` אירו, `4` פאונד).‬ |
| `CreditCardType` | int | ‫סינון לפי מזהה חברת האשראי של הארגון שלכם (תואם ל-`CreditType`/`CreditTypeName` המוחזרים).‬ |
| `FromAmount` / `ToAmount` | double | ‫טווח סכומים.‬ |
| `ClearingConfirmationNumber` | string | ‫סינון לפי מספר אישור/אסמכתא מהספק.‬ |
| `IsCredit` | boolean | ‫`true` להחזרת שורות זיכוי בלבד.‬ |
| `IsBitPayment` / `IsGooglePay` / `IsApplePay` | boolean | ‫סינון לפי דגלי אמצעי תשלום חלופיים.‬ |
| `CompanyType` | int | ‫סינון לפי ספק הסליקה (`ClearingCompanies`): `6` UPay, `7` Meshulam, `12` YaadSarig (רשומות היסטוריות בלבד), `15` Cardcom.‬ |
| `ClientName` | string | ‫סינון לפי שם הלקוח.‬ |
| `PaymentId` | string | ‫סינון לפי אסמכתת התשלום אצל הספק.‬ |
| `TransactionType` | int | ‫סינון לפי הסוג המאוחד — ראו [אובייקט ה-ClearingLog](#the-clearinglog-object) למעלה.‬ |

```json
{
  "searchParams": {
    "FromDate": "/Date(1780261200000+0300)/",
    "ToDate": "/Date(1782853199000+0300)/",
    "IsSuccess": true,
    "PaymentId": "100200300",
    "CompanyType": 15
  },
  "token": "<token>"
}
```

‫מחזיר `{ "d": [ … ] }` — מערך של אובייקטי `ClearingLog` כמו בדוגמה שלמעלה, מוגבל לארגון שלכם (`[]` כשאין התאמות).‬

## ‫הוספת לוג חיצוני — `ProcessApiRequestClearingLogInsertREST_V2`‬

‫לאינטגרציות שסולקות כרטיסים מחוץ ל-Invoice4U אך רוצות שהחיוב יירשם (למשל להופעה בדוחות):‬

| | |
| - | - |
| ‫**מתודה**‬ | `GET` |
| ‫**נתיב**‬ | `/ProcessApiRequestClearingLogInsertREST_V2` |

‫שלחו אובייקט `ClearingLog` ‏(`clearingLog`) עם לפחות `ClientName`, `Amount`, `PaymentNumber`, `Currency`, `CreditNumber` ‏(4 אחרונות), `IsSuccess`, `ClearingConfirmationNumber`, בתוספת ה-`token` שלכם. וריאציות legacy מבוססות פרטי גישה (`ProcessApiRequestClearingLogInsertREST`) קיימות לאינטגרציות ישנות.‬

## ‫שגיאות‬ {#errors}

| ‫שגיאה (ID)‬ | ‫נקודת קצה‬ | ‫משמעות‬ |
| ---------- | --------- | ------- |
| `UnauthorizedUser` (80) | ‫שלושתן‬ | ‫טוקן/פרטי גישה לא תקינים.‬ |
| `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) | `GetClearingLogById` | ‫הלוג שייך לארגון אחר.‬ |
| `ClearingTerminalDoesntExists` (96) | `ProcessApiRequestClearingLogInsertREST_V2` | ‫אין חשבון סליקה, או שהמסוף של הספק שלכם מוגדר שגוי (חסר מסוף/שם משתמש/סיסמה).‬ |

‫`GetClearingLogById` ו-`GetClearingLogByParams` אינם בודקים אם מוגדר חשבון סליקה — הם בודקים רק את הטוקן.‬

{% hint style="warning" %}
‫**תשובות שגיאה מ-`GetClearingLogById` ומ-`GetClearingLogByParams` אינן מגיעות כרגע ללקוח.** במקום להחזיר `UnauthorizedUser` (80) או `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322), השרת סוגר את החיבור ללא תשובה (למשל ב-curl: `Recv failure: Connection was reset`) — נבדק ב-Production וב-QA עם טוקן לא תקין. התייחסו לחיבור שנסגר במתודות אלה ככישלון אימות או בעלות: בדקו את הטוקן ואת מזהה הלוג.‬
{% endhint %}

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogByParams" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/ProcessApiRequestClearingLogInsertREST_V2" method="get" %}
{% endopenapi-operation %}
