@isTest
private class OrdersControllerTest {

    
    @isTest
    static void testGetSumOrdersByAccount_Positive() {
        //Préparation des données
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 50.00, 'Draft');

        //Ajouter un produit à la commande
        TestDataFactory.createOrderItem(testOrder);

        // Activer la commande
        testOrder.Status = 'Activated';
        update testOrder;

        Test.startTest();
        // Exécution de la méthode testée
        Decimal sumOrders = OrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();

        // Vérification des résultats
        Decimal expectedSum = 100 + 110 + 120; // Total des commandes activées
        System.assertEquals(expectedSum, sumOrders, 'Le total des commandes est incorrect.');
    }

    @isTest
    static void testGetSumOrdersByAccount_NoActivatedOrders() {
        // 1️ Préparation des données
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        List<Order> orders = TestDataFactory.createTestOrders(testAccount.Id, 3, false); // Aucune commande activée

        Test.startTest();
        // 2️ Exécution de la méthode testée
        Decimal sumOrders = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();

        // 3️ Vérification des résultats (doit être null ou 0)
        System.assertEquals(null, sumOrders, 'La somme devrait être null si aucune commande activée.');
    }

    @isTest
    static void testGetSumOrdersByAccount_NullAccountId() {
        try {
            Test.startTest();
            MyTeamOrdersController.getSumOrdersByAccount(null);
            Test.stopTest();
            System.assert(false, 'Une exception aurait dû être levée pour un ID null.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('L\'ID du compte ne peut pas être null.', e.getMessage(), 'Le message d\'erreur est incorrect.');
        }
    }
}