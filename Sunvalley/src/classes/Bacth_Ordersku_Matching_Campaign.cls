/**
*Des:ordersku与Campaign关联 根据 ordersku.amazon_tracking_id__c=campagin.amazon_tracking_id__c匹配，ordersku.source_campaign__c=campagin.id
*Author:Gary Hu
*Time:2015-9-9 15:22:29
**/
global class Bacth_Ordersku_Matching_Campaign implements Database.Batchable<SObject>{
	
	 
	 global Database.queryLocator start(Database.BatchableContext ctx)
     { 
     	 datetime myDateTime = datetime.now().addHours(-24);
     	 return Database.getQueryLocator([select amazon_tracking_id__c,source_campaign__c,amazon_order_id__c from Order_sku__c 
     	 								  where (amazon_tracking_id__c != null or amazon_order_id__c != null) and source_campaign__c = null and SystemModStamp >=:myDateTime]);
    	 
     }
     global void execute(Database.BatchableContext ctx, list<Order_sku__c> list_sku)
     {
     		System.debug(list_sku.size()+'------------list_sku------------');
    
     	  list<Campaign> listCampaign = [select Id,amazon_tracking_id__c from Campaign ];
     		if(listCampaign.size() > 0)
     		{
     			for(Order_sku__c ok:list_sku )
	     		{
	     			for(Campaign c: listCampaign)
	     			{
	     				System.debug(c.Id+'--------c.Id-----------------------'+ok.amazon_order_id__c+'---------ok.amazon_order_id__c----------------');
	     				System.debug(c.Id+'--------c.Id-----------------------'+ok.amazon_tracking_id__c+'---------ok.amazon_tracking_id__c----------------');
	     				String cId = String.valueOf(c.Id).substring(0,15);
	     				//System.debug((ok.amazon_order_id__c.contains(cId))+'-----------contains-----------------');
	     				if((ok.amazon_tracking_id__c != null && ok.amazon_tracking_id__c.contains(cId) ) || (ok.amazon_order_id__c != null && ok.amazon_order_id__c.contains(cId)))
     					{
     						ok.source_campaign__c = c.Id;
     						break;
     					}	
	     			}
	     		}
     			update list_sku;
     		}
     }
     
      global void finish(Database.BatchableContext ctx)
     {
     	
     }
}