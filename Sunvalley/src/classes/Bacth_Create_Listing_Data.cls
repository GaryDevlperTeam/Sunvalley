/**
*Des:批量创建关联到该Campaign的Listing Data记录
*Author:Gary Hu
*Time:2015年9月15日13:44:52
**/

global class Bacth_Create_Listing_Data implements  Database.Batchable<sObject>{
	
	//市场活动Id
    global ID cId= null;
    //开始日期
    global Date startDate = null;
	//结束日期
    global Date endDate = null;
    
    global String country = null;
    
    public Bacth_Create_Listing_Data(ID cId,Date startDate,Date endDate,String country)
    {
    	this.cId = cId;
    	this.startDate = startDate;
    	this.endDate = endDate;
    	this.country = country;
    }
    
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([select campaign_sku__c from  Campaign_SKU__c where campaign__c =:cId]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Campaign_SKU__c > list_CamSku) {
	 	list<Listing_Data__c> listDate = new list<Listing_Data__c>();
	  	if(list_CamSku.size() >0)
	  	{
	  		
	  		for(Campaign_SKU__c c: list_CamSku)
	  		{
	  			for(Date i=startDate;i <= endDate; i=i.addDays(1))
	  			{
		  			Listing_Data__c l = new Listing_Data__c();
		  			l.campaign__c = cId;
		  			l.date__c = i;
		  			l.sku__c = c.campaign_sku__c;
		  			l.listing_country__c = country;
	  				listDate.add(l);
	  			}	
	  			
	  		}
  		    Database.SaveResult[] saveResults = Database.insert(listDate,false);
            if(saveResults != null && !saveResults.isEmpty()) {
                for(Database.SaveResult saveResult : saveResults) {
                    if(saveResult.isSuccess()) {
                        System.debug('Successful insert Listing_Data ' + saveResult.getId());
                    } else {
                        for(Database.Error error : saveResult.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(error.getStatusCode() + ': ' + error.getMessage());
                            System.debug('Listing_Data fields that affected this error: ' + error.getFields());
                        }
                    }
                }
            }
	  		
	  	}
	  	
	  	
	 }
    global void finish(Database.BatchableContext ctx)
    {
	
    }
    
    
    
    
    
}