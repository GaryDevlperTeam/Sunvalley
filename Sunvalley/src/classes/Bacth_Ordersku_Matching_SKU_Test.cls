/**
*Des:Bacth_Ordersku_Matching_SKU Test
*Author:Gary Hu
*Time:2015年10月10日17:05:31
**/
@isTest
private class Bacth_Ordersku_Matching_SKU_Test {

    static testMethod void myUnitTest() {
       Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.amazon_tracking_id__c='xxxx';
        osku.sku__c='80-80000-117';
        insert osku;
        SKU__c s = new SKU__c();
        s.Name = '80-80000-117';
        s.sku__c = '80-80000-117';
        insert s;
 		Test.startTest();
        Schedule_BacthOrderskuMatchingSKU srtc=new Schedule_BacthOrderskuMatchingSKU(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
        
    }
}