/**
*Dis:新建RMA时根据邮件匹配客户
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/ 
global class BatchRMAMatchingCustomer implements Database.Batchable<sObject>
{
	 global Database.queryLocator start(Database.BatchableContext ctx)
  	 { 
  	 		datetime myDateTime = datetime.now().addHours(-24);
      		return Database.getQueryLocator([Select Id,amazon_email__c,customer_email__c,AccountId from Case where (amazon_email__c != null or customer_email__c != null) and  SystemModStamp >=:myDateTime]); 
	 }
	 
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope) 
	 {
	 		//RMA Amazon Email
	        Set<String> set_Aemail = new Set<String>();
	        
	        //RMA Customer Email
	        Set<String> set_Cemail = new Set<String>();
	        
	        for(Sobject sc : scope)
		  	{
		  		Case ca = (Case)sc;	
		  		 
		  		if(ca.amazon_email__c != null)
		  		{
		  			set_Aemail.add(ca.amazon_email__c);  		
		  		}				
				if(ca.customer_email__c != null)
		  		{
		  			set_Cemail.add(ca.customer_email__c);  		
		  		}
		  	}
		  	
		  	//满足条件的客户
		  	List<Account> listAccount = [select Id,amazon_email__c,customer_email__c from Account 
		  	                             where amazon_email__c in:set_Aemail or customer_email__c in:set_Cemail];
		  	                             
		  	//Amazon Email
		  	Map<String,String> map_Aemail_AccId = new Map<String,String>();  
		  	
		  	//Customer Email
		  	Map<String,String> map_Cemail_AccId = new Map<String,String>();                              
		  	
		  	
		  	for(Account acc:listAccount)
	  		{
	  			if(acc.amazon_email__c != null)
	  			{
	  				map_Aemail_AccId.put(acc.amazon_email__c,acc.Id);
	  			}
	  			if(acc.customer_email__c != null)
	  			{
	  				map_Cemail_AccId.put(acc.customer_email__c,acc.Id);
	  			}
	  		} 
	  		                            
		  	//匹配到客户的RMA  
		  	List<Case>  list_RMA = new List<Case>();   
		  	
		  	Set<Case> set_TempRMA = new Set<Case>();                      
		  	
	  		for(Sobject sc : scope)
	  		{
	  			Case ca = (Case)sc;	
	  			
  				if(map_Aemail_AccId.containsKey(ca.amazon_email__c))
  				{
  					ca.AccountId = map_Aemail_AccId.get(ca.amazon_email__c);
  					set_TempRMA.add(ca);
  				}else
  				if(map_Cemail_AccId.containsKey(ca.customer_email__c))
  				{
  					ca.AccountId = map_Cemail_AccId.get(ca.customer_email__c);
  					set_TempRMA.add(ca);
  				}
	  		} 
	  		
	  		for(Case cas:set_TempRMA)
	  		{
	  			list_RMA.add(cas);
	  		}
	  		update list_RMA;                             
	 }
	 
	 global void finish(Database.BatchableContext ctx)
     {
	       	
     }

}