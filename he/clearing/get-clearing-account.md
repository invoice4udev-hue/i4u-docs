# ‫שליפת חשבון הסליקה‬

‫מחזיר את חשבון הסליקה (המסוף) המוגדר למשתמש המאומת: באיזה ספק הוא משתמש, האם הוא פעיל, ואילו פיצ'רים (טוקנים, הוראות קבע, ביט, Google Pay, Apple Pay) מופעלים. השתמשו בו כבדיקה מקדימה לפני קריאה ל-[`ProcessApiRequestV2`](process-api-request-v2.md).‬

{% hint style="danger" %}
‫**התשובה מכילה את פרטי הגישה לספק הסליקה שלכם כטקסט גלוי** — `UserName`, `Password` ו-`Terminal`. קראו למתודה רק מהשרת שלכם, לעולם לא מדפדפן או מאפליקציית מובייל, ולעולם אל תרשמו ללוג, תשמרו במטמון או תעבירו הלאה את התשובה הגולמית. שמרו רק את הדגלים שאתם צריכים.‬
{% endhint %}

## ‫נקודת קצה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetClearingAccount` |
| ‫**תשובה**‬ | `ClearingAccount` |

## ‫סכמת הבקשה‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `token` | string | ‫כן‬ | ‫טוקן אימות (מפתח ה-API שלכם).‬ |

## ‫דוגמת בקשה‬

```http
POST /Services/ApiService.svc/GetClearingAccount HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

## ‫אובייקט ה-ClearingAccount‬

| ‫שדה‬ | ‫טיפוס‬ | ‫תיאור‬ |
| --- | ----- | ----- |
| `UserID` | int | ‫משתמש Invoice4U שאליו שייך חשבון הסליקה.‬ |
| `CompanyType` | int | ‫ספק הסליקה (`ClearingCompanies`): `6` UPay, `7` משולם, `15` קארדקום. `0` — לא מוגדר חשבון סליקה.‬ |
| `IsActive` | boolean | ‫האם חשבון הסליקה פעיל.‬ |
| `UserName` | string | ‫**רגיש.** שם המשתמש אצל הספק.‬ |
| `Password` | string | ‫**רגיש.** הסיסמה / מפתח ה-API אצל הספק.‬ |
| `Terminal` | string | ‫**רגיש.** מספר המסוף אצל הספק.‬ |
| `IsToken` | boolean | ‫טוקנים (כרטיסים שמורים) מופעלים על המסוף.‬ |
| `ExpirationDateToken` | datetime | ‫תוקף פיצ'ר הטוקנים. `2000-01-01` כשלא הוגדר.‬ |
| `IsStandingOrder` | boolean | ‫הוראות קבע מופעלות על המסוף.‬ |
| `ExpirationDateSO` | datetime | ‫תוקף פיצ'ר הוראות הקבע. `2000-01-01` כשלא הוגדר.‬ |
| `IsBitService` | boolean | ‫תשלומי ביט מופעלים.‬ |
| `IsGooglePay` / `IsApplePay` | boolean | ‫Google Pay / Apple Pay מופעלים.‬ |
| `IsEMVService` / `EmvTerminalNumber` | boolean / string | ‫פנימי. הגדרות EMV (קורא כרטיסים פיזי); לא בשימוש ב-API הסליקה.‬ |
| `IsNewApi` | boolean | ‫פנימי.‬ |
| `DateCreated` | datetime | ‫לא מאוכלס במתודה זו — תמיד `null`.‬ |
| `UpayType` | int | ‫לא מאוכלס במתודה זו — תמיד `0`.‬ |

‫`Errors`, `Info` ו-`OpenInfo` הם מעטפת התשובה הסטנדרטית — מערכים ריקים בהצלחה.‬

## ‫דוגמת תשובה‬

‫מסוף קארדקום עם טוקנים מופעלים והוראות קבע לא מופעלות:‬

```json
{
  "d": {
    "__type": "ClearingAccount:#Invoice.Common",
    "Errors": [],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "CompanyType": 15,
    "DateCreated": null,
    "EmvTerminalNumber": null,
    "ExpirationDateSO": "/Date(946677600000+0200)/",
    "ExpirationDateToken": "/Date(1830290400000+0200)/",
    "IsActive": true,
    "IsApplePay": false,
    "IsBitService": true,
    "IsEMVService": false,
    "IsGooglePay": false,
    "IsNewApi": false,
    "IsStandingOrder": false,
    "IsToken": true,
    "Password": "<provider password>",
    "Terminal": "<terminal number>",
    "UpayType": 0,
    "UserID": 12345,
    "UserName": "<provider username>"
  }
}
```

* ‫ערכי `<…>` מגיעים מהגדרות החשבון שלכם.‬
* ‫`ExpirationDateSO` הוא `2000-01-01` כאן כי הוראות קבע מעולם לא הופעלו.‬

### ‫אין חשבון סליקה מוגדר‬

‫אם לא מוגדר חשבון סליקה, הקריאה עדיין מצליחה: `Errors` ריק, `CompanyType` הוא `0`, וכל שאר השדות `null` ‏(`UserID` ו-`UpayType` הם `0`). בדקו את `CompanyType` ולא את `Errors`.‬

## ‫בדיקת זמינות פיצ'רים‬

‫השתמשו בתשובה כדי להימנע משגיאות צפויות של `ProcessApiRequestV2`:‬

| ‫לפני ש…‬ | ‫בדקו‬ | ‫אחרת השגיאה‬ |
| ------- | ---- | ----------- |
| ‫מחייבים בכלל‬ | ‫`CompanyType` שונה מ-`0`, ו-`Terminal` / `UserName` / `Password` מוגדרים עבור הספק שלכם‬ | `ClearingTerminalDoesntExists` (96) |
| ‫שומרים טוקן או מחייבים טוקן‬ | ‫`IsToken` הוא `true` ו-`ExpirationDateToken` בעתיד‬ | `ApiTokenizationNotApprovedInClearingTerminal` (309) |
| ‫יוצרים הוראת קבע‬ | ‫בדיקת הטוקן שלמעלה, וגם `IsStandingOrder` הוא `true` ו-`ExpirationDateSO` בעתיד‬ | `ApiStandingOrderNotApprovedInClearingTerminal` (310) |
| ‫מציעים Google Pay / Apple Pay‬ | ‫`IsGooglePay` / `IsApplePay` הוא `true`‬ | `ApiGooglePayNotAllowedForUser` (316) / `ApiApplePayNotAllowedForUser` (317) |

‫`IsBitService` הוא מידע בלבד — `ProcessApiRequestV2` אינו בודק אותו. ראו [ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md) לדרישות הארנקים.‬

## ‫שגיאות‬ {#errors}

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫טוקן לא תקין או לא מוכר.‬ |
| `ExpiredAccount` (66) | ‫תוקף החשבון פג לפני יותר מ-4 ימים.‬ |
| `GeneralError` (0) | ‫שגיאת שרת.‬ |

‫השגיאות מוחזרות בתוך אובייקט ה-`ClearingAccount`, וכל שאר השדות ריקים. טוקן לא תקין (נבדק מול `apiqa.invoice4u.co.il`):‬

```json
{
  "d": {
    "__type": "ClearingAccount:#Invoice.Common",
    "Errors": [
      { "__type": "CommonError:#Invoice.Common", "Error": "UnauthorizedUser", "ID": 80, "Paramters": null }
    ],
    "Info": [],
    "OpenInfo": [],
    "RecaptchaToken": null,
    "CompanyType": 0,
    "DateCreated": null,
    "EmvTerminalNumber": null,
    "ExpirationDateSO": null,
    "ExpirationDateToken": null,
    "IsActive": null,
    "IsApplePay": null,
    "IsBitService": null,
    "IsEMVService": null,
    "IsGooglePay": null,
    "IsNewApi": null,
    "IsStandingOrder": null,
    "IsToken": null,
    "Password": null,
    "Terminal": null,
    "UpayType": 0,
    "UserID": 0,
    "UserName": null
  }
}
```

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetClearingAccount" method="post" %}
{% endopenapi-operation %}
