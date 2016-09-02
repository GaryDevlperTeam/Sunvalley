/**
*Des:批量生成 MEL
*Author:Gary Hu
*Time:2015年9月6日15:30:30
**/
global class Batch_Campaign_CreateMEL implements Database.Batchable<sObject>{
    //市场活动Id
    global Set<Id> setAccId = new Set<Id>();
    
    //Soql Str
    global String strSoql;
    
    //
    global Campaign objCampaign;
    
    global list<Campaign_SKU__c> listCamSku;
    
    global DataFormat df = new DataFormat();
    
	
	  	
    
    //获取传入的变量
    public Batch_Campaign_CreateMEL(Set<Id> setAccId,String strSoql,Campaign objCampaign,list<Campaign_SKU__c>  listCamSku)
    {
        this.setAccId = setAccId;
        this.strSoql = strSoql;
        this.objCampaign = objCampaign;
        this.listCamSku = listCamSku;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuerySoql = null;
        System.debug(strSoql+'---------strSoql------------');
        if(strSoql != '')
        {
            strQuerySoql = strSoql;
        }
        else
        {
            strQuerySoql = 'select Id,reviewer_address__c,reviewer_city__c,country__c,customer_email__c,reviewer_profile_country__c,reviewer_state__c,crm_ustomer_id__c,FirstName,LastName,reviewer_zip__c,reviewer_firstname__c,reviewer_lastname__c '+ 
                            'from Account where Id in:setAccId';
                            System.debug(strQuerySoql+'------------------');
        }
        return Database.getQueryLocator(strQuerySoql); 
    }
     global void execute(Database.BatchableContext ctx,list<Account > list_Acc) {
     	System.debug(list_Acc.size()+'------------list_Acc.size()--------------');
     	
        if(list_Acc.size()> 0)
        {
            list<Mass_Email_Log__c> listMel = new list<Mass_Email_Log__c> ();
            Integer i = 1;
            for(Campaign_SKU__c c : listCamSku)
            {
                for(Account a: list_Acc)
                {
                	Integer n = i++;
                    Mass_Email_Log__c  m = new Mass_Email_Log__c();
                    if(a.reviewer_address__c != null)
                    {
                        m.reviewer_address__c = a.reviewer_address__c;
                    }

                    if(objCampaign.campaign_id__c != null)
                    {
                        m.campaign_id__c = objCampaign.campaign_id__c;
                    }
                    if(objCampaign.campaign_country__c != null)
                    {
                        m.campaign_country_code__c = objCampaign.campaign_country__c;
                    }
                    
                    if(objCampaign.Id != null)
                    {
                        m.Campaign_name__c = objCampaign.Id;
                    }
                    if(objCampaign.campaign_channel__c != null)
                    {
                        m.campaign_channel__c = objCampaign.campaign_channel__c;
                    }
                    if(a.reviewer_city__c != null)
                    {
                        m.reviewer_city__c = a.reviewer_city__c;
                    }
                    if(a.country__c != null)
                    {
                        m.country__c = a.country__c;
                    }
                    
                    if(a.customer_email__c != null)
                    {
                        m.customer_email__c = a.customer_email__c;
                    }
                   
                    if(c.SKU__c != null)
                    {
                        m.link_sku__c = c.SKU__c;
                    }
                    if(c.sku_item_name__c != null)
                    {
                        m.sku_item_name__c = c.sku_item_name__c;
                    }
                    if(c.merchant_sku__c != null)
                    {
                        m.merchant_sku__c = c.merchant_sku__c;
                    }
                    if(c.campaign_sku__c != null)
                    {
                        m.campaign_sku__c = c.campaign_sku__c;
                    }
                    if(c.ASIN__c != null)
                    {
                        m.ASIN__c = c.ASIN__c;
                    }
                    if(c.Listing_Link__c != null)
                    {
                        m.Listing_Link__c = c.Listing_Link__c;
                    }
                    if(a.reviewer_state__c != null)
                    {
                        m.reviewer_state__c = a.reviewer_state__c;
                    }
                   
                    if(a.crm_ustomer_id__c != null)
                    {
                        m.customer_id__c = a.crm_ustomer_id__c;
                    }
					
                    m.customer__c = a.Id;
                    
                    if(a.FirstName != null)
                    {
                        m.first_name__c = a.FirstName;
                    }
                    if(a.LastName != null)
                    {
                        m.last_name__c = a.LastName;
                    }
                    if(a.reviewer_firstname__c != null)
                    {
                        m.reviewer_first_name__c = a.reviewer_firstname__c;
                    }
                    if(a.reviewer_lastname__c != null)
                    {
                        m.reviewer_last_name__c = a.reviewer_lastname__c;
                    }
                    if(a.reviewer_zip__c != null)
                    {
                        m.reviewer_zip__c = a.reviewer_zip__c;
                    }
                    m.customer__c = a.Id;
                    m.merchant_fulfillment_orderItem_id__c = String.valueOf(n);
                    if(n> 999)
                    {
	                    m.m_no__c = 'NO';
                    }else
                    {
	                    m.m_no__c = df.IntToString(n, 3);
                    }
                    listMel.add(m);
                    
                }
            }
            Database.SaveResult[] saveResults = Database.insert(listMel,false);
            if(saveResults != null && !saveResults.isEmpty()) {
                for(Database.SaveResult saveResult : saveResults) {
                    if(saveResult.isSuccess()) {
                        System.debug('Successful insert MEL ' + saveResult.getId());
                    } else {
                        for(Database.Error error : saveResult.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(error.getStatusCode() + ': ' + error.getMessage());
                            System.debug('MEL fields that affected this error: ' + error.getFields());
                        }
                    }
                }
            }
        }
     }  
    global void finish(Database.BatchableContext ctx)
    {

    }
        
}