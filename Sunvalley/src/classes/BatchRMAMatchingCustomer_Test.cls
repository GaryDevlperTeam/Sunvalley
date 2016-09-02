/**
*Dis:新建RMA时根据邮件匹配客户的测试类
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/
@isTest
private class BatchRMAMatchingCustomer_Test {

    static testMethod void myUnitTest() {
        
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        //acc.customer_id__c = '123';
        insert acc;
        
        Case ca = new Case();
        ca.CurrencyIsoCode = 'USD';
        ca.Status = 'New';
        ca.Origin = 'Phone';
        ca.amazon_email__c = '843787061@qq.com';
        insert ca;
        
        System.Test.startTest();
        ScheduleBatchRMAMatchingCustomer sua = new ScheduleBatchRMAMatchingCustomer();  
        BatchRMAMatchingCustomer bua = new BatchRMAMatchingCustomer();
        Database.executeBatch(bua,50);
        string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
        system.schedule('MergeLead Job1', schLead,sua);
        System.Test.stopTest();
    }
}