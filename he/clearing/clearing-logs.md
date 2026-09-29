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
| `CurrencyName` | string | ‫שם טקסטואלי של `Currency` (למשל `"NIS"`).‬ |
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
| `ClearingLogBaseId` | int | ‫פנימי. מקשר שורת תשובה (`LogType` `2`) חזרה לשורת הבקשה (`LogType` `1`) שאליה היא שייכת.‬ |
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

‫מחזיר את ה-`ClearingLog`. לוגים השייכים לארגון אחר מחזירים `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322).‬

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

‫מחזיר `ClearingLog[]` התואם לפילטרים, מוגבל לארגון שלכם.‬

## ‫הוספת לוג חיצוני — `ProcessApiRequestClearingLogInsertREST_V2`‬

‫לאינטגרציות שסולקות כרטיסים מחוץ ל-Invoice4U אך רוצות שהחיוב יירשם (למשל להופעה בדוחות):‬

| | |
| - | - |
| ‫**מתודה**‬ | `GET` |
| ‫**נתיב**‬ | `/ProcessApiRequestClearingLogInsertREST_V2` |

‫שלחו אובייקט `ClearingLog` ‏(`clearingLog`) עם לפחות `ClientName`, `Amount`, `PaymentNumber`, `Currency`, `CreditNumber` ‏(4 אחרונות), `IsSuccess`, `ClearingConfirmationNumber`, בתוספת ה-`token` שלכם. וריאציות legacy מבוססות פרטי גישה (`ProcessApiRequestClearingLogInsertREST`) קיימות לאינטגרציות ישנות.‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫נקודת קצה‬ | ‫משמעות‬ |
| ---------- | --------- | ------- |
| `UnauthorizedUser` (80) | ‫שלושתן‬ | ‫טוקן/פרטי גישה לא תקינים.‬ |
| `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) | `GetClearingLogById` | ‫הלוג שייך לארגון אחר.‬ |
| `ClearingTerminalDoesntExists` (96) | `ProcessApiRequestClearingLogInsertREST_V2` | ‫אין חשבון סליקה, או שהמסוף של הספק שלכם מוגדר שגוי (חסר מסוף/שם משתמש/סיסמה).‬ |

‫`GetClearingLogById` ו-`GetClearingLogByParams` אינם בודקים אם מוגדר חשבון סליקה — הם בודקים רק את הטוקן.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogByParams" method="post" %}
{% endopenapi-operation %}
