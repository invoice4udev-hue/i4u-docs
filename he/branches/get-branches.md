# שליפת סניפים

מחזיר את כל הסניפים של הארגון המאומת.

## מתודה

| | |
| - | - |
| **מתודה** | `POST` |
| **נתיב** | `/GetBranches` |
| **תשובה** | `Branch[]`, או `null` בשגיאת אימות/שרת |

## סכימת הבקשה

| שדה | טיפוס | חובה | תיאור |
| --- | ----- | ---- | ----- |
| `token` | string | כן | טוקן אימות. |

## דוגמת בקשה

```http
POST /Services/ApiService.svc/GetBranches HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "token": "<token>"
}
```

## דוגמת תשובה

```json
{
  "GetBranchesResult": [
    {
      "ID": 101,
      "Name": "Head Office",
      "Description": "Main branch",
      "Enabled": true,
      "IsDefault": true,
      "IsMain": true,
      "Email": "office@acme.example"
    },
    {
      "ID": 102,
      "Name": "North Branch",
      "Enabled": true,
      "IsDefault": false,
      "IsMain": false
    }
  ]
}
```

## שגיאות

מחזיר `null` כאשר הטוקן אינו תקין או בשגיאת שרת. השתמשו בערכי ה-`ID` המוחזרים כ-`BranchID` בעת [יצירת מסמכים](../documents/create-document.md).

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/GetBranches" method="post" %}
{% endopenapi-operation %}
