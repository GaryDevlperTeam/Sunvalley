/**
*Des:BacthCustomerMatchingCampaign 引导类
 customer与Campaign关联：根据customer.original_source__c = campaign channel.campaign_channel_id__c
*Author:Gary Hu
*Time:2015年10月10日13:21:24
**/
global class Schedule_BacthCustomerMatchingCampaign  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_Customer_Matching_Campaign(),1000);
  	}
}