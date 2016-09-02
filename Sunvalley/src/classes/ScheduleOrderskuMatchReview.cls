/**
*Create By:jmark
*TIME：2015年9月9日16:50:26
*Description:ordersku与review关联：根据ordersku.amazon_id__c=review.amazon_id__c;review.sku__c=ordersku.sku__c,ordersku.review__c=review.id做关联
 */
global class ScheduleOrderskuMatchReview implements Schedulable{ 
	
  global void execute(SchedulableContext SC) {
    
    ID batchprocessid = Database.executeBatch(new Bacth_Ordersku_MatchReview(),1000);
    
  }
}