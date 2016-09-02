/**
*Des:计算 Purchase Products CRM 和客户关联：汇总Order SKU.sku_qty__c
*       Purchase Times CRM order sku（order_id__c唯一，去重复)数量
*       Purchase Total Amount CRM 和客户关联的，汇总order sku的sku_actual_amountUS__c
*Author:Jmark
*Time:2015年10月27日09:45:22
**/
@isTest
private class Bacth_CalculatePurchaseCRM_Test {

    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.original_source__c = 'xxxx';
        insert acc;
        Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.sku__c='rrrrrrrrrrrrrrrrr';
        osku.Customer__c=acc.Id;
        osku.order_id__c='sdfsfsdf';
        osku.sku_actual_amountUS__c=100;
        osku.sku_qty__c=10;
        insert osku;
        Order_sku__c osku1=new Order_sku__c();
        osku1.Name='testosku1';
        osku1.amazon_id__c='111111111111111';
        osku1.sku__c='rrrrrrrrrrrrrrrrr';
        osku1.Customer__c=acc.Id;
        osku1.order_id__c='sdfsfsdfdfg';
        osku1.sku_actual_amountUS__c=90;
        osku1.sku_qty__c=20;
        insert osku1;
        Test.startTest();
        Schedule_BacthCalculatePurchaseCRM srtc=new Schedule_BacthCalculatePurchaseCRM(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
        
    }
}