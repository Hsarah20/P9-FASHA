trigger CalculMontant on Order (before update) {

    CalculatMontantTriggerHandler.calculatMontantOrder(Trigger.New);
 
}