/**
*Des:更新MerchantSku
*Author:Gary HU
*Time:2015年9月18日11:15:37
**/
public  class Cbl_Campaign_Update_MerchantSku {
	
	//插入字段
	public static void insertMerchantSku(list<Campaign_SKU__c> listCamSku)
	{
		set<Id> setCId = new set<Id>();
		for(Campaign_SKU__c c:listCamSku )
		{
			if(c.SKU__c != null && c.campaign__c != null)
			{
				setCId.add(c.Id);
			}
		}
		if(setCId.size() >0)
		{
			list<Campaign_SKU__c> listCamSkuX = [select campaign_country_code__c,campaign_sku__c,merchant_sku__c from Campaign_SKU__c where Id in:setCId];
			//Country
			String strCountry = null;
			//Sku
			set<String> setSku = new set<String>();
			if(listCamSkuX.size() > 0)
			{
				for(Campaign_SKU__c c:listCamSkuX)
				{
					if(c.campaign_sku__c != null)
					{
						setSku.add(c.campaign_sku__c);
					}
					c.merchant_sku__c = '';
				}
			}
			
			if(listCamSkuX.size() > 0)
			{
				list<SKU__c> listSku = [select sku__c,ca_merchantsku__c,de_merchantsku__c,es_merchantsku__c,fr_merchantsku__c,it_merchantsku__c,jp_merchantsku__c,us_merchant_sku__c,uk_merchantsku__c from SKU__c where sku__c in:setSku];
				
				if(listSku.size() > 0)
				{
					String strMerchantSku = '';
					for(SKU__c s: listSku)
					{
						for(Campaign_SKU__c c:listCamSkuX)
						{
							if(s.sku__c == c.campaign_sku__c)
							{
								c.merchant_sku__c = '';
								if(c.campaign_country_code__c == 'CA')
								{
									strMerchantSku += s.ca_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'DE')
								{
									strMerchantSku += s.de_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'ES')
								{
									strMerchantSku += s.es_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'IT')
								{
									strMerchantSku += s.it_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'JP')
								{
									strMerchantSku += s.jp_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'US')
								{
									strMerchantSku += s.us_merchant_sku__c+',';
								}
								if(c.campaign_country_code__c == 'UK')
								{
									strMerchantSku += s.uk_merchantsku__c+',';
								}
								if(c.campaign_country_code__c == 'GB')
								{
									strMerchantSku += s.uk_merchantsku__c+',';
								}
							}
						}
					}
					if(strMerchantSku != '')
					{
						strMerchantSku = strMerchantSku.removeEnd(',');
					}
					for(Campaign_SKU__c c:listCamSkuX)
					{
						System.debug(strMerchantSku+'---------strMerchantSku----------');
						if(strMerchantSku != null)
						{
							c.merchant_sku__c = strMerchantSku;
						}
						if(c.merchant_sku__c == 'null')
						{
							c.merchant_sku__c = '';
						}
					}
					update listCamSkuX;
				}
			}
		}
	}
	
	//修改操作
	public static void updateMerchantSku(list<Campaign_SKU__c> listCamSku,map<Id,Campaign_SKU__c> mapOld)
	{
		list<Campaign_SKU__c> listCamSkuX = new list<Campaign_SKU__c>();
		for(Campaign_SKU__c c: listCamSku)
		{
			if(c.SKU__c != null && c.SKU__c != mapOld.get(c.Id).SKU__c)
			{
				listCamSkuX.add(c);
			}
			
		}
		if(listCamSkuX.size() >0)
		{
			insertMerchantSku(listCamSkuX);
		}
	
	}
	
	
}