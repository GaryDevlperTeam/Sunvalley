/**
*Des:customer与Campaign关联：根据customer.original_source__c = campaign channel.campaign_channel_id__c
*Author:Gary Hu
*Time:2015年9月10日13:21:16
**/
global class Bacth_Customer_Matching_Campaign implements Database.Batchable<SObject>{
	// original_source
	 global set<String>  setOrSource = new set<String>();
	  //所有Account数据集合
	 global list<Account> list_allAcc=new list<Account>();
	 
	 global Database.queryLocator start(Database.BatchableContext ctx)
     { 
     	datetime myDateTime = datetime.now().addHours(-24);
     	System.debug(myDateTime+'--------myDateTime-------');
     	return Database.getQueryLocator([select original_source__c,source_campaign__c,SystemModStamp from Account 
     									where source_campaign__c= null and original_source__c != null and SystemModStamp >=:myDateTime ]);
     }
     
       global void execute(Database.BatchableContext ctx, list<Account> list_acc)
     {
     	System.debug(list_acc.size()+'----------list_acc.size()---------');
     	
     	if(list_acc.size() > 0)
     	{
     		for(Account a:list_acc)
     		{
     			if(!setOrSource.contains(a.original_source__c))
     			{
     				setOrSource.add(a.original_source__c);
     			}
     		}
     		if(setOrSource.size() > 0)
     		{
     			list<Campaign_Channel__c> listCampaignChannel = [select campaign__r.Id,campaign_channel_key__c from Campaign_Channel__c where campaign_channel_key__c in:setOrSource];
     			if(listCampaignChannel.size() > 0)
		     	{
		     		for(Account a:list_acc)
		     		{
		     			for(Campaign_Channel__c c:listCampaignChannel)
		     			{
		     				if(a.original_source__c == c.campaign_channel_key__c)
		     				{
		     					a.source_campaign__c = c.campaign__r.Id;
		     				}
		     			}
		     		}
		     		update list_acc;
		     	}
     		}
     	}
     }
     
      global void finish(Database.BatchableContext ctx)
     {
     }
}