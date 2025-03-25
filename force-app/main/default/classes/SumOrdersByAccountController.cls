public without sharing class SumOrdersByAccountController{
    
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {

        if (accountId == null) {
            throw new IllegalArgumentException('L\'ID du compte ne peut pas être null.');
        }
    
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated' AND AccountId = :accountId];

        return (Decimal)groupedResults.get('total');
    }

}