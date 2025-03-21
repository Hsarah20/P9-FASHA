@isTest
private class OrdersControllerTest {

    
    @isTest
    static void testGetSumOrdersByAccount_Positive() {
        //Préparation des données
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 100.00, 'Draft');

        //Ajouter un produit à la commande
        TestDataFactory.createOrderItem(testOrder,true);

        // Activer la commande
        testOrder.Status = 'Activated';
        update testOrder;

        Test.startTest();
        // Exécution de la méthode testée
        Decimal sumOrders = OrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();

        // Vérification des résultats
        System.assertEquals(100, sumOrders, 'Le total des commandes est incorrect.');
    }

    @isTest
    static void testGetSumOrdersByAccount_NoActivatedOrders() {
        // 1️ Préparation des données
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        List<Order> orders = TestDataFactory.createTestOrders(testAccount.Id, 3, false); // Aucune commande activée

        Test.startTest();
        // 2️ Exécution de la méthode testée
        Decimal sumOrders = OrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();

        // 3️ Vérification des résultats (doit être null ou 0)
        System.assertEquals(null, sumOrders, 'La somme devrait être null si aucune commande activée.');
    }

    @isTest
    static void testGetSumOrdersByAccount_NullAccountId() {
        try {
            Test.startTest();
            OrdersController.getSumOrdersByAccount(null);
            Test.stopTest();
            System.assert(false, 'Une exception aurait dû être levée pour un ID null.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('L\'ID du compte ne peut pas être null.', e.getMessage(), 'Le message d\'erreur est incorrect.');
        }
    }
}