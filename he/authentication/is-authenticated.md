# ‫אימות עם מפתח ה-API‬

‫אין קריאת התחברות נפרדת. **מפתח ה-API (GUID)** של הארגון שלכם מועבר ישירות כפרמטר `token` בכל בקשה — כל מתודה מאמתת אותו באמצעות `IsAuthenticated`. התחברות עם אימייל וסיסמה (`VerifyLogin`) הוצאה משימוש והטוקנים שלה אינם מתקבלים על ידי ה-API.‬

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": { ... },
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

## ‫אימות מפתח: `IsAuthenticated`‬

‫מאמת מפתח API (או טוקן) ומחזיר את המשתמש שזוהה. שימושי לבדיקת פרטי גישה בשלב ההקמה.‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/IsAuthenticated` |
| ‫**גוף**‬ | `{ "token": "<API key>" }` |
| ‫**תשובה**‬ | ‫אובייקט `User`; בדקו את `Errors[]` לזיהוי בעיות‬ |

‫חשבון שפג תוקפו לפני יותר מ-**4 ימים** מקבל שגיאת `ExpiredAccount` על המשתמש המוחזר.‬

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/IsAuthenticated HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f"
}
```

## ‫שגיאות‬

| ‫תוצאה‬ | ‫משמעות‬ |
| ----- | ------- |
| `Errors[]` מכיל `UnauthorizedUser` (80) | ‫מפתח לא נמצא, לא תקין או בוטל.‬ |
| `Errors[]` מכיל `ExpiredAccount` (66) | ‫תוקף החשבון פג לפני יותר מ-4 ימים.‬ |

## ‫קשור: בדיקת תוקף החשבון‬

`GetExpDateByApiKey` מחזיר את תאריך תפוגת החשבון עבור המשתמש המאומת.

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetExpDateByApiKey` |
| ‫**גוף**‬ | `{ "token": "<API key>" }` |
| ‫**תשובה**‬ | ‫מחרוזת תאריך תפוגה, או `"UnauthorizedUser"`‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/IsAuthenticated" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetExpDateByApiKey" method="post" %}
{% endopenapi-operation %}
