/**
*Dis:ordersku与review关联：根据ordersku.amazon_id__c=review.amazon_id__c;review.sku__c=ordersku.sku__c,ordersku.review__c=review.id做关联的测试类
*Auther:Jmark
*Time:2015年10月27日10:07:17
**/
@isTest
private class Bacth_CalculateReviewsCRM_Test {

    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.original_source__c = 'xxxx';
        insert acc;
        Review__c rv=new Review__c();
        rv.amazon_id__c='111111111111111';
        rv.sku__c='rrrrrrrrrrrrrrrrr';
        rv.customer__c=acc.Id;
        rv.review_star__c=10;
        insert rv;
        Review__c rv1=new Review__c();
        rv1.amazon_id__c='111111111111111';
        rv1.sku__c='rrrrrrrrrrrrrrrrr';
        rv1.customer__c=acc.Id;
        rv1.review_star__c=100;
        insert rv1;
        Test.startTest();
        Schedule_BacthCalculateReviewsCRM srtc=new Schedule_BacthCalculateReviewsCRM(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}