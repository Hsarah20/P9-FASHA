trigger UpdateAccountCA on Order (after update) {
	
    UpdateAccountCATriggerHandler.updateAccountCA(Trigger.New);

}