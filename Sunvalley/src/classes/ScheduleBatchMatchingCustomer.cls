/**
*Dis:新建Order sku时根据邮件匹配客户的引导类
*Auther:Victor Li
*Time:2015年8月26日15:06:37
**/
global class ScheduleBatchMatchingCustomer implements Schedulable{
	
	global void execute(SchedulableContext SC) 
    {
   		ID batchprocessid = Database.executeBatch(new BatchMatchingCustomer(),1000);
    }
	

}