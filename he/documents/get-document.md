# ‫שליפת מסמך בודד‬

‫שלוש דרכי חיפוש לשליפת מסמך אחד. כולן מוגבלות לארגון המאומת.‬

## ‫שליפה לפי מזהה — `GetDocument`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetDocument` |

```json
{ "docId": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c", "token": "<token>" }
```

‫`docId` הוא ה-GUID של המסמך (ה-`ID` שהוחזר ביצירה). מחזיר את ה-`Document`, או `ApiDocumentDoesNotExistForUser` (321) אם הוא שייך לארגון אחר; `null` על GUID לא תקין.‬

{% hint style="warning" %}
‫`docId` חייב להיות ה-GUID — **לא** מספר המסמך. שליחת מספר (למשל `"docId": 1045`) מחזירה `{ "d": null }` ללא שגיאה. ל-`GetDocument` אין גם פרמטר `documentNumber` / `DocumentNumber`; שמות פרמטרים לא מוכרים פשוט מתעלמים מהם, כך שגם אז מתקבל `{ "d": null }`. יש לכם רק את המספר? השתמשו ב-[`GetDocumentByNumber`](#get-by-number-getdocumentbynumber) שלהלן.‬
{% endhint %}

## ‫שליפה לפי מספר — `GetDocumentByNumber`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetDocumentByNumber` |

```json
{ "docNumber": 20260123, "documentType": 3, "token": "<token>" }
```

‫מספרי מסמכים הם רציפים **פר סוג**, ולכן הסוג נדרש — למשל קבלה מס' 1045 היא `{ "docNumber": 1045, "documentType": 2, ... }` (ראו [סוגי מסמכים](document-types.md)). וריאציית GET‏: `/GetDocumentByNumberREST`.‬

## ‫שליפה לפי מזהה API — ‏`GetDocumentByApiIdentifier`‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/GetDocumentByApiIdentifier` |

```json
{ "apiIdentifier": "order-10045-invoice", "docType": 1, "token": "<token>" }
```

‫שליפת מסמך לפי מפתח האידמפוטנטיות שלכם — מסלול השחזור המומלץ אחרי יצירה שנקטעה ב-timeout. וריאציית GET‏: `/GetDocumentByApiIdentifierREST`.‬

### ‫בדיקת קיום בלבד — `IsDocumentExistsByApiIdentifier`‬

| | |
| - | - |
| ‫**מתודה**‬ | `GET` |
| ‫**נתיב**‬ | `/IsDocumentExistsByApiIdentifier` |
| ‫**תשובה**‬ | `bool` |

```http
GET /Services/ApiService.svc/IsDocumentExistsByApiIdentifier?apiIdentifier=my-first-doc-001&token=<token> HTTP/1.1
Host: apiqa.invoice4u.co.il
```

```json
{ "d": true }
```

‫בדיקת קיום קלה יותר כשלא צריך את המסמך המלא — אותו `apiIdentifier` כמו למעלה, אך כפרמטרים ב-query string במקום גוף JSON. מחזיר `false` גם כשאין מסמך עם המזהה הזה וגם כשהטוקן לא תקין או פג תוקף — בדקו את הטוקן קודם עם [`IsAuthenticated`](../authentication/is-authenticated.md) אם צריך להבחין בין שני המקרים.‬

## ‫דוגמת תשובה‬

‫שלושתן מחזירות את [אובייקט המסמך](document-object.md) המלא:‬

```json
{
  "d": {
    "ID": "7f6a2c1e-8b4d-4f2a-9c3e-0d1e2f3a4b5c",
    "DocumentNumber": 20260123,
    "DocumentType": 3,
    "Subject": "Monthly subscription",
    "Total": 117.0,
    "StatusID": 2,
    "CipherText": "zKlvEbG4Na3F9XzyXFa%2frM%2bVhJwl4Pwx...",
    "CipherTextOriginal": "TBReFaFsHr1U%2fieSEr89F0G1N3P78jMtL...",
    "PrintOriginalPDFLink": null,
    "PrintCertifiedCopyPDFLink": null,
    "Errors": []
  }
}
```

{% hint style="info" %}
‫`Print*PDFLink` נקבע רק ב[יצירת מסמך](create-document.md) — שליפות אלה תמיד מקבלות שם `null`. בנו את כתובת ה-PDF בעצמכם מתוך `CipherText` / `CipherTextOriginal`; ראו [צפייה במסמך (קישורי PDF)](overview.md#viewing-the-document-pdf-links).‬
{% endhint %}

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `UnauthorizedUser` (80) | ‫הטוקן זוהה אך אינו תקף לקריאה זו (למשל חשבון שפג תוקפו).‬ |
| `ApiDocumentDoesNotExistForUser` (321) | ‫המסמך שייך לארגון אחר.‬ |

{% hint style="warning" %}
‫**תשובת `{ "d": null }` לא בהכרח אומרת שהמסמך לא קיים — בדקו קודם את הבקשה.** `GetDocument` ו-`GetDocumentByNumber` מחזירות `{ "d": null }` (HTTP 200, ללא `Errors`) כאשר:‬

* ‫לא ניתן לפענח את הטוקן כלל — למשל כשנשארו סביבו תווי placeholder כמו `<...>`, או תווים מיותרים. שלחו את מחרוזת הטוקן בלבד. בדקו אותו עם [`IsAuthenticated`](../authentication/is-authenticated.md);‬
* ‫`docId` אינו GUID (ראו למעלה).‬
{% endhint %}

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/GetDocument" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByNumber" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/GetDocumentByApiIdentifier" method="post" %}
{% endopenapi-operation %}

{% openapi-operation spec="invoice4u-api" path="/IsDocumentExistsByApiIdentifier" method="get" %}
{% endopenapi-operation %}
