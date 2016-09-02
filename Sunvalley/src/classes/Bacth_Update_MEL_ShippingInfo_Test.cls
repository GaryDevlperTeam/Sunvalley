/**
*Des:Bacth_Update_MEL_ShippingInfo Test
*Author:Gary Hu
*Time:2015年10月11日17:15:40
**/
@isTest
private class Bacth_Update_MEL_ShippingInfo_Test {

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
        cp.amazon_tracking_id__c = 'xxx';
        insert cp;
		Mass_Email_Log__c me = new Mass_Email_Log__c();
        me.campaign_name__c = cp.Id;
        me.campaign_sku__c = '111';
        me.customer__c = acc.Id;
        insert me;
		Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.amazon_tracking_id__c='xxx';
        osku.sku__c='80-80000-117';
        osku.shipping_date__c = Date.today().addDays(-1);
        osku.source_campaign__c = cp.id;
        insert osku;
 		Test.startTest();
        Schedule_BacthUpdateMELShippingInfo srtc=new Schedule_BacthUpdateMELShippingInfo(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest();
        
        
        
    }
}