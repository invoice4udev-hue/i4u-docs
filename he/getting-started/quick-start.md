# ‫התחלה מהירה‬

‫צרו את המסמך הראשון שלכם בחמישה צעדים. עבדו מול **סביבת ה-QA** (`https://apiqa.invoice4u.co.il/Services/ApiService.svc`) עד שהתהליך שלכם יציב.‬

### 1. השיגו את מפתח ה-API

‫העתיקו את מפתח ה-API של הארגון (GUID) מאפליקציית ה-Invoice4U (הגדרות). תעבירו אותו כ-`token` בכל קריאה — אין שלב התחברות נפרד. אפשר לאמת אותו:‬

```http
POST /Services/ApiService.svc/IsAuthenticated HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{ "token": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f" }
```

‫ראו [סקירת אימות](../authentication/overview.md).‬

### 2. צרו לקוח

```http
POST /Services/ApiService.svc/CreateCustomer HTTP/1.1

{
  "cu": { "Name": "Acme Ltd", "Email": "billing@acme.example" },
  "token": "<token>"
}
```

‫שמרו את ה-`ID` שחוזר. ראו [יצירת לקוח](../customers/create-customer.md).‬

### 3. צרו מסמך

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1

{
  "doc": {
    "DocumentType": 3,
    "Subject": "First invoice-receipt",
    "ClientID": 88231,
    "TaxIncluded": true,
    "ApiIdentifier": "my-first-doc-001",
    "Items": [ { "Name": "Test item", "Quantity": 1, "Price": 117.0 } ],
    "Payments": [ { "PaymentType": 4, "Amount": 117.0, "Date": "2026-07-06T00:00:00" } ]
  },
  "token": "<token>"
}
```

‫ראו [יצירת מסמך](../documents/create-document.md).‬

### 4. בדקו את התשובה

* `Errors` ריק ← הצלחה. השתמשו ב-`DocumentNumber`, `ID` ובשדות `PrintOriginalPDFLink` / `PrintCertifiedCopyPDFLink`.
* `Errors` לא ריק ← תקנו ונסו שוב עם `ApiIdentifier` **חדש** (או השתמשו ב[יצירה עם ולידציית מזהה](../documents/create-document-with-validation.md) ושמרו על אותו מזהה).

### 5. אמתו באמצעות שליפה

```http
POST /Services/ApiService.svc/GetDocumentByApiIdentifier HTTP/1.1

{ "apiIdentifier": "my-first-doc-001", "docType": 3, "token": "<token>" }
```

‫ראו [שליפת מסמך בודד](../documents/get-document.md).‬

### ‫מה הלאה‬

* ‫מחייבים כרטיסים? קראו את [סקירת מתודות הסליקה](../clearing/overview.md).‬
* ‫לפני עלייה לאוויר, קראו את [הטיפים והחידודים](key-tips.md).‬
* ‫מעדיפים Postman? הורידו את [אוסף ה-Postman המוכן של Invoice4U](https://drive.google.com/uc?export=download&id=1qiCp0kNrWvgOGEzrqoCTrnAfoFLdCORp) — או הורידו את [מפרט ה-OpenAPI](https://drive.google.com/uc?export=download&id=1lkmSOUi5S1smYy61EVoXObqpV96fBu2F) וייבאו אותו ישירות ל-Postman.‬
