public with sharing class AccountRevenueService {


    public static void updateAccountRevenue(Set<Id> accountIds) {
        if (accountIds.isEmpty()) {
            return;
        }

        // Récupérer le chiffre d'affaires pour chaque compte
        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue
            FROM Order
            WHERE AccountId IN :accountIds AND Status = 'Activated'
            GROUP BY AccountId
        ]) {
            accountRevenueMap.put((Id) ar.get('AccountId'), (Decimal) ar.get('totalRevenue'));
        }

        // Mettre à jour les comptes avec le nouveau chiffre d'affaires
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountRevenueMap.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accId,
                Chiffre_d_affaire__c = accountRevenueMap.get(accId)
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}