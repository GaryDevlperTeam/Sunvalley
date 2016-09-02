/**
*Dis:新建Customer时根据Original Source匹配Campaign Channel
*Auther:Victor Li
*Time:2015年9月25日15:22:54
**/
global class Batch_Customer_Matching_Campaign_Channel implements Database.Batchable<sObject>
{
	 global Database.queryLocator start(Database.BatchableContext ctx)
  	 { 		datetime myDateTime = datetime.now().addHours(-24);
      		return Database.getQueryLocator([Select Id,original_source__c,link_register_channel__c from Account  where original_source__c != null and link_register_channel__c = null and  SystemModStamp >=:myDateTime]); 
	 }
	 
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope) 
	 {
	 		//original_source__c
	        Set<String> set_OS = new Set<String>();
	        
	        for(Sobject sc : scope)
		  	{
		  		Account acc = (Account)sc;	
	  			set_OS.add(acc.original_source__c);  		
		  	}
	  		System.debug(set_OS + '*******set_OS*******');                             
		  		
		  	//满足条件的Campaign Channel
		  	List<Campaign_Channel__c> listCampaignChannel = [select Id,campaign_channel_key__c from Campaign_Channel__c 
		  	                                                 where campaign_channel_key__c in:set_OS];
		  	
		  	System.debug(listCampaignChannel + '*******listCampaignChannel*******');                                                 
		  	//匹配到Campaign Channel的客户
		  	List<Account>  list_Account = new List<Account>(); 
		  	
		  	Set<Account> set_TempAccount = new Set<Account>();  
		  	
		  	for(Sobject sc : scope)
	  		{
	  			Account acc = (Account)sc;	
	  			
	  			for(Campaign_Channel__c cc:listCampaignChannel)
	  			{
	  				if(acc.original_source__c == cc.campaign_channel_key__c)
	  				{
	  					acc.link_register_channel__c = cc.Id;
	  					set_TempAccount.add(acc);
	  					break;
	  				}
	  			}
	  		} 
	  		
	  		for(Account acc1:set_TempAccount)
	  		{
	  			list_Account.add(acc1);
	  		}
	  		
	  		update list_Account;      
	 }
	 
	 global void finish(Database.BatchableContext ctx)
     {
	       	
     }

}