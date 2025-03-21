@IsTest
private class CalculateNetAmountTriggerHandlerTest{

    @IsTest
    static void testCalculateNetAmount() {
        Test.startTest();
        Account testAccount = TestDataFactory.createTestAccount('Test Account');

        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 50.00, 'Draft');
        OrderItem testOrderItem = TestDataFactory.createOrderItem(testOrder,true);
        Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c, Status 
                              FROM Order WHERE Id = :testOrder.Id LIMIT 1];

        // Vérifier le calcul avant activation
        System.assertEquals((updatedOrder.TotalAmount - 50.00), updatedOrder.NetAmount__c, 
            'Le NetAmount devrait être TotalAmount - ShipmentCost');

        // Activer la commande
        testOrder.Status = 'Activated';
        update testOrder;

        // Récupérer la commande après activation
        Order activatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c, Status 
                                FROM Order WHERE Id = :testOrder.Id LIMIT 1];

        // Vérifier que l'activation ne modifie pas NetAmount
        System.assertEquals((activatedOrder.TotalAmount - 50.00), activatedOrder.NetAmount__c, 
            'Le NetAmount ne devrait pas changer après activation');

        Test.stopTest();
    }

    @IsTest
    static void testBulkCalculateNetAmount() {
        Test.startTest(); 

        // Création d'un compte de test
        Account testAccount = TestDataFactory.createTestAccount('Test Bulk Account');

        // Création de plusieurs commandes de test
        List<Order> testOrders = TestDataFactory.createMultipleTestOrders(testAccount.Id, 10);
        
        // Récupération des commandes après ajout des OrderItems
        List<Order> updatedOrders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c 
                                     FROM Order WHERE AccountId = :testAccount.Id];

        for (Order o : updatedOrders) {
            System.assertEquals((o.TotalAmount - o.ShipmentCost__c), o.NetAmount__c, 
                'Le NetAmount devrait être TotalAmount - ShipmentCost');
        }

        Test.stopTest();
    }
}
