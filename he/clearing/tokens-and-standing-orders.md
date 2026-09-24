# ‫טוקנים והוראות קבע‬

‫שמרו את כרטיס הלקוח כ**טוקן** לחיובים עתידיים מצד השרת, או הקימו **הוראת קבע** (חיוב חודשי חוזר). כל התהליכים עוברים דרך [`ProcessApiRequestV2`](process-api-request-v2.md) עם הדגלים שלהלן.‬

{% hint style="info" %}
‫טוקנים והוראות קבע חייבים להיות מופעלים על מסוף הסליקה שלכם. אחרת תקבלו `ApiTokenizationNotApprovedInClearingTerminal` ‏(309) / `ApiStandingOrderNotApprovedInClearingTerminal` ‏(310).‬
{% endhint %}

## ‫שמירת טוקן — `AddToken`‬

‫פותח דף מתארח שקולט את הכרטיס ושומר טוקן, **ללא חיוב**.‬

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

## ‫שמירה + חיוב — `AddTokenAndCharge`‬

‫זהה לקודם אך גם מחייב את `Sum` מיידית. לא ניתן לשלב עם `IsStandingOrderClearance` ‏(`ApiBadRequestChargeMethodMustBeSelected`, 319).‬

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

‫הטוקן השמור של הלקוח מזוהה אוטומטית. חייב להתקיים בדיוק טוקן אחד ללקוח — אחרת `ApiTokenDoesntExistForThatCustomer` ‏(304). בהצלחה, התשובה נושאת את האישור, ועם `IsDocCreate` — את שדות המסמך שנוצר. אם הטוקן נוצר אך חיוב ההמשך נכשל: `ApiTokenWasCreatedChargeFailed` ‏(313).‬

## ‫הוראת קבע — `IsStandingOrderClearance`‬

‫מקים חיוב חודשי חוזר: הדף המתארח שומר את הכרטיס (ללא חיוב), ו-Invoice4U מחייבת אותו מדי חודש החל ממחרת, למשך `StandingOrderDuration` חודשים. חיובים חודשיים שנכשלו **לא מנוסים שוב**.‬

‫ראו **[הוראות קבע (חיובים חוזרים)](standing-orders.md)** עבור שדות הבקשה, לוח החיובים, שני פורמטי הקולבק (הקמה מול חיוב חוזר), טיפול בכישלונות ושאלות נפוצות.‬

## ‫שגיאות‬

| ‫שגיאה (ID)‬ | ‫משמעות‬ |
| ---------- | ------- |
| `ApiTokenizationNotApprovedInClearingTerminal` (309) | ‫טוקנים לא מופעלים על המסוף (או שתוקף פיצ'ר הטוקן פג).‬ |
| `ApiStandingOrderNotApprovedInClearingTerminal` (310) | ‫הוראות קבע לא מופעלות.‬ |
| `ApiTokenDoesntExistForThatCustomer` (304) | ‫אין טוקן שמור (או שיש כמה) עבור הלקוח.‬ |
| `ApiTokenWasCreatedChargeFailed` (313) | ‫הטוקן נשמר, החיוב נדחה.‬ |
| `ApiStandingOrderDurationNotFilled` (301) / `ApiStandingOrderDocSubjectNotFilled` (302) / `ApiStandingOrderCallbackurlInvalid` (318) | ‫ולידציית הוראת קבע.‬ |
| `ApiBadRequestChargeMethodMustBeSelected` (319) | ‫דגלי מצב סותרים.‬ |
