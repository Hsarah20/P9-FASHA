public with sharing class CalculateNetAmountTriggerHandler{
       
    public static void updateNetAmount(List<Order> orderList, Map<Id, Order> oldOrderMap) {
        if (orderList == null || orderList.isEmpty()) {
            return;
        }

        for (Order order : orderList) {
            Order oldOrder = oldOrderMap.get(order.Id);

            // Vérifier si TotalAmount ou ShipmentCost__c ont changé
            if (oldOrder == null || 
                order.TotalAmount != oldOrder.TotalAmount || 
                order.ShipmentCost__c != oldOrder.ShipmentCost__c) {

                if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                    order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
                } else {
                    order.NetAmount__c = 0; 
                }
            }
        }
    }
}