trigger CalculateNetAmount on Order (before update) {

    CalculateNetAmountTriggerHandler.calculateNetAmountOfOrders(Trigger.New);
 
}