/**
*Dis:新建Customer时根据Original Source匹配Campaign Channel的测试类
*Auther:Victor Li
*Time:2015年9月25日15:22:54
**/
@isTest
private class BatchCustomerMatCampaignChannel_Test {

    static testMethod void myUnitTest() 
    { 
        Campaign ca = new Campaign();
        ca.Name = 'jjj';
        ca.CurrencyIsoCode = 'USD';
        ca.campaign_type__c = 'Registration';
        insert ca;
        
        Campaign_Channel__c cc = new Campaign_Channel__c();
        cc.campaign__c = ca.Id;
        cc.CurrencyIsoCode = 'USD';
        cc.campaign_channel__c = 'Facebook';
        cc.campaign_channel_key__c  = String.valueOf(ca.Id).substring(0,15)+'&'+ca.campaign_type__c+'&'+cc.campaign_channel__c;
        insert cc;
        
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.original_source__c = String.valueOf(ca.Id).substring(0,15)+'&'+ca.campaign_type__c+'&'+cc.campaign_channel__c;
        insert acc;
        
               
        System.Test.startTest();
        ScheduleCustomerMatchingCampaignChannel sua = new ScheduleCustomerMatchingCampaignChannel();    
        Batch_Customer_Matching_Campaign_Channel bua = new Batch_Customer_Matching_Campaign_Channel();
        Database.executeBatch(bua,50);
        string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
        system.schedule('MergeLead Job', schLead,sua);
        System.Test.stopTest();
    }
}