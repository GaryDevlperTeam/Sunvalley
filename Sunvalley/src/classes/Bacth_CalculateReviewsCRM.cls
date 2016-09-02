/**
*Des:Reviews CRM 汇总和客户相关的review 条数,Review Star Summary CRM为该客户下所有review的Review Star的求和汇总。
*Author:Jmark
*Time:2015年10月21日13:37:11
**/

global class Bacth_CalculateReviewsCRM implements  Database.Batchable<sObject>{
	
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([SELECT Id,reviews_crm__c FROM Account]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Account> list_acc)
	 {
	 	 //计算汇总和客户相关的review 条数
	 	 set<Id> set_id=new set<Id>();//客户Id
	 	 for(Account acc:list_acc)
	 	 {
	 	    set_id.add(acc.Id);
	 	 }
	 	 list<Review__c> list_rev=new list<Review__c>();
	 	 if(set_id.size()>0) 
	 	 {
	 	    list_rev=[select Id,customer__c,review_star__c from Review__c where customer__c in:set_id];
	 	 }
	 	 map<Id,list<Review__c>> map_rev=new map<Id,list<Review__c>>();
	 	 if(list_rev.size()>0)
	 	 {
	 	     for(Review__c rev:list_rev)
	 	     {
	 	        if(map_rev.containsKey(rev.customer__c))
	 	        {
	 	           map_rev.get(rev.customer__c).add(rev);
	 	        }
	 	        else
	 	        {
	 	           list<Review__c> list_revnew=new list<Review__c>();
	 	           list_revnew.add(rev);
	 	           map_rev.put(rev.customer__c,list_revnew);
	 	        }
	 	     }
	 	     if(map_rev.size()>0)
	 	     {
	 	         //给客户赋值
			 	 for(Account acc:list_acc)
			 	 {
			 	    if(map_rev.containsKey(acc.Id))
			 	    {
			 	       acc.reviews_crm__c = map_rev.get(acc.Id).size();
			 	       Double num=0;
			 	       for(Review__c rev:map_rev.get(acc.Id))
			 	       {
			 	          if(rev.review_star__c != null)
			 	          {
			 	              num=num+rev.review_star__c;
			 	          }
			 	       }
			 	       acc.reviews_star_summary_crm__c=num;
			 	    }
			 	    else
			 	    {
			 	       acc.reviews_crm__c=0;
			 	       acc.reviews_star_summary_crm__c=0;
			 	    }
			 	 }
			 	 update list_acc;
			 }
	 	 }
	 }
     global void finish(Database.BatchableContext ctx)
     {
     	
     }
}