# ‫חשבוניות זיכוי (זיכוי מלא וחלקי)‬

‫**חשבונית זיכוי** (`DocumentType: 4`) מבטלת את כולה או חלק מחשבונית או חשבונית מס קבלה שהופקה קודם. היא נוצרת במתודה הרגילה של [יצירת מסמך](create-document.md) — מה שמייחד אותה הוא מערך ההפניות `Invoices` וכללי הולידציה סביבו.‬

{% hint style="info" %}
‫**זיכויים חלקיים הם נושא התמיכה הנפוץ ביותר.** הכלל המרכזי: כל מסמך מקושר ניתן לזיכוי רק עד **היתרה הניתנת לזיכוי** שלו — `Total − CreditAmount` (מה שטרם זוכה). קראו את [כללי הולידציה](#validation-rules) לפני האינטגרציה.‬
{% endhint %}

## ‫שלוש הדרכים להפיק זיכוי‬

| ‫מצב‬ | ‫איך‬ | ‫מתי להשתמש‬ |
| --- | --- | ---------- |
| ‫**זיכוי מלא**‬ | ‫הפניה למסמך המקורי עם `ReceiptAmount` השווה למלוא היתרה שנותרה.‬ | ‫ביטול חשבונית במלואה. המקור הופך ל-`FullyCredited` (StatusID 3).‬ |
| ‫**זיכוי חלקי**‬ | ‫הפניה למקור עם `ReceiptAmount` **הקטן** מהיתרה שנותרה.‬ | ‫החזר על פריט אחד, תיקון חיוב יתר. המקור הופך ל-`PartiallyCredited` (StatusID 4); ניתן לזכות את היתרה בהמשך.‬ |
| ‫**זיכוי עצמאי**‬ | ‫ללא מערך `Invoices` — רק `Items` (ו/או `Payments`).‬ | ‫זיכוי על משהו שאינו קשור למסמך ספציפי במערכת (למשל חשבוניות מיובאות/ישנות).‬ |

‫חשבונית זיכוי **ללא** הפניות, ללא פריטים וללא תשלומים נדחית עם `InvoiceCreditMustHaveRefDocuments` (57).‬

## ‫מבנה הבקשה (זיכוי עם הפניה)‬

```http
POST /Services/ApiService.svc/CreateDocument HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "doc": {
    "DocumentType": 4,
    "DocumentReffType": 1,
    "ClientID": 88231,
    "Subject": "Credit for invoice 20260123",
    "TaxIncluded": true,
    "Invoices": [
      { "ID": "7f6a2c1e-1111-2222-3333-444455556666", "ReceiptAmount": 50.0 }
    ],
    "Items": [
      { "Name": "Refund - Pro plan June", "Quantity": 1, "Price": 50.0 }
    ]
  },
  "token": "<token>"
}
```

‫הערות שדות:‬

| ‫שדה‬ | ‫כלל‬ |
| --- | --- |
| `DocumentType` | `4` (InvoiceCredit). |
| `DocumentReffType` | ‫סוג המסמכים המזוכים: `1` (Invoice) או `3` (InvoiceReceipt) **בלבד**. כל דבר אחר ← `DocumentReffTypeNotInRange`.‬ |
| `Invoices[].ID` | ‫GUID של המסמך לזיכוי (שדה ה-`ID` של המקור, לא `DocumentNumber`). חייב להשתייך לארגון שלכם.‬ |
| `Invoices[].ReceiptAmount` | ‫הסכום לזיכוי כנגד **אותו** מסמך. מספרים חיוביים — **אל** תשלחו שלילי.‬ |
| `Items` | ‫שורות פריטים המתארות את הזיכוי, במחירים **חיוביים**. השרת מטפל בסימן החשבונאי.‬ |
| `ClientID` | ‫חייב להתאים ללקוח במסמכים המקושרים.‬ |

‫ניתן לזכות **מספר מסמכים בחשבונית זיכוי אחת** — הוסיפו רשומה פר מסמך ב-`Invoices`, כל אחת עם `ReceiptAmount` משלה.‬

## ‫כללי ולידציה‬ {#validation-rules}

‫נבדקים פר שורה של `Invoices` (‏`Paramters` של השגיאה מכיל `"Row Number - N"`):‬

1. ‫**קיום ובעלות** — ה-GUID חייב להתאים למסמך בארגון שלכם ← `DocumentIDDoesntExists`.‬
2. ‫**התאמת לקוח** — ה-`ClientID` של המסמך המקושר חייב להיות שווה ל-`ClientID` של הזיכוי ← `ReceiptClientNameDoesntMatchInvoiceClientName`.‬
3. ‫**התאמת סוג** — סוג המסמך המקושר חייב להיות שווה ל-`DocumentReffType` ← `ReceiptDocumentReffTypeDoesntMatchInvoiceDocumentType`.‬
4. ‫**סטטוס** — מסמך שכבר `FullyCredited` (StatusID 3) לא ניתן לזיכוי נוסף ← `DocumentStatusInValid`.‬
5. ‫**תקרת הסכום** — כלל הזיכוי החלקי:‬

$$0 < \text{ReceiptAmount} \le \text{Total} - \text{CreditAmount}$$

‫`CreditAmount` הוא סכום כל הזיכויים שכבר הוחלו על אותו מסמך. חריגה מהיתרה שנותרה (או שליחת `0`/שלילי) ← `DocumentReceiptAmountOutOfRange`.‬

## ‫מה קורה אחרי זיכוי מוצלח‬

* ‫ה-`CreditAmount` של המסמך המקושר גדל ב-`ReceiptAmount` שלכם.‬
* ‫ה-`StatusID` שלו הופך ל-`4` (PartiallyCredited) או ל-`3` (FullyCredited) כאשר הזיכוי המצטבר מגיע ל-`Total`.‬
* ‫חשבונית הזיכוי עצמה מקבלת `DocumentNumber` חוקי משלה ברצף חשבוניות הזיכוי.‬
* ‫שלפו את המקור עם [שליפת מסמך בודד](get-document.md) כדי לקרוא את ה-`CreditAmount`, ‏`Balance` ו-`StatusID` המעודכנים לפני הפקת זיכויים נוספים.‬

## ‫מלכודות נפוצות‬

| ‫תופעה‬ | ‫סיבה‬ | ‫תיקון‬ |
| ----- | ---- | ----- |
| `DocumentReceiptAmountOutOfRange` על סכום "תקין" | ‫זיכויים חלקיים קודמים כבר צרכו חלק מהיתרה.‬ | ‫שלפו את המקור תחילה; זכו לכל היותר `Total − CreditAmount`.‬ |
| `DocumentReceiptAmountOutOfRange` עם סכומים שליליים | ‫שליחת `ReceiptAmount`/מחירים שליליים כדי "להפחית".‬ | ‫שלחו ערכים חיוביים — סוג המסמך נושא את הסימן.‬ |
| `DocumentStatusInValid` | ‫המקור כבר זוכה במלואו.‬ | ‫לא נשאר מה לזכות; בדקו `StatusID` לפני הקריאה.‬ |
| `DocumentReffTypeNotInRange` | ‫ניסיון לזכות קבלה, הצעת מחיר או הזמנה.‬ | ‫רק חשבונית (1) וחשבונית מס קבלה (3) ניתנות לזיכוי. ביטול קבלות — באמצעות קבלה מבטלת.‬ |
| ‫אי-התאמות סכומים בזיכויים מרובי שורות‬ | ‫עיגול בין שורות.‬ | ‫עגלו כל `ReceiptAmount` ל-2 ספרות; ודאו שסכום הפריטים שווה לסכום ה-`ReceiptAmount`-ים.‬ |

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `InvoiceCreditMustHaveRefDocuments` (57) | ‫לא נשלחו הפניות, פריטים או תשלומים.‬ |
| `DocumentReffTypeNotInRange` (53) | ‫`DocumentReffType` אינו חשבונית/חשבונית מס קבלה.‬ |
| `DocumentIDDoesntExists` | ‫ה-GUID המקושר לא נמצא בארגון שלכם.‬ |
| `ReceiptClientNameDoesntMatchInvoiceClientName` | ‫אי-התאמת לקוח בין הזיכוי למסמך המקושר.‬ |
| `ReceiptDocumentReffTypeDoesntMatchInvoiceDocumentType` | ‫סוג המסמך המקושר ≠ `DocumentReffType`.‬ |
| `DocumentStatusInValid` (49) | ‫המסמך המקושר כבר זוכה במלואו.‬ |
| `DocumentReceiptAmountOutOfRange` (50) | ‫`ReceiptAmount` ≤ 0 או עולה על היתרה הניתנת לזיכוי.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/CreateDocument" method="post" %}
{% endopenapi-operation %}
