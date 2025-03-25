@isTest
public class TestDataFactory{

    // Méthode pour créer un OrderItem de test
    public static OrderItem createOrderItem(Order order, Boolean isInsert) {
        // Mise à jour nécessaire avant d'ajouter un OrderItem
        if (order.Pricebook2Id == null) {
            Id standardPricebookId = Test.getStandardPricebookId();
            order.Pricebook2Id = standardPricebookId;
            update order; 
        }

        Product2 product = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert product;


        PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = order.Pricebook2Id,
            UnitPrice = 50,
            IsActive = true,
            UseStandardPrice = false
        );
        insert pbe;
        
        OrderItem orderItem = new OrderItem(OrderId = order.Id, Quantity = 1, PricebookEntryId = pbe.Id,UnitPrice = 100 );

        if(isInsert==true){
            insert orderItem;
        }

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
        Status = 'Draft',
        AccountId = accountId,
        ShipmentCost__c = shipmentCost,
        EffectiveDate = Date.today(), 
        EndDate = Date.today().addDays(8)
        );
        insert testOrder;

        // Si on veut que l'Order soit activé, on le met à jour
        if (status == 'Activated') {
            List<OrderItem> orderItems = new List<OrderItem>();
            orderItems.add(createOrderItem(testOrder,false));
            insert orderItems;
            
            testOrder.Status = 'Activated';
            update testOrder;
        }

        return testOrder;
    }
    public static List<Order> createTestOrders(Id accountId, Integer count, Boolean isActivated) {
        List<Order> orders = new List<Order>();

        for (Integer i = 0; i < count; i++) {
            orders.add(new Order(
                Name = 'Test Order ' + i,
                Status =  'Draft',
                AccountId = accountId,
                EffectiveDate = Date.today(),
                EndDate=Date.today().addDays(8)
            ));
        }
        insert orders;
        
        if (isActivated) {
            for(Order o:orders){
                o.Status = 'Activated';
            }
            update orders;
        }
            
        return orders;
    }

    // Méthode pour générer plusieurs commandes de test pour un compte
    public static List<Order> createMultipleTestOrders(Id accountId, Integer count) {
        List<Order> orders = new List<Order>();
        Id standardPricebookId = Test.getStandardPricebookId();

        // 1️⃣ Création des Orders en statut "Draft"
        for (Integer i = 0; i < count; i++) {
            orders.add(new Order(
                Name = 'Test Order ' + i,
                Status = 'Draft',
                AccountId = accountId,
                ShipmentCost__c = Math.random() * 50,
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPricebookId,
                EndDate = Date.today().addDays(8)
            ));
        }
        insert orders;

        // Ajout d'un produit et OrderItem pour chaque Order
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order o : orders) {
            orderItems.add(createOrderItem(o,false));
        }
        insert orderItems;
    
        // Activation des Orders après ajout des produits
        for (Order o : orders) {
            o.Status = 'Activated';
        }
        update orders;
    
        return orders;
    }
}