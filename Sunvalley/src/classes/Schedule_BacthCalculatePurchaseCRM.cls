/**
*Des:计算 Purchase Products CRM 和客户关联：汇总Order SKU.sku_qty__c
*       Purchase Times CRM order sku（order_id__c唯一，去重复)数量
*       Purchase Total Amount CRM 和客户关联的，汇总order sku的Sku Original AmountUS
*Author:Jmark
*Time:2015年10月21日13:19:56
**/
global class Schedule_BacthCalculatePurchaseCRM  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_CalculatePurchaseCRM(),1000);
  	}
}