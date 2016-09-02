/**
*Des:order sku（N）和SKU（1）关联：Order SKU.sku__c = SKU.sku__c；
*Author:Gary Hu
*Time:2015年9月14日15:02:15
**/
global class Bacth_Ordersku_Matching_SKU implements Database.Batchable<SObject>{
	 global Database.queryLocator start(Database.BatchableContext ctx)
     { 
     	datetime myDateTime = datetime.now().addHours(-24);
     	return Database.getQueryLocator([select sku__c,link_sku__c from Order_sku__c where sku__c != null and link_sku__c = null and SystemModStamp >=:myDateTime]);
     }
     
     
     global void execute(Database.BatchableContext ctx, list<Order_sku__c> list_OrdSku)
     {
     	
 		map<String,Order_sku__c> mapOrdSku = new map<String,Order_sku__c>();
 		// set SKU
		 set<String>  setSKU = new set<String>();
     	if(list_OrdSku.size() > 0)
     	{
     		for(Order_sku__c o: list_OrdSku)
     		{
     			if(!setSKU.contains(o.sku__c))
	 			{
	 				setSKU.add(o.sku__c);
	 			}
     		}
     	}
     	if(setSKU.size() > 0)
     	{
     		list<SKU__c> list_SKU = [select Id,sku__c from SKU__c where sku__c in:setSKU];
     		if(list_SKU.size() >0)
     		{
     			for(Order_sku__c o: list_OrdSku)
     			{
	     			for(SKU__c s: list_SKU)
	     			{
	     				if(o.sku__c == s.sku__c)
	     				{
	     					o.link_sku__c = s.Id;
	     				}
	     			}
     			}
     			update list_OrdSku;
     		}
     	}
     }
     
       global void finish(Database.BatchableContext ctx)
     {
     	
     }
     

}