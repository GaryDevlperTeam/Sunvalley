/**
*Create By:jmark
*TIME：2015年9月14日16:17:55
*Description:review（N） 和SKU（1）关联：review.sku__c = sku.sku__c；
*
**/ 
global class ScheduleReviewMatchSKU implements Schedulable{ 
	
  global void execute(SchedulableContext SC) {
    
    ID batchprocessid = Database.executeBatch(new Bacth_Review_MatchSKU(),1000);
    
  }
}