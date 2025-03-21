trigger OrderTrigger on Order (before update, after update) {

    // before update : Calcul du NetAmount
    if (Trigger.isBefore && Trigger.isUpdate) {
        CalculateNetAmountTriggerHandler.updateNetAmount(Trigger.New, Trigger.oldMap);
    }

    // after update : Mise à jour du Chiffre_d_affaire__c
    if (Trigger.isAfter && Trigger.isUpdate) {
        UpdateAccountCATriggerHandler.updateAccountCA(Trigger.New);
    }
}