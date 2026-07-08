# רישום משתמשים (שותפים)

ה-API כולל מתודה ייעודית לשותפים לרישום חשבונות Invoice4U חדשים באופן תכנותי:

| | |
| - | - |
| ‏**מתודה** | `POST` |
| ‏**נתיב** | `/UserRegistrationApi` |
| ‏**תשובה** | `UserRegApiObject` (בדקו את `Errors`) |

{% hint style="warning" %}
מתודה זו **מוגבלת**. היא דורשת טוקן ייחודי לשותף המונפק על ידי Invoice4U **וגם** כתובת ה-IP של השרת הקורא חייבת להיות ברשימה הלבנה. היא אינה זמינה למשתמשי API רגילים.
{% endhint %}

### אובייקט ה-UserRegApiObject (לעיון)

| ‏שדה | ‏טיפוס | ‏חובה | ‏תיאור |
| --- | ----- | ---- | ----- |
| `Email` | string | ‏כן | ‏אימייל החשבון החדש. חייב להיות ייחודי ותקין. |
| `UserPassword` | string | ‏כן | ‏חייב לעבור את מדיניות הסיסמאות. |
| `FirstName` / `LastName` | string | ‏כן | ‏שם בעל החשבון. |
| `CompanyName` | string | ‏כן | ‏שם העסק. |
| `OrganizationUniqueId` | string | ‏כן | ‏מספר עוסק/ח.פ של העסק. חייב להיות ייחודי. |
| `Phone` / `Mobile` | string | ‏לא | ‏מספרי טלפון. |
| `TaxRate` | int | ‏לא | ‏חייב להיות שיעור המע"מ החוקי הנוכחי או `0` (פטור ממס). |
| `BusinessType` | int | ‏לא | enum של סוג עסק (ברירת מחדל `1` — עוסק מורשה). |
| `BundleID` | int | ‏לא | ‏חבילת מנוי. |
| `ApiKey` | string (GUID) | ‏לא | ‏מפתח API מוקצה מראש לחשבון החדש. |

### שגיאות נפוצות

| ‏שגיאה (ID) | ‏משמעות |
| ---------- | ------- |
| `ApiInvalidUniqueToken` (308) | ‏טוקן שותף חסר/לא תקין. |
| `ApiUnauthorizedAccessInvalidIPAddress` (306) | ‏ה-IP הקורא לא ברשימה הלבנה. |
| `EmailExists` (1) / `EmailNotValid` (16) | ‏אימייל כפול/לא תקין. |
| `UniqueIdExists` (9) / `UniqueIDNotValid` (64) | ‏מספר עסק כפול/לא תקין. |
| `PasswordNotValid` (17) | ‏סיסמה חלשה. |
| `InvalidVatPercentage` (77) | `TaxRate` אינו השיעור החוקי או 0. |

### איך הופכים לשותף

אם אתם צריכים ליצור חשבונות Invoice4U עבור המשתמשים שלכם (פלטפורמות, מרקטפלייסים, מערכות הנהלת חשבונות), פנו לפיתוח העסקי של Invoice4U לקבלת טוקן שותף ורישום כתובות ה-IP של השרתים שלכם. תהליך הקליטה כולל מיפוי חבילות וגישה לסביבת ה-QA.

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/UserRegistrationApi" method="post" %}
{% endopenapi-operation %}
