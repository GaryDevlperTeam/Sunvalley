/**
*Des:Cbl_MEL_updateCampaign Test
*Author:Gary Hu
*Time:2015年10月12日11:53:39
**/
@isTest
private class Cbl_MEL_updateCampaign_Test {

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
	    Campaign cp1=new Campaign();
	    cp1.Name='testcp';
	    cp1.Person_in_Charge__c='testp';
	    cp1.campaign_country__c='US';
	    cp1.campaign_brand__c='RAVPower';
	    cp1.campaign_target__c='Superuser';
	    cp1.StartDate=Date.today().addDays(-1);
	    cp1.review_collect_end_day__c=5;
	    cp1.campaign_country__c='US';
	    CP1.EndDate = Date.today().addDays(3);
	    insert cp1;
       Mass_Email_Log__c me = new Mass_Email_Log__c();
       me.campaign_name__c = cp.Id;
       me.shipping_date__c = Date.today().addDays(3);
       insert me;
       me.campaign_name__c = cp1.Id;
       update me;
       
       
       
    }
}