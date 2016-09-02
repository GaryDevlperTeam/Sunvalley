/**
*Dis:新建Review时根据邮件匹配客户
*Auther:Victor Li
*Time:2015年8月27日10:22:58
**/ 
global class BatchReviewMatchingCustomer implements Database.Batchable<sObject>
{
	 global Database.queryLocator start(Database.BatchableContext ctx)
  	 { 		datetime myDateTime = datetime.now().addHours(-24);
      		return Database.getQueryLocator([Select Id,amazon_id__c,Customer__c from Review__c  where amazon_id__c != null and Customer__c = null and  SystemModStamp >=:myDateTime]); 
	 }
	 
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope) 
	 {
	 		//Review Amazon Id
	        Set<String> set_AmazonId = new Set<String>();
	        
	        for(Sobject sc : scope)
		  	{
		  		Review__c re = (Review__c)sc;	
		  		 
		  		if(re.amazon_id__c != null)
		  		{
		  			set_AmazonId.add(re.amazon_id__c);  		
		  		}				
		  	}
		  	System.debug(set_AmazonId + '*******set_AmazonId*******');  
		  	
		  	//满足条件的客户
		  	List<Account> listAccount = [select Id,amazon_id__c from Account 
		  	                             where amazon_id__c in:set_AmazonId];
		  	System.debug(listAccount + '*******listAccount*******');                               
		  	//匹配到客户的Review
		  	List<Review__c>  list_Review = new List<Review__c>(); 
		  	
		  	Set<Review__c> set_TempReview = new Set<Review__c>();                  
		  	
	  		for(Sobject sc : scope)
	  		{
	  			Review__c re = (Review__c)sc;	
	  			
	  			for(Account acc:listAccount)
	  			{
	  				if(re.amazon_id__c == acc.amazon_id__c)
	  				{
	  					re.Customer__c = acc.Id;
	  					set_TempReview.add(re);
	  					break;
	  				}
	  			}
	  		} 
	  		System.debug(set_TempReview + '******set_TempReview********');
	  		for(Review__c rev:set_TempReview)
	  		{
	  			list_Review.add(rev);
	  		}
	  		System.debug(list_Review + '******list_Review********');
	  		update list_Review;                                          
	 }
	 
	 global void finish(Database.BatchableContext ctx)
     {
	       	
     }

}