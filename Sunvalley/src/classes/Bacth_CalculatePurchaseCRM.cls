/**
*Des:计算 Purchase Products CRM 和客户关联：汇总Order SKU.sku_qty__c
*       Purchase Times CRM order sku（order_id__c唯一，去重复)数量
*       Purchase Total Amount CRM 和客户关联的，汇总order sku的Sku Original AmountUS
*       客户对象上字段Last Purchase Time, 取值为该客户下最近一条Ordersku的Order Date
*Author:Jmark
*Time:2015年10月21日10:28:33
**/

global class Bacth_CalculatePurchaseCRM implements  Database.Batchable<sObject>{
	
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([SELECT Id,purchase_products_crm__c,purchase_times_crm__c,purchase_total_amount_crm__c FROM Account]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Account> list_acc)
	 {
	 	 //计算Purchase Products CRM和 Purchase Total Amount CRM
	 	 set<Id> set_id=new set<Id>();//客户Id
	 	 for(Account acc:list_acc)
	 	 {
	 	    set_id.add(acc.Id);
	 	 }
	 	 list<Order_sku__c> list_sku=new list<Order_sku__c>();
	 	 AggregateResult[] groupedResults; 
	 	 if(set_id.size()>0) 
	 	 {
	 	    list_sku=[select sku_qty__c,sku_actual_amountUS__c,Customer__c,order_date__c from Order_sku__c where Customer__c in:set_id order by CreatedDate desc];
	 	    groupedResults=[select order_id__c oid,Customer__c cus,Count(Id) cou from Order_sku__c where Customer__c in:set_id group by order_id__c,Customer__c];
	 	 }
	 	 map<Id,list<Order_sku__c>> map_sku=new map<Id,list<Order_sku__c>>();
	 	 map<Id,Order_sku__c> map_skudate=new map<Id,Order_sku__c>();
	 	 map<Id,Double> map_Products=new map<Id,Double>();//Purchase Products CRM
	 	 map<Id,Double> map_Amount=new map<Id,Double>();//Purchase Total Amount CRM
	 	 
	 	 if(list_sku.size()>0)
	 	 {
	 	     for(Order_sku__c sku:list_sku)
	 	     {
	 	        if(map_sku.containsKey(sku.Customer__c))
	 	        {
	 	           map_sku.get(sku.Customer__c).add(sku);
	 	        }
	 	        else
	 	        {
	 	           list<Order_sku__c> list_skunew=new list<Order_sku__c>();
	 	           list_skunew.add(sku);
	 	           map_sku.put(sku.Customer__c,list_skunew);
	 	        }
	 	        if(!map_skudate.containsKey(sku.Customer__c))
	 	        {
	 	           map_skudate.put(sku.Customer__c,sku);
	 	        }
	 	     }
	 	     if(map_sku.size()>0)
	 	     {
	 	         for(Id skuid:map_sku.keySet())
	 	         {
	 	             Double products=0;
	 	             Double amount=0;
	 	             for(Order_sku__c sku : map_sku.get(skuid))
	 	             {
	 	                 if(sku.sku_qty__c != null)
	 	                 {
	 	                    products=products+sku.sku_qty__c;
	 	                 }
	 	                 if(sku.sku_actual_amountUS__c != null)
	 	                 {
	 	                     amount=amount+sku.sku_actual_amountUS__c;
	 	                 }
	 	             }
	 	             map_Products.put(skuid,products);
	 	             map_Amount.put(skuid,amount);
	 	         }
	 	     }
	 	 }
	 	 //计算Purchase Times CRM 
	 	 map<String,list<AggregateResult>> map_ar=new map<String,list<AggregateResult>>();//按客户ID分组
	 	 if(groupedResults != null && groupedResults.size()>0)
	 	 {
	 	     for(AggregateResult ar:groupedResults)
	 	     {
	 	         if(Integer.valueof(ar.get('cou')) == 1)//去重复
	 	         {
	 	             if(map_ar.containsKey(String.valueOf(ar.get('cus'))))
	 	             {
	 	                 map_ar.get(String.valueOf(ar.get('cus'))).add(ar);
	 	             }
	 	             else
	 	             {
	 	                 list<AggregateResult> list_arnew=new list<AggregateResult>();
	 	                 list_arnew.add(ar);
	 	                 map_ar.put(String.valueOf(ar.get('cus')),list_arnew);
	 	             }
	 	         }
	 	     }
	 	 }
	 	 //给客户赋值
	 	 for(Account acc:list_acc)
	 	 {
	 	    if(map_Products.containsKey(acc.Id))
	 	    {
	 	       acc.purchase_products_crm__c = map_Products.get(acc.Id);
	 	    }
	 	    else
	 	    {
	 	       acc.purchase_products_crm__c = 0;
	 	    }
	 	    if(map_Amount.containsKey(acc.Id))
	 	    {
	 	       acc.purchase_total_amount_crm__c = map_Amount.get(acc.Id);
	 	    }
	 	    else
	 	    {
	 	       acc.purchase_total_amount_crm__c = 0;
	 	    }
	 	    if(map_ar.containsKey(acc.Id))
	 	    {
	 	       acc.purchase_times_crm__c = map_ar.get(acc.Id).size();
	 	    }
	 	    else
	 	    {
	 	       acc.purchase_times_crm__c = 0;
	 	    }
	 	    if(map_skudate.containsKey(acc.Id))
	 	    {
	 	        acc.last_purchase_time__c=map_skudate.get(acc.Id).order_date__c;
	 	    }
	 	 }
	 	 update list_acc;
	 }
     global void finish(Database.BatchableContext ctx)
     {
     	
     }
}