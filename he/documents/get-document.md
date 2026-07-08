# שליפת מסמך בודד

שלוש דרכי חיפוש לשליפת מסמך אחד. כולן מוגבלות לארגון המאומת.

## שליפה לפי מזהה — `GetDocument`

| | |
| - | - |
| **מתודה** | `POST` |
| **נתיב** | `/GetDocument` |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

`docId` הוא ה-GUID של המסמך (ה-`ID` שהוחזר ביצירה). מחזיר את ה-`Document`, או `ApiDocumentDoesNotExistForUser` (321) אם הוא שייך לארגון אחר; `null` על GUID לא תקין.

## שליפה לפי מספר — `GetDocumentByNumber`

| | |
| - | - |
| **מתודה** | `POST` |
| **נתיב** | `/GetDocumentByNumber` |

```json
{ "docNumber": 20260123, "documentType": 3, "token": "<token>" }
```

מספרי מסמכים הם רציפים **פר סוג**, ולכן הסוג נדרש. וריאציית GET‏: `/GetDocumentByNumberREST`.

## שליפה לפי מזהה API — ‏`GetDocumentByApiIdentifier`

| | |
| - | - |
| **מתודה** | `POST` |
| **נתיב** | `/GetDocumentByApiIdentifier` |

```json
{ "apiIdentifier": "order-10045-invoice", "docType": 1, "token": "<token>" }
```

שליפת מסמך לפי מפתח האידמפוטנטיות שלכם — מסלול השחזור המומלץ אחרי יצירה שנקטעה ב-timeout. וריאציית GET‏: `/GetDocumentByApiIdentifierREST`.

בדיקת קיום בלבד: `IsDocumentExistsByApiIdentifier` ← `{ "apiIdentifier": "...", "token": "..." }` ← boolean.

## דוגמת תשובה

שלושתן מחזירות את [אובייקט המסמך](document-object.md) המלא:

```json
{
  "GetDocumentResult": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260123,
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "Total": 117.0,
    "StatusID": 2,
    "Errors": []
  }
}
```

## שגיאות

| שגיאה (ID) | משמעות |
| ---------- | ------- |
| `UnauthorizedUser` (80) | טוקן לא תקין. |
| `ApiDocumentDoesNotExistForUser` (321) | המסמך שייך לארגון אחר. |

## נסו את זה

{% openapi-operation spec="invoice4u-api" path="/GetDocument" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByApiIdentifier" method="post" %}
{% endopenapi-operation %}
