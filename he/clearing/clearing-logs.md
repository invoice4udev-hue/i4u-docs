# לוגי סליקה

כל בקשת סליקה ותשובה נרשמות כשורת `ClearingLog`. השתמשו במתודות האלה לשאילתת היסטוריית חיובים ולהתאמת עסקאות.

## אובייקט ה-ClearingLog

| ‏שדה | ‏טיפוס | ‏תיאור |
| --- | ----- | ----- |
| `Id` | int | ‏מזהה שורת הלוג. |
| `Date` | datetime | ‏חותמת זמן. |
| `LogType` | int | `1` בקשה, `2` תשובה. |
| `ClientName` | string | ‏שם הלקוח. |
| `Amount` | double | ‏הסכום שחויב. |
| `Currency` | int | `1` שקל, `2` דולר, `3` אירו. |
| `PaymentNumber` | int | ‏מספר תשלומים. |
| `CreditNumber` | string | 4 ספרות אחרונות של הכרטיס. |
| `ClearingCompany` / `ClearingCompanyName` | int / string | ‏ספק הסליקה. |
| `IsSuccess` | boolean | ‏תוצאת החיוב. |
| `ErrorMessage` | string | ‏טקסט השגיאה מהספק בכישלון. |
| `ClearingConfirmationNumber` | string | ‏מספר אישור/אסמכתא מהספק. |
| `ClearingTraceId` | string | ‏מזהה מעקב המקשר בקשה↔תשובה. |
| `PaymentId` | string | ‏אסמכתת התשלום אצל הספק — לשימוש ב[זיכויים](process-api-request-v2.md#refunds). |
| `IsCredit` | boolean | `true` עבור שורות זיכוי. |
| `CreditedTransaction` / `CreditAmount` | bool / double | ‏האם/בכמה חיוב זה זוכה מאוחר יותר. |
| `IsToken` | boolean | ‏חיוב מבוסס טוקן. |
| `IsBitPayment` / `IsGooglePay` / `IsApplePay` | boolean | ‏דגלי אמצעי תשלום חלופיים. |
| `IsDocumentCreated` / `DocId` | bool / GUID | ‏הפניה למסמך שנוצר אוטומטית. |
| `TransactionType` | int | ‏סוג מאוחד: 1 חיוב, 2 זיכוי/החזר, 3 תשלומים, 4 תשלומים עם עמלה, 5 יצירת טוקן, 6 טוקן+חיוב, 7 חיוב בטוקן. |

## שליפה לפי מזהה — `GetClearingLogById`

| | |
| - | - |
| ‏**מתודה** | `POST` |
| ‏**נתיב** | `/GetClearingLogById` |

```json
{ "clearingLogId": 123456, "token": "<token>" }
```

מחזיר את ה-`ClearingLog`. לוגים השייכים לארגון אחר מחזירים `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322).

## חיפוש — `GetClearingLogByParams`

| | |
| - | - |
| ‏**מתודה** | `POST` |
| ‏**נתיב** | `/GetClearingLogByParams` |

```json
{
  "searchParams": {
    "FromDate": "2026-06-01T00:00:00",
    "ToDate": "2026-06-30T23:59:59",
    "IsSuccess": true
  },
  "token": "<token>"
}
```

מחזיר `ClearingLog[]` התואם לפילטרים, מוגבל לארגון שלכם.

## הוספת לוג חיצוני — `ProcessApiRequestClearingLogInsertREST_V2`

לאינטגרציות שסולקות כרטיסים מחוץ ל-Invoice4U אך רוצות שהחיוב יירשם (למשל להופעה בדוחות):

| | |
| - | - |
| ‏**מתודה** | `GET` |
| ‏**נתיב** | `/ProcessApiRequestClearingLogInsertREST_V2` |

שלחו אובייקט `ClearingLog` ‏(`clearingLog`) עם לפחות `ClientName`, `Amount`, `PaymentNumber`, `Currency`, `CreditNumber` ‏(4 אחרונות), `IsSuccess`, `ClearingConfirmationNumber`, בתוספת ה-`token` שלכם. וריאציות legacy מבוססות פרטי גישה (`ProcessApiRequestClearingLogInsertREST`) קיימות לאינטגרציות ישנות.

## שגיאות

| ‏שגיאה (ID) | ‏משמעות |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‏טוקן/פרטי גישה לא תקינים. |
| `ApiUnauthorizedAccessForEntityNotBelongingToUser` (322) | ‏הלוג שייך לארגון אחר. |
| `ClearingCompanyUndefined` (8) | ‏לא מוגדר חשבון סליקה. |

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogById" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetClearingLogByParams" method="post" %}
{% endopenapi-operation %}
