@isTest
private class AccountRevenueServiceTest{

    @isTest
    static void testUpdateAccountRevenue() {
        // Créer un compte et des commandes
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order activatedOrder = TestDataFactory.createTestOrder(testAccount.Id, 100.00, 'Activated');
        Order draftOrder = TestDataFactory.createTestOrder(testAccount.Id, 200.00, 'Draft');

        // Ajouter des produits aux commandes
        TestDataFactory.createOrderItem(activatedOrder, true);
        TestDataFactory.createOrderItem(draftOrder, true);

        // Appeler la méthode utilitaire
        Set<Id> accountIds = new Set<Id>{testAccount.Id};
        Test.startTest();
        AccountRevenueService.updateAccountRevenue(accountIds);
        Test.stopTest();

        // Vérifier que le Chiffre_d_affaire__c a été mis à jour
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(100.00, updatedAccount.Chiffre_d_affaire__c, 'Le Chiffre_d_affaire__c est incorrect.');
    }
}
