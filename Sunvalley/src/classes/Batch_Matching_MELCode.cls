/**
*Des:批量匹配MEL Coupon Code
*Author:Gary Hu
*Time:2015年9月9日9:08:29
**/
global class Batch_Matching_MELCode implements Database.Batchable<sObject>,Database.Stateful{
	//campaign Id
	global Id cId;
	global Integer num;
	//获取code 集合
	global set<String> setAmCode = new set<String>();
	
	global String[] arrAmCode = new list<String>();
	
	
	public Batch_Matching_MELCode(Id cId, String[] arrAmCode)
	{
		this.cId = cId;
		this.arrAmCode = arrAmCode;
		num=0;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		
		return Database.getQueryLocator([select coupon_code__c,campaign_name__c from Mass_Email_Log__c 
										 where campaign_name__c =:cId and coupon_code__c =null limit :arrAmCode.size() ]); 
	}
	 global void execute(Database.BatchableContext ctx,list<Mass_Email_Log__c > list_MEL) {
	 	
	 	System.debug(list_MEL.size()+'-------list_MEL.size()-------');
	 	
	 	if(list_MEL.size() >0)
	 	{
	 		//匹配MEL的amazon 
	 		for(Integer i=0;i<list_MEL.size();i++)
	 		{
	 			if(arrAmCode.size() >0)
	 			{
		 			Integer n = 0;
	 				n = math.mod(i,arrAmCode.size())+num;
	 				list_MEL[i].coupon_code__c = arrAmCode[n];
	 			}
	 		}
	 		num=num+list_MEL.size();
	 		Database.SaveResult[] saveResults = Database.update(list_MEL,false);
			if(saveResults != null && !saveResults.isEmpty()) {
				for(Database.SaveResult saveResult : saveResults) {
					if(saveResult.isSuccess()) {
						System.debug('Successful update MEL amazon tracking ID' + saveResult.getId());
					} else {
						for(Database.Error error : saveResult.getErrors()) {
							System.debug('The following error has occurred.');
							System.debug(error.getStatusCode() + ': ' + error.getMessage());
							System.debug('MEL amazon tracking fields that affected this error: ' + error.getFields());
						}
					}
				}
			}
	 	}
	 	
	 }
	 
	 global void finish(Database.BatchableContext ctx)
	{

    }
	
	
}