@isTest
private class UpdateAllAccountsBatchTest {

    @isTest
    static void testUpdateAllAccountsBatch() {
      // 1️ Préparation des données avec TestDataFactory
      Account testAccount1 = TestDataFactory.createTestAccount('Test Account 1');
      Account testAccount2 = TestDataFactory.createTestAccount('Test Account 2');

      // Créer des commandes activées pour le premier compte avec des produits
      Order activatedOrder1 = TestDataFactory.createTestOrder(testAccount1.Id, 100.00, 'Activated');
      Order activatedOrder2 = TestDataFactory.createTestOrder(testAccount1.Id, 200.00, 'Activated');

      // Créer une commande non activée pour le deuxième compte
      Order draftOrder = TestDataFactory.createTestOrder(testAccount2.Id, 150.00, 'Draft');
      TestDataFactory.createOrderItem(draftOrder, true);

      // 2️ Exécution du batch
      Test.startTest();
      UpdateAllAccountsBatch batch = new UpdateAllAccountsBatch();
      Database.executeBatch(batch);
      Test.stopTest();

      // 3️ Vérification des résultats
      // Récupérer les comptes mis à jour
      Account updatedAccount1 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount1.Id];
      Account updatedAccount2 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount2.Id];
      System.debug('Account 1 '+updatedAccount1);
      System.debug('Account 2 '+updatedAccount2);

      // Vérifier que le chiffre d'affaires du premier compte est correct
      System.assertEquals(200, updatedAccount1.Chiffre_d_affaire__c, 'Le chiffre d\'affaires du premier compte est incorrect.');

      // Vérifier que le chiffre d'affaires du deuxième compte est null (aucune commande activée)
      System.assertEquals(null, updatedAccount2.Chiffre_d_affaire__c, 'Le chiffre d\'affaires du deuxième compte devrait être null.');
  }
}