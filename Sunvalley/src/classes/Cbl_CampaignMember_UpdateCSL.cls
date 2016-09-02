/**
*Dis:新建"市场活动成员"，通过“市场活动”，“联系人”字段，赋值字段Campaign Sku List
*Author:Gavin Li
*Time:2015年11月02日10:55:23
**/
public class Cbl_CampaignMember_UpdateCSL {
	//新建"市场活动成员"，通过“市场活动”，“联系人”字段，赋值字段Campaign Sku List
	public void updateCSL(list<CampaignMember> listCM)
	{
		
		set<Id> set_CustomerId = new set<Id>();//客户的Id集合
		set<Id> set_CampaignId = new set<Id>();//市场活动的Id集合
		for(CampaignMember cm:listCM)
		{
			if(cm.ContactId!=null&&cm.CampaignId!=null)
			{
				set_CustomerId.add(cm.ContactId);
				set_CampaignId.add(cm.CampaignId);
			}
		}
		if(set_CustomerId.size()>0&&set_CampaignId.size()>0)
		{
			//查询"市场活动SKU"的name
			list<Campaign_SKU__c> listCampaignSKU =[select campaign_sku__c from Campaign_SKU__c where campaign__c in:set_CampaignId];
			if(listCampaignSKU.size()>0)
			{
				String csl=null;
				for(Campaign_SKU__c sc:listCampaignSKU)
				{
					if(sc.campaign_sku__c!=null)
					{
						if(csl==null)
						{
							csl=sc.campaign_sku__c;
						}
						else
						{
							csl=csl+'&'+sc.campaign_sku__c;
						}
					}
				}
			if(csl!=null)
			{
			//查询“客户”下的campaign_sku_list
			list<Account> listAccount =[select campaign_sku_list__c from Account where PersonContactId in:set_CustomerId];
			if(listAccount.size()>0)
			{
				for(Account acc:listAccount)
				{
					if(acc.campaign_sku_list__c==null)
   					{
   						acc.campaign_sku_list__c  = csl;
   					}
   					else
   					{
   						acc.campaign_sku_list__c  = acc.campaign_sku_list__c+','+csl;
   					}
   				}
			}
			update listAccount;
		}
		}
	}  
	
	}
}