/**
*Des:Cls_WS_Campaign_CreateMEL Test
*Author:Gary Hu
*Time:2015年10月11日18:24:26
**/
@isTest
private class Cls_WS_Campaign_CreateMEL_Test {

    static testMethod void myUnitTest() {
    	Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        //acc.customer_id__c = '123';
        acc.original_source__c = 'xxxx';
        acc.amazon_id__c = '111111111111111';
        insert acc;
        Account a = [Select PersonContactId From Account Where Id = :acc.Id];
		Campaign cp=new Campaign();
	    cp.Name='testcp';
	    cp.Person_in_Charge__c='testp';
	    cp.campaign_country__c='US';
	    cp.campaign_brand__c='RAVPower';
	    cp.campaign_target__c='Superuser';
	    cp.StartDate=Date.today().addDays(-1);
	    cp.review_collect_end_day__c=5;
	    cp.campaign_country__c='US';
	    CP.EndDate = Date.today().addDays(3);
	    insert cp;
	    CampaignMember ca = new CampaignMember();
	    ca.CampaignId  = cp.Id;
	    ca.ContactId   = a.PersonContactId;
	    insert ca;
	    SKU__c sku=new SKU__c();
        sku.Name='testosku';
        sku.sku__c='rrrrrrrrrrrrrrrrr';
        insert sku;
        Campaign_SKU__c csku=new Campaign_SKU__c();
        csku.campaign__c=cp.Id;
        csku.fct_sku_nmuber__c=100;
        csku.SKU__c=sku.Id;
        insert csku;
        Cls_WS_Campaign_CreateMEL.autoCreateMEL(cp.id,'');
    }
}