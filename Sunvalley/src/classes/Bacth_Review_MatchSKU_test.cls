/**
*Dis:review（N） 和SKU（1）关联：review.sku__c = sku.sku__c；的测试类
*Auther:Jmark
*Time:2015年10月8日10:25:00
**/
@isTest
private class Bacth_Review_MatchSKU_test {

    static testMethod void myUnitTest() {
        SKU__c sku=new SKU__c();
        sku.Name='testosku';
        sku.sku__c='rrrrrrrrrrrrrrrrr';
        insert sku;
        Review__c rv=new Review__c();
        rv.amazon_id__c='111111111111111';
        rv.sku__c='rrrrrrrrrrrrrrrrr';
        insert rv;
        Test.startTest();
        ScheduleReviewMatchSKU srtc=new ScheduleReviewMatchSKU(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}