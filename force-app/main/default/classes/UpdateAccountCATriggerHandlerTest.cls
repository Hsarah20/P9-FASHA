@isTest
private class UpdateAccountCATriggerHandlerTest {

    @isTest
    static void testUpdateAccountCA_WithActivatedOrders() {
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order activatedOrder = TestDataFactory.createTestOrder(
            testAccount.Id, 
            100.00, 
            'Activated'
        );
        
        Order draftOrder = TestDataFactory.createTestOrder(
            testAccount.Id, 
            50.00, 
            'Draft'
        );

        // Exécution du test
        Test.startTest();
        UpdateAccountCATriggerHandler.updateAccountCA(
            new List<Order>{activatedOrder, draftOrder}
        );
        Test.stopTest();

        // Vérification des résultats
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c 
                                FROM Account 
                                WHERE Id = :testAccount.Id];
        
        // Seule la commande activée doit être prise en compte
        System.assertEquals(100.00, updatedAccount.Chiffre_d_affaire__c, 
            'Le chiffre d\'affaires doit correspondre aux commandes activées');
    }

    @isTest
    static void testUpdateAccountCA_WithNullAccountId() {
        Order orderWithoutAccount = new Order(
            Status = 'Draft',
            EffectiveDate = Date.today(),
            AccountId=null,
            Name = 'Test Order',
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert orderWithoutAccount;

        orderWithoutAccount.Status='Activated';
        update orderWithoutAccount;

        //Exécution du test
        Test.startTest();
        UpdateAccountCATriggerHandler.updateAccountCA(
            new List<Order>{orderWithoutAccount}
        );
        Test.stopTest();

        // 3. Vérification - Aucune exception ne doit être levée
        System.assert(true, 'Le handler doit gérer les commandes sans compte');
    }
}