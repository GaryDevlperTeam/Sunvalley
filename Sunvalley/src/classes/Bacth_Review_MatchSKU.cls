/**
*Create By:jmark
*TIME：2015年9月14日16:17:55
*Description:review（N） 和SKU（1）关联：review.sku__c = sku.sku__c；
*
**/  
global class Bacth_Review_MatchSKU implements Database.Batchable<SObject>,Database.Stateful{

     global Database.queryLocator start(Database.BatchableContext ctx)
     { 	   datetime myDateTime = datetime.now().addHours(-24);	    
           return Database.getQueryLocator([select sku__c,link_sku__c from Review__c where link_sku__c = null and sku__c != null  and SystemModStamp >=:myDateTime]); 
     }
     global void execute(Database.BatchableContext ctx, list<Review__c> list_rev)
     {
     	 set<String> set_sku=new set<String>();//sku__c集合
     	 for(Review__c rev:list_rev)
     	 {
     	 	if(!set_sku.contains(rev.sku__c))
     	 	{
     	 	   set_sku.add(rev.sku__c);
     	 	}
     	 }
     	 list<SKU__c> list_sku=new list<SKU__c>();//SKU__c记录
     	 if(set_sku.size()>0)
     	 {
     	    list_sku=[select Id,sku__c from SKU__c where sku__c in:set_sku];
     	    map<String,Id> map_sku=new map<String,Id>();
     	    if(list_sku.size()>0)
     	    {
     	       for(SKU__c sku:list_sku)
     	       {
     	           if(!map_sku.containsKey(sku.sku__c) && sku.sku__c != null)
     	           {
     	               map_sku.put(sku.sku__c,sku.Id);
     	           }
     	       }
     	    }
     	    for(Review__c rev:list_rev)
	     	{
	     	 	if(rev.sku__c != null && map_sku.get(rev.sku__c) != null)
	     	 	{
	     	 	    rev.link_sku__c=map_sku.get(rev.sku__c);
	     	 	}
	     	}
	     	update list_rev;
     	 }    	 
     }
     global void finish(Database.BatchableContext ctx)
     {
     	 
     }
}