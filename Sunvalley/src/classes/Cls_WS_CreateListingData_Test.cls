/**
*Des:Cls_WS_CreateListingData Test
*Author:Gary Hu
*Time:2015年10月10日10:08:11
**/
@isTest
private class Cls_WS_CreateListingData_Test {

    static testMethod void myUnitTest() {
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
	    SKU__c sku=new SKU__c();
        sku.Name='testosku';
        sku.sku__c='rrrrrrrrrrrrrrrrr';
        insert sku;
        Campaign_SKU__c csku=new Campaign_SKU__c();
        csku.campaign__c=cp.Id;
        csku.fct_sku_nmuber__c=100;
        csku.SKU__c=sku.Id;
        insert csku;
		Cls_WS_CreateListingData.autoCreateListDate(cp.Id);
		
		
			    
        
    }
}