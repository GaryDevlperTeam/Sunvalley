/**
*Des:Bacth_Review_Matching_MEL Test
*Author:Gary Hu
*Time:2015年10月10日15:03:06
**/
@isTest
private class Bacth_Review_Matching_MEL_Test {

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
    	Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        insert cp;
        
        Review__c rv=new Review__c();
        rv.amazon_id__c='111111111111111';
        rv.sku__c='111';
        rv.campaign__c = cp.Id;
        rv.review_star__c = 20;
        rv.review_date__c = Date.today().addDays(-1);
        insert rv;
        Mass_Email_Log__c me = new Mass_Email_Log__c();
        me.campaign_name__c = cp.Id;
        me.campaign_sku__c = '111';
        me.customer__c = acc.Id;
        insert me;
 		Test.startTest();
        Schedule_BacthReviewMatchingMEL srtc=new Schedule_BacthReviewMatchingMEL(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest();
    }
}