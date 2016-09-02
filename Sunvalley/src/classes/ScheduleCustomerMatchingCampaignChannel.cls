/**
*Dis:新建Customer时根据Original Source匹配Campaign Channel的引导类
*Auther:Victor Li
*Time:2015年9月25日15:22:54
**/
global class ScheduleCustomerMatchingCampaignChannel implements Schedulable{
	
	global void execute(SchedulableContext SC) 
    {
   		ID batchprocessid = Database.executeBatch(new Batch_Customer_Matching_Campaign_Channel(),1000);
    }

}