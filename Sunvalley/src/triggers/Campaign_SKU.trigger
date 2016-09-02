/**
*Des:处理SKU重复的情况
*Author:Gary Hu
*Time:2015年9月18日10:42:50
**/
trigger Campaign_SKU on Campaign_SKU__c (after insert,after update) {
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			//自动给Merchant Sku赋值
			Cbl_Campaign_Update_MerchantSku.insertMerchantSku(trigger.new);
			System.debug('----------我来了----------');
		}
		if(trigger.isUpdate)
		{
			Cbl_Campaign_Update_MerchantSku.updateMerchantSku(trigger.new, trigger.oldMap);
		}
	}
}