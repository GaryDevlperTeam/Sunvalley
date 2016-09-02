/**
*Dis:新建和删除"市场活动成员"，通过“市场活动”，“联系人”字段，更新字段Campaign Sku List，的测试类
*Author:Gavin Li
*Time:2015年11月03日11:05:28
**/
@isTest
private class Cbl_CampaignMember_UpdateCSL_Test {

    static testMethod void myUnitTest() {
    	
        Account a = new Account();
        RecordType re = [select Id from RecordType where Name='Approved Super User'];
        a.RecordTypeId=re.Id;
        a.LastName='li';
        insert a;//新建一条“客户”记录
        Account acc = [Select PersonContactId From Account Where Id = :a.Id];
        
        Campaign c = new Campaign();
       	RecordType rt = [select Id from RecordType where Name='Registration Campaign'];
       	c.RecordTypeId=rt.Id;
       	c.Name='gavintest';
        c.Person_in_Charge__c='test';
        c.campaign_country__c='US';
        c.campaign_type__c='Registration';
        c.campaign_brand__c='HooToo';
        c.campaign_target__c='Superuser';
        c.StartDate=date.valueOf('2015-9-9');
        insert c;//新建一条“市场活动”记录
        
        SKU__c sku = new SKU__c();
        sku.Name='test1';
        insert sku;//新建一条“SKU”记录
                
        Campaign_SKU__c cs = new Campaign_SKU__c();
        cs.campaign__c=c.Id;
        cs.fct_sku_nmuber__c=123;
        cs.sku_cost__c=111;
        cs.SKU__c=sku.Id;
        cs.sku_item_name__c='xxxx';
        insert cs;//新建一条“Campaign_SKU”记录
        
        Campaign_SKU__c csc = new Campaign_SKU__c();
        csc.campaign__c=c.Id;
        csc.fct_sku_nmuber__c=123;
        csc.sku_cost__c=111;
        csc.SKU__c=sku.Id;
        csc.sku_item_name__c='xxxx';
        insert csc;//新建第二条“Campaign_SKU”记录
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId=c.Id;
        cm.ContactId=acc.PersonContactId;
        insert cm;//测试新建"市场活动成员"更新字段功能
        delete cm;//测试删除“市场活动成员”更新字段的功能
        
    }
}