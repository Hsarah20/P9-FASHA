global class UpdateAllAccountsBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){

        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Activated\')');
        
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }

        if (accountIds.isEmpty()) {
            return;
        }
        
        //mettre à jour le chiffre d'affaires
        AccountRevenueService.updateAccountRevenue(accountIds);
    }    
     
    global void finish(Database.BatchableContext info){   
        System.debug('Batch Finished - All Accounts are updated with their most recent Orders');  
        
    } 
 }