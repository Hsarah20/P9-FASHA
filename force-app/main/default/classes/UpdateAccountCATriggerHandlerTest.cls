@isTest
private class UpdateAccountCATriggerHandlerTest {

    @isTest
    static void testUpdateAccountCA_WithActivatedOrders() {   
       // Création Account Test
       Account testAccount = TestDataFactory.createTestAccount('Test Account');
        
       // Création Draft orders Test 
       List<Order> ordersTest = TestDataFactory.createMultipleTestOrders(testAccount.Id, 3,'Draft');    

       // Update Status Orders to Activated    
       for(Integer i = 0; i < ordersTest.size(); i++) {
            ordersTest[i].Status='Activated';       
       }
      
       Test.startTest();
        // Mise à jour des commandes (le trigger devrait se déclencher)
        update ordersTest;
       Test.stopTest();
       
       List<Order> updatedOrders = [
            SELECT Id, TotalAmount 
            FROM Order 
            WHERE AccountId = :testAccount.Id AND Status = 'Activated'
        ];

        Decimal expectedCA = 0;
        for(Order order : updatedOrders) {
            if(order.TotalAmount!= null) {
                expectedCA += order.TotalAmount;
            }
        }

        

       // Vérification des résultats
       Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
       System.assertEquals(expectedCA, updatedAccount.Chiffre_d_affaire__c, 
           'Le CA doit être mis à jour avec le Status');
    }
}