# ‫שליחת מסמך במייל‬

‫שולח מסמך קיים במייל — אותו ערוץ משלוח שמופעל אוטומטית כש-`AssociatedEmails` מוגדר ביצירת המסמך, אך ניתן לקרוא לו בכל שלב מאוחר יותר (למשל כשלקוח מבקש לקבל שוב את החשבונית).‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/SendDocumentByMail` |
| ‫**תשובה**‬ | ‫`CommonObject` — ללא payload נתונים, רק `Errors` / `Info`‬ |

## ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| ----- | ---- | -------- | ----------- |
| `doc.ID` | GUID | ‫כן‬ | ‫מזהה המסמך לשליחה. השרת טוען מחדש את המסמך ממסד הנתונים לפי המזהה הזה — כל שדה אחר של `doc` שנשלח מתעלמים ממנו.‬ |
| `doc.AssociatedEmails` | [AssociatedEmail](document-object.md#associatedemail)[] | ‫לא‬ | ‫רשימת נמענים, למשל `{ "Mail": "..." }`. כשלא נשלח, המסמך נשלח לכתובת המייל של הלקוח כפי שרשומה במערכת.‬ |
| `token` | string | ‫כן‬ | ‫טוקן אימות.‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/SendDocumentByMail HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "ID": "3f2b9c1e-7a4d-4e8b-9c1a-2b3c4d5e6f70",
    "AssociatedEmails": [
      { "Mail": "billing@acme.example" }
    ]
  },
  "token": "<token>"
}
```

## ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [
      { "ID": 2, "Info": "SuccessfulAction", "Paramters": null }
    ],
    "OpenInfo": []
  }
}
```

## ‫הערות‬

* ‫הקריאה שולחת מייל אמיתי דרך אותו ערוץ משלוח כמו יצירת מסמך — אין מצב ניסוי ואין תצוגה מקדימה. הימנעו מלהפנות אותה לכתובות לקוחות אמיתיות מסקריפטים לבדיקות.‬
* ‫רק `doc.ID` ו-`doc.AssociatedEmails` נקראים על ידי השרת; הוא טוען את שאר המסמך בעצמו ומתעלם מכל שדה אחר שנשלח ב-`doc`.‬
* ‫אם `doc.AssociatedEmails` לא נשלח ואין ללקוח מייל רשום, הקריאה עדיין מדווחת על הצלחה — אך בפועל שום דבר לא נשלח.‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫חשבון שפג תוקפו, או שהמסמך שייך לארגון אחר.‬ |
| `GeneralError` (0) | ‫טוקן לא תקין או לא ניתן לפענוח, או כל כשל אחר בשליחת המייל.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/SendDocumentByMail" method="post" %}
{% endopenapi-operation %}
