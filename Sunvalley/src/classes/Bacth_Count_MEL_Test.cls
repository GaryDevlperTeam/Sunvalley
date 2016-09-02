/**
*Des:Mails click Is Click=Ture 汇总客户关联MEL
Mails Open Is Open=Ture 汇总客户关联MEL
Recent Contact Date 最近一条MEL的创建日期
Review Accept 汇总和客户相关的MEL的is apccept=1的接受数量 
Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
Review Request 汇总MEL.Campaign Type=Super User 
Reviewer Feedback Rate 接受到完成时间天数（只取最近一次）MEL.Accept Date减去MEL.Review Date
*Author:Gary Hu
*Time:2015年10月27日15:29:11
**/
@isTest
private class Bacth_Count_MEL_Test {

    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.original_source__c = 'xxxx';
        insert acc;
        Mass_Email_Log__c me = new Mass_Email_Log__c();
        me.campaign_sku__c = '111';
        me.customer__c = acc.Id;
        me.is_click__c=true;
        me.is_open__c=true;
        me.is_review__c=true;
        me.is_accept__c=true;
        me.accepted_date__c=Date.today();
        me.review_date__c=Date.today().addDays(5);
        insert me;
        Test.startTest();
        Schedule_Bacth_Count_MEL srtc=new Schedule_Bacth_Count_MEL(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}