/**
*Des: Campaign Times 参加活动次数 
Mails Send 参加过的Campaign的EDM Event数量
*Author:Gary Hu
*Time；2015年10月21日9:13:44
**/
global class Bacth_Count_Campaign implements  Database.Batchable<sObject>{
	 
	 global RecordType r = [Select Id, DeveloperName From RecordType Where DeveloperName ='EDM_Event' and Sobjecttype='Campaign'];
	 
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	return Database.getQueryLocator([select Id,PersonContactId,campaign_times__c,mails_send__c  from  Account]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Account> list_Acc) {
	 	if(list_Acc.size() > 0)
	 	{
	 		
	 		//Account Id
	 		set<Id> setAccId = new set<Id>();
	 		//Campain 
	 		for(Account a:list_Acc)
	 		{
	 			setAccId.add(a.PersonContactId);
	 		}
	 		if(setAccId.size() > 0)
	 		{
	 			//Campaign Times 参加活动次数
	 			map<Id,integer> mapCountCampain = new map<Id,integer>();
	 			//统计campaign
	 			AggregateResult []  countCampain = [select count(CampaignId) countCam,ContactId  from CampaignMember 
	 											   where ContactId  in:setAccId group by ContactId  ];
	 			if(countCampain.size() > 0)
	 			{
	 				for(AggregateResult c:countCampain)
	 				{
	 					if(!mapCountCampain.containsKey(String.valueOf(c.get('ContactId'))))
	 					{
	 						mapCountCampain.put(String.valueOf(c.get('ContactId')),Integer.valueOf(c.get('countCam')));
	 					}
	 				}
	 			}
	 			//Mails Send 参加过的Campaign的EDM Event数量
	 			map<Id,set<Id>> mapCamSet = new map<Id,set<Id>>();
 				set<Id> setCid = new set<Id>();
	 			list<CampaignMember> listCampMember = [select ContactId,CampaignId from CampaignMember where ContactId in:setAccId ];
	 			if(listCampMember.size() > 0)
	 			{
	 				for(CampaignMember a:listCampMember)
	 				{
	 					setCid.add(String.valueOf(a.CampaignId));
	 					if(!mapCamSet.containsKey(String.valueOf(a.ContactId)))
	 					{
	 						set<Id> setCidX = new set<Id>();
	 						setCidX.add(a.CampaignId);
	 						mapCamSet.put(String.valueOf(a.ContactId),setCidX);
	 					}else{
	 						mapCamSet.get(String.valueOf(a.ContactId)).add(a.CampaignId);
	 					}
	 				}
	 			}
	 			map<Id,integer> mapCountEDM = new map<Id,integer>();
	 			AggregateResult[] listCampEDM = [select count(Id) countEDM,ParentId  from Campaign  where ParentId in:setCid and RecordTypeId=:r.id group by ParentId];
	 			if(listCampEDM.size() > 0)
	 			{
	 				for(AggregateResult a: listCampEDM)
	 				{
	 					if(!mapCountEDM.containsKey(String.valueOf(a.get('ParentId'))))
	 					{
	 						mapCountEDM.put(String.valueOf(a.get('ParentId')),Integer.valueOf(a.get('countEDM')));
	 					}
	 				}
	 			}
	 			for(Account a:list_Acc)
	 			{
	 				//Campaign Times 参加活动次数
	 				if(mapCountCampain.containsKey(a.PersonContactId))
	 				{
	 					//更新客户上的Campaign Times
	 					a.campaign_times__c = mapCountCampain.get(a.PersonContactId);
	 				}
	 				//Mails Send 参加过的Campaign的EDM Event数量
	 				if(mapCamSet.containsKey(a.PersonContactId))
	 				{
	 					Integer i =0;
	 					
	 					for(ID ids:mapCamSet.get(a.PersonContactId))
	 					{
	 						System.debug('------------------');
	 						if(mapCountEDM.containsKey(ids))
	 						{
	 							i = i+mapCountEDM.get(ids);
	 						}
	 					}
	 					a.mails_send__c = i;
	 				}
	 			}
	 			update list_Acc;
	 		}
	 	}
	 }
	  global void finish(Database.BatchableContext ctx)
    {
	
    }
    
}