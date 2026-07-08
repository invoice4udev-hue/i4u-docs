# סוגי מסמכים

שדה ה-`DocumentType` בכל מסמך הוא enum מספרי:

| ‏ערך | ‏סוג | ‏עברית | ‏תיאור |
| --- | --- | ----- | ----- |
| `1` | Invoice | ‏חשבונית מס | ‏חשבונית מס. |
| `2` | Receipt | ‏קבלה | ‏קבלה על תשלום כנגד חשבוניות. |
| `3` | InvoiceReceipt | ‏חשבונית מס קבלה | ‏חשבונית + קבלה משולבת (הנפוץ ביותר לתשלום מיידי). |
| `4` | InvoiceCredit | ‏חשבונית זיכוי | ‏חשבונית זיכוי (החזר/ביטול). ראו את [מדריך חשבוניות הזיכוי](credit-invoices.md) לזיכויים מלאים וחלקיים. |
| `5` | ProformaInvoice | ‏חשבון עסקה | ‏חשבון עסקה. |
| `6` | InvoiceOrder | ‏הזמנת עבודה | ‏הזמנת עבודה. |
| `7` | InvoiceQuote | ‏הצעת מחיר | ‏הצעת מחיר. |
| `8` | InvoiceShip | ‏תעודת משלוח | ‏תעודת משלוח. |
| `9` | Deposits | ‏הפקדה | ‏הפקדה בנקאית של תשלומים שנגבו. |
| `10` | SupplierInvoiceToInventory | ‏חשבונית ספק למלאי | ‏חשבונית ספק שנקלטת למלאי. |
| `13` | PurchaseOrder | ‏הזמנת רכש | ‏הזמנת רכש (דורשת `SupplierId`/`SupplierName`). |

### מה כל סוג דורש

| ‏סוג | `Items` | `Payments` | `Invoices` (מסמכים מקושרים) |
| --- | ------- | ---------- | --------------------------- |
| Invoice (1) | ‏**חובה** | — | ‏אופציונלי (הפניות להצעת מחיר/הזמנה/משלוח/חשבון עסקה) |
| Receipt (2) | — | ‏**חובה** | ‏אופציונלי (הפניות לחשבונית/חשבון עסקה); סכום התשלומים חייב להתאים לסכומים המקושרים אלא אם `CloseReceipt` |
| InvoiceReceipt (3) | ‏**חובה** | ‏**חובה** — הסכומים חייבים להתאים לסכום הפריטים (ראו `AutoFixPaymentsMismatchItems`) | ‏אופציונלי (הפניות לחשבון עסקה/הזמנה/הצעת מחיר/משלוח) |
| InvoiceCredit (4) | ‏אופציונלי | ‏אופציונלי | ‏לפחות אחד מ-Items / Payments / Invoices — הפניות לחשבונית או חשבונית מס קבלה |
| ProformaInvoice (5) | ‏**חובה** | — | ‏אופציונלי (הפניות להצעת מחיר) |
| InvoiceOrder (6) | ‏**חובה** | — | ‏אופציונלי (הפניות להצעת מחיר) |
| InvoiceQuote (7) | ‏**חובה** | — | — |
| InvoiceShip (8) | ‏**חובה** (מחיר יכול להיות 0) | — | ‏אופציונלי (הפניות להזמנה) |
| Deposits (9) | — | ‏**חובה** — מזהי תשלומים קיימים, כולם מאותו סוג תשלום, שלא הופקדו קודם; `BankAccount` חובה | — |
| SupplierInvoiceToInventory (10) | ‏**חובה** (פריטי מלאי) | — | — |
| PurchaseOrder (13) | ‏**חובה** | — | — |

### כללי מסמכים מקושרים (`DocumentReffType`) {#documentrefftype}

בעת יצירת מסמך כנגד מסמכים קיימים (מערך `Invoices`), `DocumentReffType` חייב להיות אחד מסוגי המקור המותרים:

| ‏יוצרים | `DocumentReffType` מותר |
| ------ | ----------------------- |
| Invoice (1) | InvoiceQuote (7), InvoiceOrder (6), InvoiceShip (8), ProformaInvoice (5) |
| Receipt (2) | Invoice (1), ProformaInvoice (5); Receipt (2) רק כאשר `CancelDocument` הוא `true` |
| InvoiceReceipt (3) | ProformaInvoice (5), InvoiceOrder (6), InvoiceQuote (7), InvoiceShip (8) |
| InvoiceCredit (4) | Invoice (1), InvoiceReceipt (3) |
| InvoiceOrder (6) | InvoiceQuote (7) |
| InvoiceShip (8) | InvoiceOrder (6) |

הפרות מחזירות `DocumentReffTypeNotInRange` (53). כל מסמך מקושר חייב להשתייך לארגון שלכם, להתאים ללקוח, להיות בסטטוס תקין, וה-`ReceiptAmount` פר הפניה לא יעלה על היתרה הפתוחה — אחרת `DocumentReceiptAmountOutOfRange` (50) / `DocumentStatusInValid` (49).

### סטטוסי מסמכים (`StatusID`) {#statusid}

| ‏ערך | ‏סטטוס |
| --- | ----- |
| `1` | ‏פתוח |
| `2` | ‏סגור |
| `3` | ‏זוכה במלואו |
| `4` | ‏זוכה חלקית |
| `5` | ‏מבוטל |

### חשבונות עורכי דין

בחשבונות עם עיסוק עריכת דין, `Items[0].LawyerIdentifier` בערך `"1"` מסמן את המסמך כפקדונות ו-`"2"` כהוצאות; ה-API קובע את `LawyerDocType` בהתאם.
