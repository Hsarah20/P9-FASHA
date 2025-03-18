@isTest
private class TestDataFactory {

    // Méthode pour créer un compte de test
    public static Account createTestAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    // Méthode pour créer une commande de test
    public static Order createTestOrder(Id accountId, Decimal totalAmount, Decimal shipmentCost, String status) {
        Order testOrder = new Order(
            Name = 'Test Order',
            Status = status,
            AccountId = accountId,
            TotalAmount = totalAmount,
            ShipmentCost__c = shipmentCost
        );
        insert testOrder;
        return testOrder;
    }

    // Méthode pour générer plusieurs commandes de test pour un compte
    public static List<Order> createMultipleTestOrders(Id accountId, Integer count) {
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < count; i++) {
            orders.add(new Order(
                Name = 'Test Order ' + i,
                Status = 'Activated',
                AccountId = accountId,
                TotalAmount = Math.random() * 1000,
                ShipmentCost__c = Math.random() * 50
            ));
        }
        insert orders;
        return orders;
    }
}