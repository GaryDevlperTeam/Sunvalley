/**
*Dis:ordersku与review关联：根据ordersku.amazon_id__c=review.amazon_id__c;review.sku__c=ordersku.sku__c,ordersku.review__c=review.id做关联的测试类
*Auther:Jmark
*Time:2015年10月8日10:02:49
**/
@isTest
private class Bacth_Ordersku_MatchReview_test {

    static testMethod void myUnitTest() {
        Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.sku__c='rrrrrrrrrrrrrrrrr';
        insert osku;
        Review__c rv=new Review__c();
        rv.amazon_id__c='111111111111111';
        rv.sku__c='rrrrrrrrrrrrrrrrr';
        insert rv;
        Test.startTest();
        ScheduleOrderskuMatchReview srtc=new ScheduleOrderskuMatchReview(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}