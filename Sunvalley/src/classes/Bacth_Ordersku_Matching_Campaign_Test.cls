/**
*Des:Bacth_Ordersku_Matching_Campaign Test
*Author:Gary Hu
*Time:2015年10月10日13:10:45
**/
@isTest
private class Bacth_Ordersku_Matching_Campaign_Test {
	 static testMethod void myUnitTest() {
	 	Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.amazon_tracking_id__c='xxxx';
        osku.sku__c='rrrrrrrrrrrrrrrrr';
        insert osku;
        Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        cp.amazon_tracking_id__c='xxxx';
        insert cp;
        osku.amazon_tracking_id__c='xxxx'+cp.Id;
        update osku;
 		Test.startTest();
        Schedule_BacthOrderskuMatchingCampaign srtc=new Schedule_BacthOrderskuMatchingCampaign(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
	 }
}