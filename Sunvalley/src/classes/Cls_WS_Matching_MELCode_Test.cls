/**
*Des:Cls_WS_Matching_MELCode Test
*Author:Gary Hu
*Time:2015年10月11日18:01:05
**/
@isTest
private class Cls_WS_Matching_MELCode_Test {
	 static testMethod void myUnitTest() {
	 	Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        //acc.customer_id__c = '123';
        acc.original_source__c = 'xxxx';
        acc.amazon_id__c = '111111111111111';
	 	 Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        cp.amazon_tracking_id__c = 'xxx';
        insert cp;
        Blob b = Blob.valueOf('xxxxx');
        Attachment attachment = new Attachment();
        attachment.ParentId = cp.Id;
        attachment.Name = 'PLOA';
        attachment.Body = b;         
        insert attachment;
         SKU__c s = new SKU__c();
        s.Name = '80-80000-117';
        s.sku__c = '80-80000-118';
        insert s;
        Campaign_SKU__c cs = new Campaign_SKU__c();
        cs.campaign__c = cp.Id;
        cs.SKU__c = s.Id;
        insert cs;
        Mass_Email_Log__c me = new Mass_Email_Log__c();
        me.campaign_name__c = cp.Id;
        me.campaign_sku__c = '80-80000-117';
        me.customer__c = acc.Id;
        insert me;
        Cls_WS_Matching_MELCode.autoUpdateMEL(cp.id);
         SKU__c s1 = new SKU__c();
        s1.Name = '80-80000-117';
        s1.sku__c = '80-80000-117';
        insert s1;
        cs.SKU__c = s1.id;
        update cs;
        
	 }
}