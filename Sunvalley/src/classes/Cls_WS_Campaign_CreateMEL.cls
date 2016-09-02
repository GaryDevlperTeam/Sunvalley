/**
*Des:市场活动成员生成MEL
*Author:Gary Hu
*Time：2015年9月6日14:28:00
**/
global class Cls_WS_Campaign_CreateMEL {
    //创建MEL
    webservice static String autoCreateMEL(ID cId,String strSoql)
    {
        //返回结果
        String resultValue = null;
        if(cId != null)
        {
            //客户Id          
            set<Id> setAccId = new set<Id>();
            //CampSku
            String strCampSku = null;
            //获取 Sku set
            set<String> setCampSku = new set<String>();
            
            //获取campaign 
            Campaign  objCampaign = [select is_create_mel__c,Id,campaign_id__c,Name,campaign_channel__c,campaign_country__c,Type from Campaign where Id =: cId]; 
            
            //获取campaign Member
            list<CampaignMember> listCampainMember = [ Select Contact.AccountId, ContactId, CampaignId From CampaignMember where CampaignId =: cId];

            //获取campaign sku
            list<Campaign_SKU__c>  listCamSku = [select SKU__c,campaign_sku__c,merchant_sku__c,sku_item_name__c,Listing_Link__c,ASIN__c from  Campaign_SKU__c where campaign__c =:cId ];
            
           
            
            if(listCamSku.size() > 0 )
            {
                if(listCampainMember.size() > 0 ||strSoql != '' )
	            {
	                resultValue = 'OK';
	                for(CampaignMember cm : listCampainMember)
	                {
	                    if(cm.Contact.AccountId != null)
	                    {
	                        setAccId.add(cm.Contact.AccountId);
	                    }
	                }   
	                objCampaign.is_create_mel__c = true;
	                //调用batch 进行创建MEL
	                Database.executeBatch(new Batch_Campaign_CreateMEL(setAccId,strSoql,objCampaign,listCamSku), 999);
	                //修改状态          
	                update objCampaign; 
	            }else{
	            	resultValue = 'E';  
	            }
            }else
            {
            	resultValue = 'Ec'; 
            }
        }
            
        return resultValue;
    }
}