@IsTest
private class CalculatMontantTriggerHandlerTest {

    @IsTest
    static void testCalculatMontantOrder() {
        // Création d'un compte et d'une commande
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 50.00, 'Draft');

        // Exécuter la méthode à tester
        List<Order> orders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        CalculatMontantTriggerHandler.calculatMontantOrder(orders);

        // Vérification du calcul
        Test.startTest();
        System.assertEquals(450.00, orders[0].NetAmount__c, 'Le montant net devrait être 450.00');
        Test.stopTest();
    }
   
}
