trigger UpdateAccountCATrigger on Order (after update) {
	
    UpdateAccountCATriggerHandler.updateAccountCA(Trigger.New);

}