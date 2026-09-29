# ‫ברוכים הבאים‬

‫ה-API של Invoice4U מאפשר לכם ליצור מסמכים תקינים מבחינת מס (חשבוניות, קבלות, חשבוניות זיכוי ועוד), לנהל לקוחות וסניפים, ולחייב כרטיסי אשראי דרך שירות הסליקה של Invoice4U — הכל מתוך האפליקציה שלכם.‬

‫השתמשו בו לאוטומציה של תהליכי חיוב, סנכרון ה-CRM או חנות האינטרנט שלכם עם Invoice4U, וגביית תשלומים באמצעות דפי סליקה מתארחים, טוקנים של כרטיסים שמורים או הוראות קבע.‬

‫שירות הסליקה תומך בשלושה ספקים — **קארדקום**, **UPay** ו-**משולם** (ערכי `ClearingCompanies`: `15`, `6`, `7`); הספק המוגדר בחשבונכם משמש אוטומטית. ראו את [סקירת הסליקה](../clearing/overview.md).‬

### ‫קבלת גישה‬

1. ‫צרו חשבון ב-[invoice4u.co.il](https://invoice4u.co.il).‬
2. ‫הפעילו גישת API לארגון שלכם (הגדרות ← API, או פנו לתמיכה).‬
3. ‫העבירו את מפתח ה-API של הארגון כ-`token` בכל קריאה — אין שלב התחברות נפרד.‬

### ‫כתובות בסיס‬

| ‫סביבה‬ | ‫כתובת בסיס‬ |
| ----- | ---------- |
| ‫פרודקשן‬ | `https://api.invoice4u.co.il/Services/ApiService.svc` |
| ‫QA (בדיקות)‬ | `https://apiqa.invoice4u.co.il/Services/ApiService.svc` |

‫כל המתודות בתיעוד הזה יחסיות לכתובות הבסיס האלה. פתחו ובדקו מול **QA** תחילה, ואז החליפו את כתובת הבסיס ל**פרודקשן**.‬

{% hint style="info" %}
‫ה-API הוא שירות WCF החשוף כ-REST (JSON). קיים גם endpoint של SOAP בכתובת `{baseUrl}/Soap` (basicHttpBinding) לאינטגרציות ישנות, אך REST/JSON הוא הממשק המומלץ והמתועד.‬
{% endhint %}

### ‫פורמט הבקשות‬

‫אלא אם צוין אחרת, הקריאות למתודות מתבצעות ב-**POST** עם גוף JSON שעוטף את פרמטרי הפעולה לפי שם (סגנון "wrapped request" של WCF):‬

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: api.invoice4u.co.il
Content-Type: application/json

{
  "doc": { ... },
  "token": "<your-token>"
}
```

### ‫אימות‬

‫כמעט כל מתודה מקבלת פרמטר `token` — זהו **מפתח ה-API** של הארגון שלכם (GUID), המועבר בגוף של כל קריאה. ראו [סקירת אימות](../authentication/overview.md).‬

### ‫מעטפת התשובה‬ {#response-envelope}

‫כל תשובה היא אובייקט JSON עם מאפיין יחיד `d` שמכיל את התוצאה:‬

```json
{
  "d": {
    "__type": "Document:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "DocumentNumber": 10045
  }
}
```

‫בהתאם למתודה, `d` יכול להיות גם ערך פשוט (`true`, מחרוזת, מערך) או `null`. אפשר להתעלם משדה `__type`.‬

‫רוב אובייקטי התשובה יורשים מעטפת משותפת. תמיד בדקו את `Errors` לפני שימוש בתוצאה:‬

| ‫שדה‬ | ‫סוג‬ | ‫תיאור‬ |
| --- | --- | ----- |
| `Errors` | array | ‫רשימת שגיאות. ריקה בהצלחה. כל פריט: `ID` (קוד שגיאה מספרי), `Error` (שם השגיאה), `Paramters` (הקשר אופציונלי, למשל מספר שורה).‬ |
| `Info` | array | ‫הודעות מידע. כל פריט: `ID`, `Info` (שם ההודעה, למשל `SuccessfulAction`), `Paramters`.‬ |
| `OpenInfo` | array | ‫תוספות מפתח/ערך שחלק מהמתודות מחזירות, כזוגות `{ "Key": "...", "Value": "..." }` — למשל `[{ "Key": "PaymentMismatchDelta", "Value": "0.01" }]`.‬ |

### ‫תאריכים‬ {#dates}

‫שדות תאריך נשלחים ומוחזרים בפורמט התאריך של WCF JSON: אלפיות שנייה מאז 1970-01-01 UTC, ואחריהן (אופציונלית) הפרש אזור הזמן.‬

```json
"IssueDate": "/Date(1788210000000+0300)/"
```

‫הערך הזה הוא 1 בספטמבר 2026, 00:00 שעון ישראל. מקודדי JSON עשויים לסמן את הלוכסנים ב-escape (`"\/Date(1788210000000+0300)\/"`) — שתי הצורות מתקבלות. מחרוזות ISO-8601 כמו `"2026-09-01T00:00:00"` **אינן** מתקבלות בבקשות. חריגה: השדה `date` האופציונלי של [`GetTaxRate`](../account/vat-rate-and-numbering.md) הוא מחרוזת תאריך פשוטה בפורמט `yyyy-MM-dd`, לא תאריך WCF.‬

‫כדי לבנות ערך, קחו את זמן Unix באלפיות שנייה (JavaScript: `date.getTime()`, C#: `DateTimeOffset.ToUnixTimeMilliseconds()`, PHP: `$date->getTimestamp() * 1000`) והוסיפו את הפרש אזור הזמן.‬

### ‫צעדים ראשונים‬

‫עברו על [ההתחלה המהירה](quick-start.md) ואז קראו את [הטיפים והחידודים](key-tips.md).‬

### ‫משאבים קריאים למכונה‬

* ‫[מפרט OpenAPI 3.0 בפורמט JSON](https://raw.githubusercontent.com/invoice4udev-hue/i4u-docs/main/openapi/invoice4u-openapi.json) — כל ממשק ה-API עבור מחוללי קוד, Postman וסוכני AI.‬
* ‫[אוסף Postman](https://raw.githubusercontent.com/invoice4udev-hue/i4u-docs/main/openapi/Invoice4u%20API%20collection.postman_collection.json) — בקשות מוכנות כמעט לכל מתודה מתועדת (רק `GetExpDateByApiKey`, מתודת שותפים בלבד, אינה כלולה).‬
* ‫סוכני AI: האתר מגיש [llms.txt](https://invoice4u.gitbook.io/invoice4u-docs/llms.txt), וכל עמוד זמין כ-Markdown על ידי הוספת `.md` לכתובת שלו.‬

### ‫תמיכה‬

‫לעזרה באינטגרציה, פנו לתמיכת Invoice4U דרך החשבון שלכם. צרפו לכל פנייה את המתודה (endpoint) שנקראה, גוף הבקשה, גוף התשובה והסביבה (QA/פרודקשן).‬

### ‫עמודים הבאים‬

* ‫[התחלה מהירה](quick-start.md)‬
* ‫[סקירת אימות](../authentication/overview.md)‬
* ‫[סקירת מתודות מסמכים](../documents/overview.md)‬
