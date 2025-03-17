public with sharing class CalculatMontantTriggerHandler{
    
    public static void  calculatMontantOrder(List<Order> newOrders) {

        for (Order newOrder : newOrders) {
            // Vérifier que TotalAmount et ShipmentCost__c ne sont pas null pour éviter les erreurs
            Decimal totalAmount = (newOrder.TotalAmount != null) ? newOrder.TotalAmount : 0;
            Decimal shipmentCost = (newOrder.ShipmentCost__c != null) ? newOrder.ShipmentCost__c : 0;
    
            newOrder.NetAmount__c = totalAmount - shipmentCost;
        }

    }
}