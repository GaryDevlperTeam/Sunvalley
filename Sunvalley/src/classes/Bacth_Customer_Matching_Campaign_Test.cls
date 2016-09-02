/**
*Des:Bacth_Customer_Matching_Campaign Test
*Author:Gary Hu
*Time:2015年10月10日13:10:45
**/
@isTest
private class Bacth_Customer_Matching_Campaign_Test {

    static testMethod void myUnitTest() {
  		Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        //acc.customer_id__c = '123';
        acc.original_source__c = 'xxxx';
        insert acc;
         Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        insert cp;
        Campaign_Channel__c cc = new Campaign_Channel__c();
        cc.campaign__c= cp.Id;
        cc.campaign_channel_key__c = 'xxxx';
        insert cc;
        System.debug(cc.campaign_channel_key__c+'----------campaign_channel_key__c-----------');
 		Test.startTest();
        Schedule_BacthCustomerMatchingCampaign srtc=new Schedule_BacthCustomerMatchingCampaign(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}