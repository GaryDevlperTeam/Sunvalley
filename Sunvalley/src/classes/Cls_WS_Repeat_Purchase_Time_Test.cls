/**
*Des:计算复购率 
*Author:Jmark
*Time:2015年10月27日10:38:47
**/
@isTest
private class Cls_WS_Repeat_Purchase_Time_Test {

    static testMethod void myUnitTest() {
    	
        Order_sku__c osku=new Order_sku__c();
        osku.Name='testosku';
        osku.amazon_id__c='111111111111111';
        osku.sku__c='rrrrrrrrrrrrrrrrr';
        osku.order_id__c='sdfsfsdf';
        osku.sku_actual_amountUS__c=100;
        osku.sku_qty__c=10;
        osku.amazon_email__c='11111111@123.com';
        osku.order_date__c=Datetime.now();
        insert osku;
        Order_sku__c osku1=new Order_sku__c();
        osku1.Name='testosku1';
        osku1.amazon_id__c='111111111111111';
        osku1.sku__c='rrrrrrrrrrrrrrrrr';
        osku1.order_id__c='sdfsfsdfdfg';
        osku1.sku_actual_amountUS__c=90;
        osku1.sku_qty__c=20;
        osku1.amazon_email__c='11111111@123.com';
        osku1.order_date__c=Datetime.now();
        insert osku1;
        Order_sku__c osku2=new Order_sku__c();
        osku2.Name='testosku2';
        osku2.amazon_id__c='111111111111111';
        osku2.sku__c='rrrrrrrrrrrrrrrrr';
        osku2.order_id__c='sdfsfsdfdfg';
        osku2.sku_actual_amountUS__c=90;
        osku2.sku_qty__c=20;
        osku2.amazon_email__c='11111212@123.com';
        osku2.order_date__c=Datetime.now();
        insert osku2;
        Repeat_Purchase_Time__c rpt=new Repeat_Purchase_Time__c();
        rpt.Calculate_End_Date__c=Date.today().addDays(+5);
        rpt.Calculate_Start_Date__c=Date.today().addDays(-5);
        insert rpt;
        Test.startTest();
        Cls_WS_Repeat_Purchase_Time.autoCalculate(rpt.Id);
        Test.stopTest();
    }
}