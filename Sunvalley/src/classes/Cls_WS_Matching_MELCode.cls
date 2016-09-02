/**
*Des:附件匹配MEL中的Amazon Tracking ID
*Author:Gary Hu
*Time:2015年9月8日13:48:21
**/
global class Cls_WS_Matching_MELCode {
	//更改MEL中的 Amazon Tracking ID
	webservice static String autoUpdateMEL(ID cId)
	{
		//返回结果
    	String resultValue = null;
    	if(cId != null)
    	{
    		Attachment  atta = new Attachment();
    		
    		String body = null;
    		if([select Body,ParentId from Attachment where ParentId =:cId].size() > 0)
    		{
	    		atta = [select Body,ParentId from Attachment where ParentId =:cId]; 
    		}
    		list<Mass_Email_Log__c> listMel = [select Id from Mass_Email_Log__c where campaign_name__c =:cId];
    		//获取campaign 
			Campaign objCampaign = [select is_import_coupon_code__c,Id from Campaign where Id =: cId]; 
    		
    		if(atta != null && atta.Body != null && listMel.size() > 0)
    		{
    			String strBody = atta.body.toString();
    			System.debug(strBody+'------strBody----------');
    			
    			//分割RepCode
				String[] arrAmCode = new list<String>();
				if(strBody.indexOf('\n') != -1)
				{
					arrAmCode = strBody.split('\n');
				}
				else
				{
					arrAmCode.add(strBody);
				}
    			system.debug(arrAmCode+'----------------');
    			system.debug(arrAmCode.size()+'----------------');
    			
    			if(arrAmCode.size() > 0)
    			{
	    			resultValue = 'OK';
	    			Database.executeBatch(new Batch_Matching_MELCode(cId,arrAmCode), 999);
	    			objCampaign.is_import_coupon_code__c = true;
	    			update objCampaign;
    			}
    		}else
    		{
    			resultValue = 'E';
    		}
    		
    	}
    	return resultValue;
	}
}