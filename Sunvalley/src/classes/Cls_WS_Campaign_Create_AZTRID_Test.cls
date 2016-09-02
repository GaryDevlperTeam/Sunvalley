/**
*Des:Cls_WS_Campaign_Create_AZTRID Test
*Author:Gary Hu
*Time:2015年10月11日18:01:05
**/
@isTest
private class Cls_WS_Campaign_Create_AZTRID_Test {

    static testMethod void myUnitTest() {
		  Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        cp.amazon_tracking_id__c = 'xxx';
        insert cp;
         SKU__c s = new SKU__c();
        s.Name = '80-80000-117';
        s.sku__c = '80-80000-117';
        insert s;
        Campaign_SKU__c cs = new Campaign_SKU__c();
        cs.campaign__c = cp.Id;
        cs.SKU__c = s.Id;
        insert cs;
        Cls_WS_Campaign_Create_AZTRID.autoCreateAZTRID(cp.Id);
    }
}