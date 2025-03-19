@isTest
public class TestDataFactory{

    // Méthode pour créer un OrderItem de test
    public static OrderItem createOrderItem(Order order) {
        Product2 product = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert product;
    
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
    
        PricebookEntry priceBookEntry = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = 50,
            IsActive = true
        );
        insert priceBookEntry;

        order.Pricebook2Id = Test.getStandardPricebookId();
        OrderItem orderItem = new OrderItem(OrderId = order.Id, Quantity = 1, PricebookEntryId = priceBookEntry.Id,UnitPrice = 100 );
        insert orderItem;
    
        return orderItem;
    }
    
    // Méthode pour créer un compte de test
    public static Account createTestAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    // Méthode pour créer une commande de test
    public static Order createTestOrder(Id accountId, Decimal shipmentCost, String status) {
        Order testOrder = new Order(
            Name = 'Test Order',
            Status = status,
            AccountId = accountId,
            ShipmentCost__c = shipmentCost,
            EffectiveDate=Date.today(),
            EndDate=Date.today().addDays(8)
        );
        insert testOrder;
        return testOrder;
    }
    public static List<Order> createTestOrders(Id accountId, Integer count, Boolean isActivated) {
        List<Order> orders = new List<Order>();

        for (Integer i = 0; i < count; i++) {
            orders.add(new Order(
                Name = 'Test Order ' + i,
                Status = isActivated ? 'Activated' : 'Draft',
                AccountId = accountId,
                EffectiveDate = Date.today(),
                EndDate=Date.today().addDays(8)
            ));
        }

        insert orders;
        return orders;
    }

    // Méthode pour générer plusieurs commandes de test pour un compte
    public static List<Order> createMultipleTestOrders(Id accountId, Integer count) {
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < count; i++) {
            orders.add(new Order(
                Name = 'Test Order ' + i,
                Status = 'Activated',
                AccountId = accountId,
                ShipmentCost__c = Math.random() * 50
            ));
        }
        insert orders;
        return orders;
    }
}