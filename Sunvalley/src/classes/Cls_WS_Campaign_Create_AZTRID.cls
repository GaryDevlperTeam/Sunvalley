/**
*DES:自动生成Amazon Tracking ID
*Author:Gary Hu
*Time:2015年9月22日17:43:25
**/
global class Cls_WS_Campaign_Create_AZTRID {
	 webservice static String autoCreateAZTRID(ID cId)
    {
        //返回结果
        String resultValue = null;
       	if(cId != null)
       	{
       		String strCmaSku = '';
       		list<Campaign_SKU__c> listCSKU = [select campaign_sku__c from Campaign_SKU__c where campaign__c =:cId and campaign_sku__c != null];
       		Integer size  = listCSKU.size();
       		if(listCSKU.size() >0)
       		{
       			for(Campaign_SKU__c c:listCSKU)
       			{
   					strCmaSku += c.campaign_sku__c+'&';
       			}
       			strCmaSku = strCmaSku.removeEnd('&');
       			//修改Campaign 的值
       			Campaign objCa = [select amazon_tracking_id__c,AZTRID__c from Campaign where id =:cId];
       			objCa.amazon_tracking_id__c = strCmaSku+'-'+objCa.AZTRID__c;
       			update objCa;
       		}else{
       			resultValue = 'E';
       		}
       	}
       	
       	return resultValue;
    
    }
}