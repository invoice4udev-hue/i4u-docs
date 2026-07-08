# ‫סקירת מתודות סליקה‬

‫ה-API של הסליקה מחייב כרטיסי אשראי (וגם ביט / Google Pay / Apple Pay) דרך חשבון הסליקה המוגדר על הארגון שלכם ב-Invoice4U, ויכול ליצור אוטומטית את המסמך המתאים.‬

### ‫חברות סליקה נתמכות‬

‫ה-API עובד עם ספק הסליקה המוגדר בחשבונכם — כולל **משולם**, **קארדקום**, **UPay** ו-**ייעד שריג**. התהליך זהה מהצד שלכם; ה-API מנתב לספק שלכם.‬

### ‫תהליך הדף המתארח‬

‫רוב החיובים משתמשים בדף תשלום מתארח:‬

```
Your server                    Invoice4U                        Customer
    │  ProcessApiRequestV2         │                               │
    ├──────────────────────────────►                               │
    │  ClearingRedirectUrl         │                               │
    ◄──────────────────────────────┤                               │
    │  redirect customer ──────────┼──────────────────────────────►│
    │                              │   customer pays on the page   │
    │                              ◄────────────────────────────────
    │   CallBackUrl notification   │                               │
    ◄──────────────────────────────┤                               │
    │                              │  (optional) document created  │
```

1. ‫קראו ל-[`ProcessApiRequestV2`](process-api-request-v2.md) עם הסכום, פרטי הלקוח והדגלים.‬
2. ‫הפנו את הלקוח ל-`ClearingRedirectUrl` המוחזר.‬
3. Invoice4U מודיע ל-`CallBackUrl` שלכם ומפנה את הלקוח ל-`ReturnUrl` שלכם.
4. ‫אם `IsDocCreate` היה `true`, המסמך נוצר אוטומטית לאחר חיוב מוצלח.‬

‫**חיובי טוקן** (`ChargeWithToken`) ו**זיכויים** (`Refund`) הם שרת-לשרת — ללא הפניה; התוצאה מוחזרת סינכרונית.‬

### ‫וריאציות‬

| ‫וריאציה‬ | ‫דגל/ים‬ | ‫עמוד‬ |
| ------- | ------ | ---- |
| ‫חיוב רגיל (דף מתארח)‬ | — | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md)‬ |
| ‫חיוב בתשלומים / קרדיט‬ | `Type` = 2/3 | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md)‬ |
| ‫ביט / Google Pay / Apple Pay‬ | `IsBitPayment` / `IsGooglePay` / `IsApplePay` | ‫[ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md)‬ |
| ‫שמירת טוקן כרטיס בלבד‬ | `AddToken` | ‫[טוקנים והוראות קבע](tokens-and-standing-orders.md)‬ |
| ‫שמירת טוקן + חיוב‬ | `AddTokenAndCharge` | ‫[טוקנים והוראות קבע](tokens-and-standing-orders.md)‬ |
| ‫חיוב טוקן שמור‬ | `ChargeWithToken` | ‫[טוקנים והוראות קבע](tokens-and-standing-orders.md)‬ |
| ‫הוראת קבע (חיוב חוזר)‬ | `IsStandingOrderClearance` | ‫[טוקנים והוראות קבע](tokens-and-standing-orders.md)‬ |
| ‫זיכוי‬ | `Refund` | ‫[ביצוע בקשת סליקה (V2)](process-api-request-v2.md#refunds)‬ |
| ‫שאילתת היסטוריית חיובים‬ | — | ‫[לוגי סליקה](clearing-logs.md)‬ |

{% hint style="warning" %}
`ProcessApiRequest` (V1) ווריאציות ה-GET ‏`ProcessApiRequestFullContents*` עדיין עובדות אך הן **legacy**. אינטגרציות חדשות צריכות להשתמש ב-`ProcessApiRequestV2` בלבד.
{% endhint %}

### ‫דרישות מוקדמות‬

* ‫חשבון סליקה מוגדר ופעיל בארגון שלכם (`GetClearingAccount` מחזיר אותו).‬
* ‫לטוקנים / הוראות קבע: פיצ'ר הטוקן / הוראת הקבע מופעל על מסוף הסליקה שלכם (אחרת `ApiTokenizationNotApprovedInClearingTerminal` ‏309 / `ApiStandingOrderNotApprovedInClearingTerminal` ‏310).‬
* ‫לביט / Google Pay / Apple Pay: ראו [ביט, Google Pay ו-Apple Pay](alternative-payment-methods.md) — אמצעי ארנק דורשים הפעלה בחשבון ותמיכת ספק.‬
