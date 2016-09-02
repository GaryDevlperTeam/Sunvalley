/**
*Des:score(Purchase Times)=[Purchase Times]/[max(Purchase Times))]              
    score(Purchase Products)=[Purchase Products)]/[max(Purchase Products)]             
	score(Purchase Total Amount)=[Purchase Total Amount]/[max(Purchase Total Amount)]           
	score(Avg Order Price)=[Avg Order Price]/[max(Avg Order Price)]              
	score(Reviews)=[Reviews]/[max(Reviews)]                
	score(Avg Review Star)=[Avg Review Star]/[max(Avg Review Star)]              
	score(Mails Open rate)=[Mails Open rate]/[max(Mails Open rate)]              
	score(Mails click rate)=[Mails click rate]/[max(Mails click rate)]             
	score(Reviewer Helpful)=[Reviewer Helpful]/[max(Reviewer Helpful)]             
	score(Reviewer Helpful Rating)=[Reviewer Helpful Rating]/[max(Reviewer Helpful Rating)]           
	score(Reviewer ranking)=[ max(Reviewer ranking) - Reviewer ranking]/[max(Reviewer ranking)] --- 0除外，即当运算结果为1时，值为0             
	score(Reviewer Avg Review Star)=[Reviewer Avg Review Star]/[max(Reviewer Avg Review Star)]          
	score(Review Accept rate)=[Review Accept rate]/[max(Review Accept rate)]            
	score(Review Finish rate)=[Review Finish rate]/[max(Review Finish rate)]            
	score(Reviewer Avg Star For Sunvalley)=[Reviewer Avg Star For Sunvalley]/[max(Reviewer Avg Star For Sunvalley)]        
	score(Reviewer Feedback Rate)=[max(Reviewer Feedback Rate) - Reviewer Feedback Rate]/max(Reviewer Feedback Rate) --- 0除外，即当运算结果为1时，值为0
*Author:Jmark
*Time:2015年10月27日10:14:43
**/
@isTest
private class Bacth_CalculateScore_Test {

    static testMethod void myUnitTest() {
       Account acc = new Account();
        acc.LastName = 'xxx';
        acc.CurrencyIsoCode = 'USD';
        acc.amazon_email__c = '843787061@qq.com';
        acc.customer_email__c = '1484546367@qq.com';
        acc.original_source__c = 'xxxx';
        acc.reviewer_helpful__c = 10;
        acc.reviewer_helpful_rating__c = 10;
        acc.reviewer_ranking__c = 10;
        acc.reviewer_avg_review_star__c = 10;
        acc.reviewer_avg_star_for_sunvalley__c = 10;
        insert acc;
         Account acc1 = new Account();
        acc1.LastName = 'xxx1';
        acc1.CurrencyIsoCode = 'USD';
        acc1.amazon_email__c = '843787062@qq.com';
        acc1.customer_email__c = '1484546363@qq.com';
        acc1.original_source__c = 'xxxx1';
        insert acc1;
        
        Test.startTest();
        Schedule_BacthCalculateScore srtc=new Schedule_BacthCalculateScore(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}