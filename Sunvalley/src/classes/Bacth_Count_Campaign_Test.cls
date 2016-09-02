/**
*Des: Campaign Times 参加活动次数 
Mails Send 参加过的Campaign的EDM Event数量
*Author:Gary Hu
*Time；2015年10月27日15:19:42
**/
@isTest
private class Bacth_Count_Campaign_Test {

    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.original_source__c = 'xxxx';
        insert acc;
        Account a = [Select PersonContactId From Account Where Id = :acc.Id];
        RecordType r = [Select Id, DeveloperName From RecordType Where DeveloperName ='EDM_Event' and Sobjecttype='Campaign'];
		Campaign cp=new Campaign();
	    cp.Name='testcp';
	    cp.Person_in_Charge__c='testp';
	    cp.campaign_country__c='US';
	    cp.campaign_brand__c='RAVPower';
	    cp.campaign_target__c='Superuser';
	    cp.StartDate=Date.today().addDays(-1);
	    cp.review_collect_end_day__c=5;
	    cp.campaign_country__c='US';
	    cp.EndDate = Date.today().addDays(3);
	    cp.RecordTypeId=r.Id;
	    insert cp;
	    CampaignMember ca = new CampaignMember();
	    ca.CampaignId  = cp.Id;
	    ca.ContactId   = a.PersonContactId;
	    insert ca;
        Test.startTest();
        Schedule_Bacth_Count_Campaign srtc=new Schedule_Bacth_Count_Campaign(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}