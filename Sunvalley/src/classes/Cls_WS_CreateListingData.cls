/**
*Des:创建关联到该Campaign的Listing Data记录
*Author:Gary Hu
*Time:2015年9月15日13:44:52
**/
global class Cls_WS_CreateListingData {
	//创建
	 webservice static String autoCreateListDate(ID cId)
    {
    	 //返回结果
        String resultValue = null;
         if(cId != null)
        {
        	//获取campaign sku
            list<Campaign_SKU__c>  listCamSku = [select campaign_sku__c from  Campaign_SKU__c where campaign__c =:cId ];
            //获取campaign 
            Campaign  objCampaign = [select is_create_listing_data__c,StartDate,EndDate,campaign_country__c from Campaign where Id =: cId]; 
            
            if(listCamSku.size() > 0)
            {
            	 objCampaign.is_create_listing_data__c = true;
            	 Database.executeBatch(new Bacth_Create_Listing_Data(cId,objCampaign.StartDate,objCampaign.EndDate,String.valueOf(objCampaign.campaign_country__c)), 50);
            	 update objCampaign;
            }else
            {
            	resultValue = 'Ec';
            }
        }
        
        return resultValue;
    }
}