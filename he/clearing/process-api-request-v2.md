# ‫ביצוע בקשת סליקה (V2)‬

‫מתודת הסליקה המרכזית. יוצרת דף תשלום מתארח, מחייבת טוקן שמור, או מזכה חיוב קודם — ואופציונלית יוצרת את המסמך המתאים.‬

## ‫מתודה‬

| | |
| - | - |
| ‫**מתודה**‬ | `POST` |
| ‫**נתיב**‬ | `/ProcessApiRequestV2` |
| ‫**תשובה**‬ | ‫אותו אובייקט `ApiClearingRequest`, מועשר בתוצאות (`ClearingRedirectUrl`, `PaymentId`, `DocumentNumber`, …) — בדקו את `Errors` תחילה‬ |

## ‫סכימת הבקשה — `request` (ApiClearingRequest)‬

### ‫אימות (אחד נדרש)‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Invoice4UUserApiKey` | string (GUID) | ‫אחד מהם‬ | ‫מומלץ.‬ |
| `Invoice4UUserEmail` + `Invoice4UUserPassword` | string | ‫אחד מהם‬ | ‫חלופת פרטי גישה.‬ |

### ‫פרטי החיוב‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Sum` | double | ‫**כן**‬ | ‫הסכום לחיוב.‬ |
| `Currency` | string | ‫לא‬ | `"NIS"` (ברירת מחדל), `"USD"`, `"EUR"`. |
| `Type` | int | ‫לא‬ | `1` רגיל (ברירת מחדל), `2` תשלומים, `3` תשלומי קרדיט, `4` זיכוי. |
| `PaymentsNum` | int | ‫לא‬ | ‫מספר תשלומים כאשר `Type` הוא 2/3.‬ |
| `Description` | string | ‫לא‬ | ‫תיאור החיוב (מוצג בדף/במסמך).‬ |
| `IsQaMode` | boolean | ‫לא‬ | `true` בבדיקות מול QA. |
| `OrderIdClientUsage` | string | ‫לא‬ | ‫מזהה ההזמנה שלכם, מוחזר בקולבקים.‬ |
| `CreditCardCompanyType` | int | ‫לא‬ | ‫דריסת חברת האשראי.‬ |

‫חיובי ביט / Google Pay / Apple Pay משתמשים בדגלים `IsBitPayment` / `IsGooglePay` / `IsApplePay` — ראו [ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md) להפעלה, מגבלות ושגיאות.‬

### ‫לקוח‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `CustomerId` | int | ‫מותנה‬ | ‫לקוח קיים. השם/אימייל/טלפון שלו משמשים לדף ולהתראות.‬ |
| `FullName` | string | ‫מותנה‬ | ‫שם מלא של הלקוח (חובה כשאין `CustomerId`).‬ |
| `Phone` | string | ‫מותנה‬ | ‫טלפון הלקוח (משמש ל-SMS/זיהוי בדף התשלום).‬ |
| `Email` | string | ‫לא‬ | ‫אימייל הלקוח — מקבל את המסמך.‬ |
| `IsAutoCreateCustomer` | boolean | ‫לא‬ | ‫איתור-או-יצירה של רשומת לקוח אמיתית לפי טלפון/אימייל; אחרת החיוב משתמש בלקוח מזדמן.‬ |
| `IsGeneralClient` | boolean | ‫לא (ברירת מחדל `true`)‬ | ‫המסמך מופק ללקוח מזדמן.‬ |

### ‫הפניות וקולבקים‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `ReturnUrl` | string | ‫דף מתארח‬ | ‫לאן הלקוח מופנה לאחר התשלום.‬ |
| `CallBackUrl` | string | ‫מומלץ‬ | ‫כתובת התראה שרת-לשרת.‬ |

### ‫יצירת מסמך‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `IsDocCreate` | boolean | ‫לא‬ | ‫יצירת מסמך אוטומטית לאחר חיוב מוצלח.‬ |
| `DocHeadline` | string | ‫לא‬ | ‫נושא המסמך (ברירת מחדל: `Description`).‬ |
| `IsManualDocCreationsWithParams` | boolean | ‫לא‬ | ‫שליחת שורות פריטים מפורשות דרך שדות ה-`DocItem*` המופרדים ב-pipe שלהלן.‬ |
| `DocItemName` / `DocItemQuantity` / `DocItemPrice` | string | ‫עם פריטים ידניים‬ | ‫רשימות מופרדות ב-pipe, באורך שווה, למשל `"Item A\|Item B"`, `"1\|2"`, `"100\|50"`.‬ |
| `DocItemCode` / `DocItemTaxRate` | string | ‫לא‬ | ‫רשימות אופציונליות של קוד/שיעור מע"מ.‬ |
| `IsItemsBase64Encoded` | boolean | ‫לא‬ | ‫ערכי `DocItem*` מקודדים ב-Base64 (לתווים מיוחדים).‬ |
| `DocBranchId` | string | ‫לא‬ | ‫סניף עבור המסמך.‬ |
| `DocComments` | string | ‫לא‬ | ‫הערות המסמך.‬ |
| `Language` / `DocLanguage` | string | ‫לא‬ | ‫שפת הדף / המסמך (`"he"` / `"en"`).‬ |
| `TaxPercentage` | double | ‫לא‬ | ‫דריסת מע"מ למסמך.‬ |

### ‫טוקנים, הוראות קבע, זיכויים‬

‫ראו [טוקנים והוראות קבע](tokens-and-standing-orders.md) עבור `AddToken`, `AddTokenAndCharge`, `ChargeWithToken`, `IsStandingOrderClearance`, `StandingOrderDuration`, `StandingOrderFirstChargeAmount`, `StandingOrderCallBackUrl` — ו[זיכויים](#refunds) להלן עבור `Refund` + `PaymentId`.‬

## ‫דוגמת בקשה — דף מתארח + מסמך אוטומטי‬

```http
POST /Services/ApiService.svc/ProcessApiRequestV2 HTTP/1.1
Host: apiqa.invoice4u.co.il
Content-Type: application/json

{
  "request": {
    "Invoice4UUserApiKey": "d2f1a6b3-1234-4c9a-9f00-1a2b3c4d5e6f",
    "Sum": 117.0,
    "Currency": "NIS",
    "Type": 1,
    "FullName": "Israel Israeli",
    "Phone": "0501234567",
    "Email": "israel@example.com",
    "Description": "Order #10045",
    "OrderIdClientUsage": "10045",
    "IsDocCreate": true,
    "DocHeadline": "Order #10045",
    "ReturnUrl": "https://shop.example/thanks",
    "CallBackUrl": "https://shop.example/api/i4u-callback",
    "IsQaMode": true
  }
}
```

## ‫דוגמת תשובה‬

```json
{
  "ProcessApiRequestV2Result": {
    "Sum": 117.0,
    "OrderIdClientUsage": "10045",
    "ClearingRedirectUrl": "https://pay.example-provider.co.il/page/abc123",
    "PaymentId": "ab12cd34",
    "Errors": []
  }
}
```

‫הפנו את הלקוח ל-`ClearingRedirectUrl`. לאחר התשלום תקבלו את הקולבק, וכאשר `IsDocCreate` מוגדר, שדות המסמך (`DocumentId`, `DocumentNumber`, `CipherText`) מאוכלסים.‬

## ‫זיכויים‬ {#refunds}

‫קבעו `Refund: true` וזהו את החיוב המקורי:‬

| ‫שדה‬ | ‫טיפוס‬ | ‫חובה‬ | ‫תיאור‬ |
| --- | ----- | ---- | ----- |
| `Refund` | boolean | ‫כן‬ | ‫מצב זיכוי.‬ |
| `PaymentId` | string | ‫תלוי-ספק‬ | ‫אסמכתת התשלום/העסקה המקורית (חובה ב-UPay).‬ |
| `Sum` | double | ‫כן‬ | ‫הסכום לזיכוי — לא יעלה על היתרה שטרם זוכתה.‬ |

‫מגבלות זיכוי: זיכויי קארדקום נבדקים מול היתרה שנותרה; זיכויי UPay אפשריים עד 5 חודשים מהחיוב (`ClearingErrorRefundTimeExceeded`, 158).‬

## ‫שגיאות נפוצות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `EmptyObjectInRequest` (146) | ‫גוף הבקשה חסר.‬ |
| `UnauthorizedUser` (80) | ‫מפתח API / פרטי גישה שגויים.‬ |
| `ClearingCompanyUndefined` (8) | ‫אין חשבון סליקה פעיל, או שהחשבון מוגדר שגוי.‬ |
| `ApiBadRequestChargeMethodMustBeSelected` (319) | ‫דגלים סותרים (למשל `AddTokenAndCharge` + `IsStandingOrderClearance`).‬ |
| `ApiTokenizationNotApprovedInClearingTerminal` (309) | ‫פיצ'רי טוקן לא מופעלים על המסוף.‬ |
| `ApiStandingOrderNotApprovedInClearingTerminal` (310) | ‫הוראות קבע לא מופעלות.‬ |
| `ApiGooglePayNotAllowedForUser` (316) / `ApiApplePayNotAllowedForUser` (317) | ‫אמצעי הארנק לא מופעל.‬ |
| `ClientIDDoesntExists` (37) | `CustomerId` לא נמצא. |
| `NumberOfItemsIsNotEqual` (24) | ‫רשימות ה-`DocItem*` באורכים שונים.‬ |
| `ClearingError` (32) | ‫החיוב נדחה / שגיאת ספק — פרטים ב-`Paramters`.‬ |
| `ClearingErrorRefundTimeExceeded` (158) | ‫חלון הזיכוי חלף.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/ProcessApiRequestV2" method="post" %}
{% endopenapi-operation %}
