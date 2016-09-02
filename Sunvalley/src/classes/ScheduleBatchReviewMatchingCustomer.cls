/**
*Dis:新建Review时根据邮件匹配客户的引导类
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/
global class ScheduleBatchReviewMatchingCustomer implements Schedulable{
	
	global void execute(SchedulableContext SC) 
    {
   		ID batchprocessid = Database.executeBatch(new BatchReviewMatchingCustomer(),1000);
    }
	

}