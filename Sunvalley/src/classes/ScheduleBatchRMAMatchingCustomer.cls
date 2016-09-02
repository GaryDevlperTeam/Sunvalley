/**
*Dis:新建RMA时根据邮件匹配客户的引导类
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/
global class ScheduleBatchRMAMatchingCustomer implements Schedulable{
	
	global void execute(SchedulableContext SC) 
    {
   		ID batchprocessid = Database.executeBatch(new BatchRMAMatchingCustomer(),1000);
    }

}