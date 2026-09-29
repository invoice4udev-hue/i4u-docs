# ‫טוקנים (כרטיסים שמורים)‬

‫שמרו את כרטיס הלקוח כ**טוקן** וחייבו אותו מאוחר יותר, שרת-לשרת. כל התהליכים עוברים דרך [`ProcessApiRequestV2`](process-api-request-v2.md) עם הדגלים שלהלן. לחיובים חודשיים חוזרים, ראו [הוראות קבע (חיובים חוזרים)](standing-orders.md).‬

{% hint style="info" %}
‫הטוקניזציה חייבת להיות מופעלת על מסוף הסליקה שלכם. אחרת תקבלו `ApiTokenizationNotApprovedInClearingTerminal` ‏(309).‬
{% endhint %}

## ‫שמירת טוקן — `AddToken`‬

‫פותח דף מתארח שקולט את הכרטיס ושומר טוקן, **ללא חיוב**. במשולם ובקארדקום, ניסיון לכידה כושל עשוי להחזיר `ApiChargeAttemptPhoneInvalid` ‏(314) — בדקו את מספר הטלפון של הלקוח ונסו שוב.‬

```json
{
  "request": {
    "Invoice4UUserApiKey": "<api-key>",
    "AddToken": true,
    "FullName": "Israel Israeli",
    "Phone": "0501234567",
    "Email": "israel@example.com",
    "CustomerId": 88231,
    "ReturnUrl": "https://shop.example/card-saved",
    "CallBackUrl": "https://shop.example/api/i4u-callback"
  }
}
```

‫הפנו את הלקוח ל-`ClearingRedirectUrl` המוחזר. הטוקן נשמר כנגד הלקוח (מומלץ `CustomerId` כדי שהטוקן יהיה שליף בהמשך).‬

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[ProcessApiRequestV2<br/>AddToken]:::step --> B{Tokens enabled<br/>on terminal?}:::dec
    B -- "✗ / expired" --> E1[ApiTokenizationNotApproved<br/>InClearingTerminal 309]:::err
    B -- ✓ --> C[🖥 Card capture page<br/>NO charge]:::page
    C --> D{Capture OK?}:::dec
    D -- ✓ --> F[Token stored for CustomerId —<br/>replaces previous token]:::step
    F --> G[CallBackUrl notified]:::cb
    D -- ✗ --> H[Failure posted<br/>to CallBackUrl]:::err
```

## ‫שמירה + חיוב — `AddTokenAndCharge`‬

‫זהה לקודם אך גם מחייב את `Sum` מיידית. לא ניתן לשלב עם `IsStandingOrderClearance` ‏(`ApiBadRequestChargeMethodMustBeSelected`, 319). במשולם ובקארדקום, ניסיון לכידה כושל עשוי להחזיר `ApiChargeAttemptPhoneInvalid` ‏(314) — בדקו את מספר הטלפון של הלקוח ונסו שוב.‬

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333
    classDef page fill:#F5F5F5,stroke:#999,color:#333

    A[ProcessApiRequestV2<br/>AddTokenAndCharge]:::step --> B{Also<br/>IsStandingOrderClearance?}:::dec
    B -- ✓ --> E1[ApiBadRequestChargeMethod<br/>MustBeSelected 319]:::err
    B -- ✗ --> C{Tokens enabled?}:::dec
    C -- ✗ --> E2[ApiTokenizationNotApproved<br/>InClearingTerminal 309]:::err
    C -- ✓ --> D[🖥 Capture + charge page<br/>Sum charged]:::page
    D --> F{Result}:::dec
    F -- "token + charge ✓" --> G[Token stored · CallBackUrl<br/>doc if IsDocCreate]:::cb
    F -- "token ✓, charge ✗" --> E3[ApiTokenWasCreatedChargeFailed 313<br/>token kept]:::err
    F -- "capture ✗" --> E4[Failure posted<br/>to CallBackUrl]:::err
```

## ‫חיוב טוקן שמור — `ChargeWithToken`‬

‫שרת-לשרת, סינכרוני — ללא הפניה:‬

```json
{
  "request": {
    "Invoice4UUserApiKey": "<api-key>",
    "ChargeWithToken": true,
    "CustomerId": 88231,
    "Sum": 117.0,
    "Description": "Monthly subscription - July",
    "IsDocCreate": true,
    "DocHeadline": "Monthly subscription - July"
  }
}
```

‫הטוקן השמור של הלקוח מזוהה אוטומטית. `CustomerId` **חובה** — כל אינטגרציית ספק דורשת אותו כדי לאתר את הטוקן השמור, ולכן השמטתו נכשלת ללא שגיאת API נקייה. חייב להתקיים בדיוק טוקן אחד ללקוח — אחרת `ApiTokenDoesntExistForThatCustomer` ‏(304). בהצלחה, התשובה נושאת את האישור, ועם `IsDocCreate` — את שדות המסמך שנוצר. אם הטוקן נוצר אך חיוב ההמשך נכשל: `ApiTokenWasCreatedChargeFailed` ‏(313).‬

```mermaid
flowchart LR
    classDef step fill:#E7D9FC,stroke:#9B6DD6,color:#333
    classDef dec fill:#D2F0D2,stroke:#4CAF50,color:#333
    classDef err fill:#FFD9A0,stroke:#E8A33D,color:#333
    classDef cb fill:#BBDEFB,stroke:#42A5F5,color:#333

    A[ProcessApiRequestV2<br/>ChargeWithToken]:::step --> B{Stored token found<br/>for customer?}:::dec
    B -- ✗ --> E1[ApiTokenDoesntExist<br/>ForThatCustomer 304]:::err
    B -- ✓ --> C[Sync charge at provider<br/>no redirect]:::step
    C --> D{Charge OK?}:::dec
    D -- ✓ --> F[Log + confirmation<br/>+ doc if IsDocCreate]:::step
    F --> G[Result inline<br/>in response]:::cb
    D -- ✗ --> H[ClearingError 32<br/>in response]:::err
```

## ‫קשור‬

* ‫**הוראות קבע** (`IsStandingOrderClearance`) גם הן שומרות את הכרטיס ומחייבות אותו מדי חודש — ראו [הוראות קבע (חיובים חוזרים)](standing-orders.md).‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `ApiTokenizationNotApprovedInClearingTerminal` (309) | ‫טוקנים לא מופעלים על המסוף (או שתוקף פיצ'ר הטוקן פג).‬ |
| `ApiTokenDoesntExistForThatCustomer` (304) | ‫אין טוקן שמור (או שיש כמה) עבור הלקוח.‬ |
| `ApiTokenWasCreatedChargeFailed` (313) | ‫הטוקן נשמר, החיוב נדחה.‬ |
| `ApiChargeAttemptPhoneInvalid` (314) | ‫`AddToken`/`AddTokenAndCharge` (משולם, קארדקום): דף לכידת הכרטיס המתארח נכשל, לרוב עקב מספר טלפון/פרטי לקוח שגויים.‬ |
| `ApiBadRequestChargeMethodMustBeSelected` (319) | ‫דגלי מצב סותרים.‬ |

## ‫נסו את זה‬

{% openapi-operation spec="invoice4u-api" path="/ProcessApiRequestV2" method="post" %}
{% endopenapi-operation %}
