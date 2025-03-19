global class UpdateAllAccountsBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){

        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Activated\')');
        
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = new Set<Id>();

        for (Account acc : scope) {
            setAccountIds.add(acc.Id);
        }

        if (setAccountIds.isEmpty()) {
            return;
        }

        // 1️ Récupérer le nouveau chiffre d’affaires pour ces comptes
        Map<Id, Decimal> mapAccountRevenue = new Map<Id, Decimal>();

        for (AggregateResult ar : [
            SELECT AccountId, SUM(TotalAmount) totalCA
            FROM Order
            WHERE AccountId IN :setAccountIds AND Status = 'Activated'
            GROUP BY AccountId
        ]) {
            mapAccountRevenue.put((Id) ar.get('AccountId'), (Decimal) ar.get('totalCA'));
        }

        // 2️ Mettre à jour les comptes avec le nouveau chiffre d’affaires
        List<Account> lstAccountsToUpdate = new List<Account>();

        for (Id accId : mapAccountRevenue.keySet()) {
            Account acc = new Account(Id = accId, Chiffre_d_affaire__c = mapAccountRevenue.get(accId));
            lstAccountsToUpdate.add(acc);
        }

        if (!lstAccountsToUpdate.isEmpty()) {
            update lstAccountsToUpdate;
        }
    }    
     
    global void finish(Database.BatchableContext info){   
        System.debug('Batch Finished - All Accounts are updated with their most recent Orders');  
        
    } 
 }