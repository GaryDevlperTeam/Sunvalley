/**
*Create By:jmark
*TIME：2015年9月10日14:14:42
**Description:review与Campaign关联：
*1.a）有memberlist(即customer)：customer.amazon_id__c=review.amazon_id__c
*                          review.sku__c包含在 Campaign.campaginsku.campaign_sku__c(数据集合)
*  b）没有memberlist：campagin .campaign_country__c=review.review_country__c
*                      review.sku__c包含在 Campaign.campaginsku.campaign_sku__c
*2.开始发货时间（需要在市场活动上新建），MEL.logistics_number__c(来自接口)，IF MEL.logistics_number__c存在（MEL必须是市场活动相关）,开始发货时间=Today
*3.在市场活动新建字段：review收集结束（天）(手填)，review.review_date__c落在{开始发货时间，开始发货时间+review收集结束（天）之内}
*匹配：review.campaign__c=campagin.id
 */
global class ScheduleReviewMatchCampaign implements Schedulable{ 
	
  global void execute(SchedulableContext SC) {
    
    ID batchprocessid = Database.executeBatch(new Bacth_Review_MatchCampaign(),1000);
    
  }
}