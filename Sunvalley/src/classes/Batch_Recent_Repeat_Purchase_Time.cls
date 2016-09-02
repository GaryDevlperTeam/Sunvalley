/**
*Des:计算复购率 = （ordersku中出现过两次以上的Amazon_Email数/此时间段内Amazon_Email的唯一不重复数量）*100%
*Author:Jmark
*Time:2015年10月20日16:51:56
**/

global class Batch_Recent_Repeat_Purchase_Time implements  Database.Batchable<sObject>,Database.Stateful{
	
	//Repeat Purchase TimeId
    global ID cId= null;
    //开始日期
    global Date startDate = null;
	//结束日期
    global Date endDate = null;
    //邮箱分组
    global map<String,set<Id>> map_email=new map<String,set<Id>>();
    
    public Batch_Recent_Repeat_Purchase_Time(ID cId,Date startDate,Date endDate)
    {
    	this.cId = cId;
    	this.startDate = startDate;
    	this.endDate = endDate;
    }
    
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([SELECT Id,amazon_email__c FROM Order_sku__c where amazon_email__c != null and order_date__c <=:endDate and order_date__c >=:startDate]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Order_sku__c> list_sku)
	 {
	 	  system.debug('list_skulist_skulist_skulist_sku'+list_sku);
          for(Order_sku__c sku:list_sku)
          {
             if(map_email.containsKey(sku.amazon_email__c))
             { 
                 map_email.get(sku.amazon_email__c).add(sku.Id);
             }
             else
             {
                 set<Id> set_Id=new set<Id>();
                 set_Id.add(sku.Id);
                 map_email.put(sku.amazon_email__c,set_Id);
             }
          }
	 }
     global void finish(Database.BatchableContext ctx)
     {
     	  system.debug('map_emailmap_emailmap_emailmap_email'+map_email);
	      Repeat_Purchase_Time__c rpt=[select Repeat_Purchase_Time__c from Repeat_Purchase_Time__c where Id =: cId];
	      if(map_email.size()>0)
	      {
	      	 Double num=0;
	         for(String str:map_email.keySet())
	         {
	             if(map_email.get(str).size() >= 2)
	             {
	                num++;
	             }
	         }
	         if(num != 0)
	         {
	         	
	            rpt.Repeat_Purchase_Time__c=(num/(map_email.size()))*100;
	            update rpt;
	         }
	      }
     }
    
    
    
    
    
}