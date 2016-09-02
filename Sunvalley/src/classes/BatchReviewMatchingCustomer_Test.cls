/**
*Dis:新建Review时根据邮件匹配客户的测试类
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/
@isTest
private class BatchReviewMatchingCustomer_Test {

    static testMethod void myUnitTest() {
        
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.amazon_id__c = 'abc';
        insert acc;
        
        Campaign ca = new Campaign();
        ca.Name = 'jjj';
        ca.CurrencyIsoCode = 'USD';
        insert ca;
        
        Review__c re = new Review__c();
        //re.Name = 'xxx';
        re.CurrencyIsoCode = 'USD';
        re.amazon_id__c = 'abc';
        re.Campaign__c = ca.Id;
        insert re;
        
        System.Test.startTest();
        ScheduleBatchReviewMatchingCustomer sua = new ScheduleBatchReviewMatchingCustomer();    
        BatchReviewMatchingCustomer bua = new BatchReviewMatchingCustomer();
        Database.executeBatch(bua,50);
        string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
        system.schedule('MergeLead Job', schLead,sua);
        System.Test.stopTest();
    }
}