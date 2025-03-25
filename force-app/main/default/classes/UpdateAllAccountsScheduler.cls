global class UpdateAllAccountsScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateAllAccountsBatch(), 200);
    }
}