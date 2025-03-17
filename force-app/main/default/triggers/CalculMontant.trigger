trigger CalculMontant on Order (before update) {

    CalculateMontantTriggerHandler.calculatMontantOrder(Trigger.New);
 
}