# יצירת לקוח

יוצר לקוח בארגון המאומת. אם נשלח `ID` והוא קיים, הקריאה מתנהגת כעדכון.

## מתודה

| | |
| - | - |
| ‏**מתודה** | `POST` |
| ‏**נתיב** | `/CreateCustomer` |
| ‏**תשובה** | ‏אובייקט `Customer` (בדקו את `Errors` וקודי `ID` שליליים) |

וריאציות:

| ‏נתיב | ‏מתודה | ‏אימות | ‏הערות |
| ---- | ----- | ----- | ----- |
| `/CreateCustomer` | POST | token | ‏הסטנדרטי — אובייקט `Customer` מלא. |
| `/CreateCustomerREST` | GET | ‏אימייל+סיסמה | ‏וריאציית query string. |
| `/CreateCustomerParamsREST` | GET | ‏אימייל+סיסמה | ‏פרמטרים שטוחים (`name`, `customerEmail`, `uniqueId`, `phone`, `cell`, `externalNumber`); תמיד מאפשר שמות לא ייחודיים. |

## סכימת הבקשה

| ‏שדה | ‏טיפוס | ‏חובה | ‏תיאור |
| --- | ----- | ---- | ----- |
| `cu` | Customer | ‏כן | ‏הלקוח ליצירה. ראו [אובייקט ה-Customer](overview.md#the-customer-object). מינימום: `Name`. `UniqueID`, אם נשלח, חייב להיות מספרי. |
| `token` | string | ‏כן | ‏טוקן אימות. |

## דוגמת בקשה

```http
POST /Services/ApiService.svc/CreateCustomer HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "cu": {
    "Name": "Acme Ltd",
    "UniqueID": "512345678",
    "Email": "billing@acme.example",
    "Phone": "03-1234567",
    "Cell": "050-1234567",
    "Address": "1 Herzl St",
    "City": "Tel Aviv",
    "ExtNumber": 10045,
    "Active": true,
    "PayTerms": 30
  },
  "token": "<token>"
}
```

## דוגמת תשובה

```json
{
  "CreateCustomerResult": {
    "ID": 88231,
    "Name": "Acme Ltd",
    "UniqueID": "512345678",
    "Email": "billing@acme.example",
    "ExtNumber": 10045,
    "OrgID": 12345,
    "Active": true,
    "Errors": []
  }
}
```

## שגיאות

| ‏שגיאה (ID) | ‏משמעות |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‏טוקן לא תקין. |
| `CustomerNameCanNotBeEmpty` (28) | ‏חסר `Name`. |
| `CustomerUniqueIdNotNumeric` (79) | `UniqueID` מכיל תווים שאינם ספרות. |
| `CustomerNameExists` (2) / `ID = -1` | ‏שם כפול. קבעו `IsNonUniqueNameCreation: true` כדי לאפשר. |
| `CustomerExternalNumberExists` (31) / `ID = -2` | `ExtNumber` כפול. |
| `CustomerUniqueIdExistsForUser` (78) / `ID = -3` | `UniqueID` כפול. |
| `CustomerGuidExists` (84) / `ID = -4` | `Guid` כפול. |
| `ClientDoesntExists` (7) | ‏נשלח `ID` אך אין לקוח כזה (מסלול העדכון). |

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/CreateCustomer" method="post" %}
{% endopenapi-operation %}
