# ‫מספרי הקצאה (רשות המסים)‬

‫חשבוניות ישראליות מעל הסף החוקי דורשות **מספר הקצאה** מרשות המסים. המתודות האלה בודקות את חיבור Israel Invoices שלכם, ושולפות או קובעות מספר הקצאה למסמך קיים.‬

## ‫בדיקת סטטוס החיבור — `UserIsraelInvoicesStatus`‬

‫מאמת אם הארגון מחובר לשירות חשבוניות ישראל, לפני ניסיון שליפה.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UserIsraelInvoicesStatus` |
| ‫**תשובה**‬ | ‫`Organization` — רק `ID`, ‏`IsraelInvoicesConnected` ו-`IsraelInvoicesTokenRegisterDate` משמעותיים; כל שדה אחר של `Organization` חוזר בערך ברירת המחדל שלו.‬ |

```json
{ "token": "<token>" }
```

```json
{
  "d": {
    "ID": 12345,
    "IsraelInvoicesConnected": true,
    "IsraelInvoicesTokenRegisterDate": "/Date(1767218400000+0200)/"
  }
}
```

## ‫שליפה מרשות המסים — `FetchAllocationNumber`‬

‫מבקש מספר הקצאה עבור מסמך שעדיין אין לו.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/FetchAllocationNumber` |
| ‫**תשובה**‬ | `Document` מעודכן (`AllocationNumber`, `AllocationMessage`) |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

‫דורש שהארגון יהיה מחובר לשירות חשבוניות ישראל (בדקו בהגדרות החשבון). מסמכים השייכים לארגון אחר מתעלמים מהם.‬

## ‫סביבות — QA מול ה-sandbox של רשות המסים‬ {#environments-qa-vs-ita-sandbox}

‫מספרי הקצאה נשלפים מה-**API האמיתי של רשות המסים (ITA) בשתי הסביבות** — כולל QA (‏`apiqa.invoice4u.co.il`). סביבת ה-ITA היא הגדרת שרת אחת ברמת הפלטפורמה כולה, המוגדרת כיום לפרודקשן; היא **אינה** נשלטת על ידי הבקשה שלכם:‬

* ‫קריאה לכתובת הבסיס של QA **אינה** מנתבת בקשות הקצאה ל-sandbox של ה-ITA.‬
* ‫לדגל `IsQaMode` אין השפעה על סביבת ה-ITA.‬
* ‫הארגון חייב להיות מחובר לשירות חשבוניות ישראל (הסכמת OAuth) — ללא החיבור הזה לא מונפק מספר הקצאה.‬

{% hint style="warning" %}
‫מספרי הקצאה שהונפקו בבדיקות QA הם הקצאות אמיתיות של רשות המסים. הימנעו מבקשתם עבור מסמכי בדיקה חד-פעמיים בארגונים המחוברים לשירות חשבוניות ישראל.‬
{% endhint %}

## ‫קביעה ידנית — `UpdateAllocationNumber`‬

‫שומר מספר הקצאה שהתקבל מחוץ ל-Invoice4U.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateAllocationNumber` |
| ‫**תשובה**‬ | `null` בהצלחה; `Document` עם `Errors` רק בכישלון |

```json
{
  "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
  "allocationNumber": "123456789",
  "token": "<token>"
}
```

‫המספר חייב להיות באורך **9 תווים** לפחות — אחרת `AllocationNumberInvalid` (162).‬

‫בהצלחה, התשובה היא `{ "d": null }` — המתודה אינה מחזירה את המסמך המעודכן:‬

```json
{ "d": null }
```

‫רק כישלון (טוקן לא תקין, או `allocationNumber` קצר מ-9 תווים) מחזיר `Document` עם `Errors` מאוכלס. קראו ל-[`GetDocument`](get-document.md) לאחר מכן אם אתם צריכים לקרוא בחזרה את ערך ה-`AllocationNumber` שנשמר.‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן לא תקין.‬ |
| `AllocationNumberInvalid` (162) | ‫מספר קצר מ-9 תווים.‬ |
| `AllocationNumberNotGenerated` (152) / `AllocationNumberNotSaved` (153) | ‫כשל בשליפה/שמירה מול רשות המסים.‬ |
| `AllocationNumberDeclined` (156) / `AllocationNumberDeclinedWaitDecision` (157) | ‫רשות המסים דחתה את הבקשה / ממתין להחלטה.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/UserIsraelInvoicesStatus" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/FetchAllocationNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/UpdateAllocationNumber" method="post" %}
{% endopenapi-operation %}
