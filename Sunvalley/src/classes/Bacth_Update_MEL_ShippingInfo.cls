/**
*Des:批量更新MEL上的 shipping 信息
1、如果 MEL上的amazon_tracking__c 等于Order sku 上的 amazon_tracking_id__c
那么 MEL shipping_date__c = Order sku shipping_date__c
那么 MEL is_shipping__c = true
那么 MEL logistics_number__c = Order sku (暂无)
那么 MEL order_sku__c = Order sku.Id
else if MEL上的  Merchant Fulfillment OrderID 等于Order sku 上的 Amazon order Id
那么 MEL shipping_date__c = Order sku shipping_date__c
那么 MEL is_shipping__c = ture
那么 MEL logistics_number__c = Order sku (暂无)
那么 MEL order_sku__c = Order sku.Id
*Author:Gary Hu
*Time:2015年9月17日17:32:13
**/
global class Bacth_Update_MEL_ShippingInfo implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		
		return Database.getQueryLocator([select amazon_id__c,amazon_tracking_id__c,shipping_date__c,is_shipping__c,logistics_number__c,order_sku__c,merchant_fulfillment_orderid__c,campaign_name__c
										 from Mass_Email_Log__c where (campaign_name__c != null or merchant_fulfillment_orderid__c != null) and shipping_date__c = null  and is_shipping__c = false ]);	
	
	}
	global void execute(Database.BatchableContext ctx,list<Mass_Email_Log__c > list_mel)
	{
		
		//Am Id
	 	set<String> setAmTr = new set<String>();
	 	
	 	//MFOrd Id
	 	set<String> setMefOrdId = new set<String>();
	 	
	 	System.debug(list_mel.size()+'-------list_mel.size()-----------');
	 	if(list_mel.size() > 0)
	 	{
	 	
	 		for(Mass_Email_Log__c l:list_mel)
	 		{
	 			if(l.campaign_name__c != null)
	 			{
	 				setAmTr.add(l.campaign_name__c);
	 			}
	 			if(l.merchant_fulfillment_orderid__c != null)
	 			{
	 				setMefOrdId.add(l.merchant_fulfillment_orderid__c);
	 			}
	 		}
	 	}
	 	System.debug(setMefOrdId.size() +'------setMefOrdId---------');
	 	System.debug(setMefOrdId+'------setMefOrdId---------');
	 	if(setAmTr.size() > 0)
	 	{
	 		list<Order_sku__c> list_OrdSku = [select amazon_id__c,Id,shipping_date__c,source_campaign__c from Order_sku__c where source_campaign__c in:setAmTr  and shipping_date__c != null and  amazon_id__c != null];
	 		if(list_OrdSku.size() > 0)
	 		{
		 		for(Order_sku__c o: list_OrdSku)
		 		{
		 			for(Mass_Email_Log__c m:list_mel)
		 			{
		 				if(m.campaign_name__c == o.source_campaign__c && m.amazon_id__c == o.amazon_id__c)
		 				{
		 					m.shipping_date__c = o.shipping_date__c;
		 					m.is_shipping__c = true;
		 					//l.logistics_number__c = 
		 					m.order_sku__c = o.Id;
		 				}
		 			}
		 		}
		 		update list_mel;
	 		}
	 	}
	  	if(setMefOrdId.size() > 0)
	 	{
	 		list<Order_sku__c> list_OrdSku = [select Id,shipping_date__c,amazon_order_id__c from Order_sku__c where amazon_order_id__c in:setMefOrdId and shipping_date__c != null and amazon_order_id__c!=null];	
	 		System.debug(list_OrdSku.size() +'--------------list_OrdSku-------------');
	 		if(list_OrdSku.size() > 0)
	 		{
	 			for(Order_sku__c o: list_OrdSku)
		 		{
		 			for(Mass_Email_Log__c m:list_mel)
		 			{
		 				System.debug(m.merchant_fulfillment_orderid__c+'--------m.merchant_fulfillment_orderid__c---------------'+o.amazon_order_id__c+'--------m.amazon_order_id__c---------------');
		 				if(m.merchant_fulfillment_orderid__c == o.amazon_order_id__c && m.shipping_date__c == null)
		 				{
			 				System.debug(m.merchant_fulfillment_orderid__c+'--------m.merchant_fulfillment_orderid__c1---------------'+o.amazon_order_id__c+'--------m.amazon_order_id__c1---------------');
		 					m.shipping_date__c = o.shipping_date__c;
		 					m.is_shipping__c = true;
		 					//l.logistics_number__c = 
		 					m.order_sku__c = o.Id;
		 				}
		 			}
		 		}
		 		update list_mel;
	 		}
	 	}
	}
	global void finish(Database.BatchableContext ctx)
    {

    }
}