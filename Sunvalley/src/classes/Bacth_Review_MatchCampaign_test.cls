/**
*Dis:review与Campaign关联：
*1.a）有memberlist(即customer)：customer.amazon_id__c=review.amazon_id__c
*                          review.sku__c包含在 Campaign.campaginsku.campaign_sku__c(数据集合)
*  b）没有memberlist：campagin .campaign_country__c=review.review_country__c
*                      review.sku__c包含在 Campaign.campaginsku.campaign_sku__c
*2.开始发货时间（需要在市场活动上新建），MEL.logistics_number__c(来自接口)，IF MEL.logistics_number__c存在（MEL必须是市场活动相关）,开始发货时间=Today
*3.在市场活动新建字段：review收集结束（天）(手填)，review.review_date__c落在{开始发货时间，开始发货时间+review收集结束（天）之内}
*匹配：review.campaign__c=campagin.id
*Auther:Jmark
*Time:2015年10月8日10:48:36
**/
@isTest
private class Bacth_Review_MatchCampaign_test {

    static testMethod void myUnitTest() {
        Campaign cp=new Campaign();
        cp.Name='testcp';
        cp.Person_in_Charge__c='testp';
        cp.campaign_country__c='US';
        cp.campaign_brand__c='RAVPower';
        cp.campaign_target__c='Superuser';
        cp.StartDate=Date.today().addDays(-1);
        cp.review_collect_end_day__c=5;
        insert cp;
        SKU__c sku=new SKU__c();
        sku.Name='testosku';
        sku.sku__c='rrrrrrrrrrrrrrrrr';
        insert sku;
        Campaign_SKU__c csku=new Campaign_SKU__c();
        csku.campaign__c=cp.Id;
        csku.fct_sku_nmuber__c=100;
        csku.SKU__c=sku.Id;
        insert csku;
        Mass_Email_Log__c mel=new Mass_Email_Log__c();
        mel.campaign_name__c=cp.Id;
        insert mel;
        mel.shipping_date__c=Date.today().addDays(-1);
        update mel;
        Review__c rv=new Review__c();
        rv.amazon_id__c='111111111111111';
        rv.sku__c='rrrrrrrrrrrrrrrrr';
        rv.review_country__c='US';
        rv.review_date__c=Date.today();
        insert rv;
        Test.startTest();
        ScheduleReviewMatchCampaign srtc=new ScheduleReviewMatchCampaign(); 
        string ch1='0 30 9 * * ?'; 
        System.schedule('计划工作',ch1,srtc); 
        Test.stopTest(); 
    }
}