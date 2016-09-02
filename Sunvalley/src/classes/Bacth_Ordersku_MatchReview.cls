/**
*Create By:jmark
*TIME：2015年9月9日10:45:08
*Description:ordersku与review关联：根据ordersku.amazon_id__c=review.amazon_id__c;review.sku__c=ordersku.sku__c,ordersku.review__c=review.id做关联
 */  
global class Bacth_Ordersku_MatchReview implements Database.Batchable<SObject>{


     global Database.queryLocator start(Database.BatchableContext ctx)
     {      datetime myDateTime = datetime.now().addHours(-24);    
           return Database.getQueryLocator([select amazon_id__c,review__c,sku__c from Order_sku__c where review__c = null and amazon_id__c != null and sku__c != null  and SystemModStamp >=:myDateTime]); 
     }
     global void execute(Database.BatchableContext ctx, list<Order_sku__c> list_sku)
     {
        if(list_sku.size() > 0)
         {
             set<String> set_amazonid = new set<String>(); //ordersku.amazon_id__c集合
             set<String> set_sku = new set<String>(); //ordersku.sku__c集合
             for(Order_sku__c osku:list_sku)//给set集合赋值
             {
                 if(!set_amazonid.contains(osku.amazon_id__c))
                 {
                     set_amazonid.add(osku.amazon_id__c);
                 }
                  if(!set_sku.contains(osku.sku__c))  
                 {
                     set_sku.add(osku.sku__c);   
                 }
             }
             if(set_amazonid.size() > 0 && set_sku.size() > 0)
             {
                 list<Review__c>  list_rev=[select amazon_id__c,sku__c,Id from Review__c where amazon_id__c in:set_amazonid and sku__c in:set_sku];
                 if(list_rev.size()>0)//配比赋值
                 {
                     for(Order_sku__c sku:list_sku)
                     {
                         for(Review__c rev:list_rev)
                         {
                             if(sku.amazon_id__c == rev.amazon_id__c && sku.sku__c == rev.sku__c)
                             {
                                 sku.review__c =rev.Id;
                             }
                         }
                     }
                     update list_sku;
                 }
             }
         }
     }
     global void finish(Database.BatchableContext ctx)
     {
        
     }
}