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

## ‫קביעה ידנית — `UpdateAllocationNumber`‬

‫שומר מספר הקצאה שהתקבל מחוץ ל-Invoice4U.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateAllocationNumber` |

```json
{
  "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
  "allocationNumber": "123456789",
  "token": "<token>"
}
```

‫המספר חייב להיות באורך **9 תווים** לפחות — אחרת `AllocationNumberInvalid` (162).‬

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
