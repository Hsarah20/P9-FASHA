public with sharing class UpdateAccountCATriggerHandler{
 
    public static void  updateAccountCA(List<Order> newOrders) {
        set<Id> accountIds = new set<Id>();   
        // Collecter les AccountId des Orders modifiés
        for (Order newOrder : newOrders) {
            if (newOrder.AccountId != null) {
                accountIds.add(newOrder.AccountId);
            }
        }

        // Mettre à jour le chiffre d'affaires
        AccountRevenueService.updateAccountRevenue(accountIds);
    }
}