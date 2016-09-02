/**
*delete Date
*
*
**/
trigger Data_Delete_Request on Data_Delete_Request__c (after update) {
	if(trigger.isAfter&& trigger.isUpdate)
	{
		ID batchprocessid = Database.executeBatch(new Batch_Delete_Date(),1000);
	}
}