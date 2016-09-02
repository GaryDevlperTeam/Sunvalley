/**
*Des:Review/MEL关联
根据sku、amazon id关联，并更新is review 、review date、review star字段，
在Campaign 和 Review 关联的基础上&  sku__c & amazon_id__c MEL和review之间的关联；
*
*
**/
global class Bacth_Review_Matching_MEL implements  Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC) {
		datetime myDateTime = datetime.now().addHours(-24); 
		return Database.getQueryLocator([select link_mel__c,sku__c,campaign__c,amazon_id__c,review_star__c,review_date__c from Review__c  
		 								  where link_mel__c = null and sku__c != null and campaign__c != null and amazon_id__c != null and SystemModStamp >=:myDateTime]);
	}
	 global void execute(Database.BatchableContext ctx,list<Review__c > list_Review) {
	 	System.debug(list_Review.size()+'----------list_Review.size()---------------');
	 	//Campaign
	 	set<Id> setCam = new set<Id>();
	 	//sku
	 	set<String> setSku = new set<String>();
	 	//am Id
	 	set<String> setAMid = new set<String>();
	 	
	 	
	 	if(list_Review.size() > 0)
	 	{
	 		for(Review__c r:list_Review )
	 		{
	 			setCam.add(r.campaign__c);
	 			setSku.add(r.sku__c);
	 			setAMid.add(r.amazon_id__c);
	 		}
	 	}
	 	if(setCam.size() > 0 && setSku.size() >0 && setAMid.size() > 0)
	 	{
	 		list<Mass_Email_Log__c> listMel = [select is_review__c,review_date__c,review_star__c,Id,campaign_sku__c,amazon_id__c,campaign_name__c 
	 									from Mass_Email_Log__c where campaign_name__c in: setCam and campaign_sku__c in:setSku and amazon_id__c in:setAMid and is_review__c =false and review_date__c = null and review_star__c = null];
			System.debug(listMel.size() +'------listMel.size()------------');
			
			if(listMel.size() > 0)
			{
				for(Review__c r:list_Review)
				{
					for(Mass_Email_Log__c m:listMel)
					{
						if(r.sku__c == m.campaign_sku__c && r.amazon_id__c == m.amazon_id__c && r.campaign__c == m.campaign_name__c)
						{
							r.link_mel__c = m.Id;
							m.is_review__c = true;
							m.review_date__c = r.review_date__c;
							m.review_star__c = String.valueOf(r.review_star__c);
							break;
						}
					}
				}
				update listMel;
				update list_Review;
			}
	 	} 
	 }
	  global void finish(Database.BatchableContext ctx)
    {
	
    }
}