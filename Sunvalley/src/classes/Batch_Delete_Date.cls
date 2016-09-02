/**
*Des:delete All data
*Author:Gary Hu
*Time:2015年10月15日10:00:34
**/
global class  Batch_Delete_Date implements  Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([select Id from  SKU__c]); 
	 }
	  global void execute(Database.BatchableContext ctx,list<SKU__c > list_sku) {
	  	if(list_sku.size()>0)
	  	{
	  		delete list_sku;
	  	}
	  }
	   global void finish(Database.BatchableContext ctx)
    {
	
    }
}