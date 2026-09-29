# ‫רישום משתמשים (שותפים)‬

‫ה-API כולל מתודה ייעודית לשותפים לרישום חשבונות Invoice4U חדשים באופן תכנותי:‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UserRegistrationApi` |
| ‫**תשובה**‬ | `UserRegApiObject` (בדקו את `Errors`) |

{% hint style="warning" %}
‫מתודה זו **מוגבלת**. כל קריאה חייבת לשאת שני אישורים: `token` תקין (נבדק באותו האופן כמו [`IsAuthenticated`](../authentication/is-authenticated.md)) **וגם** `uniqueToken` ייעודי לשותף המונפק על ידי Invoice4U. כתובת ה-IP של השרת הקורא חייבת גם היא להיות ברשימה הלבנה, אם כי חלק מהשותפים פטורים מהבדיקה הזו. היא אינה זמינה למשתמשי API רגילים.‬
{% endhint %}

### ‫סכימת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `user` | UserRegApiObject | ‫כן‬ | ‫החשבון החדש ליצירה — ראו את תיאור האובייקט למטה.‬ |
| `token` | string | ‫כן‬ | ‫טוקן/מפתח API תקין, נבדק באותו האופן כמו `IsAuthenticated`.‬ |
| `uniqueToken` | string | ‫כן‬ | ‫הטוקן הייעודי לשותף שלכם, המונפק על ידי Invoice4U.‬ |

‫`token` לא תקין/חסר, **או** `uniqueToken` לא תקין, שניהם מחזירים `UnauthorizedUser` (80) — אין שגיאה ייעודית לטוקן שותף שגוי.‬

### ‫אובייקט ה-UserRegApiObject (לעיון)‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Email` | string | ‫כן‬ | ‫אימייל החשבון החדש. חייב להיות ייחודי ותקין.‬ |
| `UserPassword` | string | ‫כן‬ | ‫חייב לעבור את מדיניות הסיסמאות.‬ |
| `FirstName` / `LastName` | string | ‫כן‬ | ‫שם בעל החשבון.‬ |
| `CompanyName` | string | ‫כן‬ | ‫שם העסק.‬ |
| `OrganizationUniqueId` | string | ‫כן‬ | ‫מספר עוסק/ח.פ של העסק. חייב להיות ייחודי.‬ |
| `Phone` / `Mobile` | string | ‫לא‬ | ‫מספרי טלפון.‬ |
| `TaxRate` | int | ‫לא‬ | ‫חייב להיות שיעור המע"מ החוקי הנוכחי או `0` (פטור ממס).‬ |
| `BusinessType` | int | ‫לא‬ | enum של סוג עסק (ברירת מחדל `1` — עוסק מורשה). |
| `BundleID` | int | ‫לא‬ | ‫**מתעלמים ממנו.** השרת תמיד קובע את חבילת המנוי של הארגון החדש — חבילת ניסיון כברירת מחדל, שנדרסת על ידי מיפויים ייעודיים לשותפים מסוימים. כל ערך שתשלחו כאן אינו בשימוש.‬ |
| `ApiKey` | string (GUID) | ‫לא‬ | ‫מפתח API מוקצה מראש לחשבון החדש.‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UserRegistrationApi HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "user": {
    "Email": "owner@newcustomer.example",
    "UserPassword": "Str0ngP@ssw0rd!",
    "FirstName": "Dana",
    "LastName": "Cohen",
    "CompanyName": "New Customer Ltd",
    "OrganizationUniqueId": "512345678",
    "TaxRate": 17
  },
  "token": "<token>",
  "uniqueToken": "<partner-unique-token>"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Email": "owner@newcustomer.example",
    "FirstName": "Dana",
    "LastName": "Cohen",
    "CompanyName": "New Customer Ltd",
    "OrganizationUniqueId": "512345678",
    "Errors": []
  }
}
```

### ‫שגיאות נפוצות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫`token` לא תקין/חסר, או `uniqueToken` לא תקין/חסר.‬ |
| `ApiUnauthorizedAccessInvalidIPAddress` (306) | ‫ה-IP הקורא לא ברשימה הלבנה (חלק מהשותפים פטורים).‬ |
| `EmailExists` (1) / `EmailNotValid` (16) | ‫אימייל כפול/לא תקין.‬ |
| `UniqueIdExists` (9) / `UniqueIDNotValid` (64) | ‫מספר עסק כפול/לא תקין.‬ |
| `PasswordNotValid` (17) | ‫סיסמה חלשה.‬ |
| `InvalidVatPercentage` (77) | ‫`TaxRate` אינו השיעור החוקי או 0.‬ |

## ‫הגדרת מפתח API חדש: `UpdateAKU`‬

‫גם זה חלק מתהליך רישום השותפים: מחליף את מפתח ה-API הנוכחי של ארגון ב-GUID חדש שאתם מספקים. המפתח הישן מפסיק לעבוד באופן מיידי, לכן השתמשו בפעולה זו מיד לאחר `UserRegistrationApi` כדי להעניק לחשבון החדש מפתח ידוע, או כדי להחליף מפתח שהנפקתם בעבר.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/UpdateAKU` |
| ‫**גוף**‬ | `{ "newAkU": "<new API key (GUID)>", "token": "<current API key>" }` |
| ‫**תשובה**‬ | ‫אובייקט `User`; רק `Errors` ו-`Info` משמעותיים‬ |

### ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/UpdateAKU HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "newAkU": "0f9e8d7c-6b5a-4c3d-2e1f-a0b1c2d3e4f5",
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

### ‫דוגמת תשובה‬

```json
{
  "d": {
    "Errors": [],
    "Info": [
      { "ID": 0, "Info": "success" }
    ]
  }
}
```

### ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `ApiKeyNotInCorrectFormat` (303) | ‫`newAkU` אינו GUID תקין.‬ |
| `ApiKeyWasntGenerated` (144) | ‫השמירה של המפתח החדש נכשלה.‬ |
| `UnauthorizedUser` (80) | ‫`token` אינו תקין.‬ |
| `ExpiredAccount` (66) | ‫`token` תקין אך תוקף החשבון פג לפני יותר מ-4 ימים; המפתח נשאר ללא שינוי.‬ |
| `GeneralError` (0) | ‫שגיאת שרת בלתי צפויה.‬ |

### ‫איך הופכים לשותף‬

‫אם אתם צריכים ליצור חשבונות Invoice4U עבור המשתמשים שלכם (פלטפורמות, מרקטפלייסים, מערכות הנהלת חשבונות), פנו לפיתוח העסקי של Invoice4U לקבלת טוקן שותף ורישום כתובות ה-IP של השרתים שלכם. תהליך הקליטה כולל מיפוי חבילות וגישה לסביבת ה-QA.‬

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/UserRegistrationApi" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/UpdateAKU" method="post" %}
{% endopenapi-operation %}
