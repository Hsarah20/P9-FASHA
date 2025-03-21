public with sharing class UpdateAccountCATriggerHandler{
 
    public static void  updateAccountCA(List<Order> newOrders) {
        set<Id> setAccountIds = new set<Id>();   
        // 1️ Collecter les AccountId des Orders modifiés
        for (Order newOrder : newOrders) {
            if (newOrder.AccountId != null) {
                setAccountIds.add(newOrder.AccountId);
            }
        }

        // 2 Récupérer tous les comptes concernés en une seule requête
        Map<Id, Account> mapAccounts = new Map<Id, Account>(
            [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :setAccountIds]
        );

        // 3️ Utiliser un Set pour éviter les doublons
        Set<Id> processedAccountIds = new Set<Id>();
        List<Account> lstAccountsToUpdate = new List<Account>();

        for (Order newOrder : newOrders) {
            if (newOrder.AccountId != null && mapAccounts.containsKey(newOrder.AccountId)) {
                if (!processedAccountIds.contains(newOrder.AccountId)) {  // Évite les doublons
                    Account acc = mapAccounts.get(newOrder.AccountId);
                    acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null ? acc.Chiffre_d_affaire__c : 0) 
                                            + (newOrder.TotalAmount != null ? newOrder.TotalAmount : 0);
                    lstAccountsToUpdate.add(acc);
                    processedAccountIds.add(newOrder.AccountId); // Marquer l'ID comme traité
                }
            }
        }

        // 4️ Mise à jour unique sans doublons
        if (!lstAccountsToUpdate.isEmpty()) {
            update lstAccountsToUpdate;
        }

    }
}