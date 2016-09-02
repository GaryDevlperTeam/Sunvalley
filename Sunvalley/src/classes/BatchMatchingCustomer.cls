/**
*Dis:新建Order sku时根据邮件匹配客户
*Auther:Victor Li
*Time:2015年8月26日15:06:37
**/
global class BatchMatchingCustomer implements Database.Batchable<sObject>
{
	 global Database.queryLocator start(Database.BatchableContext ctx)
  	 { 		datetime myDateTime = datetime.now().addHours(-24);
      		return Database.getQueryLocator([Select Id,amazon_email__c,shipping_zip__c,shipping_state__c,shipping_city__c,shipping_country__c,amazon_id__c,customer_email__c,Customer__c,shipping_last_name__c,shipping_first_name__c from Order_sku__c where SystemModStamp >=:myDateTime]); 
	 }
	 
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope) 
	 {
	 		//Order sku Amazon Email
	        Set<String> set_Aemail = new Set<String>();
	        
	        //Order sku Customer Email
	        Set<String> set_Cemail = new Set<String>();
	    	
	    	for(Sobject sc : scope)
		  	{
		  		Order_sku__c os = (Order_sku__c)sc;	 
		  		System.debug(os + '*****os*****'); 
		  		if(os.amazon_email__c != null)
		  		{
		  			set_Aemail.add(os.amazon_email__c);  		
		  		}				
				if(os.customer_email__c != null)
		  		{
		  			set_Cemail.add(os.customer_email__c);  		
		  		}
		  	}
		  	
		  	//满足条件的客户
		  	List<Account> listAccount = [select Id,amazon_email__c,customer_email__c,firstName,LastName from Account 
		  	                             where amazon_email__c in:set_Aemail or customer_email__c in:set_Cemail];
		  	System.debug(listAccount + '*****listAccount*****');  
		  	
		  	//Amazon Email
		  	Map<String,Account> map_Aemail_AccId = new Map<String,Account>();  
		  	
		  	//Customer Email
		  	Map<String,Account> map_Cemail_AccId = new Map<String,Account>();                              
		  	
		  	
		  	for(Account acc:listAccount)
	  		{
	  			if(acc.amazon_email__c != null)
	  			{
	  				map_Aemail_AccId.put(acc.amazon_email__c,acc);
	  			}
	  			if(acc.customer_email__c != null)
	  			{
	  				map_Cemail_AccId.put(acc.customer_email__c,acc);
	  			}
	  		} 
	  		                            
		  	//Amazon Email
		  	Map<String,Boolean> map_Aemail_Bool = new Map<String,Boolean>();  
		  	
		  	//Customer Email
		  	Map<String,Boolean> map_Cemail_Bool = new Map<String,Boolean>(); 
		  	
		  	//匹配到客户的Order_sku    
		  	List<Order_sku__c>  list_Ordersku = new List<Order_sku__c>();                   
		  	
		  	Set<Order_sku__c> set_TempOrdersku = new Set<Order_sku__c>();      
		  	
	  		for(Sobject sc : scope)
	  		{
	  			Order_sku__c os = (Order_sku__c)sc;	  			
	  			
  				if(map_Aemail_AccId.containsKey(os.amazon_email__c))
  				{
  					os.Customer__c =  map_Aemail_AccId.get(os.amazon_email__c).Id;
  					if(os.shipping_first_name__c != null)
  					{ 						
  						if(os.shipping_first_name__c.length() > 35)
                        {
                            map_Aemail_AccId.get(os.amazon_email__c).firstName = os.shipping_first_name__c.substring(0,35);
                        }else
                        {
                            map_Aemail_AccId.get(os.amazon_email__c).firstName = os.shipping_first_name__c;
                        }
  					}
  					if( os.shipping_last_name__c != null)
  					{
                        if(os.shipping_last_name__c.length() > 35)
                        {
	  						map_Aemail_AccId.get(os.amazon_email__c).lastName = os.shipping_last_name__c.substring(0,35); 	
                        }else
                        {
                            map_Aemail_AccId.get(os.amazon_email__c).lastName = os.shipping_last_name__c;
                        }
  					}
  					map_Aemail_Bool.put(os.amazon_email__c,true);					
  					set_TempOrdersku.add(os);
  				}else
  				if(map_Cemail_AccId.containsKey(os.customer_email__c))
  				{ 					
  					os.Customer__c = map_Cemail_AccId.get(os.customer_email__c).Id;
  					if(os.shipping_first_name__c != null)
  					{ 
  						System.debug(map_Cemail_AccId.get(os.customer_email__c) + '*******mapAcc********8'); 	
  						if(os.shipping_first_name__c.length() > 35)
                        {				
	  						map_Cemail_AccId.get(os.customer_email__c).firstName = os.shipping_first_name__c.substring(0,35);
                        }else
                        {
                            map_Cemail_AccId.get(os.customer_email__c).firstName = os.shipping_first_name__c;
                        }
  					}
  					if( os.shipping_last_name__c != null)
  					{ 
                        if(os.shipping_last_name__c.length() > 35)
                        {	
  							map_Cemail_AccId.get(os.customer_email__c).lastName = os.shipping_last_name__c.substring(0,35);
                        }else
                        {
                            map_Cemail_AccId.get(os.customer_email__c).lastName = os.shipping_last_name__c;
                        }
  					}					 						
  					map_Cemail_Bool.put(os.customer_email__c,true);	
  					set_TempOrdersku.add(os);
  				}
	  		}
	  		
	  		update listAccount;
	  		
	  		for(Order_sku__c osk:set_TempOrdersku)
	  		{
	  			list_Ordersku.add(osk);
	  		} 
	  		update list_Ordersku;
	  		
	  		//新建的Customer
	  		List<Account> list_Account = new List<Account>();
	  		
	  		//没有匹配到客户的Order_sku    
		  	List<Order_sku__c>  list_NoOrdersku = new List<Order_sku__c>(); 
		  	
		  	RecordType rt = [select Id,Name from RecordType where Name = 'NonAmazon Customer'];
	  		
	  		for(Sobject sc : scope)
	  		{
	  			Order_sku__c os = (Order_sku__c)sc;
	  			
	  			if(!map_Aemail_Bool.containsKey(os.amazon_email__c) && !map_Cemail_Bool.containsKey(os.customer_email__c))
	  			{
	  				Account acc = new Account();
                    System.debug(os.customer_email__c + '**********os.customer_email__c********');

	  				if(os.customer_email__c != null)
	  				{
	  					if(os.shipping_last_name__c == null && os.shipping_first_name__c ==null)
		  				{
                            acc.LastName = os.customer_email__c;
		  				}else 
	  					if(os.shipping_last_name__c == null && os.shipping_first_name__c !=null)
		  				{
                            if(os.shipping_first_name__c.length() > 35)
                        	{	
		  						acc.LastName = os.shipping_first_name__c.substring(0,35);
                            }else
                            {
                                acc.LastName = os.shipping_first_name__c;
                            }
		  				}
		  				else
		  				{
                            if(os.shipping_last_name__c.length() > 35)
                        	{
			  					acc.LastName = os.shipping_last_name__c.substring(0,35);
                            }else
                            {
                                acc.LastName = os.shipping_last_name__c;
                            }
		  				}
                        if(os.shipping_first_name__c.length() > 35)
                        {
		  					acc.FirstName = os.shipping_first_name__c.substring(0,35);
                        }else
                        {
                            acc.FirstName = os.shipping_first_name__c;
                        }
		  				acc.CurrencyIsoCode = 'USD';
		  				acc.customer_email__c = os.customer_email__c;
	  					acc.RecordTypeId = rt.Id;
	  					list_Account.add(acc);
	  					list_NoOrdersku.add(os);
	  				}
	  				//acc.amazon_email__c = os.amazon_email__c;
	  				//acc.amazon_id__c = os.amazon_id__c;
	  				//acc.city__c = os.shipping_city__c;
	  				//acc.country__c = os.shipping_country__c;
	  				//acc.state__c = os.shipping_state__c;
	  				//acc.zip__c = os.shipping_zip__c;
	  				
	  			}
	  		} 
          
            map<String,List<Account>> map_Cemail_ListAcc = new map<String,List<Account>>();
         
            List<Account> list_NewAccount = new List<Account>();
         
            Set<Account> set_Account = new Set<Account>();
         
            for(Account acc:list_Account)
            {
                if(!map_Cemail_ListAcc.containsKey(acc.customer_email__c))
                {
                    List<Account> list_TempAccount = new List<Account>();
                    list_TempAccount.add(acc);
                    map_Cemail_ListAcc.put(acc.customer_email__c,list_TempAccount);
                }else
                {
                    map_Cemail_ListAcc.get(acc.customer_email__c).add(acc);
                }
            }
            System.debug(map_Cemail_ListAcc+ '*********map_Cemail_ListAcc*******');
         
            for(Account acc:list_Account)
            {
                if(map_Cemail_ListAcc.get(acc.customer_email__c).size() >1)
                {
                    set_Account.add(map_Cemail_ListAcc.get(acc.customer_email__c)[0]);
                }else
                {
                    set_Account.add(acc);
                }
            }
            System.debug(set_Account+ '*********set_Account*******');
         
            for(Account acc:set_Account)
            {
                list_NewAccount.add(acc);
            }
	  		insert list_NewAccount;  
	  		
	  		  
	  		for(Order_sku__c os:list_NoOrdersku)
	  		{	  			
	  			for(Account acc:list_NewAccount)
	  			{
	  				if((os.amazon_email__c == acc.amazon_email__c && os.amazon_email__c != null)  || (os.customer_email__c == acc.customer_email__c && os.customer_email__c != null))
	  				{
	  					os.Customer__c = acc.Id;
	  				}
	  			}
	  		} 
	  		update list_NoOrdersku;                        
	 }
	 
	 global void finish(Database.BatchableContext ctx)
     {
	       	
     }
}