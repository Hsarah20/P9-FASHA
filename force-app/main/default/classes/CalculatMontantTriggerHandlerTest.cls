@IsTest
private class CalculatMontantTriggerHandlerTest{

    @IsTest
    static void testcalculatMontantOrder() {
        // Création d'un compte et d'une commande
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 50.00, 'Draft');

        // Exécuter la méthode à tester
        List<Order> orders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        CalculatMontantTriggerHandler.calculatMontantOrder(orders);

        System.debug('ORDERS   : '+ orders);
        // Vérification du calcul
        Test.startTest();
        System.assertEquals(-50, orders[0].NetAmount__c, 'Le montant net devrait être -50');
        Test.stopTest();
    }
   
}
