# ‫סקירת מתודות סליקה‬

‫ה-API של הסליקה מחייב כרטיסי אשראי (וגם ביט / Google Pay / Apple Pay) דרך חשבון הסליקה המוגדר על הארגון שלכם ב-Invoice4U, ויכול ליצור אוטומטית את המסמך המתאים.‬

### ‫חברות סליקה נתמכות‬

‫ה-API עובד עם ספק הסליקה המוגדר בחשבונכם — כולל **משולם**, **קארדקום** ו-**UPay**. התהליך זהה מהצד שלכם; ה-API מנתב לספק שלכם.‬

### ‫תהליך הדף המתארח‬

‫רוב החיובים משתמשים בדף תשלום מתארח:‬

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[Your server:<br/>ProcessApiRequestV2]:::step --> B{Request, API key &<br/>terminal valid?}:::dec
    B -- ✗ --> E1[EmptyObjectInRequest 146<br/>ApiKeyNotInCorrectFormat 303 · UnauthorizedUser 80<br/>ClearingTerminalDoesntExists 96]:::err
    B -- ✓ --> C[ClearingRedirectUrl<br/>returned]:::step
    C --> D[🖥 Customer pays on<br/>hosted page]:::page
    D --> F{Charge OK?}:::dec
    F -- ✓ --> G[Document created<br/>if IsDocCreate]:::step
    F -- ✗ --> H
    G --> H[POST CallBackUrl<br/>server-to-server result]:::cb
    H --> I[Customer redirected<br/>to ReturnUrl]:::cb
```

1. ‫קראו ל-[`ProcessApiRequestV2`](process-api-request-v2.md) עם הסכום, פרטי הלקוח והדגלים.‬
2. ‫הפנו את הלקוח ל-`ClearingRedirectUrl` המוחזר.‬
3. ‫Invoice4U מודיע ל-`CallBackUrl` שלכם ומפנה את הלקוח ל-`ReturnUrl` שלכם.‬
4. ‫אם `IsDocCreate` היה `true`, המסמך נוצר אוטומטית לאחר חיוב מוצלח.‬

‫**חיובי טוקן** (`ChargeWithToken`) ו**זיכויים** (`Refund`) הם שרת-לשרת — ללא הפניה; התוצאה מוחזרת סינכרונית.‬

### ‫וריאציות‬

| ‫וריאציה‬ | ‫דגל/ים‬ | ‫עמוד‬ |
| ------- | ------ | ---- |
| ‫חיוב רגיל (דף מתארח)‬ | — | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md)‬ |
| ‫חיוב בתשלומים / קרדיט‬ | `Type` = 2/3 | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md)‬ |
| ‫ביט / Google Pay / Apple Pay‬ | `IsBitPayment` / `IsGooglePay` / `IsApplePay` | ‫[ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md)‬ |
| ‫שמירת טוקן כרטיס בלבד‬ | `AddToken` | ‫[טוקנים (כרטיסים שמורים)](tokens-and-standing-orders.md)‬ |
| ‫שמירת טוקן + חיוב‬ | `AddTokenAndCharge` | ‫[טוקנים (כרטיסים שמורים)](tokens-and-standing-orders.md)‬ |
| ‫חיוב טוקן שמור‬ | `ChargeWithToken` | ‫[טוקנים (כרטיסים שמורים)](tokens-and-standing-orders.md)‬ |
| ‫הוראת קבע (חיוב חוזר)‬ | `IsStandingOrderClearance` | ‫[הוראות קבע (חיובים חוזרים)](standing-orders.md)‬ |
| ‫זיכוי‬ | `Refund` | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md#refunds)‬ |
| ‫שאילתת היסטוריית חיובים‬ | — | ‫[לוגי סליקה](clearing-logs.md)‬ |
| ‫בדיקת חשבון הסליקה והפיצ'רים המופעלים‬ | — | ‫[שליפת חשבון הסליקה](get-clearing-account.md)‬ |

{% hint style="warning" %}
‫`ProcessApiRequest` (V1) ווריאציות ה-GET ‏`ProcessApiRequestFullContents*` עדיין עובדות אך הן **legacy**. אינטגרציות חדשות צריכות להשתמש ב-`ProcessApiRequestV2` בלבד.‬
{% endhint %}

### ‫דרישות מוקדמות‬

* ‫חשבון סליקה מוגדר ופעיל בארגון שלכם (מוגדר באפליקציית האינטרנט של Invoice4U). בדקו אותו עם [`GetClearingAccount`](get-clearing-account.md).‬
* ‫לטוקנים / הוראות קבע: פיצ'ר הטוקן / הוראת הקבע מופעל על מסוף הסליקה שלכם (אחרת `ApiTokenizationNotApprovedInClearingTerminal` ‏309 / `ApiStandingOrderNotApprovedInClearingTerminal` ‏310).‬
* ‫לביט / Google Pay / Apple Pay: ראו [ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md) — אמצעי ארנק דורשים הפעלה בחשבון ותמיכת ספק.‬
