trigger CalculateNetAmountTrigger on Order (before update) {

    CalculateNetAmountTriggerHandler.updateNetAmount(Trigger.New,Trigger.oldMap);
 
}